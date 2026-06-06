# Session State

**Last updated:** 2026-06-05 resume checkpoint; local preview only; verification blocked by missing Docker
**Project:** Coin Shows Near Me / Coin Directory
**Mode:** local preview only

## Active worktree and preview

- Active local preview worktree: `/Users/milohiss/Git/coin-shows-near-me-feature-auto-20260603-113200`
- Current branch: `feature/auto-20260603-113200`
- Latest preview URL used this session: `http://127.0.0.1:54981`
- No deploy, PR, publish, live Formspree changes, CRM forwarding, dealer routing, campaigns, reminders, or SMS changes have been made.

## Current local changes

- Processed feedback from the restart:
  - Homepage search field shortened further on desktop from 420px to 340px so it ends before the buffalo head starts.
  - Mobile search width still allows up to 600px so small screens are not cramped.
  - Favicon set regenerated as the enlarged dark navy Option B: transparent/shadow pixels are ignored before crop so the buffalo head fills nearly the whole square.
  - Updated favicon files were copied into `_site/` for the running local preview.
  - Favicon files regenerated again using a head-first crop and mirrored into `_site/`.
  - Local-only favicon cache-buster added to homepage and shared favicon links: `?v=local-option-b-enlarged-20260603-2`.
  - Favicon simplified again for tab readability: solid `#001944` navy square with flat `#C8912B` antique-gold buffalo silhouette, no texture/gradient/shadow/transparent background.
  - Local-only favicon cache-buster updated to `?v=local-flat-navy-gold-20260603-1`.
  - Favicon replaced again with a manually drawn simple two-color buffalo-head mark, not derived from the detailed source image.
  - Current local favicon cache-buster is `?v=local-flat-simple-20260603-2`.
  - Homepage top header/nav navy changed to match the sidebar navy: `#0e2338`.
  - Shared non-home color variable `--coin-navy` also changed to `#0e2338`, and sidebar now references that variable.
  - Public inner pages now follow the homepage design direction instead of the docs/sidebar layout:
    - `_layouts/default.html` no longer injects the Just-the-Docs sidebar or docs search header.
    - Inner pages use `body.public-page`, the same global top navigation, full-width centered content, navy/gold styling, and card-like public page content.
    - The theme breadcrumb include was removed from the public layout.
    - Custom breadcrumbs were converted from an ordered list to span markup to prevent the theme from showing a stray list number.
  - Added shared navy variable `--coinshows-navy: #0E2338` and wired homepage/inner nav/temporary sidebar references through it.
  - Inner pages now use a separate compact homepage-style blue gradient hero, shorter than the homepage hero, instead of a fixed blue background inside the content card.
  - The compact public hero is generated in `_layouts/default.html` with title, breadcrumb, short intro, gold divider, and subtle buffalo watermark mark.
  - White page content now starts in a separate card below the hero so text/cards do not overlap or run into the blue hero area.
  - Melt Value spot prices now render as a single white/gold card below the hero instead of blending into or duplicating the blue hero area.
  - Added dedicated `/major-shows/` page with title, intro, and major-show cards; top nav Major Shows link now points there instead of `/#featured`.
  - Final local audit passed for `/states/`, `/states/california/`, `/major-shows/`, `/tools/`, `/tools/melt-value-calculator/`, `/tools/sales-tax-guide/`, `/guides/`, `/guides/beginners-guide/`, `/guides/inherited-coin-collection/`, `/blog/`, `/dealers/`, and `/contact/`: no old sidebar layout or docs search header found.
- Homepage hero redesigned into a two-column layout:
  - left: headline, subtitle, stats, search field
  - right: “Get Offers Before the Show” CTA card
  - centered spot price card across the hero
- Hero buffalo watermark is using:
  - image: `assets/images/coinshows-buffalo-head-front-transparent-gold-navy.png`
  - CSS: `.hero::before`
  - size: `min(760px, 68vw)` by `min(520px, 46vw)`
  - position: `top: 51%`, `left: 50%`
  - opacity: `0.14`
- Non-home/sidebar logo now uses the transparent buffalo asset via `_config.yml`.
- Duplicate top buffalo logo was removed from `_includes/top-nav.html`.
- Non-home duplicate visible “Sign Up” was suppressed with `aux_links: {}` and `.aux-nav { display: none !important; }`.
- Heading hover permalink icon is hidden.
- Quote CTA scroll behavior was adjusted to account for sticky header/banner and sticky filter bar.
- Placeholder sponsored/industry partner placement section was restored under the hero.

## Favicon work so far

- Current favicon files were regenerated from the transparent buffalo head:
  - `favicon.ico`
  - `assets/images/favicon-16x16.png`
  - `assets/images/favicon-32x32.png`
  - `assets/images/favicon-192x192.png`
  - `assets/images/apple-touch-icon.png`
- Two local favicon test sets were generated:
  - Option A: transparent background, tighter/larger buffalo head
  - Option B: dark navy background, tighter/larger buffalo head
- Visual verdict so far: Option B is clearer in a tab-size preview because navy gives the gold buffalo stronger contrast.

## Screenshots saved to Desktop sharing folder

- `~/Desktop/Files to show Milo/coinshows-watermark-hero-centered-left.png`
- `~/Desktop/Files to show Milo/coinshows-favicon-options-a-b.png`
- `~/Desktop/Files to show Milo/coinshows-hero-search-340-local.png`
- `~/Desktop/Files to show Milo/coinshows-favicon-option-b-enlarged-local.png`
- `~/Desktop/Files to show Milo/coinshows-favicon-cachebusted-actual-local.png`
- `~/Desktop/Files to show Milo/coinshows-favicon-flat-navy-gold-local.png`
- `~/Desktop/Files to show Milo/coinshows-homepage-header-navy-match-local.png`
- `~/Desktop/Files to show Milo/coinshows-sidebar-navy-comparison-local.png`
- `~/Desktop/Files to show Milo/coinshows-actual-cachebusted-favicon-tab-preview-local.png`
- `~/Desktop/Files to show Milo/coinshows-homepage-current-public-style-local.png`
- `~/Desktop/Files to show Milo/coinshows-inner-states-public-style-local.png`
- `~/Desktop/Files to show Milo/coinshows-inner-california-public-style-final-local.png`
- `~/Desktop/Files to show Milo/coinshows-homepage-shared-navy-local.png`
- `~/Desktop/Files to show Milo/coinshows-states-compact-public-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-california-compact-public-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-major-shows-dedicated-page-local.png`
- `~/Desktop/Files to show Milo/coinshows-tools-compact-public-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-states-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-california-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-major-shows-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-melt-value-calculator-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-sales-tax-guide-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-sales-tax-california-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-guides-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-blog-compact-hero-local.png`
- `~/Desktop/Files to show Milo/coinshows-audit-contact-compact-hero-local.png`
- Earlier related screenshots remain in the same folder, including watermark, quote-click, and sidebar-logo previews.

## New inbox feedback received before restart

Inbox message read from:

- `/Users/milohiss/Git/coin-shows-near-me/inbox/2026-06-03_123601_milohiss-search-favicon-feedback.json`

Feedback to process next, local preview only:

1. Homepage search field is too long and overlaps/cuts into the buffalo watermark. Shorten the search field by about 25–35%, or just enough to avoid overlap.
2. Milo likes the dark navy favicon option, but the buffalo head needs to be larger/tighter so it reads clearly at tab size.
3. Keep local preview only. No deploy, PR, live Formspree changes, CRM forwarding, dealer routing, campaigns, or SMS.

Referenced screenshots from inbox:

- `~/Desktop/Files to show Milo/Screenshot 2026-06-03 at 12.34.19 PM.png`
- `~/Desktop/Files to show Milo/coinshows-favicon-options-a-b.png`

## Files currently modified/untracked in active worktree

Modified:

- `_config.yml`
- `_includes/head_custom.html`
- `_includes/top-nav.html`
- `_layouts/homepage.html`
- `assets/images/apple-touch-icon.png`
- `assets/images/favicon-16x16.png`
- `assets/images/favicon-192x192.png`
- `assets/images/favicon-32x32.png`
- `favicon.ico`

Untracked:

- `assets/images/coinshows-buffalo-head-front-transparent-gold-navy.png`
- `assets/images/favicon-option-a-transparent-tight-16x16.png`
- `assets/images/favicon-option-a-transparent-tight-180x180.png`
- `assets/images/favicon-option-a-transparent-tight-192x192.png`
- `assets/images/favicon-option-a-transparent-tight-32x32.png`
- `assets/images/favicon-option-a-transparent-tight-48x48.png`
- `assets/images/favicon-option-b-navy-tight-16x16.png`
- `assets/images/favicon-option-b-navy-tight-180x180.png`
- `assets/images/favicon-option-b-navy-tight-192x192.png`
- `assets/images/favicon-option-b-navy-tight-32x32.png`
- `assets/images/favicon-option-b-navy-tight-48x48.png`
- `favicon-option-a-transparent-tight.ico`
- `favicon-option-b-navy-tight.ico`
- `SESSION-STATE.md`

## Build and verification notes

- Latest compact hero cleanup was built with Docker/Jekyll successfully; running preview serves the rebuilt `_site/`.
- Preview verified at `http://127.0.0.1:54981/`; homepage contains the 340px desktop search width and favicon files load.
- Verified the actual served homepage includes cache-busted links for `favicon.ico`, `favicon-16x16.png`, `favicon-32x32.png`, `favicon-192x192.png`, and `apple-touch-icon.png`.
- Verified source favicon hashes match the `_site/` preview copies.
- A later Docker Jekyll rebuild completed successfully after the compact gradient hero cleanup; no deploy was made.
- Earlier Jekyll build completed locally via Docker after watermark/favicon work.
- Build warnings were Just the Docs Sass deprecation warnings only; no build failure.
- Do not stage `_site/` or temporary files if committing later.

## Next recommended steps after restart

1. Process the inbox feedback above.
2. Copy/read the screenshot from Desktop via `/tmp` first because macOS screenshot filenames can include a narrow no-break space.
3. Shorten `.hero-action-stage` / search width by about 25–35% on desktop only, then rebuild and screenshot.
4. Generate a tighter Option B favicon where the buffalo fills more of the canvas; compare at 16x16 and 32x32.
5. Report screenshots and favicon recommendation. Do not deploy or open a PR unless explicitly approved.

## Current checkpoint

- Local preview URL: `http://127.0.0.1:54981/`
- Active worktree: `/Users/milohiss/Git/coin-shows-near-me-feature-auto-20260603-113200`
- Branch: `feature/auto-20260603-113200`
- Status: local preview only; no deploy, PR, or live changes.
- Public layout direction: homepage-style top nav across public pages, no left docs sidebar on audited public pages.
- Shared navy variable: `--coinshows-navy: #0E2338`.
- Inner pages use a compact homepage-style blue gradient hero/title band with the buffalo watermark removed.
- Major Shows dedicated page exists at `/major-shows/`.
- Temporary simplified favicon kept.
- Latest screenshot audit covered States, California, Major Shows, Melt Value Calculator, Sales Tax guide, California sales-tax page, Guides, Blog, and Contact. The original overlap issues were not visible in the captured top-of-page audits.

## Latest design cleanup checkpoint

- Removed the buffalo logo/watermark from compact inner-page heroes.
- Contact page now has tighter card-based sections, placeholder social links only (`#`) for Facebook, Instagram, X/Twitter, and LinkedIn, plus quick links and a dealer-interest CTA.
- Melt Value Calculator now uses the dark homepage-style spot price bar, cream/navy calculator panels, better contrast, and responsive table wrapper styles for result breakdowns.
- Find a Dealer now has intro cards, a styled search/filter panel, stronger dealer cards, and a `Contact Us to Be Listed` CTA.
- State/city/show layouts now use clearer `Get Dealer Quotes Before the Show` CTAs pointing to the Melt Value Calculator/offer flow.
- Guides index now has a single `Find Coin Shows Near You` CTA.
- Local Jekyll build succeeded after these changes; warnings were Just-the-Docs Sass deprecation warnings only.
- Latest screenshots saved:
  - `~/Desktop/Files to show Milo/coinshows-contact-cleanup-local.png`
  - `~/Desktop/Files to show Milo/coinshows-melt-value-cleanup-local.png`
  - `~/Desktop/Files to show Milo/coinshows-find-dealer-cleanup-local.png`
  - `~/Desktop/Files to show Milo/coinshows-california-state-cta-cleanup-local.png`
  - `~/Desktop/Files to show Milo/coinshows-guides-cta-cleanup-local.png`
  - `~/Desktop/Files to show Milo/coinshows-melt-value-mobile-overflow-check-local.png`

## 2026-06-04 local fix pass

- Fixed Melt Value Calculator result table behavior so desktop uses fixed-layout wrapping and narrow screens keep horizontal scroll inside `.coin-table-wrap` instead of forcing whole-page overflow.
- Added `overflow-x: hidden` to public-page body as a safety guard and changed public content cards to hide internal overflow rather than letting wide children push the page.
- Aligned the Sales Tax Guide search field with the state-card container by moving it into `.tax-search-panel` and letting the input span the same content width.
- Added a clean small logo mark to compact inner-page heroes via `.public-hero-logo`; no watermark treatment.
- Updated Contact CTA copy from “Need dealer interest?” to “Have a show, shop, or collection question?” and made that CTA narrower with `.public-cta--compact`.
- Reduced `.dealer-feature-card` padding so the For Collectors / For Dealers cards visually match dealer-card spacing better.
- Added Tools card/link for future Collection Tracker and created placeholder page at `/tools/collection-tracker/`.
- Local Docker/Jekyll build succeeded after this pass; warnings were Just-the-Docs Sass deprecation warnings only.
- Latest screenshots saved:
  - `~/Desktop/Files to show Milo/coinshows-melt-value-table-fix-desktop-local.png`
  - `~/Desktop/Files to show Milo/coinshows-melt-value-table-fix-mobile-local.png`
  - `~/Desktop/Files to show Milo/coinshows-sales-tax-search-align-local.png`
  - `~/Desktop/Files to show Milo/coinshows-contact-cta-wording-size-local.png`
  - `~/Desktop/Files to show Milo/coinshows-find-dealer-card-spacing-local.png`
  - `~/Desktop/Files to show Milo/coinshows-tools-collection-tracker-card-local.png`
  - `~/Desktop/Files to show Milo/coinshows-collection-tracker-placeholder-local.png`

## 2026-06-04 responsive table and hero logo correction

- Melt Value Calculator table fix was tightened again after feedback:
  - `.calc-container`, `.calc-panel`, `.result-box`, and `.coin-table-wrap` now have explicit `max-width: 100%`, `min-width: 0`, and contained overflow behavior.
  - The generated breakdown rows now include `data-label` attributes.
  - On mobile, the breakdown table converts into stacked rows/cards instead of forcing a wide table across the page.
  - Markdown/reference tables also get public-page `.table-wrapper` horizontal-scroll protection.
- Compact inner-page hero logo was changed from a tiny mark to a larger homepage-style buffalo image treatment on the right side of the compact hero; it is scaled down from the homepage hero treatment but is not a full watermark.
- Local Docker/Jekyll build succeeded after this correction; warnings were Just-the-Docs Sass deprecation warnings only.
- Latest screenshots saved:
  - `~/Desktop/Files to show Milo/coinshows-melt-value-responsive-table-desktop-local.png`
  - `~/Desktop/Files to show Milo/coinshows-melt-value-responsive-table-mobile-local.png`
  - `~/Desktop/Files to show Milo/coinshows-inner-hero-buffalo-logo-corrected-local.png`

## 2026-06-04 enlarged logo / table headers / Tools menu pass

- Enlarged the compact inner-page buffalo logo treatment again while keeping it on the right side of the compact hero.
- Added brand styling to Melt Value breakdown table headers: navy header row, white text, gold accent on value column, gold border/accent, and cream alternating rows/cards on mobile.
- Added `Collection Tracker` to the visible Tools dropdown/menu.
- Verified the placeholder page remains at `/tools/collection-tracker/` and describes tracking coins, bullion, purchase price, melt value, notes, photos, collection totals, and a database or Google Sheets-style workflow.
- Local Docker/Jekyll build succeeded; warnings were Just-the-Docs Sass deprecation warnings only.
- Latest screenshots saved:
  - `~/Desktop/Files to show Milo/coinshows-inner-hero-logo-enlarged-local.png`
  - `~/Desktop/Files to show Milo/coinshows-melt-value-table-headers-branded-local.png`
  - `~/Desktop/Files to show Milo/coinshows-tools-dropdown-collection-tracker-local.png`
  - `~/Desktop/Files to show Milo/coinshows-collection-tracker-placeholder-verified-local.png`

## 2026-06-04 checkpoint only / browser automation note

- Checkpoint saved only; no browser automation was used for this checkpoint.
- Do not open Safari for future preview checks.
- Local preview only remains the active mode: no deploy, PR, publish, live Formspree changes, CRM forwarding, dealer routing, campaigns, reminders, SMS, DNS, or live settings changes.
- Active preview URL remains `http://127.0.0.1:54981/`.
- Active worktree remains `/Users/milohiss/Git/coin-shows-near-me-feature-auto-20260603-113200` on branch `feature/auto-20260603-113200`.
- Latest pending issue: Brave Nightly-only browser automation rule was not loaded/used earlier. Future browser automation must use only Brave Nightly with the approved Milo Automation profile/window, and must not use Safari.

## 2026-06-05 resume checkpoint

- Previous active worktree `/Users/milohiss/Git/coin-shows-near-me-feature-auto-20260603-113200` was still owned by active OpenCode PID `87110`, so the preserved changes were copied into this dedicated resume worktree: `/Users/milohiss/Git/coin-shows-near-me-resume-20260605`.
- Active branch is now `feature/resume-20260605`.
- No browser automation, screenshots, deploy, PR, publish, live Formspree, CRM/SMS, DNS, or live-setting changes were made during resume.
- `git diff --check` initially found only trailing whitespace in this file; those lines were cleaned.
- Docker-based Jekyll build verification could not run in this restarted environment because `docker` is not installed/available in PATH.
