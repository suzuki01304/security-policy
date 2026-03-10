#!/bin/bash
# Credential Scanner - 扫描工作区中的凭证泄露
# 灵感来源: git-secrets-scanner

set -e

WORKSPACE="${1:-.}"
REPORT_FILE="${2:-/tmp/credential-scan-report.txt}"

echo "🔍 Scanning workspace for credential leaks..."
echo "Workspace: $WORKSPACE"
echo "Report: $REPORT_FILE"
echo ""

# 初始化报告
cat > "$REPORT_FILE" << 'EOF'
# Credential Scan Report
Generated: $(date)

## Summary
EOF

# 检测模式
PATTERNS=(
    "github_pat_[a-zA-Z0-9]{82}"
    "ntn_[a-zA-Z0-9]{32,}"
    "tvly-[a-zA-Z0-9-]{32,}"
    "[0-9]{10}:AA[a-zA-Z0-9_-]{33}"
    "sk-[a-zA-Z0-9]{48}"
    "xox[baprs]-[a-zA-Z0-9-]+"
    "AIza[0-9A-Za-z\\-_]{35}"
)

PATTERN_NAMES=(
    "GitHub Personal Access Token"
    "Notion API Key"
    "Tavily API Key"
    "Telegram Bot Token"
    "OpenAI API Key"
    "Slack Token"
    "Google API Key"
)

# 排除目录
EXCLUDE_DIRS=(
    ".git"
    "node_modules"
    ".openclaw/credentials"
    ".config"
)

# 构建排除参数
EXCLUDE_ARGS=""
for dir in "${EXCLUDE_DIRS[@]}"; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude-dir=$dir"
done

# 扫描
FOUND=0
for i in "${!PATTERNS[@]}"; do
    pattern="${PATTERNS[$i]}"
    name="${PATTERN_NAMES[$i]}"
    
    echo "Checking: $name"
    
    results=$(grep -r -E "$pattern" $EXCLUDE_ARGS "$WORKSPACE" 2>/dev/null || true)
    
    if [ -n "$results" ]; then
        FOUND=$((FOUND + 1))
        echo "⚠️  Found: $name" | tee -a "$REPORT_FILE"
        echo "$results" | while read -r line; do
            echo "  $line" | tee -a "$REPORT_FILE"
        done
        echo "" | tee -a "$REPORT_FILE"
    fi
done

# 总结
echo "" | tee -a "$REPORT_FILE"
if [ $FOUND -eq 0 ]; then
    echo "✅ No credentials found in workspace" | tee -a "$REPORT_FILE"
    exit 0
else
    echo "❌ Found $FOUND potential credential leaks" | tee -a "$REPORT_FILE"
    echo "Review report: $REPORT_FILE"
    exit 1
fi
