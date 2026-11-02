module SiteNavigation
  class Visibility < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      data = site.data["navigation"] || {}
      visibility = data.is_a?(Hash) ? data["visibility"] || {} : nil
      unless visibility.is_a?(Hash) && visibility.all? { |path, value| path.is_a?(String) && path.match?(%r{\A/(?:[A-Za-z0-9_-]+/)*\z}) && [true, false].include?(value) }
        raise Jekyll::Errors::FatalException, "_data/navigation.yml: visibility must map local page paths to true or false"
      end
      site.config["navigation_home_visible"] = visibility.fetch("/", true)
      site.pages.each do |page|
        path = page.data["permalink"] || page.url
        page.data["nav"] = visibility[path] if visibility.key?(path)
        # The theme renders the home link separately from other page links.
        page.data["nav"] = false if path == "/"
      end
    end
  end
end
