require 'uri'
require 'yaml'

module ShowSourcePolicy
  CONFIG_PATH = File.expand_path('../_scrapers/approved-show-sources.yml', __dir__)
  LEAD_ONLY_SOURCE_DOMAINS = %w[coinzip.com coinshows-usa.com].freeze

  config = YAML.load_file(CONFIG_PATH)
  APPROVED_DOMAINS = config.fetch('approved_domains').map { |domain| domain.downcase.sub(/^www\./, '') }.freeze
  APPROVED_URL_PREFIXES = config.fetch('approved_url_prefixes').freeze

  def self.public_http_uri(url)
    uri = URI.parse(url.to_s.strip)
    return nil unless %w[http https].include?(uri.scheme) && !uri.host.to_s.empty?

    uri
  rescue URI::InvalidURIError
    nil
  end

  def self.normalized_host(uri)
    uri.host.to_s.downcase.sub(/^www\./, '')
  end

  def self.lead_only_source_uri?(uri)
    host = normalized_host(uri)
    LEAD_ONLY_SOURCE_DOMAINS.any? { |domain| host == domain || host.end_with?(".#{domain}") }
  end

  def self.approved_prefix?(uri)
    path = uri.path.to_s
    return false if path.include?('\\')
    return false if path.match?(/%(?:25)*(?:2e|2f|5c)/i)
    return false if path.split('/').any? { |segment| %w[. ..].include?(segment) }

    APPROVED_URL_PREFIXES.any? do |prefix|
      approved_uri = public_http_uri(prefix)
      next false unless approved_uri
      next false unless uri.scheme == approved_uri.scheme
      next false unless normalized_host(uri) == normalized_host(approved_uri)

      uri.path.start_with?(approved_uri.path)
    end
  end

  def self.approved_source_url?(url)
    uri = public_http_uri(url)
    return false unless uri
    return false if lead_only_source_uri?(uri)

    APPROVED_DOMAINS.include?(normalized_host(uri)) || approved_prefix?(uri)
  end

  def self.source_url_for(show)
    source_url = show.fetch('source_url', '').to_s.strip
    return source_url if approved_source_url?(source_url)

    website = show.fetch('website', '').to_s.strip
    return website if approved_source_url?(website)

    ''
  end
end
