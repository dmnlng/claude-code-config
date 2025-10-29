#!/bin/bash
# Claude Code Config Remote Installer
# Usage: curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
REPO="dmnlng/claude-code-config"
BRANCH="main"
TMP_DIR="/tmp/claude-code-config-install-$$"

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Code Config Installer                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Check if already installed
if [ -d ".claude" ]; then
    echo -e "${YELLOW}⚠ .claude/ directory already exists${NC}"
    echo ""
    read -p "Overwrite existing configuration? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi
    BACKUP_DIR=".claude.backup.$(date +%Y%m%d_%H%M%S)"
    mv .claude "$BACKUP_DIR"
    echo -e "${GREEN}✓ Backed up to: $BACKUP_DIR${NC}"
    echo ""
fi

# Check prerequisites
echo -e "${CYAN}Checking prerequisites...${NC}"

if ! command -v jq >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ jq not installed (recommended for full functionality)${NC}"
    echo -e "    Install: ${CYAN}sudo apt install jq${NC} (Linux) or ${CYAN}brew install jq${NC} (macOS)"
else
    echo -e "${GREEN}  ✓ jq installed${NC}"
fi

if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}  ✗ git not installed (required)${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ git installed${NC}"

echo ""

# Download template
echo -e "${CYAN}Downloading template from GitHub...${NC}"

if git clone --depth 1 --branch "$BRANCH" "https://github.com/${REPO}.git" "$TMP_DIR" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Template downloaded${NC}"
else
    echo -e "${RED}✗ Failed to download template${NC}"
    exit 1
fi

echo ""

# Detect project type
echo -e "${CYAN}Detecting project...${NC}"

PROJECT_TYPE="Unknown"
if [ -f "package.json" ]; then
    PROJECT_TYPE="JavaScript/TypeScript"
    TEST_CMD="npm test"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="Rust"
    TEST_CMD="cargo test"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="Python"
    TEST_CMD="pytest"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="Go"
    TEST_CMD="go test ./..."
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    PROJECT_TYPE="Java"
    TEST_CMD="mvn test"
else
    TEST_CMD="# Configure test command"
fi

echo -e "${GREEN}  Project type: $PROJECT_TYPE${NC}"
echo ""

# Install files
echo -e "${CYAN}Installing configuration...${NC}"

# Create directory structure
mkdir -p .claude/scripts .claude/commands .claude/workflows .claude/logs

# Copy files
cp "$TMP_DIR/.claude/scripts/"*.sh .claude/scripts/
cp "$TMP_DIR/.claude/commands/"*.md .claude/commands/
cp "$TMP_DIR/.claude/workflows/"*.md .claude/workflows/
cp "$TMP_DIR/.claude/ignore" .claude/
cp "$TMP_DIR/.claude/settings.local.json" .claude/

# Make scripts executable
chmod +x .claude/scripts/*.sh

# Copy and customize CLAUDE.md if not exists
if [ ! -f "CLAUDE.md" ]; then
    cp "$TMP_DIR/CLAUDE.md" .

    # Simple customization
    if [ "$PROJECT_TYPE" != "Unknown" ]; then
        if command -v sed >/dev/null 2>&1; then
            sed -i.bak "s/\[web application \/ library \/ CLI tool \/ etc.\]/$PROJECT_TYPE project/" CLAUDE.md 2>/dev/null || true
            sed -i.bak "s/\[npm test \/ pytest \/ cargo test \/ go test\]/$TEST_CMD/" CLAUDE.md 2>/dev/null || true
            rm -f CLAUDE.md.bak
        fi
    fi
    echo -e "${GREEN}✓ CLAUDE.md created${NC}"
else
    echo -e "${YELLOW}  ℹ CLAUDE.md already exists (not overwriting)${NC}"
fi

# Update .gitignore
if [ -f ".gitignore" ]; then
    if ! grep -q ".claude/logs/" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# Claude Code logs" >> .gitignore
        echo ".claude/logs/" >> .gitignore
        echo -e "${GREEN}✓ Updated .gitignore${NC}"
    fi
else
    cp "$TMP_DIR/.gitignore" .
    echo -e "${GREEN}✓ Created .gitignore${NC}"
fi

echo -e "${GREEN}✓ Configuration installed${NC}"
echo ""

# Cleanup
rm -rf "$TMP_DIR"

# Count installed files
CMD_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
SCRIPT_COUNT=$(ls -1 .claude/scripts/*.sh 2>/dev/null | wc -l)
WORKFLOW_COUNT=$(ls -1 .claude/workflows/*.md 2>/dev/null | wc -l)

# Show success
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Installation Complete!                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📦 Installed:${NC}"
echo -e "   • .claude/settings.local.json (hooks + permissions)"
echo -e "   • .claude/ignore (token blocklist)"
echo -e "   • $SCRIPT_COUNT scripts in .claude/scripts/"
echo -e "   • $CMD_COUNT commands in .claude/commands/"
echo -e "   • $WORKFLOW_COUNT workflows in .claude/workflows/"
echo -e "   • CLAUDE.md (project context)"
echo ""

echo -e "${BLUE}⚡ Estimated Token Savings: ~82% per session${NC}"
echo ""

echo -e "${YELLOW}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  ⚠️  IMPORTANT: Restart Claude Now!            ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Hooks are only loaded at startup!${NC}"
echo ""
echo -e "Steps:"
echo -e "  1. ${CYAN}Exit Claude:${NC} Press Ctrl+C"
echo -e "  2. ${CYAN}Restart:${NC} Run 'claude' again"
echo -e "  3. ${CYAN}Verify:${NC} Try /doctor command"
echo ""

echo -e "${BLUE}🎯 After Restart:${NC}"
echo -e "   ${CYAN}/doctor${NC}           - Quick health check"
echo -e "   ${CYAN}/compliance${NC}       - Full audit (score 0-100)"
echo -e "   ${CYAN}/test${NC}             - Run your test suite"
echo -e "   ${CYAN}/review${NC} <path>    - Code review"
echo -e "   ${CYAN}/explore${NC} \"topic\"  - Explore codebase"
echo ""

echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "   README.md (in template)"
echo -e "   .claude/workflows/ (workflow guides)"
echo ""

# Optional: Git commit offer
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo -e "${CYAN}💡 Tip: Commit this configuration for your team${NC}"
    echo -e "   ${CYAN}git add .claude/ CLAUDE.md .gitignore${NC}"
    echo -e "   ${CYAN}git commit -m \"chore: add Claude Code optimization\"${NC}"
    echo ""
fi

echo -e "${GREEN}Installation complete! Restart Claude to activate.${NC}"
