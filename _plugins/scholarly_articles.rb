# Frozen, static scholarly article metadata and citation downloads.
require "date"

module ScholarlyArticles
  def self.enabled?(data)
    data["scholarly"].is_a?(Hash) && data["scholarly"]["enabled"] == true
  end

  def self.escape_bibtex(value)
    value.to_s.gsub(/\s+/, " ").strip.gsub(/[\\{}%&#_$~^]/) do |character|
      { "\\" => "\\textbackslash{}", "~" => "\\textasciitilde{}", "^" => "\\textasciicircum{}" }[character] || "\\#{character}"
    end
  end

  def self.bibtex(data, site)
    scholarly = data["scholarly"]
    date = data["date"].respond_to?(:strftime) ? data["date"] : Date.parse(data["date"].to_s)
    key = scholarly["bibtex_key"].to_s
    key = "chen#{date.strftime('%Y')}#{data['slug'].to_s.gsub(/[^A-Za-z0-9]/, '')}" if key.empty?
    report = scholarly["kind"] == "technical-report" && !scholarly["institution"].to_s.empty?
    fields = {
      "title" => data["title"],
      "author" => Array(scholarly["authors"]).join(" and "),
      "year" => date.strftime("%Y"),
      "month" => date.strftime("%m"),
      "url" => "#{site.config['url']}#{site.config['baseurl']}#{data['url']}",
      "note" => report ? "Technical report" : "Research Blog"
    }
    if report
      fields["institution"] = scholarly["institution"]
      fields["number"] = scholarly["report_number"] unless scholarly["report_number"].to_s.empty?
    end
    fields["doi"] = scholarly["doi"] unless scholarly["doi"].to_s.empty?
    lines = fields.map { |name, value| "  #{name} = {#{escape_bibtex(value)}}" }
    "@#{report ? 'techreport' : 'misc'}{#{key},\n#{lines.join(",\n")}\n}\n"
  end

  class PdfFile < Jekyll::StaticFile
    def initialize(site, source, article_url)
      super(site, site.source, File.dirname(source), File.basename(source))
      @article_url = article_url
    end

    def destination(dest)
      File.join(dest, @article_url, "paper.pdf")
    end

    def url
      "#{@article_url}paper.pdf"
    end
  end

  # Keep BibTeX out of jekyll-scholar's .bib-to-HTML converter.
  class CitationFile < Jekyll::StaticFile
    def initialize(site, article_url, content)
      super(site, site.source, article_url, "citation.bib")
      @content = content
    end

    def modified_time
      @modified_time ||= Time.now
    end

    def write(dest)
      target = destination(dest)
      FileUtils.mkdir_p(File.dirname(target))
      File.write(target, @content)
      true
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.posts.docs.each do |post|
        next unless ScholarlyArticles.enabled?(post.data)

        data = post.data.merge("url" => post.url, "slug" => post.data["slug"])
        scholarly = data["scholarly"]
        unless data["layout"] == "scholarly"
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: use layout: scholarly for scholarly articles"
        end
        unless !data["title"].to_s.strip.empty? && scholarly["authors"].is_a?(Array) &&
            scholarly["authors"].any? && scholarly["authors"].all? { |author| author.is_a?(String) && !author.strip.empty? } &&
            !scholarly["abstract"].to_s.strip.empty?
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: scholarly articles need a title, authors and abstract"
        end
        unless post.url.start_with?("/") && post.url.end_with?("/") && !post.url.include?("..")
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: scholarly article URL must end with /"
        end
        unless scholarly["bibtex_key"].to_s.empty? || scholarly["bibtex_key"].match?(/\A[A-Za-z0-9][A-Za-z0-9:_-]*\z/)
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: invalid BibTeX key"
        end
        bibtex = ScholarlyArticles.bibtex(data, site)
        post.data["scholarly_bibtex"] = bibtex
        site.static_files << CitationFile.new(site, post.url, bibtex)

        source = scholarly["pdf"].to_s.delete_prefix("/")
        next if source.empty?
        unless source.match?(%r{\Aassets/pdf/blog/[A-Za-z0-9][A-Za-z0-9._-]*\.pdf\z}) && File.file?(File.join(site.source, source))
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: scholarly PDF is missing or outside assets/pdf/blog"
        end
        if File.size(File.join(site.source, source)) > 5_000_000
          raise Jekyll::Errors::FatalException, "#{post.relative_path}: scholarly PDF exceeds 5 MB"
        end
        site.static_files << PdfFile.new(site, source, post.url)
      end
    end
  end
end
