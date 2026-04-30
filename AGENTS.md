# AI Assistant Instructions

## Self-Setup (MANDATORY — run on FIRST session in any repo)

If this repo is missing `inbox/`, `inbox/processed/`, or `inbox/README.md`, create them:

```bash
mkdir -p inbox/processed && touch inbox/.gitkeep inbox/processed/.gitkeep
```

If any OTHER repo you interact with is missing this structure, run the welcome script:

```bash
~/.aidevops/agents/custom/scripts/new-repo-welcome.sh ~/Git/REPO-NAME BUSINESS-NAME
```

This ensures every repo can participate in the inter-agent messaging system.

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

## Inbox Check (MANDATORY — FIRST thing on EVERY session, before ANY other work)

**YOU MUST DO THIS BEFORE RESPONDING TO THE USER'S FIRST MESSAGE.**

Other project agents and the Milo Telegram bot drop JSON messages into this repo's inbox. You must check for them and report what you found BEFORE doing anything else.

**Step 1: Check the CANONICAL repo path (NEVER a worktree path):**

```bash
ls ~/Git/REPO-NAME/inbox/*.json 2>/dev/null | grep -v README
```

**CRITICAL:** Always use `~/Git/REPO-NAME/inbox/` — the canonical repo directory. NEVER check a worktree path like `~/Git/REPO-NAME-feature-xyz/inbox/`. Messages are delivered to the canonical path only.

**Step 2: Report to user immediately.** Your FIRST message must start with one of:

- If messages found: "📬 I found N inbox messages: [brief summary of each]. Processing them now."
- If no messages: "📭 Inbox checked — no new messages."

Then proceed with whatever the user asked.

**Step 3: Process any messages found:**
1. Read each JSON file
2. Act on the message (add tasks, update configs, note the info)
3. Move processed files to `inbox/processed/`

**DO NOT SKIP THIS.** The user should never have to ask "did you check your inbox?"

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
