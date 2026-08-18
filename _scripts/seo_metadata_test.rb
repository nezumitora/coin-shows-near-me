# frozen_string_literal: true

require 'minitest/autorun'
require 'yaml'

class SeoMetadataTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  CONFIG = YAML.load_file(File.join(ROOT, '_config.yml'))
  HOMEPAGE_LAYOUT = File.read(File.join(ROOT, '_layouts/homepage.html'))
  WEEKEND_LAYOUT = File.read(File.join(ROOT, '_layouts/weekend.html'))
  HEAD_CUSTOM = File.read(File.join(ROOT, '_includes/head_custom.html'))
  SITE_TITLE_SUFFIX = " | #{CONFIG.fetch('title')}"
  MAX_RENDERED_TITLE_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 160

  def source_pages
    @source_pages ||= Dir.glob(File.join(ROOT, '**', '*.{md,html}')).each_with_object([]) do |path, pages|
      next unless File.file?(path)

      text = File.read(path)
      match = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
      next unless match

      data = YAML.safe_load(match[1], [], [], true)
      pages << [path, data] if data.is_a?(Hash)
    end
  end

  def indexable_pages
    source_pages.select do |_path, data|
      data['permalink'] && data['layout'] && data['published'] != false && data['sitemap'] != false && data['permalink'] != '/404.html'
    end
  end

  def rendered_title(data)
    if data.fetch('permalink') == '/'
      "#{CONFIG.fetch('title')} | #{CONFIG.fetch('tagline')}"
    else
      data.fetch('title') + SITE_TITLE_SUFFIX
    end
  end

  def test_jekyll_seo_tag_is_the_only_metadata_emitter
    refute File.exist?(File.join(ROOT, '_includes/seo-meta.html'))
    refute_includes HEAD_CUSTOM, 'seo-meta.html'
    assert_equal 1, HOMEPAGE_LAYOUT.scan(/\{%\s*seo\s*%\}/).length
    refute_match(/<title>/, HOMEPAGE_LAYOUT)
  end

  def test_front_matter_uses_standard_seo_fields
    source_pages.each do |path, data|
      refute data.key?('seo_title'), "legacy seo_title remains in #{path}"
      refute data.key?('seo_description'), "legacy seo_description remains in #{path}"
    end
  end

  def test_weekend_intro_uses_standard_description
    assert_includes WEEKEND_LAYOUT, 'page.description'
    refute_includes WEEKEND_LAYOUT, 'page.seo_description'
  end

  def test_indexable_page_titles_and_descriptions_are_concise_and_unique
    titles = {}
    descriptions = {}

    indexable_pages.each do |path, data|
      title = rendered_title(data)
      description = data.fetch('description')

      assert_operator title.length, :<=, MAX_RENDERED_TITLE_LENGTH, "title is too long in #{path}: #{title}"
      assert_operator description.length, :<=, MAX_DESCRIPTION_LENGTH, "description is too long in #{path}"
      refute titles.key?(title), "duplicate title in #{path} and #{titles[title]}: #{title}"
      refute descriptions.key?(description), "duplicate description in #{path} and #{descriptions[description]}"

      titles[title] = path
      descriptions[description] = path
    end
  end

  def test_default_social_image_is_explicit
    default_values = CONFIG.fetch('defaults').first.fetch('values')
    image = default_values.fetch('image')

    assert_equal '/assets/images/logo.png', image.fetch('path')
    assert_equal 1254, image.fetch('width')
    assert_equal 1254, image.fetch('height')
    refute_empty image.fetch('alt')
  end

  def test_oversized_brand_images_are_not_referenced_by_pages_or_layouts
    public_sources = Dir.glob(File.join(ROOT, '**', '*.{html,md,yml}')).select { |path| File.file?(path) }
    references = public_sources.to_h { |path| [path, File.read(path)] }

    references.each do |path, content|
      refute_includes content, 'coinshows-buffalo-head-front-transparent-gold-navy.png', path
      refute_includes content, 'coinshows-shield-transparent-20260625.png', path
    end

    assert_includes HEAD_CUSTOM, 'public-hero::after'
    refute_includes File.read(File.join(ROOT, '_layouts/default.html')), 'public-hero-logo'
  end
end
