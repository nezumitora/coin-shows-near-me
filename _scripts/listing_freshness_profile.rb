# frozen_string_literal: true

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

    expectations = source.fetch('expectations', {})
    unknown_expectation_ids = expectations.keys - covered_show_ids
    unless unknown_expectation_ids.empty?
      raise ArgumentError, "Phase 2 expectations are outside source coverage: #{source_key}"
    end
    unsupported_expectations = expectations.values - ALLOWED_EXPECTATIONS
    unless unsupported_expectations.empty?
      raise ArgumentError, "Phase 2 source has unsupported expectations: #{source_key}"
    end

    { profile: source, registry: registry_source }
  end

  def validate_policy_reference(source, policies, source_field, policy_group)
    reference = source.fetch(source_field)
    return if policies.fetch(policy_group).key?(reference)

    raise ArgumentError, "Unknown #{policy_group} policy for #{source.fetch('source_key')}: #{reference}"
  end
end
