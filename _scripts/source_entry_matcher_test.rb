require 'minitest/autorun'
require_relative 'source_entry_matcher'

class SourceEntryMatcherTest < Minitest::Test
  PEER_NAMES = ['Tri-State Coin Show', 'Omaha Monthly Show'].freeze

  def test_rejects_date_belonging_to_a_different_show
    source = 'Feb. 15 Tri-State Coin Show. Oct. 18 Omaha Monthly Show.'

    refute SourceEntryMatcher.date_associated?(source, 'Tri-State Coin Show', PEER_NAMES, 'October 18, 2026', 2026)
  end

  def test_accepts_date_nearest_to_target_show
    source = 'Oct. 18 Tri-State Coin Show. Nov. 15 Omaha Monthly Show.'

    assert SourceEntryMatcher.date_associated?(source, 'Tri-State Coin Show', PEER_NAMES, 'October 18, 2026', 2026)
  end

  def test_accepts_ordinal_range_nearest_to_target_show
    source = 'Wilkes-Barre Coin Show October 10th and 11th 2026. Scranton Coin Show April 18 and 19 2026.'
    peers = ['Wilkes-Barre Coin Show', 'Scranton Coin Show']

    assert SourceEntryMatcher.date_associated?(source, 'Wilkes-Barre Coin Show', peers, 'October 10-11, 2026')
  end

  def test_rejects_date_too_far_from_target_name
    source = "Aug. 30 #{'details ' * 30}Decorah Area Coin Club Show"

    refute SourceEntryMatcher.date_associated?(source, 'Decorah Area Coin Club Show', ['Decorah Area Coin Club Show'], 'August 30, 2026', 2026)
  end

  def test_accepts_a_literal_source_specific_name_alias
    source = 'NOW State Convention April 25, 2027 at Stadium View.'

    assert SourceEntryMatcher.date_associated?(
      source,
      'Numismatists of Wisconsin Annual Show',
      [],
      'April 25, 2027',
      nil,
      target_aliases: ['NOW State Convention']
    )
  end

  def test_peer_alias_prevents_cross_event_association
    source = 'NOW State Convention April 25, 2027. Registration details follow for visitors and dealers. Milwaukee Coin Show November 8, 2026.'

    refute SourceEntryMatcher.date_associated?(
      source,
      'Milwaukee Numismatic Society Show',
      ['Numismatists of Wisconsin Annual Show'],
      'April 25, 2027',
      nil,
      target_aliases: ['Milwaukee Coin Show'],
      peer_aliases: { 'Numismatists of Wisconsin Annual Show' => ['NOW State Convention'] }
    )
  end

  def test_validates_current_date_against_an_explicit_nth_weekday_rule
    rule = {
      'ordinal' => 4,
      'weekday' => 'Sunday',
      'source_phrases' => ['every fourth Sunday']
    }

    assert SourceEntryMatcher.current_date_matches_nth_weekday_rule?(
      'The Trevose show is held every fourth Sunday of the month.',
      'September 27, 2026',
      rule
    )
    refute SourceEntryMatcher.current_date_matches_nth_weekday_rule?(
      'The Trevose show is held every fourth Sunday of the month.',
      'September 20, 2026',
      rule
    )
    refute SourceEntryMatcher.current_date_matches_nth_weekday_rule?(
      'Monthly show schedule.',
      'September 27, 2026',
      rule
    )
  end

  def test_accepts_a_bounded_source_specific_name_date_distance
    source = "North Metro#{' details' * 20} November 1st"

    refute SourceEntryMatcher.date_associated?(
      source,
      'North Metro Coin Show',
      [],
      'November 1, 2026',
      2026,
      target_aliases: ['North Metro']
    )
    assert SourceEntryMatcher.date_associated?(
      source,
      'North Metro Coin Show',
      [],
      'November 1, 2026',
      2026,
      target_aliases: ['North Metro'],
      max_name_date_distance: 200
    )
  end
end
