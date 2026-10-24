require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require "nokogiri"
require_relative "../_plugins/blog_feeds"

class BlogFeedsTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  NS = { "a" => "http://www.w3.org/2005/Atom" }.freeze

  def test_content_license_catalog_in_ordinary_pages_and_feeds
    Dir.mktmpdir("content-licenses-") do |root|
      %w[_posts _includes _layouts].each { |dir| FileUtils.mkdir_p(File.join(root, dir)) }
      %w[feed.xml research-feed.xml _includes/blog-feed.liquid _includes/scholarly-head.liquid _includes/content-license.liquid].each { |file| FileUtils.cp(File.join(ROOT, file), File.join(root, file)) }
      File.write(File.join(root, "_layouts/post.liquid"), '<html><head>{% include scholarly-head.liquid %}</head><body>{{ content }}{% include content-license.liquid %}</body></html>')
      BlogFeeds::LICENSES.each_with_index do |(id, _license), index|
        write_post(File.join(root, "_posts/2026-01-01-license-#{index}.md"), { "layout" => "post", "title" => id, "license" => id, "scholarly" => { "enabled" => false, "license" => "CC-BY-4.0", "archive" => true } })
      end
      write_post(File.join(root, "_posts/2026-01-01-empty.md"), { "layout" => "post", "license" => "", "scholarly" => { "license" => "CC-BY-4.0" } })
      File.write(File.join(root, "_posts/2026-01-01-standalone.html"), { "layout" => nil, "title" => "Standalone", "license" => "CC-BY-NC-4.0" }.to_yaml + "---\n<!doctype html><html><head><title>Standalone</title></head><body><h1>Original HTML</h1></body></html>")
      Jekyll::Site.new(Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "url" => "https://example.org", "baseurl" => "", "permalink" => "/blog/:year/:title/", "quiet" => true })).process
      all = feed(root, "feed.xml")
      BlogFeeds::LICENSES.each_with_index do |(_id, license), index|
        html = Nokogiri::HTML(File.read(File.join(root, "_site/blog/2026/license-#{index}/index.html")))
        assert_equal license["name"], html.at_css(".scholarly-license").text.strip
        assert_equal license["url"] || license["name"], html.at_css('meta[name="DC.rights"]')["content"]
        assert_empty html.css('meta[name="citation_title"]'), "ordinary posts must not gain scholarly metadata"
        entry = all.at_xpath("//a:entry[a:id='https://example.org/blog/2026/license-#{index}/']", NS)
        assert_equal license["name"], entry.at_xpath("a:rights", NS).text
        if license["url"]
          assert_equal license["url"], html.at_css('p a[rel="license"]')["href"]
          assert_equal license["url"], entry.at_xpath('a:link[@rel="license"]', NS)["href"]
        else
          assert_empty html.css('a[rel="license"], link[rel="license"]'), "reserved rights is not a CC grant"
          assert_empty entry.xpath('a:link[@rel="license"]', NS)
        end
      end
      empty = Nokogiri::HTML(File.read(File.join(root, "_site/blog/2026/empty/index.html")))
      assert_empty empty.css('.scholarly-license, meta[name="DC.rights"], link[rel="license"]'), "clearing a license overrides legacy scholarly data"
      standalone = Nokogiri::HTML(File.read(File.join(root, "_site/blog/2026/standalone/index.html")))
      assert_equal "Original HTML", standalone.at_css("h1").text
      assert_equal "CC BY-NC 4.0", standalone.at_css(".scholarly-license").text
      assert_equal "https://creativecommons.org/licenses/by-nc/4.0/", standalone.at_css('head link[rel="license"]')["href"]
      assert_empty feed(root, "research-feed.xml").xpath("//a:entry", NS)
    end
  end

  def test_full_text_author_license_and_publication_lifecycle
    Dir.mktmpdir("blog-feeds-") do |root|
      %w[_posts _includes].each { |dir| FileUtils.mkdir_p(File.join(root, dir)) }
      %w[feed.xml research-feed.xml _includes/blog-feed.liquid].each { |file| FileUtils.cp(File.join(ROOT, file), File.join(root, file)) }
      config = Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "url" => "https://example.org", "baseurl" => "", "title" => "blank", "blog_name" => "Junjie Chen's Blogs", "blog_description" => "AI & interaction", "lang" => "en", "author" => { "name" => "Junjie Chen", "uri" => "https://orcid.org/0009-0001-5288-048X", "orcid" => "0009-0001-5288-048X" }, "research_feed" => { "title" => "Junjie Chen — Research Blog", "description" => "Research articles" }, "time" => Time.new(2026, 10, 25, 12, 0, 0, "+08:00"), "permalink" => "/blog/:year/:title/", "quiet" => true })
      scholarly = { "enabled" => true, "kind" => "research-note", "authors" => ["Junjie Chen", "Xi Qiu"], "abstract" => "A complete abstract.", "language" => "en", "license" => "CC-BY-4.0", "archive" => true }
      metadata = { "layout" => nil, "title" => "Evidence & <context>", "date" => "2026-01-01 12:00:00 +0800", "scholarly" => scholarly }
      article = File.join(root, "_posts/2026-01-01-public.md")
      write_post(article, metadata)
      write_post(File.join(root, "_posts/2026-01-02-unlicensed.md"), metadata.merge("scholarly" => scholarly.merge("license" => "", "archive" => false)))
      write_post(File.join(root, "_posts/2026-01-03-not-selected.md"), metadata.merge("scholarly" => scholarly.merge("archive" => false)))
      write_post(File.join(root, "_posts/2026-01-04-ordinary.md"), { "layout" => nil, "title" => "Ordinary post" })
      write_post(File.join(root, "_posts/2026-01-05-hidden.md"), metadata.merge("published" => false))
      write_post(File.join(root, "_posts/2099-01-01-future.md"), metadata.merge("date" => "2099-01-01 12:00:00 +0800"))

      site = Jekyll::Site.new(config)
      site.process
      all = feed(root, "feed.xml")
      research = feed(root, "research-feed.xml")
      assert_equal "Junjie Chen's Blogs", all.at_xpath("/a:feed/a:title", NS).text
      assert_equal "Junjie Chen — Research Blog", research.at_xpath("/a:feed/a:title", NS).text
      assert_equal 1, research.xpath("/a:feed/a:title", NS).size
      assert_equal 4, all.xpath("//a:entry", NS).size
      assert_equal 1, research.xpath("//a:entry", NS).size
      entry = research.at_xpath("//a:entry", NS)
      assert_equal "Evidence & <context>", entry.at_xpath("a:title", NS).text
      assert_equal ["Junjie Chen", "Xi Qiu"], entry.xpath("a:author/a:name", NS).map(&:text)
      assert_equal "https://orcid.org/0009-0001-5288-048X", entry.at_xpath("a:author[1]/a:uri", NS).text
      assert_empty entry.xpath("a:author[2]/a:uri", NS), "never assign the owner's ORCID to a coauthor"
      assert_equal "en", entry["xml:lang"]
      assert_equal "https://creativecommons.org/licenses/by/4.0/", entry.at_xpath('a:link[@rel="license"]', NS)["href"]
      assert_includes entry.at_xpath("a:content", NS).text, "full-text-final-marker"
      assert_includes entry.at_xpath("a:content", NS).text, "<h2"
      assert_equal "https://example.org/blog/2026/public/", entry.at_xpath("a:id", NS).text
      assert_empty all.xpath('/a:feed/a:link[@rel="license"]', NS), "do not license the entire general feed"
      assert_empty all.xpath('//a:entry[a:id="https://example.org/blog/2026/unlicensed/"]/a:link[@rel="license"]', NS)
      assert_equal "Junjie Chen", all.at_xpath('//a:entry[a:id="https://example.org/blog/2026/ordinary/"]/a:author/a:name', NS).text
      jsonld = JSON.parse(site.posts.docs.find { |post| post.basename_without_ext.end_with?("public") }.data["scholarly_jsonld"])
      assert_equal "https://creativecommons.org/licenses/by/4.0/", jsonld["license"]
      assert_equal "https://orcid.org/0009-0001-5288-048X", jsonld["author"][0]["sameAs"]

      Jekyll::Site.new(config.merge("unpublished" => true, "future" => true)).process
      assert_equal 4, feed(root, "feed.xml").xpath("//a:entry", NS).size, "private preview flags cannot expose hidden or scheduled entries in feeds"
      assert_equal 1, feed(root, "research-feed.xml").xpath("//a:entry", NS).size

      write_post(article, metadata.merge("published" => false))
      Jekyll::Site.new(config).process
      assert_empty feed(root, "research-feed.xml").xpath("//a:entry", NS)
      write_post(article, metadata)
      Jekyll::Site.new(config).process
      assert_equal 1, feed(root, "research-feed.xml").xpath("//a:entry", NS).size
      write_post(article, metadata.merge("scholarly" => scholarly.merge("archive" => false)))
      Jekyll::Site.new(config).process
      assert_empty feed(root, "research-feed.xml").xpath("//a:entry", NS)
      restricted = metadata.merge("scholarly" => scholarly.merge("archive" => false, "license" => "CC-BY-NC-ND-4.0"))
      write_post(article, restricted)
      site = Jekyll::Site.new(config)
      site.process
      restricted_entry = feed(root, "feed.xml").at_xpath('//a:entry[a:id="https://example.org/blog/2026/public/"]', NS)
      assert_equal "https://creativecommons.org/licenses/by-nc-nd/4.0/", restricted_entry.at_xpath('a:link[@rel="license"]', NS)["href"]
      assert_equal "CC BY-NC-ND 4.0", restricted_entry.at_xpath("a:rights", NS).text
      assert_empty feed(root, "research-feed.xml").xpath("//a:entry", NS)
      jsonld = JSON.parse(site.posts.docs.find { |post| post.basename_without_ext.end_with?("public") }.data["scholarly_jsonld"])
      assert_equal "https://creativecommons.org/licenses/by-nc-nd/4.0/", jsonld["license"]
      write_post(article, metadata.merge("scholarly" => scholarly.merge("license" => "")))
      assert_raises(Jekyll::Errors::FatalException) { Jekyll::Site.new(config).process }
    end
  end

  def feed(root, name)
    Nokogiri::XML(File.read(File.join(root, "_site", name))) { |xml| xml.strict.nonet }
  end

  def write_post(file, metadata)
    File.write(file, "#{metadata.to_yaml}---\n\n## Full research article\n\n#{'Evidence & context. ' * 50}\n\nXML terminator: ]]>\n\nfull-text-final-marker\n")
  end
end
