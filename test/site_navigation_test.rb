require "minitest/autorun"
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"
require_relative "../_plugins/site_navigation"

class SiteNavigationTest < Minitest::Test
  def test_visibility_overrides_keep_pages_available_and_home_link_separate
    Dir.mktmpdir("site-navigation-") do |root|
      FileUtils.mkdir_p(File.join(root, "_data"))
      File.write(File.join(root, "index.html"), "---\ntitle: About Me\npermalink: /\nnav: true\n---\nHome content")
      File.write(File.join(root, "services.html"), "---\ntitle: Services\npermalink: /services/\nnav: false\n---\nServices content")
      config = Jekyll.configuration({ "source" => root, "destination" => File.join(root, "_site"), "quiet" => true })
      file = File.join(root, "_data/navigation.yml")
      File.write(file, { "visibility" => { "/" => false, "/services/" => true } }.to_yaml)
      site = Jekyll::Site.new(config); site.process
      assert_equal false, site.config["navigation_home_visible"]
      assert_equal false, site.pages.find { |page| page.url == "/" }.data["nav"]
      assert_equal true, site.pages.find { |page| page.url == "/services/" }.data["nav"]
      File.write(file, { "visibility" => { "/" => true, "/services/" => false } }.to_yaml)
      site = Jekyll::Site.new(config); site.process
      assert_equal true, site.config["navigation_home_visible"]
      assert_equal false, site.pages.find { |page| page.url == "/services/" }.data["nav"]
      assert_includes File.read(File.join(root,"_site/services/index.html")), "Services content"
      File.write(file, { "visibility" => { "/services/" => "true" } }.to_yaml)
      assert_raises(Jekyll::Errors::FatalException) { Jekyll::Site.new(config).process }
    end
  end
end
