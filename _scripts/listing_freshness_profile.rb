# frozen_string_literal: true

require 'date'
require 'uri'
require 'yaml'
require_relative 'listing_freshness'

module ListingFreshnessProfile
  SOURCE_COUNT_RANGE = (10..20)
  ALLOWED_EXPECTATIONS = %w[
    current_match candidate_change review_conflict source_unavailable cancellation_evidence
  ].freeze
  REQUIRED_SOURCE_FIELDS = %w[
    source_key covered_show_ids source_tier authority_basis check_method page_shape expected_cadence
    constraints_policy redirect_policy fail_closed_policy
  ].freeze
  ALLOWED_LISTING_RULE_KEYS = %w[
    request_url aliases calendar_year recurring_rule exact_date_anywhere_on_page max_name_date_distance
  ].freeze
  ALLOWED_RECURRING_RULE_KEYS = %w[
    ordinal weekday source_phrases
  ].freeze

  module_function

  def load(path:, external_sources:)
    validate(config: YAML.load_file(path), external_sources: external_sources)
  end

  def validate(config:, external_sources:)
    raise ArgumentError, 'Phase 2 profile version must be 2' unless config.fetch('version') == 2
    raise ArgumentError, 'Phase 2 profile must remain report_only' unless config.fetch('mode') == 'report_only'
    raise ArgumentError, 'Phase 2 automatic_action must remain none' unless config.fetch('automatic_action') == 'none'

    policies = config.fetch('policies')
    sources = config.fetch('sources')
    unless SOURCE_COUNT_RANGE.cover?(sources.length)
      raise ArgumentError, "Phase 2 profile must select 10-20 sources; found #{sources.length}"
    end

    keys = sources.map { |source| source.fetch('source_key') }
    raise ArgumentError, 'Phase 2 source keys must be unique' unless keys.uniq.length == keys.length

    registry_by_key = external_sources.to_h { |source| [source.fetch('key'), source] }
    resolved_sources = sources.map do |source|
      validate_source(source: source, registry_by_key: registry_by_key, policies: policies)
    end

    {
      config: config,
      sources: resolved_sources,
      source_keys: keys,
      source_count: sources.length
    }
  end

  def load_schedule(path:, expected_profile:)
    schedule = YAML.load_file(path)
    raise ArgumentError, 'Phase 2 schedule version must be 1' unless schedule.fetch('version') == 1
    raise ArgumentError, 'Phase 2 schedule must remain disabled' unless schedule.fetch('enabled') == false
    raise ArgumentError, 'Phase 2 manual dispatch must remain disabled' unless schedule.fetch('manual_dispatch') == false
    raise ArgumentError, 'Phase 2 schedule must not define cron' unless schedule.fetch('cron').nil?
    raise ArgumentError, 'Phase 2 schedule must not define a workflow' unless schedule.fetch('workflow_file').nil?
    raise ArgumentError, 'Phase 2 schedule must remain report_only' unless schedule.fetch('mode') == 'report_only'
    unless schedule.fetch('profile') == expected_profile
      raise ArgumentError, 'Phase 2 schedule points to an unexpected profile'
    end
    unless schedule.fetch('requires_owner_approval_to_enable') == true
      raise ArgumentError, 'Phase 2 schedule must require owner approval to enable'
    end

    schedule
  end

  def listing_rule(source:, show_id:)
    source.fetch(:profile).fetch('listing_rules', {}).fetch(show_id, {})
  end

  def request_url_for(source:, show_id:)
    profile = source.fetch(:profile)
    registry_url = source.fetch(:registry).fetch('url')
    listing_rule(source: source, show_id: show_id).fetch('request_url', profile.fetch('request_url', registry_url))
  end

  def aliases_for(source:, show_id:)
    Array(listing_rule(source: source, show_id: show_id)['aliases'])
  end

  def validate_source(source:, registry_by_key:, policies:)
    missing_fields = REQUIRED_SOURCE_FIELDS.reject { |field| source.key?(field) }
    unless missing_fields.empty?
      raise ArgumentError, "Phase 2 source #{source['source_key']} is missing: #{missing_fields.join(', ')}"
    end

    source_key = source.fetch('source_key')
    registry_source = registry_by_key[source_key]
    raise ArgumentError, "Phase 2 source is not in the approved registry: #{source_key}" unless registry_source

    covered_show_ids = source.fetch('covered_show_ids')
    registered_show_ids = registry_source.fetch('expected_show_ids')
    unless covered_show_ids.sort == registered_show_ids.sort
      raise ArgumentError, "Phase 2 source coverage drifted from the approved registry: #{source_key}"
    end

    expected_tier = ListingFreshness.source_tier(
      registry_source.fetch('source_type'),
      registry_source.fetch('url')
    )
    unless source.fetch('source_tier') == expected_tier
      raise ArgumentError, "Phase 2 source tier does not match the approved registry: #{source_key}"
    end

    validate_policy_reference(source, policies, 'check_method', 'check_methods')
    validate_policy_reference(source, policies, 'expected_cadence', 'cadence_policies')
    validate_policy_reference(source, policies, 'constraints_policy', 'constraints')
    validate_policy_reference(source, policies, 'redirect_policy', 'redirects')
    validate_policy_reference(source, policies, 'fail_closed_policy', 'fail_closed')
    validate_safety_policies(source: source, policies: policies)

    expectations = source.fetch('expectations', {})
    unknown_expectation_ids = expectations.keys - covered_show_ids
    unless unknown_expectation_ids.empty?
      raise ArgumentError, "Phase 2 expectations are outside source coverage: #{source_key}"
    end
    unsupported_expectations = expectations.values - ALLOWED_EXPECTATIONS
    unless unsupported_expectations.empty?
      raise ArgumentError, "Phase 2 source has unsupported expectations: #{source_key}"
    end

    validate_source_review_rules(source: source, registry_source: registry_source)

    { profile: source, registry: registry_source }
  end

  def validate_policy_reference(source, policies, source_field, policy_group)
    reference = source.fetch(source_field)
    return if policies.fetch(policy_group).key?(reference)

    raise ArgumentError, "Unknown #{policy_group} policy for #{source.fetch('source_key')}: #{reference}"
  end

  def validate_safety_policies(source:, policies:)
    source_key = source.fetch('source_key')
    check_method = policies.fetch('check_methods').fetch(source.fetch('check_method'))
    cadence = policies.fetch('cadence_policies').fetch(source.fetch('expected_cadence'))
    constraints = policies.fetch('constraints').fetch(source.fetch('constraints_policy'))
    redirect = policies.fetch('redirects').fetch(source.fetch('redirect_policy'))
    fail_closed = policies.fetch('fail_closed').fetch(source.fetch('fail_closed_policy'))

    unless check_method.fetch('recurrence_inference') == false && check_method.fetch('cancellation_inference') == false
      raise ArgumentError, "Phase 2 inference must remain disabled: #{source_key}"
    end
    raise ArgumentError, "Phase 2 cadence must remain inactive: #{source_key}" unless cadence.fetch('activation') == 'inactive'
    unless constraints.fetch('copy_page_content') == false &&
           constraints.fetch('max_requests_per_source_path_per_run') == 1 &&
           constraints.fetch('credentials') == 'forbidden' &&
           constraints.fetch('forms_and_outreach') == 'forbidden'
      raise ArgumentError, "Phase 2 source constraints are unsafe: #{source_key}"
    end
    unless redirect.fetch('follow_redirects') == false && redirect.fetch('final_url_requires_manual_reapproval') == true
      raise ArgumentError, "Phase 2 redirect policy must record and stop: #{source_key}"
    end
    unless fail_closed.fetch('source_failure_is_cancellation') == false && fail_closed.fetch('automatic_action') == 'none'
      raise ArgumentError, "Phase 2 fail-closed policy is unsafe: #{source_key}"
    end
  end

  def validate_source_review_rules(source:, registry_source:)
    source_key = source.fetch('source_key')
    registry_url = registry_source.fetch('url')
    validate_request_url(source_key: source_key, request_url: source['request_url'], registry_url: registry_url) if source.key?('request_url')

    listing_rules = source.fetch('listing_rules', {})
    unless listing_rules.is_a?(Hash)
      raise ArgumentError, "Phase 2 listing rules must be a mapping: #{source_key}"
    end

    unknown_show_ids = listing_rules.keys - source.fetch('covered_show_ids')
    unless unknown_show_ids.empty?
      raise ArgumentError, "Phase 2 listing rules are outside source coverage: #{source_key}"
    end

    alias_owners = {}
    listing_rules.each do |show_id, rule|
      validate_listing_rule(
        source_key: source_key,
        show_id: show_id,
        rule: rule,
        registry_url: registry_url,
        alias_owners: alias_owners,
        single_event_page: source.fetch('covered_show_ids').length == 1 && source.fetch('page_shape').start_with?('single_event')
      )
    end
  end

  def validate_listing_rule(source_key:, show_id:, rule:, registry_url:, alias_owners:, single_event_page:)
    unless rule.is_a?(Hash)
      raise ArgumentError, "Phase 2 listing rule must be a mapping: #{source_key}/#{show_id}"
    end

    unknown_keys = rule.keys - ALLOWED_LISTING_RULE_KEYS
    unless unknown_keys.empty?
      raise ArgumentError, "Phase 2 listing rule has unsupported settings: #{source_key}/#{show_id}"
    end

    if rule.key?('request_url')
      validate_request_url(source_key: source_key, request_url: rule['request_url'], registry_url: registry_url)
    end
    validate_aliases(source_key: source_key, show_id: show_id, aliases: rule.fetch('aliases', []), alias_owners: alias_owners)
    validate_calendar_year(source_key: source_key, show_id: show_id, calendar_year: rule['calendar_year']) if rule.key?('calendar_year')
    validate_name_date_distance(source_key: source_key, show_id: show_id, distance: rule['max_name_date_distance']) if rule.key?('max_name_date_distance')
    validate_recurring_rule(source_key: source_key, show_id: show_id, rule: rule) if rule.key?('recurring_rule')
    if rule.key?('exact_date_anywhere_on_page')
      validate_exact_page_rule(source_key: source_key, show_id: show_id, rule: rule, single_event_page: single_event_page)
    end
  end

  def validate_request_url(source_key:, request_url:, registry_url:)
    request_uri = URI.parse(request_url.to_s)
    registry_uri = URI.parse(registry_url.to_s)
    valid_scheme = %w[http https].include?(request_uri.scheme)
    same_host = normalized_host(request_uri.host) == normalized_host(registry_uri.host)
    default_port = request_uri.scheme == 'https' ? 443 : 80
    return if valid_scheme && request_uri.host && same_host && request_uri.port == default_port &&
              request_uri.userinfo.nil? && request_uri.fragment.nil?

    raise ArgumentError, "Phase 2 request URL must be an approved same-host HTTP(S) URL: #{source_key}"
  rescue URI::InvalidURIError
    raise ArgumentError, "Phase 2 request URL is invalid: #{source_key}"
  end

  def validate_aliases(source_key:, show_id:, aliases:, alias_owners:)
    unless aliases.is_a?(Array) && aliases.all? { |name| name.is_a?(String) && !name.strip.empty? }
      raise ArgumentError, "Phase 2 aliases must be non-empty literal strings: #{source_key}/#{show_id}"
    end

    aliases.each do |name|
      normalized = normalized_name(name)
      owner = alias_owners[normalized]
      if owner && owner != show_id
        raise ArgumentError, "Phase 2 alias is ambiguous between listings: #{source_key}/#{show_id}"
      end

      alias_owners[normalized] = show_id
    end
  end

  def validate_calendar_year(source_key:, show_id:, calendar_year:)
    return if calendar_year.is_a?(Integer) && calendar_year.between?(2000, 2100)

    raise ArgumentError, "Phase 2 calendar year must be an integer from 2000 to 2100: #{source_key}/#{show_id}"
  end

  def validate_name_date_distance(source_key:, show_id:, distance:)
    return if distance.is_a?(Integer) && distance.between?(1, 320)

    raise ArgumentError, "Phase 2 source-specific name/date distance must be an integer from 1 to 320: #{source_key}/#{show_id}"
  end

  def validate_recurring_rule(source_key:, show_id:, rule:)
    unless rule.key?('request_url')
      raise ArgumentError, "Phase 2 recurring rule requires an exact per-listing request URL: #{source_key}/#{show_id}"
    end

    recurring_rule = rule.fetch('recurring_rule')
    unless recurring_rule.is_a?(Hash) && (recurring_rule.keys - ALLOWED_RECURRING_RULE_KEYS).empty?
      raise ArgumentError, "Phase 2 recurring rule has unsupported settings: #{source_key}/#{show_id}"
    end

    ordinal = recurring_rule['ordinal']
    weekday = recurring_rule['weekday']
    phrases = recurring_rule['source_phrases']
    valid_phrases = phrases.is_a?(Array) && !phrases.empty? &&
                    phrases.all? { |phrase| phrase.is_a?(String) && !phrase.strip.empty? }
    return if ordinal.is_a?(Integer) && ordinal.between?(1, 5) && Date::DAYNAMES.include?(weekday) && valid_phrases

    raise ArgumentError, "Phase 2 recurring rule must use an ordinal, weekday, and literal source phrases: #{source_key}/#{show_id}"
  end

  def validate_exact_page_rule(source_key:, show_id:, rule:, single_event_page:)
    return if rule.fetch('exact_date_anywhere_on_page') == true && rule.key?('request_url') && single_event_page

    raise ArgumentError, "Phase 2 whole-page date matching requires an exact single-event request path: #{source_key}/#{show_id}"
  end

  def normalized_host(host)
    host.to_s.downcase.sub(/\Awww\./, '')
  end

  def normalized_name(name)
    name.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  end
end
