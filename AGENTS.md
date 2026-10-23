# Agent Guidelines for al-folio (v1.x)

## This personal site's working contract

This checkout is **CoderChen01/coderchen01.github.io**, Junjie (Jorji) Chen's personal site, not the upstream starter. The site-specific rules in this section take precedence over generic starter guidance below.

- Publish source changes to `master`; GitHub Actions builds and pushes generated output to `gh-pages`. Never delete `gh-pages` or commit generated `_site` output.
- The real production `baseurl` is empty (root at `https://www.junjie-chen.info`). Do not force `/al-folio` for this site.
- Local `_layouts`, `_includes`, and `_sass` overrides are intentional and supported. Read `docs/ARCHITECTURE.md#local-overrides-your-site-vs-this-repo`. Preserve them and audit drift when editing gem-owned paths. Starter-only ownership/integration jobs are intentionally skipped on this personal repository; keep actual formatting, build, upgrade and site checks enabled.
- Install JavaScript dependencies with `npm ci`; CI must use the committed lockfile, never install latest formatter packages during a check.
- After changing an override, run `bundle exec al-folio upgrade overrides audit`, review the result, then `bundle exec al-folio upgrade overrides accept <path>` when appropriate. **Run formatting after the audit/accept command:** it rewrites `.al-folio-overrides.yml` and can otherwise make CI fail despite an earlier clean check.
- Before committing, run `npx prettier <changed supported files> --write`, then `npm run lint:prettier`, `bundle exec jekyll build`, and `git diff --check`. Include the updated `.al-folio-overrides.yml` in the commit. Use an available supported Ruby/Bundler executable if the system Ruby is obsolete.
- After publishing, inspect Actions for the actual pushed commit SHA, confirm Pages deployment success, and inspect the live behavior. Do not report deployment complete based only on `git push`.
- Home news must render all entries inside `.home-news-scroll`, with bounded height, touch/keyboard scrolling and focus visibility. Do not reintroduce a five-entry Liquid limit.
- Publication annotations use `.publication-note-trigger` and an immediate custom tooltip implemented in `assets/js/site-custom.js`; preserve hover, focus, touch/click and Escape/outside dismissal. Never restore delayed native `title` tooltips for notes.
- Interactive blogs keep HTML in `_posts/*.html`, article CSS in `assets/css/blog/`, and JavaScript in `assets/js/blog/`. Research Interests uses `_posts/2026-03-15-research-vision.html` plus `research-vision.css`/`.js` in those folders. Keep its existing public URL and post slug. Do not move article styles back into `_sass/_site-custom.scss` or parse this HTML article as Markdown in the CMS.
- Scholarly posts opt in with `layout: scholarly` and `scholarly.enabled: true`; see `docs/SCHOLARLY_POSTS.md` and `templates/scholarly-post.md`. `_plugins/scholarly_articles.rb` emits the `.bib` download and copies optional PDFs to the article directory. Keep PDF optional, never emit an empty PDF link/meta tag, preserve citation URLs, and do not turn placeholder templates into live posts. Run `bundle exec ruby test/scholarly_articles_test.rb` when changing this feature.

**This file is the authoritative entry point for coding agents working in this repo.** Read it before making any change. It is intentionally short and tool-neutral; it links to the one place each longer-form fact lives.

`al-folio` v1.x is a **thin Jekyll starter, not a theme**. This repo owns starter wiring, example content, docs, and cross-plugin tests. All runtime — layouts, includes, Sass, Liquid tags, filters, feature JS — lives in versioned gems published under [`al-org-dev`](https://github.com/al-org-dev).

## Route your change

Find your change on the left; edit only what is on the right.

| Your change                                                                                                              | Goes in                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------- |
| Dependency pin, plugin activation, feature flag                                                                          | this repo: `Gemfile` **and** `_config.yml` (both — see below)                                                 |
| Example/demo content, bibliography, data files                                                                           | this repo: `_pages`, `_posts`, `_projects`, `_news`, `_teachings`, `_books`, `_data`                          |
| Documentation                                                                                                            | this repo: `docs/` (long-form) or this file (agent rules)                                                     |
| Cross-plugin integration test, visual parity test                                                                        | this repo: `test/integration_*.sh`, `test/visual/`                                                            |
| Plugin catalog metadata                                                                                                  | this repo: `_data/featured_plugins.yml`                                                                       |
| A layout, include, or Sass partial                                                                                       | the owning gem — start with `al_folio_core`                                                                   |
| A Liquid tag or filter, or what a tag renders                                                                            | the gem that registers it — see the [delegation table](docs/ARCHITECTURE.md#wrapper-to-tag-to-gem-delegation) |
| Feature behavior (search, math, charts, comments, cookies, icons, CV, distill, analytics, images, newsletter, citations) | that feature's gem — see [`docs/BOUNDARIES.md`](docs/BOUNDARIES.md)                                           |
| Component/unit test for gem-owned behavior                                                                               | the owning gem, not here                                                                                      |
| A feature with no existing owner                                                                                         | open a plugin proposal issue first, then a standalone plugin repo                                             |

[`docs/BOUNDARIES.md`](docs/BOUNDARIES.md) is the authoritative area-to-gem table. [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) explains how the pieces connect.

## Stop sign

**If your change would create any of these paths in this repo, it belongs in a gem instead:**

```
_layouts/   _includes/   _sass/   _scripts/   assets/tailwind/   tailwind.config.js   assets/webfonts/
```

`npm run lint:style-contract` fails CI when any of them exists here, and it also rejects `build:css` / `build:tailwind` npm scripts. Do not add a starter-local Tailwind or CSS build pipeline.

This restriction applies to **this repo only**. A user's own site created from this template _may_ legally shadow gem-owned files — see [local overrides: your site vs. this repo](docs/ARCHITECTURE.md#local-overrides-your-site-vs-this-repo).

## Three failures that produce no error message

Read [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md#failure-modes-that-produce-no-error-message) for the full explanation. The short version:

1. **Features fail silently.** A feature renders only when its gem is loaded _and_ its flag is on _and_ the page opts in. Otherwise the Liquid tag emits an empty string — no warning, no error.
2. **`Gemfile` and `_config.yml` are two lists that must agree.** A plugin in only one of them is inert. Adding or removing a plugin means editing both. Repo dirs use hyphens (`al-folio-core`); gem/plugin ids use underscores (`al_folio_core`).
3. **This repo's effective baseurl is `/al-folio`.** `_config.yml` already sets it, so a plain `bundle exec jekyll build` is correct — that is what `deploy.yml`, `broken-links-site.yml` and `axe.yml` run. Passing `--baseurl /al-folio` is redundant but harmless; blanking the baseurl out is what renders the site unstyled with broken links. Dev server is at `http://localhost:4000/al-folio/`.

## Validated local command set

Run from the repo root, in this order:

```bash
bundle install
npm ci
npm run lint:prettier
npm run lint:style-contract
bundle exec jekyll build --baseurl /al-folio
bash test/integration_comments.sh
bash test/integration_plugin_toggles.sh
bash test/integration_distill.sh
bash test/integration_bootstrap_compat.sh
bash test/integration_upgrade_cli.sh
bash test/integration_css_minify.sh
bash test/integration_new_plugins.sh
npx playwright install chromium webkit
npm run test:visual
bundle exec al-folio upgrade audit
bundle exec al-folio upgrade overrides audit
bundle exec al-folio upgrade report
docker compose up -d
curl -fsS http://127.0.0.1:8080/al-folio/ >/dev/null
docker compose logs --tail=80
docker compose down
```

All seven `test/integration_*.sh` scripts are gated by `unit-tests.yml`; run the ones your change touches. Docker note: v1 uses `/srv/jekyll/bin/entry_point.sh` and serves from container-local `/tmp/_site` to avoid host bind-mount write deadlocks.

## Before you open a PR

- Keep starter work here; route runtime behavior to the owning plugin repo.
- Run `npm run lint:prettier` (Prettier with `@shopify/prettier-plugin-liquid`, `printWidth: 150`). `npx prettier . --write` fixes formatting.
- Keep docs aligned with v1 ownership, and keep each fact in one place — link rather than restate.
- If you create or keep local overrides of plugin-owned files, run `bundle exec al-folio upgrade overrides audit` and commit `.al-folio-overrides.yml` after review.

## Further reading

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — how the starter and gems fit together, silent failure modes, the v1 config contract, local overrides.
- [`docs/BOUNDARIES.md`](docs/BOUNDARIES.md) — authoritative area-to-gem ownership table and PR triage playbook.
- [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) — contributor workflow and agent tooling.
- [`docs/README.md`](docs/README.md) — index of all user and maintainer guides.
- `.agents/skills/al-folio-bootstrap/SKILL.md` — new-site setup workflow.
- `.agents/skills/al-folio-v1-migration/SKILL.md` — customized-fork migration and override drift auditing.
- `.codex/skills` and `.claude/skills` are symlinks to `.agents/skills` for agent-specific discovery.
