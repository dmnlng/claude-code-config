#!/bin/bash
# Post-Install Check for Claude Code
# Runs on first Claude start after bootstrap to verify installation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check if this is first run after install
MARKER_FILE=".claude/.bootstrap-complete"
FIRST_RUN_MARKER=".claude/.first-run-done"

# Only run if bootstrap was completed but first run not yet done
if [ ! -f "$MARKER_FILE" ] || [ -f "$FIRST_RUN_MARKER" ]; then
    exit 0
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Welcome to Claude Code! 🚀                    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}First-run verification after bootstrap...${NC}"
echo ""

# Quick validation
ISSUES_FOUND=0

# Check hooks are loaded
echo -e "${CYAN}Checking hook configuration...${NC}"
if [ -f ".claude/settings.local.json" ]; then
    if command -v jq >/dev/null 2>&1; then
        if jq -e '.hooks.PreToolUse[]? | select(.matcher == "Bash")' .claude/settings.local.json >/dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Bash validation hook is configured${NC}"
        else
            echo -e "${RED}  ✗ Bash hook not found in settings${NC}"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    fi
else
    echo -e "${RED}  ✗ settings.local.json not found${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check scripts are executable
echo -e "${CYAN}Checking scripts...${NC}"
if [ -x ".claude/scripts/validate-bash.sh" ]; then
    echo -e "${GREEN}  ✓ validate-bash.sh is executable${NC}"
else
    echo -e "${RED}  ✗ validate-bash.sh not executable${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check CLAUDE.md exists
echo -e "${CYAN}Checking context file...${NC}"
if [ -f "CLAUDE.md" ]; then
    echo -e "${GREEN}  ✓ CLAUDE.md exists${NC}"
else
    echo -e "${RED}  ✗ CLAUDE.md not found${NC}"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

echo ""

# Show result
if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Configuration is active.${NC}"
    echo ""
    echo -e "${BLUE}🎯 Try these commands:${NC}"
    echo -e "   ${CYAN}/doctor${NC}          - Full diagnostic check"
    echo -e "   ${CYAN}/compliance${NC}      - See your optimization score"
    echo -e "   ${CYAN}/test${NC}            - Run your test suite"
    echo -e "   ${CYAN}/review <path>${NC}   - Code review"
    echo -e "   ${CYAN}/explore <topic>${NC} - Explore codebase"
    echo ""
    echo -e "${BLUE}📚 Learn more:${NC}"
    echo -e "   Workflows:  ${CYAN}.claude/workflows/${NC}"
    echo -e "   Commands:   ${CYAN}.claude/commands/${NC}"
    echo ""
else
    echo -e "${YELLOW}⚠ Found $ISSUES_FOUND issue(s)${NC}"
    echo ""
    echo -e "${YELLOW}Run ${CYAN}/doctor${NC} for detailed diagnostics${NC}"
    echo ""
fi

# Mark first run as done
touch "$FIRST_RUN_MARKER"

# Show tip about token optimization
if command -v jq >/dev/null 2>&1 && [ -x ".claude/scripts/check-token-usage.sh" ]; then
    echo -e "${BLUE}💡 Pro Tip:${NC}"
    echo -e "   Run ${CYAN}/optimize-tokens${NC} to see how much you're saving!"
    echo ""
fi
