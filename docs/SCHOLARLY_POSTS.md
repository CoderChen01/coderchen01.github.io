# Scholarly blog posts

Create an article from the CMS Blog page, then select **Blog post**, **Research note** or **Technical report** in the right-hand editor. Selecting a research type fills an empty body with the Markdown/LaTeX outline and reveals **Research details**. Switching types preserves existing text and metadata. A fresh Markdown template can also be downloaded there. Fill in authors and an abstract, optionally upload a PDF, then save, review the Git diff, validate and publish as usual.

Publication time defaults to the actual local date, time and UTC offset when the article is created. **Use current time** captures a new timestamp; the date/time picker can schedule a future release. Private Jekyll previews include future and unpublished articles. **Preview article** saves the current article and opens its own URL in the built preview.

The production build excludes future articles until their timestamp. Once a scheduled article has been committed through Publish, the **Publish scheduled posts** workflow checks every five minutes and triggers a production rebuild when it becomes due. Only the public repository is checked; uncommitted CMS drafts are never published by this job. GitHub Actions can delay scheduled runs, so release is after the selected time rather than guaranteed at the exact second. The checker compares against the last successful production build's start time, and skips while another production build is active.

The website renders a visible abstract and author list, Highwire `citation_*` metadata, and a bottom **Cite this article** section with copyable BibTeX and a `.bib` download. A PDF is optional: without one, neither a PDF link nor `citation_pdf_url` is emitted. Do not invent a DOI, institution, report number or publication venue. A technical report requires its actual issuing institution; otherwise use Research note.

## Files and URLs

For manual editing, copy [the template](../templates/scholarly-post.md) to `_posts/YYYY-MM-DD-your-slug.md`. Set the actual title, date, authors, abstract and body. The CMS freezes `permalink` when saving a scholarly article so later date or filename edits do not change its citation URL. For a manual post, set a stable permalink such as `/blog/2026/your-slug/` yourself.

Uploads are stored under `assets/pdf/blog/` with unique filenames and never overwrite another upload. The CMS checks the PDF signature, 5 MB limit, readable structure, lack of encryption and searchable text with Poppler. It does not verify scientific claims or that the PDF's title/authors match the form: check those yourself. Export selectable text, put the title and authors at the top, and end with formal references. Avoid scanned pages.

The Jekyll generator publishes attachments as `<article-url>paper.pdf` and citations as `<article-url>citation.bib`. This keeps the PDF in the article's directory, as required for `citation_pdf_url`. The raw upload directory and templates are excluded from public output. Removing an attachment clears its reference; the original upload remains recoverable in Git.

## Indexing

Follow the [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html). Correct metadata makes a qualifying article easier to parse; it does not guarantee indexing. Keep at least the complete abstract publicly visible, use ordinary HTML links from the blog index, and check inclusion by searching the full title in Scholar. Adding a record to your Scholar profile is separate from search indexing.
