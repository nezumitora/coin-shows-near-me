# Dealer Claim and Contact Verification

## Safety boundary

- Dealer listing and claim submissions are private review inputs. They never edit `_data/dealers.yml` or publish automatically.
- Never request or retain passwords, identity documents, private home addresses, or unnecessary personal data.
- Private review email and phone values stay in the review system. They are not copied into public dealer data.
- Payment, sponsorship, advertising, or promotion never changes claim or verification decisions.

## Manual review workflow

1. Match the submission to an existing dealer record using the stable slug shown as `dealer_id` and the business name.
2. Confirm the claimant's relationship using a business-domain email plus an approved public business, organization, licensing, or official contact source. Do not rely on the claimant's statement alone.
3. Set `claim_status: claimed` only after the representative relationship is established. This does not verify every listing field.
4. Independently check each proposed public address, phone, website, and social profile. Confirm it is a business contact, not a private residence or personal contact.
5. Add approved fields under `public_contacts` in `_data/dealers.yml`. Set `publication_basis` to `voluntarily_submitted` or `source_verified`, and record the exact `source_url` and `last_verified` date.
6. Set `claim_status: verified` only when the displayed public business details have current independent evidence. A dealer can be claimed without being verified.
7. Run the dealer-data tests and production build, then review `/dealers/` at desktop and mobile widths before committing.

## Files and verification

- Data decisions: `_data/dealers.yml`
- Public rendering and claim form: `dealers/index.md`
- Shared profile/form styling: `_includes/head_custom.html`
- Regression coverage: `_scripts/homepage_trust_test.rb`
- Build gate: `ruby _scripts/homepage_trust_test.rb` followed by the repository's Docker Jekyll build command
