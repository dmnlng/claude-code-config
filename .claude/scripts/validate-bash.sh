#!/bin/bash
# Claude Code Bash Command Validator
# Prevents token waste by blocking access to dependencies, build artifacts, and git internals
# This hook runs before every Bash tool execution

set -euo pipefail

# Read the command from stdin (provided by Claude Code hook system)
COMMAND=$(cat | jq -r '.tool_input.command' 2>/dev/null || echo "")

if [ -z "$COMMAND" ]; then
  echo "ERROR: Could not parse command from hook input" >&2
  exit 2
fi

# ============================================================================
# SAFE COMMANDS WHITELIST
# ============================================================================
# These commands are generally safe and don't need further validation
BASE_CMD=$(echo "$COMMAND" | awk '{print $1}')
SAFE_COMMANDS="^(git|npm|yarn|pnpm|node|python|python3|pip|pip3|poetry|cargo|rustc|go|docker|kubectl|make|cmake|which|pwd|whoami|date|uname)$"

if echo "$BASE_CMD" | grep -qE "$SAFE_COMMANDS"; then
  # Additional check: Block git commands that access internals directly
  if echo "$COMMAND" | grep -qE "git.*(objects|refs/|logs/)"; then
    echo "ERROR: Direct access to git internals is blocked" >&2
    exit 2
  fi
  exit 0
fi

# ============================================================================
# SCOPE-BASED VALIDATION
# ============================================================================
# Encourage scoped searches (e.g., "grep pattern src/" instead of "grep -r pattern")
# Allow if command explicitly scopes to common source directories
if echo "$COMMAND" | grep -qE "(grep|find|rg|fd|ag).*(src/|lib/|app/|tests?/|docs?/|examples?/|scripts?/)"; then
  exit 0
fi

# ============================================================================
# LOAD BLOCKED PATTERNS FROM .claude/ignore
# ============================================================================
IGNORE_FILE=".claude/ignore"
BLOCKED_PATTERNS=""

if [ -f "$IGNORE_FILE" ]; then
  # Read .claude/ignore, skip comments and empty lines, join with |
  BLOCKED_PATTERNS=$(grep -v '^#' "$IGNORE_FILE" | grep -v '^$' | sed 's/[\/]/\\\//g' | tr '\n' '|' | sed 's/|$//')
fi

# Fallback patterns if .claude/ignore doesn't exist
if [ -z "$BLOCKED_PATTERNS" ]; then
  BLOCKED_PATTERNS="node_modules|\.env|__pycache__|\.git/objects|\.git/refs|\.git/logs|dist/|build/|vendor/|target/|coverage/|\.cache/|bin/|obj/"
fi

# ============================================================================
# PATTERN MATCHING
# ============================================================================
if echo "$COMMAND" | grep -qE "$BLOCKED_PATTERNS"; then
  echo "ERROR: Command contains blocked pattern from .claude/ignore" >&2
  echo "Blocked command: $COMMAND" >&2
  echo "" >&2
  echo "Tip: Use scoped searches instead:" >&2
  echo "  - grep 'pattern' src/        (instead of grep -r 'pattern')" >&2
  echo "  - find src/ -name '*.js'     (instead of find . -name '*.js')" >&2
  exit 2
fi

# ============================================================================
# OPTIONAL: LOGGING FOR DEBUGGING
# ============================================================================
# Uncomment to log all validated commands
# TIMESTAMP=$(date -Iseconds)
# echo "[$TIMESTAMP] ALLOWED: $COMMAND" >> .claude/logs/bash-validation.log

exit 0
