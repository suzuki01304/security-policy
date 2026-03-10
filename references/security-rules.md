# Security Rules Reference

Detailed security rules and configurations for AI agent operations.

## Credential Storage

### Recommended Locations

```json
{
  "credentials": {
    "api_keys": "~/.openclaw/credentials/",
    "tokens": "~/.openclaw/credentials/",
    "env_vars": "~/.openclaw/.env",
    "service_configs": "~/.config/<service>/",
    "private_identity": "~/.openclaw/workspace/memory/identity_private/"
  }
}
```

### File Permissions

```bash
# Credential files
chmod 600 ~/.openclaw/credentials/*
chmod 600 ~/.openclaw/.env

# Credential directories
chmod 700 ~/.openclaw/credentials/
chmod 700 ~/.openclaw/workspace/memory/identity_private/
```

### Git Ignore Rules

```gitignore
# Credentials
.env
credentials/
identity_private/

# Service configs
.config/*/api_key
.config/*/token

# Temporary files
*.tmp
*.log
```

## External Actions

### Requires Approval

```json
{
  "external_actions": {
    "messaging": [
      "send_email",
      "send_sms",
      "post_tweet",
      "post_facebook",
      "send_telegram",
      "send_whatsapp"
    ],
    "financial": [
      "make_payment",
      "transfer_funds",
      "create_invoice",
      "process_refund"
    ],
    "data_modification": [
      "delete_external_data",
      "modify_public_content",
      "update_external_service",
      "revoke_access"
    ],
    "system": [
      "install_software",
      "modify_system_config",
      "change_permissions",
      "run_as_root"
    ]
  }
}
```

### Safe to Execute

```json
{
  "safe_actions": {
    "read_operations": [
      "read_file",
      "list_directory",
      "search_content",
      "check_status"
    ],
    "local_modifications": [
      "create_file",
      "edit_file",
      "organize_workspace",
      "run_validation"
    ],
    "information_gathering": [
      "web_search",
      "check_calendar",
      "read_email",
      "analyze_data"
    ]
  }
}
```

## File Operations

### Safe Operations

```json
{
  "safe_file_ops": {
    "read": ["read", "cat", "less", "grep"],
    "create": ["touch", "mkdir", "echo >"],
    "modify": ["edit", "sed", "awk"],
    "organize": ["mv", "cp", "ln"],
    "safe_delete": ["trash", "trash-put"]
  }
}
```

### Dangerous Operations

```json
{
  "dangerous_file_ops": {
    "destructive": ["rm -rf", "dd", "shred"],
    "permissions": ["chmod 777", "chown", "setfacl"],
    "system": ["rm /etc/*", "rm /usr/*", "rm /var/*"]
  }
}
```

## Group Chat Privacy

### Private Information

```json
{
  "private_info": {
    "personal": [
      "full_name",
      "address",
      "phone_number",
      "email_address",
      "date_of_birth"
    ],
    "schedule": [
      "calendar_events",
      "location",
      "availability",
      "travel_plans"
    ],
    "financial": [
      "bank_account",
      "credit_card",
      "salary",
      "transactions"
    ],
    "communications": [
      "private_messages",
      "email_content",
      "dm_history",
      "call_logs"
    ]
  }
}
```

### Public Information

```json
{
  "public_info": {
    "already_shared": [
      "username",
      "public_profile",
      "public_posts",
      "shared_links"
    ],
    "general_knowledge": [
      "public_facts",
      "common_knowledge",
      "publicly_available_data"
    ]
  }
}
```

## Configuration Changes

### Backup Before Modify

```bash
# Backup pattern
cp config.json config.json.backup.$(date +%Y%m%d_%H%M%S)

# Modify
edit config.json

# Validate
validate-config config.json

# If valid, commit
git add config.json
git commit -m "Update config: [description]"
```

### Validation Checklist

```json
{
  "validation": {
    "syntax": "Check JSON/YAML syntax",
    "schema": "Validate against schema",
    "permissions": "Check file permissions",
    "dependencies": "Verify dependencies exist",
    "test": "Test in safe environment"
  }
}
```

## Incident Response

### Credential Leak Response

```json
{
  "response_steps": [
    {
      "step": 1,
      "action": "Immediately revoke compromised credential",
      "urgency": "critical"
    },
    {
      "step": 2,
      "action": "Generate new credential",
      "urgency": "critical"
    },
    {
      "step": 3,
      "action": "Update all references",
      "urgency": "high"
    },
    {
      "step": 4,
      "action": "Audit where it was exposed",
      "urgency": "high"
    },
    {
      "step": 5,
      "action": "Document incident",
      "urgency": "medium"
    },
    {
      "step": 6,
      "action": "Review and update security policies",
      "urgency": "medium"
    }
  ]
}
```

## Security Audit Schedule

```json
{
  "audit_schedule": {
    "daily": [
      "Check for new credentials",
      "Verify file permissions",
      "Review external actions"
    ],
    "weekly": [
      "Run security audit script",
      "Check for leaked secrets",
      "Review access logs"
    ],
    "monthly": [
      "Rotate credentials",
      "Update security documentation",
      "Test backup/restore",
      "Security training review"
    ],
    "quarterly": [
      "Full security assessment",
      "Penetration testing",
      "Policy review and update",
      "Incident response drill"
    ]
  }
}
```

## Common Patterns

### Credential Reference Pattern

```markdown
## API Configuration
- Service: Notion
- Location: ~/.config/notion/api_key
- Status: ✅ Active
- Last rotated: 2026-03-01
- Next rotation: 2026-06-01
```

### External Action Pattern

```markdown
## External Action Request
- Action: Send email
- To: user@example.com
- Subject: Project update
- Body: [draft content]
- Approval: ⏳ Pending
```

### Group Chat Response Pattern

```markdown
## Group Chat Context
- Chat: Project Team
- Question: "When is Alice free?"
- Private info: Yes (Alice's calendar)
- Response: "I don't have access to Alice's calendar. Alice, can you share?"
```

---

**Version:** 2.0.0  
**Last Updated:** 2026-03-10
