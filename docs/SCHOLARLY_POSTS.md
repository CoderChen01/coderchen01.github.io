# Scholarly blog posts

Create an article from the CMS Blog page, then select **Blog post**, **Research Blog** or **Technical report** in the right-hand editor. Selecting a research type fills an empty body with the Markdown/LaTeX outline and reveals **Research details**. Switching types preserves existing text and metadata. A fresh Markdown template can also be downloaded there. Fill in authors and an abstract, optionally upload a PDF, then save, review the Git diff, validate and publish as usual.

Research Blog is the display name for the existing `scholarly.kind: research-note` value. Keep that stored value for compatibility; the page label and BibTeX note use Research Blog. The display name alone does not affect Google Scholar eligibility. New templates use the `research-blog` category; existing article permalinks remain unchanged.

Publication time defaults to the actual local date, time and UTC offset when the article is created. **Use current time** captures a new timestamp; the date/time picker can schedule a future release. Private Jekyll previews include future and unpublished articles. **Preview article** saves the current article and opens its own URL in the built preview.

The production build excludes future articles until their timestamp. Once a scheduled article has been committed through Publish, the **Publish scheduled posts** workflow checks every five minutes and triggers a production rebuild when it becomes due. Only the public repository is checked; uncommitted CMS drafts are never published by this job. GitHub Actions can delay scheduled runs, so release is after the selected time rather than guaranteed at the exact second. The checker compares against the last successful production build's start time, and skips while another production build is active.

The website renders a visible abstract and author list, Highwire `citation_*` metadata, and a bottom **Cite this article** section with copyable BibTeX and a `.bib` download. A PDF is optional: without one, neither a PDF link nor `citation_pdf_url` is emitted. Do not invent a DOI, institution, report number or publication venue. A technical report requires its actual issuing institution; otherwise use Research Blog.

## Files and URLs

For manual editing, copy [the template](../templates/scholarly-post.md) to `_posts/YYYY-MM-DD-your-slug.md`. Set the actual title, date, authors, abstract and body. The CMS freezes `permalink` when saving a scholarly article so later date or filename edits do not change its citation URL. For a manual post, set a stable permalink such as `/blog/2026/your-slug/` yourself.

Uploads are stored under `assets/pdf/blog/` with unique filenames and never overwrite another upload. The CMS checks the PDF signature, 5 MB limit, readable structure, lack of encryption and searchable text with Poppler. It does not verify scientific claims or that the PDF's title/authors match the form: check those yourself. Export selectable text, put the title and authors at the top, and end with formal references. Avoid scanned pages.

The Jekyll generator publishes attachments as `<article-url>paper.pdf` and citations as `<article-url>citation.bib`. This keeps the PDF in the article's directory, as required for `citation_pdf_url`. The raw upload directory and templates are excluded from public output. Removing an attachment clears its reference; the original upload remains recoverable in Git.

## Hide and restore

The Blog editor's **Hide post** action sets `published: false` without deleting or rewriting the article body or its attachments. The entry stays in the editor with a **Hidden** badge; **Restore post** sets it back to visible while retaining its URL and publication time. Click **Publish** to apply either change to the public site. Saving visibility never automatically publishes other workspace edits.

After the production deployment, a hidden post is absent from the blog index, home-page post lists, feeds, site search and sitemap. Its public article URL and the generated scholarly `paper.pdf` / `citation.bib` are removed from the output. Source files and the original PDF stay in Git for restoration. Private previews intentionally include hidden posts. Hiding a scheduled article also prevents the due-date job from releasing it.

## Indexing

The public [all-posts Atom feed](https://www.junjie-chen.info/feed.xml) includes full article bodies and normalized author metadata. The [Research Blog Atom feed](https://www.junjie-chen.info/research-feed.xml) includes only scholarly articles with both `scholarly.archive: true` and `scholarly.license: CC-BY-4.0`. Hidden posts and future articles are excluded from both feeds even in a private preview build. Feed metadata includes the blog title, authors, available ORCID URLs, language, dates, complete body and the article's actual license. The owner selected `CC-BY-NC-ND-4.0` for research articles and new templates; archive opt-in starts disabled.

In CMS **Research details → Publication & archiving**, set the language and each author's own ORCID. The separate **Content license** control applies to ordinary blogs and research articles; it explains permissions, intended uses and typical scenarios, with an expandable comparison table. Select the license there, then optionally enable **Include in Research Blog feed** when eligible. The selected CC BY-NC-ND 4.0 license is one of the options supported by arXiv; it permits attributed redistribution of the unadapted material for noncommercial purposes. Article pages display only a small license link below the citation block, with matching Atom and structured metadata. Removing an article from this site's feed does not recall copies already archived by third parties. The general feed does not impose CC BY on other posts or site assets.

Rogue Scholar requires CC BY 4.0, so the current restrictive license is not eligible and the research archive feed remains empty unless a separate compatible article is explicitly selected. No Rogue Scholar application has been submitted. A DOI must be assigned by the service before it is entered in the CMS.

Follow the [Google Scholar inclusion guidelines](https://scholar.google.com/intl/en/scholar/inclusion.html). Correct metadata makes a qualifying article easier to parse; it does not guarantee indexing. Keep at least the complete abstract publicly visible, use ordinary HTML links from the blog index, and check inclusion by searching the full title in Scholar. Adding a record to your Scholar profile is separate from search indexing.

## Content licenses

The CMS offers all six Creative Commons 4.0 licenses, CC0 1.0, All rights reserved and an unset state. See the [official CC comparison](https://creativecommons.org/cc-licenses/) and [CC0 terms](https://creativecommons.org/publicdomain/zero/1.0/). This control licenses article content; third-party material and separately licensed code retain their own terms. CC licenses do not remove statutory exceptions, and an existing compliant recipient's license cannot generally be revoked by changing the page later.

New research templates retain the owner's `CC-BY-NC-ND-4.0` default; ordinary new posts have no explicit grant until chosen. Existing posts are not relicensed automatically. The canonical per-article YAML field is `license`, using `CC-BY-4.0`, `CC-BY-SA-4.0`, `CC-BY-ND-4.0`, `CC-BY-NC-4.0`, `CC-BY-NC-SA-4.0`, `CC-BY-NC-ND-4.0`, `CC0-1.0`, `all-rights-reserved` or an empty string. Legacy `scholarly.license` is read when the top-level field is absent; the CMS synchronizes both on selection. An explicit empty top-level value suppresses a legacy grant. Switching article types preserves the selected license.

A small footer and `DC.rights` reflect the selected license for theme articles and standalone HTML posts. CC / CC0 choices link to official terms via `rel=license`; All rights reserved is a plain statement without an open-license URL. No choice emits no statement. Atom entries carry the same rights, and scholarly structured metadata carries the actual CC / CC0 URL. The archive feed still requires an explicit CC BY 4.0 selection and opt-in; selecting another license clears opt-in.
