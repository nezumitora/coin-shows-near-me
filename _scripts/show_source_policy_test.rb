require 'minitest/autorun'
require_relative 'show_source_policy'

class ShowSourcePolicyTest < Minitest::Test
  def test_accepts_registered_domain
    assert ShowSourcePolicy.approved_source_url?('https://michigancoinclub.org/local_shows/')
  end

  def test_rejects_unregistered_and_lead_only_domains
    refute ShowSourcePolicy.approved_source_url?('https://example.com/show')
    refute ShowSourcePolicy.approved_source_url?('https://coinzip.com/show/1234')
  end

  def test_shared_host_requires_approved_page_prefix
    assert ShowSourcePolicy.approved_source_url?('https://www.facebook.com/SouthBaldwinNumismaticSociety/events/')
    refute ShowSourcePolicy.approved_source_url?('https://www.facebook.com/UnreviewedCoinShow/')
    refute ShowSourcePolicy.approved_source_url?('https://www.facebook.com.evil.example/SouthBaldwinNumismaticSociety/')
    refute ShowSourcePolicy.approved_source_url?('https://www.facebook.com/SouthBaldwinNumismaticSociety/../UnreviewedCoinShow/')
    refute ShowSourcePolicy.approved_source_url?('https://www.facebook.com/SouthBaldwinNumismaticSociety/%2e%2e/UnreviewedCoinShow/')
    refute ShowSourcePolicy.approved_source_url?('https://www.facebook.com/SouthBaldwinNumismaticSociety/%252e%252e/UnreviewedCoinShow/')
  end

  def test_prefers_approved_source_url_and_falls_back_to_approved_website
    show = {
      'source_url' => 'https://example.com/unreviewed',
      'website' => 'https://cupertinocoinclub.org/show/'
    }

    assert_equal 'https://cupertinocoinclub.org/show/', ShowSourcePolicy.source_url_for(show)
  end

  def test_returns_blank_without_registry_approved_evidence
    show = {
      'source_url' => 'javascript:alert(1)',
      'website' => 'https://example.com/unreviewed'
    }

    assert_equal '', ShowSourcePolicy.source_url_for(show)
  end
end
