# Academic services

The homepage displays **Services** after Selected Publications. It groups visible entries into Journal Reviewing and Conference Reviewing inside a fixed `21rem` scroll region, with touch scrolling, keyboard focus and a visible focus outline. All visible entries are rendered; the height never truncates the underlying list. An empty list hides the section.

Use **CMS → Services** to add or edit a venue, abbreviation, category, role, optional years/period and official website. Leave the period blank when no dates are specified. **Show on homepage** retains hidden records in the CMS; **Up / Down** changes order within a category. Save edits before reordering. Delete is available under Remove service, with confirmation. Save writes to the isolated workspace; review the Git diff and publish as usual. The footer's Jekyll preview includes saved service changes.

`_data/services.yml` is the only content source. Each item in `entries` has a stable `id`, `name`, `acronym`, `category` (`journal` or `conference`), `role`, `period`, `url`, `visible` and numeric `order`. The CMS validates names, URLs, unique IDs and order, preserves extra metadata, and rejects stale writes from another browser rather than overwriting them. Do not invent service years or promote a reviewer role to an editorial role.

Verify with `bundle exec ruby test/services_test.rb` and the Services case in `npm run test:personal`. The independent CMS has API and browser checks for editing, hiding, reordering, deletion and stale-save protection.
