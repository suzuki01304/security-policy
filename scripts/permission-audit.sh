#!/bin/bash
# Permission Audit - 检查文件权限合规性
# 灵感来源: dependency-auditor 的审计系统

set -e

echo "🔐 Auditing file permissions..."
echo ""

# 检查 .env 文件
check_file() {
    local file="$1"
    local expected="$2"
    
    if [ -f "$file" ]; then
        actual=$(stat -f "%Lp" "$file" 2>/dev/null || stat -c "%a" "$file" 2>/dev/null)
        if [ "$actual" != "$expected" ]; then
            echo "⚠️  $file: $actual (expected: $expected)"
            return 1
        else
            echo "✅ $file: $actual"
            return 0
        fi
    else
        echo "ℹ️  $file: not found"
        return 0
    fi
}

# 检查目录权限
check_dir() {
    local dir="$1"
    local expected="$2"
    
    if [ -d "$dir" ]; then
        actual=$(stat -f "%Lp" "$dir" 2>/dev/null || stat -c "%a" "$dir" 2>/dev/null)
        if [ "$actual" != "$expected" ]; then
            echo "⚠️  $dir/: $actual (expected: $expected)"
            return 1
        else
            echo "✅ $dir/: $actual"
            return 0
        fi
    else
        echo "ℹ️  $dir/: not found"
        return 0
    fi
}

ISSUES=0

# 检查关键文件
echo "## Credential Files"
check_file ~/.openclaw/.env 600 || ISSUES=$((ISSUES + 1))
check_file ~/.config/notion/api_key 600 || ISSUES=$((ISSUES + 1))

# 检查凭证目录
echo ""
echo "## Credential Directories"
check_dir ~/.openclaw/credentials 700 || ISSUES=$((ISSUES + 1))
check_dir ~/.config 700 || ISSUES=$((ISSUES + 1))

# 检查凭证目录中的所有文件
if [ -d ~/.openclaw/credentials ]; then
    echo ""
    echo "## Credential Directory Contents"
    for file in ~/.openclaw/credentials/*; do
        if [ -f "$file" ]; then
            check_file "$file" 600 || ISSUES=$((ISSUES + 1))
        fi
    done
fi

# 总结
echo ""
echo "---"
if [ $ISSUES -eq 0 ]; then
    echo "✅ All permissions are compliant"
    exit 0
else
    echo "❌ Found $ISSUES permission issues"
    echo ""
    echo "To fix:"
    echo "  chmod 600 ~/.openclaw/.env"
    echo "  chmod 700 ~/.openclaw/credentials/"
    echo "  chmod 600 ~/.openclaw/credentials/*"
    exit 1
fi
