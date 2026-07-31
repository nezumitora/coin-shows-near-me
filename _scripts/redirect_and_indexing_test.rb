# frozen_string_literal: true

require 'minitest/autorun'
require 'yaml'

class RedirectAndIndexingTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  EXPECTED_REDIRECTS = {
    'westland-mi' => 'warren-mi',
    'south-st-paul-mn' => 'south-saint-paul-mn',
    'sept-17th-19th-countryside-il' => 'countryside-il',
    'des-moines-ia' => 'altoona-ia',
    'july-11th-2026-big-flats-ny' => 'big-flats-ny',
    'charlotte-nc' => 'middleton-wi',
    'creating-collectors-co' => 'tucson-az'
  }.freeze

  def test_exact_city_redirects_are_noindex_and_canonicalized
    redirects = YAML.load_file(File.join(ROOT, '_data/city_redirects.yml'))
    redirect_map = redirects.to_h { |redirect| [redirect.fetch('legacy_slug'), redirect.fetch('canonical_slug')] }
    canonical_cities = YAML.load_file(File.join(ROOT, '_data/shows.yml')).map { |show| show.fetch('city_slug') }.uniq

    assert_equal EXPECTED_REDIRECTS, redirect_map
    assert_empty redirect_map.keys & canonical_cities
    assert_empty redirect_map.values - canonical_cities
    assert_empty redirect_map.values & redirect_map.keys

    redirect_map.each do |legacy_slug, canonical_slug|
      page = File.read(File.join(ROOT, 'cities', "#{legacy_slug}.md"))
      assert_includes page, 'sitemap: false'
      assert_includes page, '<meta name="robots" content="noindex,follow">'
      assert_includes page, "url={{ site.baseurl }}/cities/#{canonical_slug}/"
      assert_includes page, "href=\"{{ site.url }}{{ site.baseurl }}/cities/#{canonical_slug}/\""
    end
  end

  def test_widget_stays_published_but_is_not_indexed
    widget = File.read(File.join(ROOT, 'widget.html'))

    assert_includes widget, 'permalink: /widget.html'
    assert_includes widget, 'sitemap: false'
    assert_includes widget, '<meta name="robots" content="noindex,follow">'
    assert_includes widget, 'show.name'
    refute_includes widget, 'show.show_name'
    refute_includes widget, 'show.website_url'
  end

  def test_tucson_record_no_longer_uses_the_malformed_city
    shows = YAML.load_file(File.join(ROOT, '_data/shows.yml'))
    tucson_expo = shows.find { |show| show.fetch('id') == 'tucson-coin-and-currency-expo' }

    assert_equal 'AZ', tucson_expo.fetch('state')
    assert_equal 'Tucson', tucson_expo.fetch('city')
    assert_equal 'tucson-az', tucson_expo.fetch('city_slug')
    assert_equal 'https://tucsoncoinshow.com/', tucson_expo.fetch('source_url')
    refute_includes shows.map { |show| show.fetch('city_slug') }, 'creating-collectors-co'
  end
end
