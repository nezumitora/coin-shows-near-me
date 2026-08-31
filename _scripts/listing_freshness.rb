# frozen_string_literal: true

require 'date'
require_relative 'show_date_parser'
require_relative 'show-data-trust-audit'

module ListingFreshness
  RISK_RANK = {
    'urgent' => 0,
    'high' => 1,
    'medium' => 2,
    'routine' => 3
  }.freeze

  module_function

  def parse_iso_date(value)
    Date.iso8601(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end

  def normalized(value)
    value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  end

  def truthy?(value)
    value == true || value.to_s.casecmp('true').zero?
  end

  def source_tier(source_type, source_url)
    normalized_type = source_type.to_s.downcase.tr('_', '-')
    return 'none' if source_url.to_s.empty?
    return 'controlled_fixture' if normalized_type == 'controlled-fixture'
    return 'lead_only' if normalized_type.include?('third-party')
    return 'tier_1_direct' if normalized_type == 'direct-promoter-submission'
    return 'tier_1_primary' if normalized_type.match?(/organizer|promoter|official-show/)
    return 'tier_2_official_organization' if normalized_type.match?(/club|association/)
    return 'tier_2_official_venue' if normalized_type.include?('venue')

    'tier_3_approved_unclassified'
  end

  def event_context(show, as_of:)
    upcoming_dates = Array(show['upcoming_dates']).map { |value| parse_iso_date(value) }.compact.sort
    current_or_future = upcoming_dates.select { |date| date >= as_of }

    unless current_or_future.empty?
      event_date = current_or_future.first
      return {
        date_status: 'scheduled',
        event_date: event_date,
        days_until_event: (event_date - as_of).to_i
      }
    end

    date_text = show.fetch('next_date', '').to_s.strip
    return { date_status: 'tbd', event_date: nil, days_until_event: nil } if date_text.empty? || date_text == 'TBD'
    return { date_status: 'partial', event_date: nil, days_until_event: nil } if ShowDateParser.partial_date?(date_text)

    date_range = ShowDateParser.date_range(date_text)
    return { date_status: 'invalid', event_date: nil, days_until_event: nil } unless date_range

    start_date, finish_date = date_range
    if finish_date < as_of
      {
        date_status: 'past',
        event_date: finish_date,
        days_until_event: (finish_date - as_of).to_i
      }
    else
      event_date = [start_date, as_of].max
      {
        date_status: 'scheduled',
        event_date: event_date,
        days_until_event: (event_date - as_of).to_i
      }
    end
  end

  def baseline_policy(event)
    days_until = event.fetch(:days_until_event)

    if event.fetch(:date_status) == 'scheduled'
      return ['every_2_to_3_days', 2] if days_until <= 2
      return ['every_2_to_3_days', 3] if days_until <= 30
      return ['weekly', 7] if days_until <= 90

      return ['monthly', 30]
    end

    return ['weekly_stale_queue', 7] if event.fetch(:date_status) == 'past'

    ['monthly_unconfirmed_queue', 30]
  end

  def due_on(as_of:, last_verified:, event:, interval_days:, conflict_reasons:)
    return as_of if last_verified.nil? || !conflict_reasons.empty?

    candidates = [last_verified + interval_days]
    if event.fetch(:date_status) == 'scheduled'
      event_date = event.fetch(:event_date)
      [21, 7, 2].each do |days_before|
        milestone = event_date - days_before
        candidates << milestone if milestone > last_verified
      end
    end

    candidates.min
  end

  def risk_level(event:, source_url:, conflict_reasons:)
    days_until = event.fetch(:days_until_event)
    date_status = event.fetch(:date_status)

    return 'urgent' if !conflict_reasons.empty? && days_until&.between?(0, 30)
    return 'urgent' if date_status == 'scheduled' && days_until <= 2
    return 'high' unless conflict_reasons.empty?
    return 'high' if %w[past invalid].include?(date_status)
    return 'high' if date_status == 'scheduled' && days_until <= 30
    return 'high' if source_url.to_s.empty? && days_until&.between?(0, 90)
    return 'medium' if date_status == 'scheduled' && days_until <= 90
    return 'medium' if %w[tbd partial].include?(date_status) || source_url.to_s.empty?

    'routine'
  end

  def reason_codes(event:, last_verified:, due_date:, as_of:, source_url:, conflict_reasons:)
    reasons = []
    date_status = event.fetch(:date_status)
    days_until = event.fetch(:days_until_event)

    if date_status == 'scheduled'
      reasons << if days_until <= 2
                   'event_within_2_days'
                 elsif days_until <= 7
                   'event_within_7_days'
                 elsif days_until <= 21
                   'event_within_21_days'
                 elsif days_until <= 30
                   'event_within_30_days'
                 elsif days_until <= 90
                   'event_31_to_90_days'
                 else
                   'event_over_90_days'
                 end
    else
      reasons << "date_#{date_status}"
    end

    reasons << 'verification_missing' if last_verified.nil?
    reasons << 'verification_due_by_policy' if due_date <= as_of
    reasons << 'approved_source_missing' if source_url.to_s.empty?
    reasons.concat(conflict_reasons)
    reasons.uniq
  end

  def classify(show:, as_of:, source_url:, source_type:, conflict_reasons: [])
    event = event_context(show, as_of: as_of)
    last_verified = parse_iso_date(show['last_verified'])
    last_verified = nil if last_verified && last_verified > as_of
    baseline_cadence, interval_days = baseline_policy(event)
    due_date = due_on(
      as_of: as_of,
      last_verified: last_verified,
      event: event,
      interval_days: interval_days,
      conflict_reasons: conflict_reasons
    )
    due_status = if due_date <= as_of
                   'due_now'
                 elsif due_date <= as_of + 7
                   'due_within_7_days'
                 else
                   'scheduled_later'
                 end

    {
      show_id: show.fetch('id'),
      show_name: show.fetch('name'),
      city: show.fetch('city'),
      state: show.fetch('state'),
      current_next_date: show.fetch('next_date', '').to_s,
      date_status: event.fetch(:date_status),
      event_date: event.fetch(:event_date)&.iso8601.to_s,
      days_until_event: event.fetch(:days_until_event),
      last_verified: last_verified&.iso8601.to_s,
      verification_age_days: last_verified ? (as_of - last_verified).to_i : nil,
      source_url: source_url.to_s,
      source_type: source_type.to_s.empty? ? 'unclassified' : source_type.to_s,
      source_tier: source_tier(source_type, source_url),
      source_conflict: !conflict_reasons.empty?,
      risk_level: risk_level(event: event, source_url: source_url, conflict_reasons: conflict_reasons),
      baseline_cadence: baseline_cadence,
      review_cadence: conflict_reasons.empty? ? baseline_cadence : 'immediate_conflict_review',
      review_due_on: due_date.iso8601,
      due_status: due_status,
      reason_codes: reason_codes(
        event: event,
        last_verified: last_verified,
        due_date: due_date,
        as_of: as_of,
        source_url: source_url,
        conflict_reasons: conflict_reasons
      ),
      human_action: 'review_evidence_before_any_listing_change',
      automatic_action: 'none'
    }
  end

  def successful_fetch?(status)
    status.to_s.match?(/\A2\d\d\z/)
  end

  def external_outcome(row)
    return 'source_unavailable' unless successful_fetch?(row['fetch_status'])
    if truthy?(row['cancellation_evidence']) &&
       truthy?(row['name_found']) &&
       !row['cancellation_evidence_detail'].to_s.strip.empty?
      return 'cancellation_evidence'
    end
    return 'current_match' if truthy?(row['name_found']) && truthy?(row['current_date_found'])
    return 'candidate_change' if truthy?(row['name_found']) && !row['candidate_dates'].to_s.empty?

    'review_conflict'
  end

  def build_source_fact(row:, show:, source_type:, source_url:, fetched_at:, pilot:, expectation: nil, controlled: false)
    outcome = external_outcome(row)
    candidates = row['candidate_dates'].to_s
    candidate_values = candidates.split(';').map(&:strip).reject(&:empty?)
    current_value = row['current_next_date'].to_s

    field, proposed_value, status, confidence, conflict_reason, human_action = case outcome
                                                                            when 'current_match'
                                                                              ['next_date', current_value, 'no_change_observed', 'high', '', 'none_for_current_value']
                                                                            when 'candidate_change'
                                                                              confidence = pilot && candidate_values.length == 1 ? 'medium' : 'low'
                                                                              reason = 'Approved source has date candidates, but the current date was not associated reliably.'
                                                                              exact_candidate = candidate_values.length == 1 ? candidate_values.first : ''
                                                                              ['next_date', exact_candidate, 'candidate_difference', confidence, reason, 'compare_source_and_current_dates']
                                                                            when 'cancellation_evidence'
                                                                              reason = row['cancellation_evidence_detail'].to_s.strip
                                                                              ['listing_status', 'cancellation_review_required', 'cancellation_evidence', 'medium', reason, 'verify_authoritative_cancellation_before_any_listing_change']
                                                                            when 'source_unavailable'
                                                                              reason = "Source fetch returned #{row['fetch_status']} #{row['fetch_detail']}; this is not cancellation evidence."
                                                                              ['source_availability', '', 'source_availability_review', 'none', reason, 'check_source_manually_without_removing_listing']
                                                                            else
                                                                              reason = 'Show identity or date could not be associated reliably; wording or parser review is required.'
                                                                              ['listing_identity', candidates, 'insufficient_evidence', 'low', reason, 'inspect_source_and_parser_match']
                                                                            end

    expectation_matches = expectation.nil? ? nil : expectation == outcome
    false_positive = !expectation.nil? &&
                     %w[candidate_change cancellation_evidence].include?(outcome) &&
                     expectation != outcome
    false_negative = !expectation.nil? &&
                     %w[current_match candidate_change cancellation_evidence].include?(expectation) &&
                     expectation != outcome
    source_key = row['source_key'].to_s
    show_id = row['show_id'].to_s

    fact = {
      proposal_id: "#{source_key}:#{show_id}:#{field}",
      source_key: source_key,
      show_id: show_id,
      show_name: show ? show.fetch('name') : row['show_name'].to_s,
      field: field,
      current_value: current_value,
      proposed_value: proposed_value,
      source_candidate_values: candidate_values,
      proposal_status: status,
      risk_level: %w[candidate_change cancellation_evidence].include?(outcome) ? 'high' : 'medium',
      source_tier: source_tier(source_type, source_url),
      source_type: source_type.to_s,
      source_url: source_url.to_s,
      fetched_at: fetched_at.to_s,
      fetch_status: row['fetch_status'].to_s,
      fetch_detail: row['fetch_detail'].to_s,
      redirect_target: row['redirect_target'].to_s,
      name_found: truthy?(row['name_found']),
      current_date_found: truthy?(row['current_date_found']),
      candidate_count: candidate_values.length,
      cancellation_evidence: truthy?(row['cancellation_evidence']),
      cancellation_evidence_detail: row['cancellation_evidence_detail'].to_s,
      confidence: confidence,
      conflict_reason: conflict_reason,
      pilot_source: pilot,
      manual_expectation: expectation.to_s,
      actual_outcome: outcome,
      expectation_matches: expectation_matches,
      false_positive: false_positive,
      false_negative: false_negative,
      controlled_case: controlled,
      eligible_for_change_proposal: !controlled && pilot && expectation == 'candidate_change' && outcome == 'candidate_change',
      human_action: controlled ? 'controlled_case_only_no_listing_change' : human_action,
      automatic_action: 'none'
    }

    fact[:cause_code] = source_fact_cause(fact)
    fact
  end

  def source_fact_cause(fact)
    case fact.fetch(:proposal_status)
    when 'no_change_observed'
      'current_value_observed_on_source'
    when 'candidate_difference'
      candidate_difference_cause(fact)
    when 'source_availability_review'
      source_availability_cause(fact.fetch(:fetch_status))
    when 'cancellation_evidence'
      'explicit_authoritative_cancellation_evidence'
    when 'insufficient_evidence'
      if fact.fetch(:candidate_count).positive?
        'show_name_not_associated_with_page_dates'
      else
        'show_name_not_associated_no_dates_extracted'
      end
    else
      'unclassified_source_fact'
    end
  end

  def candidate_difference_cause(fact)
    current_value = fact.fetch(:current_value).to_s
    candidates = Array(fact.fetch(:source_candidate_values, fact.fetch(:proposed_value, '')))
                 .flat_map { |value| value.to_s.split(';') }
                 .map(&:strip)
                 .reject(&:empty?)

    return 'current_tbd_with_candidates' if current_value.casecmp('TBD').zero?
    if candidates.any? { |candidate| normalized(candidate) == normalized(current_value) }
      return 'current_value_present_but_not_associated'
    end
    return 'multiple_page_dates_need_event_association' if candidates.length > 1

    'single_different_candidate'
  end

  def source_availability_cause(status)
    value = status.to_s
    return 'redirect_response_not_followed' if value.match?(/\A3\d\d\z/)
    return 'access_blocked' if %w[401 403].include?(value)
    return 'source_rate_limited' if value == '429'
    return 'source_path_not_found' if %w[404 410].include?(value)
    return 'source_server_error' if value.match?(/\A5\d\d\z/)
    return 'network_or_transport_error' if value == 'error'

    'other_source_availability_failure'
  end

  def duplicate_candidates(shows)
    shows_by_id = shows.to_h { |show| [show.fetch('id'), show] }

    ShowDataTrustAudit.duplicate_candidates(shows).map do |candidate|
      left_id, right_id = candidate.listing_ids
      left = shows_by_id.fetch(left_id)
      right = shows_by_id.fetch(right_id)

      {
        left_id: left_id,
        left_name: left.fetch('name'),
        left_url: "/shows/#{left_id}/",
        right_id: right_id,
        right_name: right.fetch('name'),
        right_url: "/shows/#{right_id}/",
        city: left.fetch('city'),
        state: left.fetch('state'),
        classification: candidate.classification,
        confidence: candidate.confidence,
        reason: candidate.reason,
        human_action: 'review_possible_duplicate_without_merging',
        automatic_action: 'none'
      }
    end
  end
end
