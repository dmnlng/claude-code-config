# Quick Diagnostic Check

Run a fast diagnostic to verify Claude Code configuration is working correctly.

## Task

Perform a quick health check of the Claude Code configuration and show status in a concise, easy-to-read format.

## Diagnostic Checks

Run the following checks and display results immediately:

### 1. Core Configuration Files

```bash
# Check critical files exist
[ -f ".claude/settings.local.json" ] && echo "✅ settings.local.json" || echo "❌ settings.local.json MISSING"
[ -f ".claude/scripts/validate-bash.sh" ] && echo "✅ validate-bash.sh" || echo "❌ validate-bash.sh MISSING"
[ -f ".claude/ignore" ] && echo "✅ .claude/ignore" || echo "❌ .claude/ignore MISSING"
[ -f "CLAUDE.md" ] && echo "✅ CLAUDE.md" || echo "❌ CLAUDE.md MISSING"
```

### 2. Hook Configuration

```bash
# Check if Bash hook is configured
if command -v jq >/dev/null 2>&1; then
    if jq -e '.hooks.PreToolUse[]? | select(.matcher == "Bash")' .claude/settings.local.json >/dev/null 2>&1; then
        echo "✅ Bash validation hook active"
    else
        echo "❌ Bash hook NOT configured"
    fi
else
    echo "⚠️  Cannot verify (jq not installed)"
fi
```

### 3. Script Permissions

```bash
# Check if validate-bash.sh is executable
if [ -x ".claude/scripts/validate-bash.sh" ]; then
    echo "✅ Scripts are executable"
else
    echo "❌ Scripts NOT executable (run: chmod +x .claude/scripts/*.sh)"
fi
```

### 4. Quick Functional Test

```bash
# Test that bash validation works
if command -v jq >/dev/null 2>&1 && [ -x ".claude/scripts/validate-bash.sh" ]; then
    # Test blocked command
    if echo '{"tool_input":{"command":"grep -r test ."}}' | ./.claude/scripts/validate-bash.sh 2>&1 | grep -q "ERROR"; then
        echo "✅ Token optimization working"
    else
        echo "⚠️  Token optimization might not be active"
    fi
fi
```

### 5. Prerequisites

```bash
# Check jq
command -v jq >/dev/null 2>&1 && echo "✅ jq installed" || echo "❌ jq NOT installed (required!)"

# Check git
git rev-parse --git-dir >/dev/null 2>&1 && echo "✅ Git repository" || echo "ℹ️  Not a git repo"
```

## Output Format

Display results in a clean, scannable format:

```
╔══════════════════════════════════════════════╗
║  Claude Code Health Check                   ║
╚══════════════════════════════════════════════╝

Core Files:
  ✅ settings.local.json
  ✅ validate-bash.sh
  ✅ .claude/ignore
  ✅ CLAUDE.md

Configuration:
  ✅ Bash validation hook active
  ✅ Scripts are executable
  ✅ Token optimization working

Prerequisites:
  ✅ jq installed
  ✅ Git repository

📊 Quick Stats:
  - Ignore patterns: {count from .claude/ignore}
  - Deny permissions: {count from settings.local.json}
  - Slash commands: {count .md files in .claude/commands/}
  - Workflows: {count .md files in .claude/workflows/}

Status: 🟢 ALL SYSTEMS GO

💡 Next Steps:
  - Run /compliance for detailed score
  - Run /optimize-tokens for token analysis
  - Check .claude/workflows/ for workflow guides
```

## If Issues Found

If any check fails (❌), add a "Issues Found" section:

```
⚠️  Issues Found:

❌ jq NOT installed
   Fix: sudo apt install jq (Linux) or brew install jq (macOS)

❌ Bash hook NOT configured
   Fix: Run /bootstrap to set up configuration

Recommendation: Run /compliance for detailed diagnostics
```

## Handling Edge Cases

**If .claude/ doesn't exist at all:**
```
❌ Claude Code is not configured in this project

Run /bootstrap to set up token optimization and best practices.
```

**If partially configured:**
Show which parts work and which don't, with fix suggestions.

**If everything is perfect:**
```
Status: 🟢 ALL SYSTEMS GO

Your Claude Code configuration is optimal!

Try: /test, /review, /explore, /optimize-tokens
```

## Implementation Notes

- Keep output concise (max 30 lines)
- Use emojis for quick visual scanning
- Group related checks together
- Always provide actionable fix suggestions
- Don't run expensive operations (no full token scan)
- Total execution time should be < 2 seconds
