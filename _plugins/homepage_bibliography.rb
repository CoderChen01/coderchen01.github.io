require "jekyll/scholar"

# Keep the bibliography renderer and apply the CMS order only on the homepage.
class HomepageBibliography < Jekyll::Scholar::BibliographyTag
  def render_items(items)
    order = Array(site.data.dig("homepage_publications", "order"))
    positions = order.each_with_index.to_h
    ordered = items.each_with_index.sort_by do |entry, index|
      positions.fetch(entry.key, order.length + index)
    end
    super(ordered.map(&:first))
  end
end

Liquid::Template.register_tag("homepage_bibliography", HomepageBibliography)
