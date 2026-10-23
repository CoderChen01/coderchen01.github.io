# Check only source dates; never create commits or publish uncommitted CMS drafts.
require "date"
require "time"
require "yaml"

module DuePosts
  def self.due?(root, since:, now: Time.now)
    Dir.glob(File.join(root, "{_posts,_news}", "*.{md,html}")).any? do |file|
      header = File.read(file).match(/\A---\r?\n(.*?)\r?\n---/m)
      next false unless header
      data = YAML.safe_load(header[1], permitted_classes: [Date, Time], aliases: true) || {}
      next false if data["published"] == false || data["date"].nil?
      date = data["date"].is_a?(Time) ? data["date"] : Time.parse(data["date"].to_s)
      date > since && date <= now
    end
  end
end

if $PROGRAM_NAME == __FILE__
  since = Time.parse(ENV.fetch("LAST_BUILD_STARTED_AT"))
  puts "due=#{DuePosts.due?(Dir.pwd, since: since)}"
end
