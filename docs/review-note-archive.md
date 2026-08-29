# Owner Review Note Archive

This is the durable chronological record for the second owner-review round. The same read-only records appear in the local review panel. They are not included in a production build.

## Note 1

- Route: `/coin-shows-this-weekend/`
- Target: `Next Weekend (Sep 5-Sep 6)`
- Selector: `#next-weekend-heading`
- Original timestamp: `2026-08-29T21:01:36.560Z`
- Owner text: `I think i already told you this, but i know for sure we're missing a coin show in this section. it might be the north county or buena park show. I'm lucky i know about that one, but how can we verify if there are othermissing shows?`
- Resolution state: Resolved with official-source evidence; no unreviewed date added.
- Resolution: Pacific Expos' exact North County dates page omits September 6 and lists October 4 as the next 2026 North County date. Its official home page lists Buena Park on September 12-13, 2026. The report-only comparison registry checks only hand-reviewed sources; new, unlisted, unavailable, or incomplete source pages remain blind spots and require manual review.

## Note 2

- Route: `/tools/melt-value-calculator/`
- Target: `Platinum Eagle`
- Selector: `body > main > div:nth-of-type(4) > table > tbody > tr:nth-of-type(21) > td:nth-of-type(2)`
- Original timestamp: `2026-08-29T21:03:53.290Z`
- Owner text: `That's not a nickname for that coin, it's APE.`
- Resolution state: Resolved with contextual terminology.
- Resolution: APE is expanded as American Platinum Eagle, while American Palladium Eagle remains fully named. U.S. law and PCGS distinguish the platinum series from the $25 palladium Eagle.

## Note 3

- Route: `/tools/collection-tracker/`
- Target: `Collection Tracker`
- Selector: `#public-page-title`
- Original timestamp: `2026-08-29T21:06:23.431Z`
- Owner text: `where does this survey form go to when submitted?`
- Resolution state: Resolved; inactive by design.
- Resolution: The review-only survey sends nowhere and stores nothing remotely. It is absent from the production build and remains inactive until separately approved.

## Note 4

- Route: `/dealers/`
- Target: `Use a business-domain email and an official public source when possible. Do not send passwords, identity documents, private home addresses, or other sensitive p`
- Selector: `body > div:nth-of-type(1) > div > div > main > section > p:nth-of-type(2)`
- Original timestamp: `2026-08-29T21:16:56.961Z`
- Owner text: `How does this section work, what listing is the user trying to claim if there are a bunch of listing above this section? Wouldnt a  button that said "claim this listing" on every dealer card. then when the user clicked the button, a window pops up witth this form so they can claim that specific listing? Maybe a similar feature would be useuful for coin shows too, what do you think?`
- Resolution state: Review candidate implemented; owner decision pending for modal treatment.
- Resolution: Every dealer card selects and opens its exact manual-claim form. Show cards route to their exact listing review form, which includes a manual claim request. A modal instead of the accessible in-page form remains an owner choice.

## Note 5

- Route: `/`
- Target: `Join the show reminder interest list`
- Selector: `body > div:nth-of-type(1) > nav > div > ul > li:nth-of-type(7) > a`
- Original timestamp: `2026-08-29T21:19:01.857Z`
- Owner text: `this button is still unclear, Maybe say something like "future show notifications" or something similar?`
- Resolution state: Resolved.
- Resolution: The navigation label now says Future Show Notifications while the destination continues to disclose that no reminder service is active.

## Note 6

- Route: `/tools/melt-value-calculator/`
- Target: `APE (American Platinum Eagle)`
- Selector: `body > main > div:nth-of-type(4) > table > tbody > tr:nth-of-type(19) > td:nth-of-type(2)`
- Original timestamp: `2026-08-29T23:05:52.515Z`
- Owner text: `the nicknane should only be APE, the brackets are not needed since the full real name is shown in the 1st column,`
- Resolution state: Resolved; shorthand simplified.
- Resolution: The Common shorthand cells now display only APE. The first column retains the full American Eagle Platinum Bullion Coin name, and American Palladium Eagle remains separately named so the two series are not confused.

## Note 7

- Route: `/`
- Target: `197`
- Selector: `#showing-count`
- Original timestamp: `2026-08-29T23:07:15.646Z`
- Owner text: `how are we updating show dates and info, this has been the same sine we made the site. Is there an automation scheduled to grab new show dates and if so, how often are we doing that and udpateing the site with the show info?`
- Resolution state: Resolved with observed active report-only schedule.
- Resolution: Observed active GitHub Actions workflows run daily: Show Update Report at 08:25 UTC checks every approved source URL stored on the 197 listings; External Source Comparison at 09:10 UTC fetches 48 reviewed source groups for 78 configured show IDs; Third-Party Discovery at 09:40 UTC checks 41 lead-source groups across 39 states. All have read-only repository permission and upload artifacts only. They do not edit show data or publish. A human must review artifacts, confirm official evidence, manually edit canonical data, validate/build, and obtain owner approval before publication. The homepage count is the number of canonical records, so date changes within existing records do not change 197. No Coin-specific cron, launchd, or aidevops routine was observed.
