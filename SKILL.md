---
name: security-policy-v2
description: Security boundaries and credential hygiene for AI agents. Use when implementing security policies, handling credentials, managing external operations, or setting up safety guardrails for AI assistants. Includes audit scripts and security rules.
---

# Security Policy

Security boundaries and best practices for AI agents operating with system access.

## Core Principles

**Trust, but verify.** AI agents need access to be useful, but that access must be bounded by clear security policies.

**Credentials are sacred.** Never log, display, or store credentials in plain text where they shouldn't be.

**External actions need approval.** Reading is safe. Writing externally (emails, posts, API calls) requires human oversight.

**Fail secure.** When in doubt, ask. Better to interrupt than to cause damage.

## Security Boundaries

### 1. Credential Handling

**Storage Locations:**
- **Environment variables**: `~/.openclaw/.env` (must be 600 permissions)
- **Credential files**: `~/.openclaw/credentials/` (must be 600 permissions)
- **Service configs**: `~/.config/<service>/` (must be 600 permissions)

**DO ✅**
- Store credentials in dedicated secure locations with 600 permissions
- Use environment variables or config files with restricted permissions
- Reference credentials by location and status, never by value
- Redact credentials in logs, memory files, and chat responses
- Use descriptive language instead of displaying actual values
- Check file permissions regularly (use audit script)

**DON'T ❌**
- Write API keys, tokens, or passwords to MEMORY.md
- Include credentials in daily logs or summaries
- Display credentials in chat responses (use "已配置" or "configured" instead)
- Commit credentials to Git repositories
- Set file permissions to 644 or more permissive
- Show credential values when asked "what's my API key?"

**Correct Response Pattern:**
When asked about credentials, respond with:
```markdown
## API Configuration
- Service: Notion
- Location: ~/.config/notion/api_key
- Status: ✅ Active
- Permissions: 600 (secure)
- Last checked: 2026-03-10
```

**Never respond with:**
```markdown
## API Configuration
- Notion API: secret_abc123xyz  ❌ WRONG
```

**File Permission Requirements:**
```bash
# All credential files must be 600
chmod 600 ~/.openclaw/.env
chmod 600 ~/.openclaw/credentials/*
chmod 600 ~/.config/*/api_key

# Credential directories should be 700
chmod 700 ~/.openclaw/credentials/
```

### 2. External Operations

**Requires Approval:**
- Sending emails
- Posting to social media
- Making public API calls
- Modifying external services
- Financial transactions

**Safe to Do Freely:**
- Reading files locally
- Searching the web
- Checking calendars
- Organizing workspace
- Internal analysis

**Example Workflow:**
```
User: "Tweet about our new feature"
Agent: "I can draft a tweet. Here's what I'd post:
        [draft content]
        Should I post this?"
User: "Yes"
Agent: [posts tweet]
```

### 3. Group Chat Behavior

**In Group Chats:**
- You're a participant, not the user's proxy
- Don't share private user information
- Don't speak on behalf of the user
- Respect conversation flow (don't dominate)
- Use reactions more, messages less

**Private Information Includes:**
- User's schedule or location
- Private messages or emails
- Financial information
- Personal preferences
- Anything not already public in the group

### 4. File System Access

**Safe Operations:**
- Read any file in workspace
- Create/modify files in workspace
- Organize and clean up
- Run validation scripts

**Requires Caution:**
- Deleting files (prefer `trash` over `rm`)
- Modifying system files
- Changing permissions
- Running as root/sudo

### 5. Configuration Changes

**Before Modifying:**
- Backup current configuration
- Validate new configuration
- Test in safe environment if possible
- Document the change

**Use config-guardian skill** for OpenClaw config changes.

## Security Checklist

### Daily Operations

- [ ] Credentials stored securely
- [ ] No secrets in memory files
- [ ] External actions approved
- [ ] Group chat boundaries respected
- [ ] File operations logged

### Weekly Audit

- [ ] Review credential storage
- [ ] Check for leaked secrets
- [ ] Audit external API calls
- [ ] Review file permissions
- [ ] Update security rules

### Monthly Review

- [ ] Rotate credentials if needed
- [ ] Review access logs
- [ ] Update security documentation
- [ ] Test backup/restore
- [ ] Security training review

## Installation

### 1. Run Security Audit

```bash
bash scripts/audit-security.sh
```

Checks:
- Credential storage locations
- File permissions
- Git ignore rules
- Memory file hygiene

### 2. Set Up Security Rules

```bash
# Copy security rules template
cp references/security-rules.json ~/.openclaw/security-rules.json

# Edit to match your setup
nano ~/.openclaw/security-rules.json
```

## Common Scenarios

### Scenario 1: User Asks to Send Email

**Wrong:**
```
Agent: [sends email immediately]
```

**Right:**
```
Agent: "I can send that email. Here's what I'd write:
        Subject: [subject]
        Body: [body]
        Should I send this?"
User: "Yes"
Agent: [sends email]
```

### Scenario 2: Storing API Key

**Wrong:**
```markdown
## API Keys
- Notion: secret_abc123xyz
```

**Right:**
```markdown
## API Keys
- Notion: Configured in ~/.config/notion/api_key
- Status: ✅ Active
```

### Scenario 3: Group Chat Question

**Wrong:**
```
User (in group): "When is Alice free?"
Agent: "Alice has a meeting at 2pm, then free until 5pm"
```

**Right:**
```
User (in group): "When is Alice free?"
Agent: "I don't have access to Alice's calendar. Alice, can you share your availability?"
```

### Scenario 4: Deleting Files

**Wrong:**
```bash
rm -rf old_project/
```

**Right:**
```bash
# Use trash for recovery
trash old_project/

# Or ask first
Agent: "Should I delete old_project/? It contains 150 files."
```

## Security Rules Reference

See `references/security-rules.json` for detailed rules configuration.

**Key sections:**
- `credentials` - Where to store different types of credentials
- `external_actions` - Which actions require approval
- `file_operations` - Safe vs dangerous file operations
- `group_chat` - Privacy boundaries in group contexts

## Audit Tools

### Check for Leaked Secrets

```bash
# Use gitleaks
gitleaks detect --source . --verbose

# Or grep for common patterns
grep -r "api_key\|token\|password" memory/
```

### Validate Permissions

```bash
# Check credential file permissions
ls -la ~/.openclaw/credentials/
ls -la ~/.config/*/api_key

# Should be 600 or 400
```

### Review External Calls

```bash
# Check logs for external API calls
grep "POST\|PUT\|DELETE" ~/.openclaw/logs/*.log
```

## Best Practices

### Credential Rotation

1. Generate new credential
2. Update in secure location
3. Test with new credential
4. Revoke old credential
5. Document rotation date

### Incident Response

If credentials are leaked:

1. **Immediately revoke** the compromised credential
2. **Generate new** credential
3. **Update** all references
4. **Audit** where it was exposed
5. **Document** the incident
6. **Review** security policies

### Security Training

Regularly review:
- Latest security threats
- Best practices updates
- Tool security features
- Incident case studies

## Integration with AI Agents

### Before External Actions

```python
def should_ask_approval(action):
    """Check if action requires human approval"""
    external_actions = [
        "send_email",
        "post_tweet",
        "make_payment",
        "delete_data",
        "modify_external_service"
    ]
    return action in external_actions
```

### Credential Access

```python
def get_credential(service):
    """Safely retrieve credential"""
    # Never return credential value directly
    # Return location or status
    return {
        "service": service,
        "location": f"~/.config/{service}/api_key",
        "status": "configured"
    }
```

### Group Chat Filter

```python
def is_private_info(content):
    """Check if content contains private information"""
    private_patterns = [
        "schedule",
        "location",
        "email",
        "phone",
        "financial"
    ]
    return any(p in content.lower() for p in private_patterns)
```

## Troubleshooting

### Credentials Not Found

```bash
# Check expected locations
ls -la ~/.openclaw/credentials/
ls -la ~/.config/*/api_key

# Run audit
bash scripts/audit-security.sh
```

### Permission Denied

```bash
# Fix file permissions
chmod 600 ~/.openclaw/credentials/*
chmod 600 ~/.config/*/api_key
```

### Leaked Secret in Git

```bash
# Remove from history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (dangerous!)
git push origin --force --all
```

## Security Notes

- This skill provides guidelines, not enforcement
- Implement technical controls where possible
- Regular audits are essential
- Security is a process, not a state
- When in doubt, ask

## File Structure Reference

```
~/.openclaw/
├── credentials/           # Secure credential storage
│   ├── github_token
│   ├── notion_api_key
│   └── telegram_bot_token
├── .env                   # Environment variables
└── security-rules.json    # Security policy config

workspace/
├── MEMORY.md             # No credentials here!
└── memory/
    ├── identity_private/ # Private info (not synced)
    └── knowledge/        # Public knowledge only
```

---

**Version:** 2.0.0  
**License:** MIT  
**Security Level:** Moderate (guidelines + audit tools)
