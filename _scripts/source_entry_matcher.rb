# frozen_string_literal: true

require_relative 'source_date_matcher'

module SourceEntryMatcher
  MAX_NAME_DATE_DISTANCE = 160

  module_function

  def date_associated?(source_text, target_name, peer_names, current_date_text, calendar_year = nil)
    target_positions = phrase_positions(source_text, target_name)
    return false if target_positions.empty?

    dated_positions = SourceDateMatcher.match_positions(source_text, current_date_text, calendar_year)
    return false if dated_positions.empty?

    names = (Array(peer_names) + [target_name]).uniq
    named_positions = names.flat_map do |name|
      phrase_positions(source_text, name).map { |position| [name, position] }
    end

    dated_positions.any? do |date_position|
      nearest_name, nearest_position = named_positions.min_by { |_name, position| (position - date_position).abs }
      nearest_name == target_name && (nearest_position - date_position).abs <= MAX_NAME_DATE_DISTANCE
    end
  end

  def phrase_positions(source_text, phrase)
    pattern = Regexp.new(Regexp.escape(phrase.to_s), Regexp::IGNORECASE)
    source_text.to_s.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
  end
end
