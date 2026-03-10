#!/bin/bash
# Security audit script for AI agent environments
set -e

echo "🔒 Running security audit..."
echo ""

ERRORS=0
WARNINGS=0

# Check credential storage locations
echo "📁 Checking credential storage..."

CRED_LOCATIONS=(
  "$HOME/.openclaw/credentials"
  "$HOME/.openclaw/.env"
  "$HOME/.config"
)

for loc in "${CRED_LOCATIONS[@]}"; do
  if [[ -d "$loc" ]] || [[ -f "$loc" ]]; then
    echo "✅ $loc exists"
    
    # Check permissions
    if [[ -d "$loc" ]]; then
      PERMS=$(stat -f "%Lp" "$loc" 2>/dev/null || stat -c "%a" "$loc" 2>/dev/null)
      if [[ "$PERMS" != "700" ]] && [[ "$PERMS" != "600" ]]; then
        echo "⚠️  $loc has loose permissions: $PERMS (should be 700)"
        ((WARNINGS++))
      fi
    fi
  else
    echo "ℹ️  $loc not found (optional)"
  fi
done

echo ""

# Check for leaked secrets in memory files
echo "🔍 Scanning for leaked secrets..."

WORKSPACE="${WORKSPACE_DIR:-$HOME/.openclaw/workspace}"

if [[ -d "$WORKSPACE/memory" ]]; then
  # Check for common secret patterns
  PATTERNS=(
    "api_key"
    "token"
    "password"
    "secret"
    "_pat_"
    "sk-"
  )
  
  for pattern in "${PATTERNS[@]}"; do
    MATCHES=$(grep -r "$pattern" "$WORKSPACE/memory" 2>/dev/null | grep -v "Configured in\|Status:\|已配置" | wc -l)
    if [[ $MATCHES -gt 0 ]]; then
      echo "⚠️  Found $MATCHES potential secret references for '$pattern'"
      ((WARNINGS++))
    fi
  done
  
  echo "✅ Secret scan complete"
else
  echo "ℹ️  No memory directory found"
fi

echo ""

# Check Git ignore rules
echo "📝 Checking .gitignore..."

if [[ -f "$WORKSPACE/.gitignore" ]]; then
  REQUIRED_IGNORES=(
    ".env"
    "credentials"
    "identity_private"
  )
  
  for ignore in "${REQUIRED_IGNORES[@]}"; do
    if grep -q "$ignore" "$WORKSPACE/.gitignore"; then
      echo "✅ $ignore is ignored"
    else
      echo "⚠️  $ignore should be in .gitignore"
      ((WARNINGS++))
    fi
  done
else
  echo "⚠️  No .gitignore found"
  ((WARNINGS++))
fi

echo ""

# Check file permissions on sensitive files
echo "🔐 Checking file permissions..."

SENSITIVE_FILES=(
  "$HOME/.openclaw/.env"
  "$HOME/.openclaw/credentials/*"
)

for pattern in "${SENSITIVE_FILES[@]}"; do
  for file in $pattern; do
    if [[ -f "$file" ]]; then
      PERMS=$(stat -f "%Lp" "$file" 2>/dev/null || stat -c "%a" "$file" 2>/dev/null)
      if [[ "$PERMS" != "600" ]] && [[ "$PERMS" != "400" ]]; then
        echo "⚠️  $file has loose permissions: $PERMS (should be 600 or 400)"
        ((WARNINGS++))
      else
        echo "✅ $file has correct permissions"
      fi
    fi
  done
done

echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
  echo "✅ Security audit passed!"
  exit 0
elif [[ $ERRORS -eq 0 ]]; then
  echo "⚠️  Security audit completed with $WARNINGS warning(s)"
  exit 0
else
  echo "❌ Security audit failed with $ERRORS error(s) and $WARNINGS warning(s)"
  exit 1
fi
