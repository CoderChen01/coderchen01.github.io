require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require "jekyll-toc"
require "jekyll/scholar"
require "jekyll-feed"
require "jekyll-sitemap"
require_relative "../_plugins/scholarly_articles"

class PostVisibilityTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_hide_and_restore_remove_public_outputs_while_retaining_source_and_private_preview
    Dir.mktmpdir("post-visibility-") do |root|
      %w[_posts _layouts _includes assets/pdf/blog].each { |dir| FileUtils.mkdir_p(File.join(root, dir)) }
      %w[_layouts/scholarly.liquid _includes/scholarly-head.liquid].each do |file|
        FileUtils.cp(File.join(ROOT, file), File.join(root, file))
      end
      File.write(File.join(root, "_layouts/default.liquid"), '<html><head>{% include scholarly-head.liquid %}</head><body>{{ content }}</body></html>')
      File.write(File.join(root, "index.html"), "---\nlayout: null\n---\n{% for post in site.posts %}<a href=\"{{ post.url }}\">{{ post.title }}</a>{% endfor %}")
      File.write(File.join(root, "search.json"), "---\nlayout: null\n---\n[{% for post in site.posts %}{{ post.title | jsonify }}{% unless forloop.last %},{% endunless %}{% endfor %}]")
      attachment = File.join(root, "assets/pdf/blog/original.pdf")
      File.write(attachment, "%PDF-1.4\nKeep the original attachment\n%%EOF")
      post = File.join(root, "_posts/2026-01-01-visibility.md")
      metadata = { "layout" => "scholarly", "title" => "Visibility lifecycle", "date" => "2026-01-01 12:00:00 +0800", "published" => true, "related_posts" => false, "scholarly" => { "enabled" => true, "kind" => "research-note", "authors" => ["Junjie Chen"], "abstract" => "A complete abstract.", "pdf" => "assets/pdf/blog/original.pdf" } }
      write_post(post, metadata)
      config = Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "theme" => "al_folio_core", "url" => "https://example.org", "baseurl" => "", "timezone" => "Asia/Shanghai", "permalink" => "/blog/:year/:title/", "exclude" => ["assets/pdf/blog/"], "quiet" => true })
      article = File.join(root, "_site/blog/2026/visibility")
      Jekyll::Site.new(config).process
      %w[index.html paper.pdf citation.bib].each { |file| assert File.file?(File.join(article, file)), file }
      assert_includes File.read(File.join(root, "_site/feed.xml")), "Visibility lifecycle"
      assert_includes File.read(File.join(root, "_site/sitemap.xml")), "/blog/2026/visibility/"

      metadata["published"] = false
      write_post(post, metadata)
      Jekyll::Site.new(config).process
      %w[index.html paper.pdf citation.bib].each { |file| refute File.exist?(File.join(article, file)), file }
      %w[index.html search.json feed.xml].each do |file|
        refute_includes File.read(File.join(root, "_site", file)), "Visibility lifecycle", file
      end
      refute_includes File.read(File.join(root, "_site/sitemap.xml")), "/blog/2026/visibility/"
      assert File.file?(post)
      assert_includes File.read(post), "Keep the original body."
      assert_includes File.read(attachment), "Keep the original attachment"

      Jekyll::Site.new(config.merge("unpublished" => true)).process
      %w[index.html paper.pdf citation.bib].each { |file| assert File.file?(File.join(article, file)), "private preview #{file}" }

      metadata["published"] = true
      write_post(post, metadata)
      Jekyll::Site.new(config).process
      %w[index.html paper.pdf citation.bib].each { |file| assert File.file?(File.join(article, file)), "restored #{file}" }
      assert_includes File.read(File.join(root, "_site/index.html")), "/blog/2026/visibility/"
    end
  end

  def write_post(file, metadata)
    File.write(file, "#{metadata.to_yaml}---\n\nKeep the original body.\n\n## References\n\n1. A real reference.\n")
  end
end
