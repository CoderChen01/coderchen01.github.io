# Normalize authors once for both Atom feeds without overriding article metadata.
require "json"
module BlogFeeds
  LICENSE = "CC-BY-4.0".freeze
  LICENSE_URL = "https://creativecommons.org/licenses/by/4.0/".freeze

  class Metadata < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      owner = site.config["author"] || {}
      site.posts.docs.each do |post|
        scholarly = post.data["scholarly"].is_a?(Hash) ? post.data["scholarly"] : {}
        names = scholarly["authors"] || post.data["authors"] || post.data["author"] || owner
        post.data["syndication_authors"] = Array(names.is_a?(Hash) ? [names] : names).map do |value|
          data = value.is_a?(Hash) ? value : { "name" => value.to_s }
          name = data["name"].to_s
          ids = scholarly["author_orcids"].is_a?(Hash) ? scholarly["author_orcids"] : {}
          orcid = ids[name] || data["orcid"] || (owner["orcid"] if name == owner["name"])
          { "name" => name, "uri" => orcid.to_s.empty? ? data["uri"] : "https://orcid.org/#{orcid.to_s.delete_prefix('https://orcid.org/')}" }
        end
        post.data["syndication_language"] = scholarly["language"].to_s.empty? ? post.data["lang"] || site.config["lang"] : scholarly["language"]
        licensed = scholarly["license"] == LICENSE
        post.data["syndication_license"] = LICENSE_URL if licensed
        post.data["research_feed_included"] = scholarly["enabled"] == true && scholarly["archive"] == true && licensed
        if scholarly["archive"] == true && !licensed
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: research archive feed requires an explicit CC-BY-4.0 license"
        end
        next unless scholarly["enabled"] == true

        url = "#{site.config['url']}#{site.config['baseurl']}#{post.url}"
        jsonld = {
          "@context" => "https://schema.org", "@type" => "BlogPosting", "@id" => "#{url}#article", "url" => url,
          "headline" => post.data["title"], "description" => scholarly["abstract"], "datePublished" => post.date.iso8601,
          "inLanguage" => post.data["syndication_language"], "mainEntityOfPage" => url,
          "author" => post.data["syndication_authors"].map do |author|
            person = { "@type" => "Person", "name" => author["name"] }
            person["sameAs"] = author["uri"] unless author["uri"].to_s.empty?
            person
          end
        }
        jsonld["license"] = LICENSE_URL if licensed
        post.data["scholarly_jsonld"] = JSON.generate(jsonld).gsub("<", '\\u003c')
      end
    end
  end
end
