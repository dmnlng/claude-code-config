#!/bin/bash
# Claude Code Template Setup Script
# Can be run standalone or called from /init command

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEMPLATE_PATH="${1:-$HOME/claude-code-template}"
DRY_RUN="${DRY_RUN:-false}"

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Code Configuration Setup               ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Check if template exists
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo -e "${RED}✗ Template not found at: $TEMPLATE_PATH${NC}"
    echo ""
    echo "Options:"
    echo "1. Download template:"
    echo "   git clone https://github.com/dmnlng/claude-code-config.git ~/claude-code-template"
    echo ""
    echo "2. Specify custom path:"
    echo "   $0 /path/to/template"
    exit 1
fi

echo -e "${GREEN}✓ Template found at: $TEMPLATE_PATH${NC}"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect project type
detect_project_type() {
    if [ -f "package.json" ]; then
        echo "JavaScript/TypeScript"
    elif [ -f "Cargo.toml" ]; then
        echo "Rust"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "Python"
    elif [ -f "go.mod" ]; then
        echo "Go"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "Java"
    elif [ -f "*.csproj" ] 2>/dev/null | grep -q "csproj"; then
        echo ".NET"
    else
        echo "Unknown"
    fi
}

# Function to detect test command
detect_test_command() {
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json; then
            echo "npm test"
        else
            echo "npm test # (configure in package.json)"
        fi
    elif [ -f "Cargo.toml" ]; then
        echo "cargo test"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "pytest"
    elif [ -f "go.mod" ]; then
        echo "go test ./..."
    else
        echo "# Configure your test command here"
    fi
}

# Check prerequisites
echo -e "${CYAN}[1/8] Checking prerequisites...${NC}"

# Check for jq
if command_exists jq; then
    echo -e "${GREEN}  ✓ jq is installed${NC}"
else
    echo -e "${RED}  ✗ jq is NOT installed (required for bash validation)${NC}"
    echo ""
    echo "  Install jq:"
    echo "    - Linux:   sudo apt install jq"
    echo "    - macOS:   brew install jq"
    echo "    - Windows: choco install jq"
    echo ""
    read -p "  Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if git repository
IS_GIT_REPO=false
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Git repository detected${NC}"
    IS_GIT_REPO=true
else
    echo -e "${YELLOW}  ⚠ Not a git repository (commit step will be skipped)${NC}"
fi

echo ""

# Detect project info
echo -e "${CYAN}[2/8] Detecting project information...${NC}"

PROJECT_TYPE=$(detect_project_type)
TEST_COMMAND=$(detect_test_command)

echo -e "  ${GREEN}Project Type:${NC} $PROJECT_TYPE"
echo -e "  ${GREEN}Test Command:${NC} $TEST_COMMAND"
echo ""

# Check existing configuration
echo -e "${CYAN}[3/8] Checking existing configuration...${NC}"

if [ -d ".claude" ]; then
    echo -e "${YELLOW}  ⚠ .claude/ directory already exists${NC}"
    read -p "  Backup existing config? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_NAME=".claude.backup.$(date +%Y%m%d_%H%M%S)"
        mv .claude "$BACKUP_NAME"
        echo -e "${GREEN}  ✓ Backed up to: $BACKUP_NAME${NC}"
    else
        echo -e "${YELLOW}  ! Will overwrite existing configuration${NC}"
    fi
fi

if [ -f "CLAUDE.md" ]; then
    echo -e "${YELLOW}  ⚠ CLAUDE.md already exists${NC}"
    read -p "  Backup existing CLAUDE.md? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv CLAUDE.md "CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${GREEN}  ✓ Backed up CLAUDE.md${NC}"
    fi
fi

echo ""

# Create directory structure
echo -e "${CYAN}[4/8] Creating directory structure...${NC}"

mkdir -p .claude/scripts .claude/commands .claude/workflows .claude/logs
echo -e "${GREEN}  ✓ Created .claude/ directories${NC}"
echo ""

# Copy core files
echo -e "${CYAN}[5/8] Installing configuration files...${NC}"

cp "$TEMPLATE_PATH/.claude/scripts/validate-bash.sh" .claude/scripts/
cp "$TEMPLATE_PATH/.claude/scripts/check-token-usage.sh" .claude/scripts/
cp "$TEMPLATE_PATH/.claude/scripts/compliance-check.sh" .claude/scripts/
cp "$TEMPLATE_PATH/.claude/scripts/setup.sh" .claude/scripts/
cp "$TEMPLATE_PATH/.claude/ignore" .claude/
cp "$TEMPLATE_PATH/.claude/settings.local.json" .claude/

echo -e "${GREEN}  ✓ Copied validate-bash.sh${NC}"
echo -e "${GREEN}  ✓ Copied check-token-usage.sh${NC}"
echo -e "${GREEN}  ✓ Copied compliance-check.sh${NC}"
echo -e "${GREEN}  ✓ Copied setup.sh${NC}"
echo -e "${GREEN}  ✓ Copied .claude/ignore${NC}"
echo -e "${GREEN}  ✓ Copied settings.local.json${NC}"

# Copy commands
cp "$TEMPLATE_PATH/.claude/commands/"*.md .claude/commands/
COMMAND_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
echo -e "${GREEN}  ✓ Copied $COMMAND_COUNT slash commands${NC}"

# Copy workflows
cp "$TEMPLATE_PATH/.claude/workflows/"*.md .claude/workflows/
WORKFLOW_COUNT=$(ls -1 .claude/workflows/*.md 2>/dev/null | wc -l)
echo -e "${GREEN}  ✓ Copied $WORKFLOW_COUNT workflow guides${NC}"

# Copy CLAUDE.md and customize
cp "$TEMPLATE_PATH/CLAUDE.md" CLAUDE.md

# Simple customization based on detection
sed -i.bak "s/\[web application \/ library \/ CLI tool \/ etc.\]/$PROJECT_TYPE project/" CLAUDE.md
sed -i.bak "s/\[npm test \/ pytest \/ cargo test \/ go test\]/$TEST_COMMAND/" CLAUDE.md
rm CLAUDE.md.bak 2>/dev/null || true

echo -e "${GREEN}  ✓ Created and customized CLAUDE.md${NC}"

# Copy .gitignore if needed
if [ -f "$TEMPLATE_PATH/.gitignore" ] && [ ! -f ".gitignore" ]; then
    cp "$TEMPLATE_PATH/.gitignore" .gitignore
    echo -e "${GREEN}  ✓ Copied .gitignore${NC}"
elif [ -f ".gitignore" ]; then
    # Append if not already present
    if ! grep -q ".claude/logs/" .gitignore 2>/dev/null; then
        echo "" >> .gitignore
        echo "# Claude Code logs" >> .gitignore
        echo ".claude/logs/" >> .gitignore
        echo -e "${GREEN}  ✓ Updated .gitignore${NC}"
    fi
fi

# Make scripts executable
chmod +x .claude/scripts/*.sh
echo -e "${GREEN}  ✓ Made scripts executable${NC}"
echo ""

# Run token usage check
echo -e "${CYAN}[6/8] Analyzing token usage...${NC}"
echo ""

if command_exists jq; then
    ./.claude/scripts/check-token-usage.sh || true
else
    echo -e "${YELLOW}  ⚠ Skipping (jq not installed)${NC}"
fi

echo ""

# Test configuration
echo -e "${CYAN}[7/8] Testing configuration...${NC}"

if command_exists jq; then
    # Test blocked command
    if echo '{"tool_input":{"command":"grep -r test ."}}' | ./.claude/scripts/validate-bash.sh 2>&1 | grep -q "ERROR"; then
        echo -e "${GREEN}  ✓ Bash validation correctly blocks unsafe commands${NC}"
    else
        echo -e "${RED}  ✗ Bash validation not working correctly${NC}"
    fi

    # Test allowed command
    if echo '{"tool_input":{"command":"grep test src/"}}' | ./.claude/scripts/validate-bash.sh 2>&1 | grep -q "ERROR"; then
        echo -e "${RED}  ✗ Bash validation incorrectly blocks safe commands${NC}"
    else
        echo -e "${GREEN}  ✓ Bash validation correctly allows scoped commands${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠ Skipping validation tests (jq not installed)${NC}"
fi

if [ -f "CLAUDE.md" ]; then
    echo -e "${GREEN}  ✓ CLAUDE.md exists and is readable${NC}"
fi

echo ""

# Git commit
echo -e "${CYAN}[8/8] Git integration...${NC}"

if [ "$IS_GIT_REPO" = true ]; then
    read -p "  Create git commit for this configuration? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .claude/ CLAUDE.md .gitignore 2>/dev/null || true
        git commit -m "chore: initialize Claude Code configuration

- Token optimization with bash validation hook
- Project-specific CLAUDE.md context file
- Custom slash commands for common workflows
- Workflow documentation for team

Estimated token savings: ~82% per session" 2>/dev/null

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}  ✓ Created git commit${NC}"

            read -p "  Push to remote? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git push
                echo -e "${GREEN}  ✓ Pushed to remote${NC}"
            fi
        else
            echo -e "${YELLOW}  ⚠ Nothing to commit (no changes)${NC}"
        fi
    fi
else
    echo -e "${YELLOW}  ⚠ Skipping (not a git repository)${NC}"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Claude Code Configuration Complete!         ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}📁 Created:${NC}"
echo "   - .claude/scripts/validate-bash.sh (token optimization)"
echo "   - .claude/scripts/check-token-usage.sh (analyzer)"
echo "   - .claude/ignore (blocklist: $(grep -v '^#' .claude/ignore | grep -v '^$' | wc -l) patterns)"
echo "   - .claude/settings.local.json (hooks + permissions)"
echo "   - CLAUDE.md (project context)"
echo "   - .claude/commands/ ($COMMAND_COUNT slash commands)"
echo "   - .claude/workflows/ ($WORKFLOW_COUNT workflow guides)"
echo ""

echo -e "${BLUE}⚡ Estimated Token Savings:${NC} ~82% per session"
echo ""

echo -e "${BLUE}🎯 Next Steps:${NC}"
echo "   1. Review and customize CLAUDE.md for your team"
echo "   2. Try custom commands: /test, /review, /explore, /optimize-tokens"
echo "   3. Read workflow guides: .claude/workflows/*.md"
if [ "$IS_GIT_REPO" = true ]; then
    echo "   4. Share with team: git push (config is committed)"
fi
echo ""

echo -e "${BLUE}💡 Pro Tips:${NC}"
echo "   - Use /clear between unrelated tasks"
echo "   - Run .claude/scripts/check-token-usage.sh monthly"
echo "   - Keep CLAUDE.md concise (loaded every session)"
echo ""

echo -e "${BLUE}📚 Resources:${NC}"
echo "   - Workflow Guides: .claude/workflows/"
echo "   - Token Analyzer: .claude/scripts/check-token-usage.sh"
echo "   - Documentation: README.md (if exists)"
echo ""

if ! command_exists jq; then
    echo -e "${YELLOW}⚠ Important: Install jq for full functionality${NC}"
    echo "   - Linux:   sudo apt install jq"
    echo "   - macOS:   brew install jq"
    echo "   - Windows: choco install jq"
    echo ""
fi

echo -e "${GREEN}Setup complete! Start a new Claude session to use the configuration.${NC}"
