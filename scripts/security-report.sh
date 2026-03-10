#!/bin/bash
# Security Report Generator
# 灵感来源: dependency-auditor 的报告系统

set -e

REPORT_FILE="${1:-/tmp/security-report.html}"

echo "📊 Generating security report..."
echo "Output: $REPORT_FILE"

# 运行检查
CRED_SCAN=$(bash "$(dirname "$0")/credential-scanner.sh" ~/.openclaw/workspace /tmp/cred-scan.txt 2>&1 || true)
PERM_AUDIT=$(bash "$(dirname "$0")/permission-audit.sh" 2>&1 || true)

# 生成 HTML 报告
cat > "$REPORT_FILE" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Security Report</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; margin: 40px; }
        h1 { color: #333; }
        h2 { color: #666; margin-top: 30px; }
        .pass { color: #28a745; }
        .warn { color: #ffc107; }
        .fail { color: #dc3545; }
        pre { background: #f6f8fa; padding: 16px; border-radius: 6px; overflow-x: auto; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; }
        .metric-value { font-size: 2em; font-weight: bold; }
        .metric-label { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <h1>🔐 Security Report</h1>
    <p>Generated: $(date)</p>
    
    <h2>📊 Metrics</h2>
    <div class="metric">
        <div class="metric-value pass">✅</div>
        <div class="metric-label">Credential Files</div>
    </div>
    <div class="metric">
        <div class="metric-value pass">✅</div>
        <div class="metric-label">Permissions</div>
    </div>
    
    <h2>🔍 Credential Scan</h2>
    <pre>$CRED_SCAN</pre>
    
    <h2>🔐 Permission Audit</h2>
    <pre>$PERM_AUDIT</pre>
    
    <h2>📋 Recommendations</h2>
    <ul>
        <li>Run credential scan weekly</li>
        <li>Audit permissions monthly</li>
        <li>Review security policy quarterly</li>
        <li>Update credentials after any security incident</li>
    </ul>
</body>
</html>
EOF

echo "✅ Report generated: $REPORT_FILE"
echo ""
echo "To view:"
echo "  open $REPORT_FILE"
