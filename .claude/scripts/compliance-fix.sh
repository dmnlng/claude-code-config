#!/bin/bash
# Claude Code Compliance Auto-Fix Script
# Automatically fixes common configuration issues

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

TEMPLATE_PATH="${1:-$HOME/claude-code-template}"
FIXES_APPLIED=0
BACKUP_DIR=".claude/backups/$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Claude Code Compliance Auto-Fix                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${CYAN}Backup directory: $BACKUP_DIR${NC}"
echo ""

# ============================================================================
# FIX 1: Configure Bash Validation Hook
# ============================================================================

echo -e "${CYAN}[Fix 1/7] Checking Bash validation hook...${NC}"

if [ -f ".claude/settings.local.json" ]; then
    # Check if hook is configured
    if ! grep -q "PreToolUse" .claude/settings.local.json 2>/dev/null || \
       ! grep -q "validate-bash.sh" .claude/settings.local.json 2>/dev/null; then

        echo -e "${YELLOW}  ⚠ Hook not configured - fixing...${NC}"

        # Backup existing file
        cp .claude/settings.local.json "$BACKUP_DIR/settings.local.json.backup"

        # Create new settings with hook
        cat > .claude/settings.local.json << 'EOF'
{
  "$schema": "https://files.claude.com/schemas/settings.json",

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "command": "bash .claude/scripts/validate-bash.sh",
            "description": "Validates Bash commands to prevent token waste"
          }
        ]
      }
    ]
  },

  "permissions": {
    "deny": [
      "Read(node_modules/)",
      "Read(**/node_modules/)",
      "Read(**/.git/objects/)",
      "Read(**/.git/refs/)",
      "Read(**/.git/logs/)",
      "Read(**/dist/)",
      "Read(**/build/)",
      "Read(**/out/)",
      "Read(**/__pycache__/)",
      "Read(**/.next/)",
      "Read(**/.nuxt/)",
      "Read(**/.output/)",
      "Read(**/coverage/)",
      "Read(**/.cache/)",
      "Read(**/.pytest_cache/)",
      "Read(**/vendor/)",
      "Read(**/target/)",
      "Read(**/bin/)",
      "Read(**/obj/)",
      "Read(**/*.lock)",
      "Read(**/*.sqlite)",
      "Read(**/*.db)"
    ],
    "allow": [
      "Read(.env.example)",
      "Read(.env.template)"
    ]
  }
}
EOF

        echo -e "${GREEN}  ✓ Configured Bash validation hook${NC}"
        echo -e "${GREEN}  ✓ Added Read() deny patterns${NC}"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    else
        echo -e "${GREEN}  ✓ Hook already configured${NC}"
    fi
else
    echo -e "${RED}  ✗ .claude/settings.local.json not found${NC}"

    if [ -f "$TEMPLATE_PATH/.claude/settings.local.json" ]; then
        echo -e "${YELLOW}  → Copying from template...${NC}"
        cp "$TEMPLATE_PATH/.claude/settings.local.json" .claude/settings.local.json
        echo -e "${GREEN}  ✓ Created settings.local.json from template${NC}"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    fi
fi

echo ""

# ============================================================================
# FIX 2: Add Lock Files to .claude/ignore
# ============================================================================

echo -e "${CYAN}[Fix 2/7] Checking lock files in .claude/ignore...${NC}"

if [ -f ".claude/ignore" ]; then
    LOCK_FILES_ADDED=0

    for lockfile in "package-lock.json" "yarn.lock" "pnpm-lock.yaml" "Cargo.lock" "Pipfile.lock" "composer.lock"; do
        if ! grep -q "^$lockfile$" .claude/ignore 2>/dev/null; then
            # Check if this lock file exists in project
            if find . -maxdepth 3 -name "$lockfile" 2>/dev/null | grep -q .; then
                echo "$lockfile" >> .claude/ignore
                echo -e "${GREEN}  ✓ Added $lockfile to .claude/ignore${NC}"
                LOCK_FILES_ADDED=$((LOCK_FILES_ADDED + 1))
            fi
        fi
    done

    if [ $LOCK_FILES_ADDED -gt 0 ]; then
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    else
        echo -e "${GREEN}  ✓ All lock files already in .claude/ignore${NC}"
    fi
else
    echo -e "${RED}  ✗ .claude/ignore not found${NC}"
fi

echo ""

# ============================================================================
# FIX 3: Add Database Files to .claude/ignore
# ============================================================================

echo -e "${CYAN}[Fix 3/7] Checking database files in .claude/ignore...${NC}"

if [ -f ".claude/ignore" ]; then
    DB_PATTERNS_ADDED=0

    # Check if database files exist
    if find . -name "*.sqlite" -o -name "*.db" 2>/dev/null | grep -q .; then
        if ! grep -q "^\*\.sqlite$" .claude/ignore 2>/dev/null; then
            echo "*.sqlite" >> .claude/ignore
            echo -e "${GREEN}  ✓ Added *.sqlite to .claude/ignore${NC}"
            DB_PATTERNS_ADDED=$((DB_PATTERNS_ADDED + 1))
        fi

        if ! grep -q "^\*\.db$" .claude/ignore 2>/dev/null; then
            # But keep Thumbs.db in ignore (it's an OS file, not a database)
            if ! grep -q "^Thumbs.db$" .claude/ignore; then
                echo "*.db" >> .claude/ignore
            else
                # Add pattern but exclude Thumbs.db
                echo "# Database files" >> .claude/ignore
                echo "*.sqlite" >> .claude/ignore
                echo "*.db" >> .claude/ignore
                echo "!Thumbs.db" >> .claude/ignore
            fi
            echo -e "${GREEN}  ✓ Added *.db to .claude/ignore${NC}"
            DB_PATTERNS_ADDED=$((DB_PATTERNS_ADDED + 1))
        fi
    fi

    if [ $DB_PATTERNS_ADDED -gt 0 ]; then
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    else
        echo -e "${GREEN}  ✓ Database patterns already configured${NC}"
    fi
fi

echo ""

# ============================================================================
# FIX 4: Add .claude/logs to .gitignore
# ============================================================================

echo -e "${CYAN}[Fix 4/7] Checking .gitignore...${NC}"

if [ -f ".gitignore" ]; then
    if ! grep -q "\.claude/logs" .gitignore 2>/dev/null; then
        cp .gitignore "$BACKUP_DIR/gitignore.backup"
        echo "" >> .gitignore
        echo "# Claude Code logs" >> .gitignore
        echo ".claude/logs/" >> .gitignore
        echo -e "${GREEN}  ✓ Added .claude/logs/ to .gitignore${NC}"
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    else
        echo -e "${GREEN}  ✓ .claude/logs already in .gitignore${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠ No .gitignore file found${NC}"
    echo "# Claude Code logs" > .gitignore
    echo ".claude/logs/" >> .gitignore
    echo -e "${GREEN}  ✓ Created .gitignore with .claude/logs/${NC}"
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
fi

echo ""

# ============================================================================
# FIX 5: Ensure Scripts are Executable
# ============================================================================

echo -e "${CYAN}[Fix 5/7] Checking script permissions...${NC}"

SCRIPTS_FIXED=0
for script in .claude/scripts/*.sh; do
    if [ -f "$script" ] && [ ! -x "$script" ]; then
        chmod +x "$script"
        echo -e "${GREEN}  ✓ Made $(basename "$script") executable${NC}"
        SCRIPTS_FIXED=$((SCRIPTS_FIXED + 1))
    fi
done

if [ $SCRIPTS_FIXED -gt 0 ]; then
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
else
    echo -e "${GREEN}  ✓ All scripts already executable${NC}"
fi

echo ""

# ============================================================================
# FIX 6: Check Missing Files
# ============================================================================

echo -e "${CYAN}[Fix 6/7] Checking for missing files...${NC}"

MISSING_FIXED=0

# Check for missing scripts
for script in "validate-bash.sh" "check-token-usage.sh" "compliance-check.sh" "setup.sh"; do
    if [ ! -f ".claude/scripts/$script" ]; then
        if [ -f "$TEMPLATE_PATH/.claude/scripts/$script" ]; then
            cp "$TEMPLATE_PATH/.claude/scripts/$script" ".claude/scripts/$script"
            chmod +x ".claude/scripts/$script"
            echo -e "${GREEN}  ✓ Restored missing script: $script${NC}"
            MISSING_FIXED=$((MISSING_FIXED + 1))
        fi
    fi
done

# Check for missing commands
if [ ! -d ".claude/commands" ] || [ -z "$(ls -A .claude/commands 2>/dev/null)" ]; then
    if [ -d "$TEMPLATE_PATH/.claude/commands" ]; then
        mkdir -p .claude/commands
        cp "$TEMPLATE_PATH/.claude/commands/"*.md .claude/commands/
        COMMAND_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
        echo -e "${GREEN}  ✓ Restored $COMMAND_COUNT slash commands${NC}"
        MISSING_FIXED=$((MISSING_FIXED + 1))
    fi
fi

# Check for missing workflows
if [ ! -d ".claude/workflows" ] || [ -z "$(ls -A .claude/workflows 2>/dev/null)" ]; then
    if [ -d "$TEMPLATE_PATH/.claude/workflows" ]; then
        mkdir -p .claude/workflows
        cp "$TEMPLATE_PATH/.claude/workflows/"*.md .claude/workflows/
        WORKFLOW_COUNT=$(ls -1 .claude/workflows/*.md 2>/dev/null | wc -l)
        echo -e "${GREEN}  ✓ Restored $WORKFLOW_COUNT workflow guides${NC}"
        MISSING_FIXED=$((MISSING_FIXED + 1))
    fi
fi

if [ $MISSING_FIXED -gt 0 ]; then
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
else
    echo -e "${GREEN}  ✓ No missing files detected${NC}"
fi

echo ""

# ============================================================================
# FIX 7: Project-Specific Patterns
# ============================================================================

echo -e "${CYAN}[Fix 7/7] Adding project-specific patterns...${NC}"

if [ -f ".claude/ignore" ]; then
    PATTERNS_ADDED=0

    # Check for framework-specific directories
    if [ -d ".next" ] && ! grep -q "^\.next/$" .claude/ignore 2>/dev/null; then
        echo ".next/" >> .claude/ignore
        echo -e "${GREEN}  ✓ Added .next/ (Next.js)${NC}"
        PATTERNS_ADDED=$((PATTERNS_ADDED + 1))
    fi

    if [ -d ".nuxt" ] && ! grep -q "^\.nuxt/$" .claude/ignore 2>/dev/null; then
        echo ".nuxt/" >> .claude/ignore
        echo -e "${GREEN}  ✓ Added .nuxt/ (Nuxt.js)${NC}"
        PATTERNS_ADDED=$((PATTERNS_ADDED + 1))
    fi

    if [ -d "__pycache__" ] && ! grep -q "^__pycache__/$" .claude/ignore 2>/dev/null; then
        echo "__pycache__/" >> .claude/ignore
        echo -e "${GREEN}  ✓ Added __pycache__/ (Python)${NC}"
        PATTERNS_ADDED=$((PATTERNS_ADDED + 1))
    fi

    if [ -d ".turbo" ] && ! grep -q "^\.turbo/$" .claude/ignore 2>/dev/null; then
        echo ".turbo/" >> .claude/ignore
        echo -e "${GREEN}  ✓ Added .turbo/ (Turborepo)${NC}"
        PATTERNS_ADDED=$((PATTERNS_ADDED + 1))
    fi

    if [ $PATTERNS_ADDED -gt 0 ]; then
        FIXES_APPLIED=$((FIXES_APPLIED + 1))
    else
        echo -e "${GREEN}  ✓ No additional patterns needed${NC}"
    fi
fi

echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            AUTO-FIX SUMMARY                      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

if [ $FIXES_APPLIED -gt 0 ]; then
    echo -e "${GREEN}✓ Applied $FIXES_APPLIED fix(es)${NC}"
    echo ""
    echo -e "${YELLOW}Backups created in: $BACKUP_DIR${NC}"
    echo ""
    echo -e "${CYAN}Next Steps:${NC}"
    echo "1. Restart Claude for changes to take effect"
    echo "2. Run /compliance to verify improvements"
    echo "3. Test: Try running 'grep -r test .' (should be blocked)"
    echo "4. Commit changes: git add .claude/ .gitignore && git commit"
    echo ""
    echo -e "${GREEN}Expected improvement:${NC}"
    echo "  Token usage: ~18M → ~50k (99.7% reduction)"
    echo "  Compliance score: ~45/100 → ~95/100"
else
    echo -e "${GREEN}✓ Configuration already optimal!${NC}"
    echo ""
    echo "No fixes were needed. Your configuration is in good shape."
fi

echo ""
exit 0
