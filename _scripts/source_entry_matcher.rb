# frozen_string_literal: true

require_relative 'source_date_matcher'
require_relative 'show_date_parser'

module SourceEntryMatcher
  MAX_NAME_DATE_DISTANCE = 160

  module_function

  def date_associated?(source_text, target_name, peer_names, current_date_text, calendar_year = nil,
                       target_aliases: [], peer_aliases: {}, max_name_date_distance: MAX_NAME_DATE_DISTANCE)
    target_names = literal_names([target_name] + Array(target_aliases))
    peer_name_groups = Array(peer_names).map do |peer_name|
      literal_names([peer_name] + Array(peer_aliases[peer_name]))
    end.reject { |peer_group| !(peer_group & target_names).empty? }
    date_associated_for_names?(
      source_text,
      target_names,
      peer_name_groups,
      current_date_text,
      calendar_year,
      max_name_date_distance
    )
  end

  def date_associated_for_names?(source_text, target_names, peer_name_groups, current_date_text, calendar_year = nil,
                                 max_name_date_distance = MAX_NAME_DATE_DISTANCE)
    target_names = literal_names(target_names)
    target_positions = target_names.flat_map { |name| phrase_positions(source_text, name) }
    return false if target_positions.empty?

    dated_positions = SourceDateMatcher.match_positions(source_text, current_date_text, calendar_year)
    return false if dated_positions.empty?

    named_positions = target_names.flat_map do |name|
      phrase_positions(source_text, name).map { |position| [:target, position] }
    end
    Array(peer_name_groups).each_with_index do |names, index|
      literal_names(names).each do |name|
        phrase_positions(source_text, name).each { |position| named_positions << [index, position] }
      end
    end

    dated_positions.any? do |date_position|
      nearest_distance = named_positions.map { |_owner, position| (position - date_position).abs }.min
      next false if nearest_distance > max_name_date_distance

      nearest_owners = named_positions.each_with_object([]) do |owned_position, owners|
        owner, position = owned_position
        owners << owner if (position - date_position).abs == nearest_distance
      end
      nearest_owners.include?(:target) && nearest_owners.all? { |owner| owner == :target }
    end
  end

  def name_found?(source_text, names)
    literal_names(names).any? { |name| !phrase_positions(source_text, name).empty? }
  end

  def current_date_matches_nth_weekday_rule?(source_text, current_date_text, rule)
    date_range = ShowDateParser.date_range(current_date_text)
    return false unless date_range && date_range.first == date_range.last

    phrases = Array(rule.fetch('source_phrases'))
    normalized_source = normalized_phrase(source_text)
    return false unless phrases.any? { |phrase| normalized_source.include?(normalized_phrase(phrase)) }

    date = date_range.first
    ordinal = ((date.day - 1) / 7) + 1
    weekday = Date::DAYNAMES.fetch(date.wday)
    ordinal == rule.fetch('ordinal').to_i && weekday.casecmp?(rule.fetch('weekday').to_s)
  end

  def phrase_positions(source_text, phrase)
    pattern = Regexp.new(Regexp.escape(phrase.to_s), Regexp::IGNORECASE)
    source_text.to_s.enum_for(:scan, pattern).map { Regexp.last_match.begin(0) }
  end

  def literal_names(names)
    Array(names).map(&:to_s).map(&:strip).reject(&:empty?).uniq
  end

  def normalized_phrase(value)
    value.to_s.downcase.gsub(/[^a-z0-9]+/, ' ').strip
  end
end
