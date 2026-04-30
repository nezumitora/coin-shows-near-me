# Inbox — Inter-Agent Communication

This folder receives JSON messages from other project agents. 

## MANDATORY: Check on every session start

```bash
ls inbox/*.json 2>/dev/null | grep -v README
```

If files exist, read each one, act on it, then move to `inbox/processed/`.

## Message Format

```json
{
  "source": "sending-repo-name",
  "timestamp": "ISO-8601 timestamp",
  "type": "task|info|expense|service|credential|infrastructure|note",
  "business": "dsi-labels|coin-directory|e-waste|local-services|fcbf|shared|all",
  "data": {
    "subject": "Brief description",
    "message": "Details",
    ...additional fields depending on type
  }
}
```

## Message Types

| Type | Action |
|------|--------|
| task | Add to TODO list, prioritize per the `priority` field |
| info | Note the information, update relevant configs/docs |
| service | New service signup — update tracking, also check dashboard |
| expense | New or changed cost — update tracking |
| credential | Where a login is stored (NEVER contains actual passwords) |
| infrastructure | Server, DNS, domain changes |
| note | Free-form info, use judgment |

## Rules

- NEVER include actual passwords, API keys, or tokens in messages
- When you discover expenses/services/infrastructure, ALWAYS also send a copy to `~/Git/business-dashboard/inbox/`
- One message per discovery. Multiple discoveries = multiple files
- After processing, move to `inbox/processed/`

