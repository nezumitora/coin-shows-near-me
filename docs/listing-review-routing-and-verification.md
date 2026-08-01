# Listing Review Routing and Verification

## Current routing

### Unpublished local fixture

- `/review/test-show/` is generated only for unpublished local builds.
- Its `review_fixture: true` flag makes the listing-review handler stop before the spam check and `coinSubmitForm` network request.
- The submitted values remain in the current browser page only. They are not sent to Formspree or EspoCRM, written to disk, or retained after the page closes.
- The success panel summarizes the request type, relationship, normalized date, and fields marked for change so the workflow can be reviewed without external data transfer.

### Production listing pages

- Production listing-review forms pass the browser spam checks and submit one discrete request to Formspree for manual review.
- Browser-side EspoCRM capture is disabled: `window.coinCrmLeadCaptureUrl` must remain empty.
- A production submission does not edit a public listing, create a verification badge, or mark the entire show as verified.

## Verification evidence model

Each accepted person or source must become a separate append-only evidence record linked to the show. A show can therefore retain concurrent organizer, club, venue, dealer, and community evidence without one submission overwriting another.

Required record fields:

| Field | Purpose |
| --- | --- |
| Record ID | Stable unique identifier for this evidence record |
| Show ID | Link to the directory show |
| Contact ID | Private link to the submitting person, when retained with consent |
| Claimed relationship | Organizer, promoter, club officer, authorized staff, venue, dealer, community, or other |
| Checked relationship | Relationship independently established by the reviewer |
| Source type and URL | Evidence used for the decision |
| Confirmed fields | Exact listing fields supported by this evidence |
| Submitted at | Original request timestamp |
| Reviewed at and reviewer | Manual decision audit trail |
| Decision | Pending, accepted, rejected, expired, or revoked |
| Evidence expiry | Optional date for time-sensitive evidence |
| Notes | Private rationale without publishing personal details |

Public listing status must be derived from active accepted evidence, not stored as an irreversible whole-show verification flag. Public provenance can say `Organizer verified`, `Venue confirmed`, `Dealer reported`, or `Community reported` with a review date, while reporter identities remain private.

## Date normalization

- The browser collects `proposed_start_date` and optional `proposed_end_date` as ISO `YYYY-MM-DD` values, or records explicit `Date TBD`.
- It generates `proposed_next_date` as a readable four-digit-year summary for the reviewer.
- A protected server-side bridge must validate the ISO dates again, reject reversed ranges, and generate the canonical public display rather than trusting browser-generated text.
- Only an accepted manual review may update the show record or synchronize normalized dates into EspoCRM.

## Future protected EspoCRM bridge

The bridge must run server-side, keep EspoCRM URLs and credentials out of public HTML/JavaScript, validate Turnstile server-side if enabled, and append a new evidence record for every reviewed request. It must never overwrite prior evidence and must not automatically publish listing changes.
