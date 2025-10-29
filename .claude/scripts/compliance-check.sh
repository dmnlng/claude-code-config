#!/bin/bash
# Claude Code Compliance Checker
# Validates configuration and identifies optimization opportunities

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Score tracking
SCORE=0
MAX_SCORE=100
CRITICAL_ISSUES=()
WARNINGS=()
RECOMMENDATIONS=()
COMPLIANT=()

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Code Compliance Check                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Helper function to add score
add_score() {
    SCORE=$((SCORE + $1))
}

# Helper function to check command
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# 1. CORE CONFIGURATION (30 points)
# ============================================================================

echo -e "${CYAN}[1/10] Checking core configuration...${NC}"

# Check settings.local.json (10 points)
if [ -f ".claude/settings.local.json" ]; then
    if jq empty .claude/settings.local.json 2>/dev/null; then
        echo -e "${GREEN}  ✓ settings.local.json exists and is valid JSON${NC}"
        COMPLIANT+=("settings.local.json configured")
        add_score 10
    else
        echo -e "${RED}  ✗ settings.local.json is invalid JSON${NC}"
        CRITICAL_ISSUES+=("settings.local.json contains syntax errors")
    fi
else
    echo -e "${RED}  ✗ .claude/settings.local.json not found${NC}"
    CRITICAL_ISSUES+=("Missing .claude/settings.local.json - no hooks or permissions configured")
fi

# Check validate-bash.sh (10 points)
if [ -f ".claude/scripts/validate-bash.sh" ]; then
    if [ -x ".claude/scripts/validate-bash.sh" ]; then
        echo -e "${GREEN}  ✓ validate-bash.sh exists and is executable${NC}"
        COMPLIANT+=("Bash validation script ready")
        add_score 10
    else
        echo -e "${YELLOW}  ⚠ validate-bash.sh exists but not executable${NC}"
        WARNINGS+=("validate-bash.sh not executable (chmod +x .claude/scripts/validate-bash.sh)")
        add_score 5
    fi
else
    echo -e "${RED}  ✗ .claude/scripts/validate-bash.sh not found${NC}"
    CRITICAL_ISSUES+=("Missing validate-bash.sh - token optimization inactive")
fi

# Check .claude/ignore (5 points)
if [ -f ".claude/ignore" ]; then
    PATTERN_COUNT=$(grep -v '^#' .claude/ignore | grep -v '^$' | wc -l)
    echo -e "${GREEN}  ✓ .claude/ignore exists ($PATTERN_COUNT patterns)${NC}"
    COMPLIANT+=(".claude/ignore with $PATTERN_COUNT patterns")
    add_score 5
else
    echo -e "${RED}  ✗ .claude/ignore not found${NC}"
    CRITICAL_ISSUES+=("Missing .claude/ignore - no pattern blocklist")
fi

# Check CLAUDE.md (5 points)
if [ -f "CLAUDE.md" ]; then
    if grep -q "\[.*\]" CLAUDE.md 2>/dev/null; then
        echo -e "${YELLOW}  ⚠ CLAUDE.md contains template placeholders${NC}"
        WARNINGS+=("CLAUDE.md not customized - contains placeholders like [tech stack]")
        add_score 2
    else
        echo -e "${GREEN}  ✓ CLAUDE.md exists and is customized${NC}"
        COMPLIANT+=("CLAUDE.md customized")
        add_score 5
    fi
else
    echo -e "${RED}  ✗ CLAUDE.md not found in project root${NC}"
    CRITICAL_ISSUES+=("Missing CLAUDE.md - no project context for Claude")
fi

echo ""

# ============================================================================
# 2. HOOK CONFIGURATION (15 points)
# ============================================================================

echo -e "${CYAN}[2/10] Checking hook configuration...${NC}"

if [ -f ".claude/settings.local.json" ]; then
    # Check if Bash hook is configured
    if jq -e '.hooks.PreToolUse[]? | select(.matcher == "Bash")' .claude/settings.local.json >/dev/null 2>&1; then
        echo -e "${GREEN}  ✓ Bash PreToolUse hook configured${NC}"
        COMPLIANT+=("Bash validation hook active")
        add_score 10
    else
        echo -e "${RED}  ✗ Bash PreToolUse hook not configured${NC}"
        CRITICAL_ISSUES+=("Bash validation hook missing in settings.local.json")
    fi

    # Check deny permissions count
    DENY_COUNT=$(jq -r '.permissions.deny[]? | length' .claude/settings.local.json 2>/dev/null | wc -l)
    if [ "$DENY_COUNT" -gt 10 ]; then
        echo -e "${GREEN}  ✓ Read permissions configured ($DENY_COUNT deny patterns)${NC}"
        COMPLIANT+=("$DENY_COUNT Read deny patterns")
        add_score 5
    elif [ "$DENY_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Only $DENY_COUNT deny patterns (recommended: 10+)${NC}"
        WARNINGS+=("Few Read deny patterns - add more for better optimization")
        add_score 2
    else
        echo -e "${RED}  ✗ No Read deny patterns configured${NC}"
        CRITICAL_ISSUES+=("No Read() deny patterns - all files accessible")
    fi
fi

echo ""

# ============================================================================
# 3. TOKEN OPTIMIZATION (20 points)
# ============================================================================

echo -e "${CYAN}[3/10] Checking token optimization...${NC}"

if [ -f ".claude/scripts/check-token-usage.sh" ] && [ -x ".claude/scripts/check-token-usage.sh" ]; then
    # Run token analysis silently and parse results
    EXPOSED_DIRS=0
    IGNORED_DIRS=0

    # Count exposed vs ignored directories
    if command_exists jq; then
        # Simple heuristic: check for common problematic directories
        for dir in node_modules dist build .git/objects vendor target __pycache__ .next; do
            if [ -d "$dir" ]; then
                if grep -q "$dir" .claude/ignore 2>/dev/null; then
                    IGNORED_DIRS=$((IGNORED_DIRS + 1))
                else
                    EXPOSED_DIRS=$((EXPOSED_DIRS + 1))
                fi
            fi
        done

        TOTAL_DIRS=$((EXPOSED_DIRS + IGNORED_DIRS))
        if [ $TOTAL_DIRS -gt 0 ]; then
            EXPOSURE_PCT=$((EXPOSED_DIRS * 100 / TOTAL_DIRS))

            if [ $EXPOSURE_PCT -lt 20 ]; then
                echo -e "${GREEN}  ✓ Token optimization: EXCELLENT (${EXPOSURE_PCT}% exposed)${NC}"
                COMPLIANT+=("Optimal token optimization")
                add_score 20
            elif [ $EXPOSURE_PCT -lt 50 ]; then
                echo -e "${YELLOW}  ⚠ Token optimization: GOOD (${EXPOSURE_PCT}% exposed)${NC}"
                WARNINGS+=("Some directories still exposed - run /optimize-tokens for details")
                add_score 12
            else
                echo -e "${RED}  ✗ Token optimization: POOR (${EXPOSURE_PCT}% exposed)${NC}"
                CRITICAL_ISSUES+=("High token waste - $EXPOSED_DIRS directories not in .claude/ignore")
                add_score 5
            fi
        else
            echo -e "${BLUE}  ℹ No common build directories detected${NC}"
            add_score 15
        fi
    else
        echo -e "${YELLOW}  ⚠ jq not installed - skipping detailed analysis${NC}"
        WARNINGS+=("Install jq for token optimization analysis")
        add_score 10
    fi
else
    echo -e "${YELLOW}  ⚠ Token analyzer script not found or not executable${NC}"
    WARNINGS+=("Missing or non-executable check-token-usage.sh")
    add_score 5
fi

echo ""

# ============================================================================
# 4. CLAUDE.MD QUALITY (10 points)
# ============================================================================

echo -e "${CYAN}[4/10] Checking CLAUDE.md quality...${NC}"

if [ -f "CLAUDE.md" ]; then
    LINES=$(wc -l < CLAUDE.md)

    if [ $LINES -gt 500 ]; then
        echo -e "${YELLOW}  ⚠ CLAUDE.md is very long (${LINES} lines)${NC}"
        WARNINGS+=("CLAUDE.md is $LINES lines - consider condensing (loaded every session)")
        add_score 5
    elif [ $LINES -lt 20 ]; then
        echo -e "${YELLOW}  ⚠ CLAUDE.md is very short (${LINES} lines)${NC}"
        WARNINGS+=("CLAUDE.md might be too minimal - add project context")
        add_score 7
    else
        echo -e "${GREEN}  ✓ CLAUDE.md length appropriate (${LINES} lines)${NC}"
        add_score 10
    fi

    # Check for project-specific content
    if [ -f "package.json" ] && ! grep -qi "npm\|node\|javascript\|typescript" CLAUDE.md; then
        echo -e "${YELLOW}  ⚠ Project uses JavaScript but CLAUDE.md doesn't mention it${NC}"
        WARNINGS+=("CLAUDE.md doesn't match project stack (JS/TS project)")
    fi

    if [ -d "tests" ] || [ -d "test" ] && ! grep -qi "test" CLAUDE.md; then
        echo -e "${YELLOW}  ⚠ Test directory exists but not documented in CLAUDE.md${NC}"
        WARNINGS+=("Test directory exists but no test command in CLAUDE.md")
    fi
else
    echo -e "${RED}  ✗ CLAUDE.md not found${NC}"
fi

echo ""

# ============================================================================
# 5. SLASH COMMANDS (5 points)
# ============================================================================

echo -e "${CYAN}[5/10] Checking slash commands...${NC}"

if [ -d ".claude/commands" ]; then
    CMD_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
    if [ $CMD_COUNT -ge 5 ]; then
        echo -e "${GREEN}  ✓ $CMD_COUNT slash commands configured${NC}"
        COMPLIANT+=("$CMD_COUNT custom slash commands")
        add_score 5
    elif [ $CMD_COUNT -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Only $CMD_COUNT slash commands (recommended: 5+)${NC}"
        RECOMMENDATIONS+=("Add more slash commands for common workflows")
        add_score 3
    else
        echo -e "${RED}  ✗ No slash commands found${NC}"
        WARNINGS+=("No custom slash commands - missing workflow automation")
    fi
else
    echo -e "${RED}  ✗ .claude/commands/ directory not found${NC}"
    WARNINGS+=("Missing .claude/commands/ directory")
fi

echo ""

# ============================================================================
# 6. WORKFLOW DOCUMENTATION (5 points)
# ============================================================================

echo -e "${CYAN}[6/10] Checking workflow documentation...${NC}"

if [ -d ".claude/workflows" ]; then
    WORKFLOW_COUNT=$(ls -1 .claude/workflows/*.md 2>/dev/null | wc -l)
    if [ $WORKFLOW_COUNT -ge 3 ]; then
        echo -e "${GREEN}  ✓ $WORKFLOW_COUNT workflow guides available${NC}"
        COMPLIANT+=("$WORKFLOW_COUNT workflow documentation files")
        add_score 5
    elif [ $WORKFLOW_COUNT -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Only $WORKFLOW_COUNT workflow guides${NC}"
        RECOMMENDATIONS+=("Add more workflow documentation for team")
        add_score 3
    fi
else
    echo -e "${YELLOW}  ⚠ .claude/workflows/ directory not found${NC}"
    RECOMMENDATIONS+=("Consider adding workflow documentation")
fi

echo ""

# ============================================================================
# 7. PROJECT-SPECIFIC PATTERNS (10 points)
# ============================================================================

echo -e "${CYAN}[7/10] Checking project-specific patterns...${NC}"

MISSING_PATTERNS=()

# Check for common framework-specific directories
if [ -d ".next" ] && ! grep -q "\.next" .claude/ignore 2>/dev/null; then
    MISSING_PATTERNS+=(".next/ (Next.js)")
fi

if [ -d ".nuxt" ] && ! grep -q "\.nuxt" .claude/ignore 2>/dev/null; then
    MISSING_PATTERNS+=(".nuxt/ (Nuxt.js)")
fi

if [ -d "__pycache__" ] && ! grep -q "__pycache__" .claude/ignore 2>/dev/null; then
    MISSING_PATTERNS+=("__pycache__/ (Python)")
fi

if [ -f "package-lock.json" ] && ! grep -q "package-lock.json" .claude/ignore 2>/dev/null; then
    MISSING_PATTERNS+=("package-lock.json")
fi

if [ -f "yarn.lock" ] && ! grep -q "yarn.lock" .claude/ignore 2>/dev/null; then
    MISSING_PATTERNS+=("yarn.lock")
fi

if [ ${#MISSING_PATTERNS[@]} -eq 0 ]; then
    echo -e "${GREEN}  ✓ All detected directories/files are blocked${NC}"
    COMPLIANT+=("Project-specific patterns covered")
    add_score 10
else
    echo -e "${YELLOW}  ⚠ Found ${#MISSING_PATTERNS[@]} unblocked pattern(s)${NC}"
    for pattern in "${MISSING_PATTERNS[@]}"; do
        echo -e "${YELLOW}    - $pattern${NC}"
        WARNINGS+=("Add $pattern to .claude/ignore")
    done
    add_score 5
fi

echo ""

# ============================================================================
# 8. SCRIPT FUNCTIONALITY (10 points)
# ============================================================================

echo -e "${CYAN}[8/10] Testing script functionality...${NC}"

SCRIPT_TESTS_PASSED=0

# Test validate-bash.sh
if [ -f ".claude/scripts/validate-bash.sh" ] && [ -x ".claude/scripts/validate-bash.sh" ]; then
    if command_exists jq; then
        # Test blocked command
        if echo '{"tool_input":{"command":"grep -r test ."}}' | ./.claude/scripts/validate-bash.sh 2>&1 | grep -q "ERROR"; then
            echo -e "${GREEN}  ✓ Bash validation correctly blocks unsafe commands${NC}"
            SCRIPT_TESTS_PASSED=$((SCRIPT_TESTS_PASSED + 1))
        else
            echo -e "${RED}  ✗ Bash validation not working correctly${NC}"
            CRITICAL_ISSUES+=("Bash validation script doesn't block unsafe commands")
        fi

        # Test allowed command
        if ! echo '{"tool_input":{"command":"grep test src/"}}' | ./.claude/scripts/validate-bash.sh 2>&1 | grep -q "ERROR"; then
            echo -e "${GREEN}  ✓ Bash validation correctly allows scoped commands${NC}"
            SCRIPT_TESTS_PASSED=$((SCRIPT_TESTS_PASSED + 1))
        else
            echo -e "${RED}  ✗ Bash validation blocks safe commands${NC}"
            WARNINGS+=("Bash validation too restrictive - might block safe commands")
        fi
    else
        echo -e "${YELLOW}  ⚠ Skipping validation tests (jq not installed)${NC}"
        WARNINGS+=("Install jq to test bash validation")
    fi
fi

if [ $SCRIPT_TESTS_PASSED -eq 2 ]; then
    add_score 10
elif [ $SCRIPT_TESTS_PASSED -eq 1 ]; then
    add_score 5
fi

echo ""

# ============================================================================
# 9. GIT INTEGRATION (5 points)
# ============================================================================

echo -e "${CYAN}[9/10] Checking git integration...${NC}"

if git rev-parse --git-dir >/dev/null 2>&1; then
    # Check if .claude/ is tracked
    if git ls-files .claude/ >/dev/null 2>&1; then
        echo -e "${GREEN}  ✓ Configuration committed to git${NC}"
        COMPLIANT+=("Configuration in version control")
        add_score 5
    else
        echo -e "${YELLOW}  ⚠ Configuration not committed to git${NC}"
        RECOMMENDATIONS+=("Commit .claude/ to share with team: git add .claude/ CLAUDE.md")
        add_score 2
    fi

    # Check if logs are ignored
    if [ -f ".gitignore" ]; then
        if grep -q ".claude/logs" .gitignore 2>/dev/null; then
            echo -e "${GREEN}  ✓ .claude/logs/ properly ignored${NC}"
        else
            echo -e "${YELLOW}  ⚠ .claude/logs/ should be in .gitignore${NC}"
            RECOMMENDATIONS+=("Add .claude/logs/ to .gitignore")
        fi
    fi
else
    echo -e "${BLUE}  ℹ Not a git repository${NC}"
    add_score 3
fi

echo ""

# ============================================================================
# 10. PREREQUISITES (10 points)
# ============================================================================

echo -e "${CYAN}[10/10] Checking prerequisites...${NC}"

if command_exists jq; then
    echo -e "${GREEN}  ✓ jq is installed${NC}"
    COMPLIANT+=("jq installed")
    add_score 10
else
    echo -e "${RED}  ✗ jq is NOT installed${NC}"
    CRITICAL_ISSUES+=("jq not installed - bash validation won't work")
    RECOMMENDATIONS+=("Install jq: sudo apt install jq (Linux) or brew install jq (macOS)")
fi

echo ""
echo ""

# ============================================================================
# GENERATE REPORT
# ============================================================================

# Determine overall status
if [ $SCORE -ge 90 ]; then
    STATUS="${GREEN}🟢 EXCELLENT${NC}"
    STATUS_EMOJI="🟢"
elif [ $SCORE -ge 70 ]; then
    STATUS="${BLUE}🔵 GOOD${NC}"
    STATUS_EMOJI="🔵"
elif [ $SCORE -ge 50 ]; then
    STATUS="${YELLOW}🟡 NEEDS IMPROVEMENT${NC}"
    STATUS_EMOJI="🟡"
else
    STATUS="${RED}🔴 CRITICAL${NC}"
    STATUS_EMOJI="🔴"
fi

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            COMPLIANCE REPORT                     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Overall Status: $STATUS"
echo -e "Score: ${SCORE}/${MAX_SCORE}"
echo ""

# Critical Issues
if [ ${#CRITICAL_ISSUES[@]} -gt 0 ]; then
    echo -e "${RED}## Critical Issues (Must Fix) 🔴${NC}"
    echo ""
    for issue in "${CRITICAL_ISSUES[@]}"; do
        echo -e "${RED}  ✗ $issue${NC}"
    done
    echo ""
fi

# Warnings
if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}## Warnings (Should Fix) 🟡${NC}"
    echo ""
    for warning in "${WARNINGS[@]}"; do
        echo -e "${YELLOW}  ⚠ $warning${NC}"
    done
    echo ""
fi

# Recommendations
if [ ${#RECOMMENDATIONS[@]} -gt 0 ]; then
    echo -e "${CYAN}## Recommendations (Nice to Have) 💡${NC}"
    echo ""
    for rec in "${RECOMMENDATIONS[@]}"; do
        echo -e "${CYAN}  💡 $rec${NC}"
    done
    echo ""
fi

# Compliant Areas
if [ ${#COMPLIANT[@]} -gt 0 ]; then
    echo -e "${GREEN}## Compliant Areas ✅${NC}"
    echo ""
    for item in "${COMPLIANT[@]}"; do
        echo -e "${GREEN}  ✓ $item${NC}"
    done
    echo ""
fi

# Next Steps
echo -e "${BLUE}## Next Steps${NC}"
echo ""

if [ ${#CRITICAL_ISSUES[@]} -gt 0 ]; then
    echo -e "1. ${RED}Fix critical issues${NC} (run /init for automatic fix)"
    echo -e "2. ${YELLOW}Address warnings${NC}"
    echo -e "3. ${CYAN}Consider recommendations${NC}"
else
    echo -e "1. ${CYAN}Consider recommendations for further optimization${NC}"
    echo -e "2. ${GREEN}Schedule monthly compliance checks${NC}"
fi

echo ""
echo -e "Run ${CYAN}/init${NC} to automatically fix configuration issues."
echo -e "Run ${CYAN}/optimize-tokens${NC} for detailed token usage analysis."
echo ""

exit 0
