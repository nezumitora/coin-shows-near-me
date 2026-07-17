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
end
