require "minitest/autorun"
require "jekyll"
require "jekyll-archives-v2"
require "tmpdir"
require "fileutils"
require "yaml"
require "nokogiri"

class BlogTaxonomyTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_taxonomy_follows_public_posts_across_hide_restore_delete_and_private_preview
    Dir.mktmpdir("blog-taxonomy-") do |root|
      %w[_posts _layouts].each { |dir| FileUtils.mkdir_p(File.join(root, dir)) }
      %w[default post archive].each { |layout| File.write(File.join(root, "_layouts/#{layout}.liquid"), "{{ content }}") }
      blog = File.read(File.join(ROOT, "_pages/blog.md")).sub("enabled: true", "enabled: false")
      File.write(File.join(root, "blog.html"), blog)
      primary = File.join(root, "_posts/2026-01-01-primary.md")
      shared = File.join(root, "_posts/2026-01-02-shared.md")
      write_post(primary, ["Alpha", "Shared", "R&D, notes"], ["Research", "Common"])
      write_post(shared, ["Shared"], ["Common"])
      write_post(File.join(root, "_posts/2026-01-03-hidden.md"), ["Hidden"], ["Hidden category"], published: false)
      write_post(File.join(root, "_posts/2099-01-01-future.md"), ["Future"], ["Future category"])
      config = Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "url" => "https://example.org", "baseurl" => "", "permalink" => "/blog/:year/:title/", "time" => Time.new(2026, 6, 1, 12, 0, 0, "+08:00"), "timezone" => "Asia/Shanghai", "quiet" => true,
        "display_tags" => ["Nonexistent"], "display_categories" => ["Nonexistent category"], "jekyll-archives" => { "posts" => { "enabled" => ["tags", "categories"], "permalinks" => { "tags" => "/blog/:type/:name/", "categories" => "/blog/:type/:name/" } } } })

      assert_terms(root, config, ["Alpha", "R&D, notes", "Shared", "Common", "Research"])
      assert_terms(root, config.merge("unpublished" => true, "future" => true), ["Alpha", "R&D, notes", "Shared", "Common", "Research"])
      assert File.file?(File.join(root, "_site/blog/2026/hidden/index.html")), "hidden article remains available in private preview"
      assert File.file?(File.join(root, "_site/blog/2099/future/index.html")), "scheduled article remains available in private preview"

      write_post(primary, ["Alpha", "Shared", "R&D, notes"], ["Research", "Common"], published: false)
      assert_terms(root, config, ["Shared", "Common"])
      refute File.exist?(File.join(root, "_site/blog/tag/alpha/index.html")), "remove stale archive from existing output"
      assert File.file?(primary), "hiding retains the original source"

      write_post(primary, ["Alpha", "Shared", "R&D, notes"], ["Research", "Common"])
      assert_terms(root, config, ["Alpha", "R&D, notes", "Shared", "Common", "Research"])
      FileUtils.rm(primary)
      assert_terms(root, config, ["Shared", "Common"])
      FileUtils.rm(shared)
      assert_terms(root, config, [])
      assert_terms(root, config.merge("unpublished" => true, "future" => true), [])
    end
  end

  def assert_terms(root, config, expected)
    Jekyll::Site.new(config).process
    document = Nokogiri::HTML(File.read(File.join(root, "_site/blog/index.html")))
    assert_equal expected, document.css(".tag-category-list a").map { |link| link.text.strip }
    assert_equal expected.empty? ? 0 : 1, document.css(".tag-category-list").size, "omit the empty taxonomy bar"
    document.css(".tag-category-list a").each do |link|
      assert File.file?(File.join(root, "_site", link["href"], "index.html")), "archive exists for #{link.text}"
    end
  end

  def write_post(file, tags, categories, published: true)
    metadata = { "layout" => "post", "title" => File.basename(file), "tags" => tags, "categories" => categories, "published" => published }
    File.write(file, "#{metadata.to_yaml}---\n\nArticle body.\n")
  end
end
