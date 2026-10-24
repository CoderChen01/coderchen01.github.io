# Normalize authors once for both Atom feeds without overriding article metadata.
require "json"
require "cgi"
module BlogFeeds
  LICENSE = "CC-BY-4.0".freeze
  LICENSE_URL = "https://creativecommons.org/licenses/by/4.0/".freeze
  LICENSES = {
    LICENSE => { "url" => LICENSE_URL, "name" => "CC BY 4.0" },
    "CC-BY-SA-4.0" => { "url" => "https://creativecommons.org/licenses/by-sa/4.0/", "name" => "CC BY-SA 4.0" },
    "CC-BY-ND-4.0" => { "url" => "https://creativecommons.org/licenses/by-nd/4.0/", "name" => "CC BY-ND 4.0" },
    "CC-BY-NC-4.0" => { "url" => "https://creativecommons.org/licenses/by-nc/4.0/", "name" => "CC BY-NC 4.0" },
    "CC-BY-NC-SA-4.0" => { "url" => "https://creativecommons.org/licenses/by-nc-sa/4.0/", "name" => "CC BY-NC-SA 4.0" },
    "CC-BY-NC-ND-4.0" => { "url" => "https://creativecommons.org/licenses/by-nc-nd/4.0/", "name" => "CC BY-NC-ND 4.0" },
    "CC0-1.0" => { "url" => "https://creativecommons.org/publicdomain/zero/1.0/", "name" => "CC0 1.0" },
    "all-rights-reserved" => { "name" => "All rights reserved" }
  }.freeze

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
        license_id = post.data.key?("license") ? post.data["license"] : scholarly["license"]
        license = LICENSES[license_id]
        post.data.delete("syndication_license")
        post.data.delete("syndication_license_name")
        if license
          post.data["syndication_license"] = license["url"]
          post.data["syndication_license_name"] = license["name"]
        end
        archive_licensed = license_id == LICENSE
        post.data["research_feed_included"] = scholarly["enabled"] == true && scholarly["archive"] == true && archive_licensed
        if scholarly["enabled"] == true && scholarly["archive"] == true && !archive_licensed
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
        jsonld["license"] = license["url"] if license && license["url"]
        post.data["scholarly_jsonld"] = JSON.generate(jsonld).gsub("<", '\\u003c')
      end
    end
  end
end

# Standalone HTML articles bypass the theme layouts, but still honor their license.
Jekyll::Hooks.register :documents, :post_render do |post|
  next unless post.collection.label == "posts" && post.data["layout"].nil?
  name = post.data["syndication_license_name"]
  next unless name

  url = post.data["syndication_license"]
  label = CGI.escapeHTML(name)
  credit = url ? %(<a rel="license" href="#{url}" style="color:inherit">#{label}</a>) : label
  footer = %(<p class="scholarly-license" style="text-align:right;font:12px/1.6 system-ui;opacity:.7;margin:2rem 1rem">#{credit}</p>)
  head = %(<meta name="DC.rights" content="#{CGI.escapeHTML(url || name)}">)
  head += %(<link rel="license" href="#{url}">) if url
  post.output = if post.output.match?(%r{</body>}i)
    post.output.sub(%r{</body>}i, "#{footer}</body>").sub(%r{</head>}i, "#{head}</head>")
  else
    "#{post.output}#{footer}"
  end
end
