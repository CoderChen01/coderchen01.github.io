require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "nokogiri"
require "yaml"

class ServicesTest < Minitest::Test
  def test_visibility_order_escaping_and_empty_state
    Dir.mktmpdir("services-site-") do |root|
      %w[_data _includes].each { |dir| FileUtils.mkdir_p(File.join(root, dir)) }
      FileUtils.cp(File.expand_path("../_includes/services.liquid", __dir__), File.join(root, "_includes/services.liquid"))
      File.write(File.join(root, "index.html"), "---\nlayout: null\n---\n{% include services.liquid %}")
      File.write(File.join(root, "services.html"), "---\nlayout: null\npermalink: /services/\n---\n{% include services.liquid full_page=true %}")
      entries = [
        { "id" => "later", "name" => "Later Journal", "category" => "journal", "role" => "Reviewer", "visible" => true, "order" => 20 },
        { "id" => "first", "name" => "Evidence & <safe>", "category" => "journal", "role" => "Guest Editor", "visible" => true, "order" => 10 },
        { "id" => "hidden", "name" => "Hidden Conference", "category" => "conference", "role" => "Reviewer", "visible" => false, "order" => 0 }
      ]
      config = Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "quiet" => true })
      file = File.join(root, "_data/services.yml")
      File.write(file, { "entries" => entries }.to_yaml)
      Jekyll::Site.new(config).process
      html = Nokogiri::HTML(File.read(File.join(root, "_site/index.html")))
      assert_equal %w[first later], html.css(".service-entry").map { |node| node["data-service-id"] }
      assert_equal "Evidence & <safe>", html.at_css(".service-venue > span").text
      assert_includes html.at_css(".service-details").text, "Guest Editor"
      assert_empty html.css("#services-conference")
      assert_equal "0", html.at_css(".services-scroll")["tabindex"]
      assert_equal "/services/", html.at_css("#services-title a")["href"]
      directory = Nokogiri::HTML(File.read(File.join(root, "_site/services/index.html")))
      assert_equal %w[first later], directory.css(".service-entry").map { |node| node["data-service-id"] }
      assert_equal 1, directory.css(".service-group h2").size
      assert_empty directory.css(".services-scroll, #services-title, #services-conference")
      File.write(file, { "entries" => [] }.to_yaml)
      Jekyll::Site.new(config).process
      assert_empty Nokogiri::HTML(File.read(File.join(root, "_site/index.html"))).css(".services-section")
      assert_includes File.read(File.join(root, "_site/services/index.html")), "No public service activities are currently listed."
    end
  end
end
