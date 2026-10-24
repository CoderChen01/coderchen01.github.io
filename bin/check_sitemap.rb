#!/usr/bin/env ruby
# Validate the generated sitemap and its discovery URL before publishing Pages.
require "jekyll"
require "nokogiri"
require "uri"

config = Jekyll.configuration("quiet" => true)
destination = File.expand_path(ARGV.fetch(0, config["destination"]))
canonical_root = "#{config['url']}#{config['baseurl']}".delete_suffix("/")
namespace = { "s" => "http://www.sitemaps.org/schemas/sitemap/0.9" }
document = Nokogiri::XML(File.binread(File.join(destination, "sitemap.xml"))) { |xml| xml.strict.nonet }
abort "Sitemap must have a namespaced urlset root" unless document.root&.name == "urlset" && document.root.namespace&.href == namespace["s"]
urls = document.xpath("/s:urlset/s:url/s:loc", namespace).map(&:text)
abort "Sitemap has no public URLs" if urls.empty?
abort "Sitemap contains duplicate URLs" unless urls.uniq == urls

urls.each do |url|
  uri = URI.parse(url)
  abort "Sitemap URL is outside the canonical site: #{url}" unless uri.scheme == "https" && url.start_with?("#{canonical_root}/") && !uri.query && !uri.fragment
  path = URI::DEFAULT_PARSER.unescape(url.delete_prefix(canonical_root))
  target = File.expand_path(".#{path}", destination)
  target = File.join(target, "index.html") if path.end_with?("/")
  abort "Sitemap URL has no generated file: #{url}" unless target.start_with?("#{destination}/") && File.file?(target)
end

robots = File.read(File.join(destination, "robots.txt"))
abort "robots.txt must advertise the canonical sitemap URL" unless robots.lines.any? { |line| line.strip == "Sitemap: #{canonical_root}/sitemap.xml" }
puts "Sitemap valid: #{urls.size} unique HTTPS URLs, all generated files exist, canonical robots.txt discovery URL."
