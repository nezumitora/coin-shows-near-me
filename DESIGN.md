# Coin Shows Near Me Design

## Product focus

- The homepage's primary action is finding a coin show.
- Search remains the first homepage action.
- Use the familiar two-column hero: show search first, one compact `Stay in the Loupe` reminder-interest card second, and the navy/gold spot-price strip directly below both.
- Keep exactly one general reminder-interest form on the homepage; do not duplicate it lower on the page.
- Provide combined `All Shows`, `This Weekend`, and `This Month` filters with one state selector rather than a crowded fifty-state pill row.
- Do not place sponsor previews or dealer promotions on the homepage.
- On the dealer directory, the compact CTA must jump directly to a dedicated dealer-listing form on the same page; do not route dealers through a generic contact page or a second CTA. Dealer types are multi-select, brick-and-mortar selection reveals a required physical address, and each social network has its own CRM-friendly field.
- Reminder-interest forms collect separate first and last names, email, selected state, and optional show/location interests.
- Do not collect mobile numbers or promise recurring reminder delivery until the delivery and opt-out systems receive separate approval.
- Use the reminder consent wording: `Notify me when show reminders become available. No reminder service is active yet. Privacy Policy.` Keep the policy text linked.

## Listing trust

- Use plain-language date statuses: `Scheduled`, `Date not confirmed`, `Past date — next date unconfirmed`, and `Past show`.
- `Scheduled` requires an explicit confirmed event range whose end is today or later; it never comes from recurrence text alone.
- Use `Past date — next date unconfirmed` for a recurring series with only past confirmed occurrences. Reserve `Past show` for a genuinely ended nonrecurring event.
- `This Weekend` means overlap with the actual Saturday/Sunday window. Do not include Friday-only dates or infer a weekend date from recurrence wording.
- Show the last-checked date when one is recorded; otherwise state that it is not recorded.
- Link to the source used for verification when available without calling every source official.
- Remind visitors to verify details before traveling and provide a correction path.
- Organizer-verification and new-show submissions are reviewed manually against public official-source evidence; submitting a form never verifies or publishes a listing automatically.
- Anyone may submit reliable show confirmations or corrections, but `Organizer verified` is reserved for independently checked organizers, promoters, club officers, or authorized show staff. Record other accepted input with dated `Venue confirmed`, `Dealer reported`, or `Community reported` provenance without exposing the reporter's identity; dealer/community reports do not establish verification by themselves.
- Listing-removal requests are manually reviewed; accurate public event facts may remain while private personal information and supported corrections receive separate consideration.
- New-show forms group venue/address fields under a clear Show location heading and use overflow-safe form controls.
- Show full street, city, state, and ZIP details only when verified; otherwise say the complete street address is not yet verified instead of repeating the venue as though it were an address.
- Give every show detail page a distinctive navy/gold Collector Share Kit. Use direct sharing only where the web platform supports it; for Instagram, TikTok, Snapchat, Whatnot, and YouTube, clearly label ready-to-paste caption copying instead of pretending there is a direct web-share endpoint. Never attach tracking parameters.
- State pages may summarize coin and bullion tax treatment only from the dedicated tax dataset, must link to the state-specific guide and authority source, and must warn that definitions, local taxes, exemptions, and laws can change.
- Tax classifications require an exact current government source and checked date. Use orange `Review pending` cards and suppress rates, thresholds, product lists, and exempt/taxed verdicts when that evidence is incomplete; reserve green/red classifications for checked entries and include category-specific conditions in text.
- Unpublished local review fixtures may exercise form states, but must never enter canonical show data, appear in the sitemap, send email, or deploy.
- Use one unified listing-review form for confirmations, corrections, organizer verification, and review/removal requests. Show current values beside prefilled proposed values, mark fields correct by default, and let users unlock only fields that need changes.
- Use validated start/end calendar fields plus a public `Date not confirmed` choice for proposed listing dates. Preserve ISO values and the internal `TBD` review value for manual CRM review, and generate the public four-digit-year display instead of accepting unrestricted date prose.
- Use the listing-review heading `Review or update this listing.` and make its collapsed/expanded action explicit. Confirmations, corrections, claims, verification requests, and removal requests remain manual and never auto-publish.
- Dealer profiles may show address, phone, website, or social links only when voluntarily submitted for publication or source-verified. Keep private review contacts and home addresses out of public data.
- `Claimed` means the representative relationship passed manual review; `Verified` means displayed public business details were independently checked. Payment and promotion never affect either state.
- Until a reviewed dealer-offer workflow exists, seller CTAs must remain educational: explain junk-silver melt value and collectible premiums, link to the calculator, and state that the site does not request dealer offers.
- Dormant portal pages must state that no account, collection-upload, offer-request, or notification service is active. They must not collect seller or waitlist information or promise a launch until the workflow, privacy, security, and legal controls are approved.
- Local review fixtures must show a browser-only result summary that clearly says nothing was sent to Formspree or EspoCRM and nothing was saved.

## Visual hierarchy

- Navy and gold remain the core brand colors.
- Keep the familiar gold `#b8860b` for button surfaces and decorative accents. Use navy text on gold controls and reserve dark gold `#7a5700` for normal link text on light surfaces so both combinations meet WCAG AA without turning site-wide controls brown.
- Green indicates a scheduled date, amber an unconfirmed date, orange a past recurring occurrence without a confirmed next date, and red an ended nonrecurring show.
- Status colors always include text labels and never communicate meaning through color alone.
- Keep trust information compact on cards and complete on show detail pages.
