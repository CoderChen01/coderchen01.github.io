require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require "nokogiri"
require "jekyll-toc"
require "jekyll/scholar"
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
      File.write(File.join(source, "_layouts/default.liquid"), '<html><head>{% include scholarly-head.liquid %}</head><body>{{ content }}</body></html>')
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
      write_post(source, "ordinary", { "layout" => "post", "title" => "Ordinary blog" })
      write_post(source, "scheduled", base.merge("date" => "2099-01-01 12:34:56 +0800"))
      config = Jekyll.configuration({ "source" => source, "destination" => File.join(source, "_site"), "theme" => "al_folio_core", "url" => "https://example.org", "baseurl" => "", "timezone" => "Asia/Shanghai", "permalink" => "/blog/:year/:title/", "exclude" => ["assets/pdf/blog/"], "quiet" => true })
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
    end
  end

  def write_post(source, slug, data)
    File.write(File.join(source, "_posts/2026-01-01-#{slug}.md"), "#{data.to_yaml}---\n\n## Method\n\nStatic body.\n\n## References\n\n1. Actual reference.\n")
  end
end
