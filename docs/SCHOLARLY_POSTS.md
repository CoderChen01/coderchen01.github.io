# Scholarly blog posts

The CMS Blog page offers **New research note** and a downloadable Markdown template. Ordinary posts can opt in with **Research note / technical report**. Write the article in Markdown with LaTeX, fill in authors and an abstract, and optionally upload a PDF. Save, review the Git diff, validate, then publish as usual.

The website renders a visible abstract and author list, Highwire `citation_*` metadata, and a bottom **Cite this article** section with copyable BibTeX and a `.bib` download. A PDF is optional: without one, neither a PDF link nor `citation_pdf_url` is emitted. Do not invent a DOI, institution, report number or publication venue. A technical report requires its actual issuing institution; otherwise use Research note.

## Files and URLs

For manual editing, copy [the template](../templates/scholarly-post.md) to `_posts/YYYY-MM-DD-your-slug.md`. Set the actual title, date, authors, abstract and body. The CMS freezes `permalink` when saving a scholarly article so later date or filename edits do not change its citation URL. For a manual post, set a stable permalink such as `/blog/2026/your-slug/` yourself.

Uploads are stored under `assets/pdf/blog/` with unique filenames and never overwrite another upload. The CMS checks the PDF signature, 5 MB limit, readable structure, lack of encryption and searchable text with Poppler. It does not verify scientific claims or that the PDF's title/authors match the form: check those yourself. Export selectable text, put the title and authors at the top, and end with formal references. Avoid scanned pages.

The Jekyll generator publishes attachments as `<article-url>paper.pdf` and citations as `<article-url>citation.bib`. This keeps the PDF in the article's directory, as required for `citation_pdf_url`. The raw upload directory and templates are excluded from public output. Removing an attachment clears its reference; the original upload remains recoverable in Git.

## Indexing

Follow the [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html). Correct metadata makes a qualifying article easier to parse; it does not guarantee indexing. Keep at least the complete abstract publicly visible, use ordinary HTML links from the blog index, and check inclusion by searching the full title in Scholar. Adding a record to your Scholar profile is separate from search indexing.
