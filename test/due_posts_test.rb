require "minitest/autorun"
require "tmpdir"
require "fileutils"
require_relative "../bin/due_posts"

class DuePostsTest < Minitest::Test
  def test_offset_dates_are_rebuilt_after_their_release_time
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, "_posts"))
      file = File.join(root, "_posts/2026-10-24-scheduled.md")
      since = Time.iso8601("2026-10-23T17:00:00Z")
      File.write(file, "---\ndate: '2026-10-24 01:30:00 +0800'\n---\nNote\n")
      refute DuePosts.due?(root, since: since, now: Time.iso8601("2026-10-23T17:29:59Z"))
      assert DuePosts.due?(root, since: since, now: Time.iso8601("2026-10-23T17:30:00Z"))
      refute DuePosts.due?(root, since: Time.iso8601("2026-10-23T17:31:00Z"), now: Time.iso8601("2026-10-23T17:40:00Z"))
      File.write(file, "---\ndate: '2026-10-24 01:30:00 +0800'\npublished: false\n---\nDraft\n")
      refute DuePosts.due?(root, since: since, now: Time.iso8601("2026-10-23T17:40:00Z"))
    end
  end
end
