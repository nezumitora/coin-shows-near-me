# AI Assistant Instructions

## User Preferences (MANDATORY)

- User has no dev/programming experience — explain things simply
- Never expose personal name/nezumitora/milohiss on public sites
- All new repos must be private unless stated otherwise
- FCBF = separate entity from DSI/E-Waste — never mix expenses/accounts

## Screenshots and File Sharing (MANDATORY)

When the user says they shared a file, screenshot, or says "see ss" / "see screenshot":

1. Check `~/Desktop/Files to show Milo/` for the most recent files
2. List files sorted by newest: `ls -t ~/Desktop/Files\ to\ show\ Milo/ | head -5`
3. **IMPORTANT:** macOS screenshot filenames contain a Unicode character (U+202F narrow no-break space before AM/PM) that breaks the Read tool. You MUST copy to /tmp/ first:
   ```bash
   cp ~/Desktop/Files\ to\ show\ Milo/Screenshot\ 2026-*\ at\ <time>* /tmp/screenshot.png
   ```
4. Then read from the temp path: `Read /tmp/screenshot.png`

**Never skip step 3** — reading directly from the Desktop path will fail with "File not found".

## Inbox System (MANDATORY — check on EVERY session start)

Other project agents drop JSON messages into `inbox/` when they have info for this project.

**On every session start, run:**

```bash
ls inbox/*.json 2>/dev/null | grep -v README
```

If messages exist:
1. Read each JSON file
2. Act on the message (add tasks, update configs, note the info)
3. Move processed files to `inbox/processed/`
4. Tell the user what you found

**To send messages to other agents**, write a JSON file to their inbox:

```bash
cat > ~/Git/TARGET-REPO/inbox/$(date +%Y-%m-%d_%H%M%S)_$(basename "$PWD").json << 'INBOX_EOF'
{
  "source": "this-repo-name",
  "timestamp": "ISO-8601",
  "type": "task|info|expense|service|credential|infrastructure|note",
  "business": "dsi-labels|coin-directory|e-waste|local-services|fcbf|shared|all",
  "data": { }
}
INBOX_EOF
```

**Message types:** task (add a TODO), info (general info), expense (cost — also send to dashboard), service (new service — also send to dashboard), credential (where a login is stored, NEVER actual passwords), infrastructure (server/DNS changes — also send to dashboard), note (free-form).

**Always send a copy to dashboard** for: expenses, services, credentials, infrastructure.
Dashboard inbox: `~/Git/business-dashboard/inbox/`

## Project Routing Table

| Project | Inbox path | Business |
|---|---|---|
| business-dashboard | `~/Git/business-dashboard/inbox/` | all |
| dsi-labels | `~/Git/dsi-labels/inbox/` | dsi-labels |
| coin-shows-near-me | `~/Git/coin-shows-near-me/inbox/` | coin-directory |
| ewastefreepickup.com | `~/Git/ewastefreepickup.com/inbox/` | e-waste |
| espocrm-setup | `~/Git/espocrm-setup/inbox/` | shared |
| fcbf | `~/Git/fcbf/inbox/` | fcbf |
| fcbf-qualifier | `~/Git/fcbf-qualifier/inbox/` | fcbf |
| fcbf-roi-calculator | `~/Git/fcbf-roi-calculator/inbox/` | fcbf |
| fcbf-newsletter | `~/Git/fcbf-newsletter/inbox/` | fcbf |
| milo-fcbf-bot | `~/Git/milo-fcbf-bot/inbox/` | all |
| milohiss | `~/Git/milohiss/inbox/` | all |
| multi-tenant-crm | `~/Git/multi-tenant-crm/inbox/` | shared |
| seo-blog-engine | `~/Git/seo-blog-engine/inbox/` | shared |

## Infrastructure (current as of April 2026)

| Service | URL | Cost |
|---|---|---|
| Hetzner CX33 | 204.168.137.38 (Helsinki) | $10.19/mo |
| Cloudron Starter | my.cloud.ewastefreepickup.com | ~$16.20/mo |
| Cloudflare DNS | Free plan | $0 |
| EspoCRM | crm.cloud.ewastefreepickup.com | Included |
| Email | info@ewastefreepickup.com (Cloudron mail + Gmail relay) | $0 |

- **SSH:** `ssh -i ~/.ssh/hetzner_server root@204.168.137.38` (from Milo machine)
- **CRM login:** Cloudron SSO at https://crm.cloud.ewastefreepickup.com (NOT admin/admin123)
- **Payment:** Chase Business Preferred
