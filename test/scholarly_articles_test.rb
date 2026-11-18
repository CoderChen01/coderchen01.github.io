require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require "nokogiri"
require "jekyll-toc"
require "jekyll/scholar"
require "jekyll-archives-v2"
require_relative "../_plugins/scholarly_articles"
require_relative "../_plugins/blog_feeds"

class ScholarlyArticlesTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_static_html_optional_pdf_and_bibtex_downloads
    Dir.mktmpdir("scholarly-site-") do |source|
      %w[_posts _layouts _includes assets/pdf/blog].each { |dir| FileUtils.mkdir_p(File.join(source, dir)) }
      %w[_layouts/scholarly.liquid _includes/scholarly-head.liquid _includes/content-license.liquid].each do |file|
        FileUtils.cp(File.join(ROOT, file), File.join(source, file))
      end
      FileUtils.cp(File.join(ROOT, "_layouts/default.liquid"), File.join(source, "_layouts/default.liquid"))
      %w[head header footer scripts].each { |name| File.write(File.join(source, "_includes/#{name}.liquid"), "") }
      blog = File.read(File.join(ROOT, "_pages/blog.md")).sub("enabled: true", "enabled: false")
      File.write(File.join(source, "blog.html"), blog)
      File.write(File.join(source, "assets/pdf/blog/test.pdf"), "%PDF-1.4\nFixture PDF\n%%EOF")
      base = {
        "layout" => "scholarly", "title" => "A {test} & 50%_result", "date" => "2026-01-01 01:02:03 +0800",
        "related_posts" => false,
        "scholarly" => { "enabled" => true, "authors" => ["Junjie Chen", "Xi Qiu"], "abstract" => "Complete abstract with <safe> content.", "kind" => "research-note", "license" => "CC-BY-NC-ND-4.0" }
      }
      write_post(source, "without-pdf", base)
      with_pdf = Marshal.load(Marshal.dump(base))
      with_pdf["scholarly"]["pdf"] = "assets/pdf/blog/test.pdf"
      with_pdf["scholarly"]["kind"] = "technical-report"
      with_pdf["scholarly"]["institution"] = "Actual institution"
      with_pdf["scholarly"]["report_number"] = "TR-1"
      write_post(source, "with-pdf", with_pdf)
      external = Marshal.load(Marshal.dump(with_pdf))
      external.merge!("external_link" => true, "redirect" => "https://example.github.io/project/?a=1&b=2", "featured" => true, "tags" => ["project"])
      write_post(source, "external", external)
      write_post(source, "ordinary", { "layout" => "post", "title" => "Ordinary blog" })
      write_post(source, "scheduled", base.merge("date" => "2099-01-01 12:34:56 +0800"))
      config = Jekyll.configuration({ "source" => source, "destination" => File.join(source, "_site"), "theme" => "al_folio_core", "url" => "https://example.org", "baseurl" => "", "timezone" => "Asia/Shanghai", "permalink" => "/blog/:year/:title/", "exclude" => ["assets/pdf/blog/"], "quiet" => true, "jekyll-archives" => { "posts" => { "enabled" => ["tags"], "permalinks" => { "tags" => "/blog/tag/:name/" } } } })
      site = Jekyll::Site.new(config)
      site.process
      output = File.join(source, "_site/blog/2026")
      html = Nokogiri::HTML(File.read(File.join(output, "without-pdf/index.html")))
      assert_equal "A {test} & 50%_result", html.at_css('meta[name="citation_title"]')["content"]
      assert_equal ["Junjie Chen", "Xi Qiu"], html.css('meta[name="citation_author"]').map { |tag| tag["content"] }
      assert_equal "2026/01/01", html.at_css('meta[name="citation_publication_date"]')["content"]
      assert_equal "Complete abstract with <safe> content.", html.at_css(".scholarly-abstract p:last-of-type").text
      assert_equal "Research Blog", html.at_css(".scholarly-kind").text.strip
      assert_equal "https://creativecommons.org/licenses/by-nc-nd/4.0/", html.at_css('meta[name="DC.rights"]')["content"]
      assert_equal "CC BY-NC-ND 4.0", html.at_css(".scholarly-license").text.strip
      assert_empty html.css('.scholarly-citation a[rel="license"]'), "keep the license outside the citation panel as a quiet footer"
      assert_empty html.css('meta[name="citation_pdf_url"], a[href$="paper.pdf"]')
      assert_empty html.css('meta[name="citation_doi"], meta[name="citation_technical_report_institution"], meta[name="citation_technical_report_number"]')
      assert html.at_css(".scholarly-citation")
      bib = File.read(File.join(output, "without-pdf/citation.bib"))
      assert_includes bib, 'title = {A \{test\} \& 50\%\_result}'
      assert_includes bib, 'author = {Junjie Chen and Xi Qiu}'
      assert_includes bib, 'url = {https://example.org/blog/2026/without-pdf/}'
      assert_includes bib, 'note = {Research Blog}'
      assert_equal bib.strip, html.at_css("[data-scholarly-bibtex]").text.strip
      html_pdf = Nokogiri::HTML(File.read(File.join(output, "with-pdf/index.html")))
      assert_equal "https://example.org/blog/2026/with-pdf/paper.pdf", html_pdf.at_css('meta[name="citation_pdf_url"]')["content"]
      assert_equal "Actual institution", html_pdf.at_css('meta[name="citation_technical_report_institution"]')["content"]
      assert_includes html_pdf.at_css(".scholarly-kind").text, "Technical report"
      assert File.file?(File.join(output, "with-pdf/paper.pdf"))
      assert_includes File.read(File.join(output, "with-pdf/citation.bib")), "@techreport{"
      project = Nokogiri::HTML(File.read(File.join(output, "external/index.html")))
      assert_empty project.css('meta[http-equiv="refresh"]'), "keep the abstract page readable without an automatic redirect"
      assert_equal external["title"], project.at_css('meta[name="citation_title"]')["content"]
      assert_includes project.at_css(".scholarly-abstract").text, external["scholarly"]["abstract"]
      assert_equal external["redirect"], project.at_css(".scholarly-abstract a[target='_blank']")["href"]
      refute_includes project.text, "Static body.", "retained editor source is not a published article body"
      assert_equal "https://example.org/blog/2026/external/paper.pdf", project.at_css('meta[name="citation_pdf_url"]')["content"]
      assert File.file?(File.join(output, "external/paper.pdf"))
      assert_includes File.read(File.join(output, "external/citation.bib")), "note = {Project page}"
      index = Nokogiri::HTML(File.read(File.join(source, "_site/blog/index.html")))
      [".featured-posts .card-title a", ".post-list a.post-title[href^='https:']"].each do |selector|
        link = index.at_css(selector)
        assert_equal external["redirect"], link["href"]
        assert_includes link["rel"], "noopener"
      end
      assert index.at_css("a.post-abstract-link[href='/blog/2026/external/']"), "expose a crawlable abstract link"
      archive = Nokogiri::HTML(File.read(File.join(source, "_site/blog/tag/project/index.html")))
      assert_equal external["redirect"], archive.at_css("a.post-link")["href"]
      refute File.exist?(File.join(source, "_site/assets/pdf/blog/test.pdf"))
      ordinary = Nokogiri::HTML(File.read(File.join(output, "ordinary/index.html")))
      assert_empty ordinary.css('meta[name^="citation_"], .scholarly-citation')
      with_pdf["scholarly"]["pdf"] = ""
      write_post(source, "with-pdf", with_pdf)
      Jekyll::Site.new(config).process
      refute File.exist?(File.join(output, "with-pdf/paper.pdf"))
      removed = Nokogiri::HTML(File.read(File.join(output, "with-pdf/index.html")))
      assert_empty removed.css('meta[name="citation_pdf_url"], a[href$="paper.pdf"]')
      refute File.exist?(File.join(source, "_site/blog/2099/scheduled/index.html"))
      Jekyll::Site.new(config.merge("future" => true)).process
      assert File.exist?(File.join(source, "_site/blog/2099/scheduled/index.html"))
      external["scholarly"]["pdf"] = ""
      write_post(source, "external", external)
      Jekyll::Site.new(config).process
      no_pdf = Nokogiri::HTML(File.read(File.join(output, "external/index.html")))
      assert_empty no_pdf.css('meta[name="citation_pdf_url"], a[href$="paper.pdf"]')
      refute File.exist?(File.join(output, "external/paper.pdf"))
      external["published"] = false
      write_post(source, "external", external)
      Jekyll::Site.new(config).process
      %w[index.html paper.pdf citation.bib].each { |file| refute File.exist?(File.join(output, "external", file)) }
      refute_includes File.read(File.join(source, "_site/blog/index.html")), external["redirect"]
      external["published"] = true
      write_post(source, "external", external)
      Jekyll::Site.new(config).process
      assert File.file?(File.join(output, "external/citation.bib")), "restoring an external entry restores its citation"
    end
  end

  def write_post(source, slug, data)
    File.write(File.join(source, "_posts/2026-01-01-#{slug}.md"), "#{data.to_yaml}---\n\n## Method\n\nStatic body.\n\n## References\n\n1. Actual reference.\n")
  end
end
