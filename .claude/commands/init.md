# Initialize & Customize Configuration

Customize your Claude Code configuration after installation.

**Note:** This command is for post-installation customization. If you haven't installed yet, run:
```bash
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash
```

## Task

Perform interactive customization of the installed Claude Code configuration.

## Step 1: Check Installation

Verify that configuration is installed:

```bash
if [ ! -f ".claude/settings.local.json" ]; then
    echo "ERROR: Configuration not installed yet!"
    echo ""
    echo "Please install first:"
    echo "curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash"
    exit 1
fi
```

If not installed, show error and installation instructions.

## Step 2: Detect Current Setup

Auto-detect what's already configured:

```bash
# Detect project type
if [ -f "package.json" ]; then PROJECT_TYPE="JavaScript/TypeScript"
elif [ -f "Cargo.toml" ]; then PROJECT_TYPE="Rust"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then PROJECT_TYPE="Python"
elif [ -f "go.mod" ]; then PROJECT_TYPE="Go"
else PROJECT_TYPE="Unknown"
fi

# Check git
IS_GIT_REPO=$(git rev-parse --git-dir 2>/dev/null && echo "yes" || echo "no")

# Check CLAUDE.md customization
if grep -q "\[.*\]" CLAUDE.md 2>/dev/null; then
    CLAUDE_MD_STATUS="contains placeholders"
else
    CLAUDE_MD_STATUS="customized"
fi
```

Show current status:
```
Current Configuration:
  Project Type: JavaScript/TypeScript
  Git Repository: Yes
  CLAUDE.md: Contains placeholders
```

## Step 3: Ask User What to Customize

Use AskUserQuestion tool for customization options (multi-select allowed):

**Question: "What would you like to customize?"**
- Header: "Customize"
- Options:
  1. **CLAUDE.md** - "Update project context and code style guidelines"
  2. **Workflows** - "Enable specific workflow guides (TDD, Visual, Multi-Claude)"
  3. **MCP Servers** - "Configure Model Context Protocol integrations"
  4. **Git Commit** - "Create a commit with this configuration"
- Multi-select: true

## Step 4: Customize Based on Selection

### If "CLAUDE.md" selected:

Ask follow-up questions about the project:

**Question 1: "Primary development workflow?"**
- Header: "Workflow"
- Options:
  - "Test-Driven Development (TDD)"
  - "Feature-first development"
  - "Rapid prototyping"
  - "Other"

**Question 2: "Team size?"**
- Header: "Team"
- Options:
  - "Solo developer"
  - "Small team (2-5)"
  - "Medium team (6-15)"
  - "Large team (16+)"

Then update CLAUDE.md with:
- Fill in placeholders with detected values
- Add workflow section based on answer
- Add team-specific guidelines based on size
- Ensure test commands are filled in

### If "Workflows" selected:

Ask which workflows to enable:

**Question: "Which workflow guides do you want to highlight?"**
- Header: "Workflows"
- Options:
  - "TDD Workflow" - "Red-Green-Refactor development pattern"
  - "Visual Iteration" - "UI development with screenshots"
  - "Multi-Claude" - "Parallel development with git worktrees"
- Multi-select: true

Then add a workflows section to CLAUDE.md pointing to the selected guides.

### If "MCP Servers" selected:

Ask which MCP servers to enable:

**Question: "Which MCP servers do you want to configure?"**
- Header: "MCP"
- Options:
  - "Puppeteer" - "Browser automation for UI testing"
  - "Filesystem" - "Extended file system access"
  - "None" - "Skip MCP configuration"
- Multi-select: false (for now)

Then update `.claude/settings.local.json`:
- Uncomment MCP examples section
- Add selected server configurations
- Show user how to verify MCP is working

### If "Git Commit" selected:

Create a comprehensive commit:

```bash
# Check if there are changes to commit
if git status --porcelain | grep -q .; then
    git add .claude/ CLAUDE.md .gitignore

    git commit -m "chore: customize Claude Code configuration

Customizations:
- Project type: $PROJECT_TYPE
- Workflows: [list selected]
- MCP: [list enabled servers]
- CLAUDE.md customized for team

Token optimization: ~82% per session"

    echo "✓ Commit created"

    # Ask about push
    read -p "Push to remote? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push
        echo "✓ Pushed to remote"
    fi
else
    echo "ℹ No changes to commit"
fi
```

## Step 5: Run Compliance Check

After customization, verify everything is optimal:

```bash
./.claude/scripts/compliance-check.sh
```

Show the compliance score. Should be 90+/100.

## Step 6: Show Summary

Display what was customized:

```
╔══════════════════════════════════════════════════╗
║  ✓ Customization Complete!                      ║
╚══════════════════════════════════════════════════╝

📝 Updated:
  • CLAUDE.md (customized for $PROJECT_TYPE)
  • Enabled workflows: TDD, Visual Iteration
  • MCP servers: Puppeteer configured
  • Git commit created

📊 Compliance Score: 95/100 🟢

🎯 Try These Commands:
  /doctor           - Quick health check
  /test             - Run your test suite
  /review <path>    - Code review
  /compliance       - Full audit

📚 Workflow Guides:
  .claude/workflows/tdd-workflow.md
  .claude/workflows/visual-iteration.md

💡 Pro Tip:
  Keep CLAUDE.md concise - it's loaded on every session!
```

## Error Handling

**Configuration not installed:**
```
❌ Configuration not found!

Please install first:
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash

Then restart Claude and run /init
```

**jq not installed:**
```
⚠️ jq not installed

Some features require jq. Install:
  Linux: sudo apt install jq
  macOS: brew install jq

Continue anyway? (y/n)
```

## Notes for Implementation

- Keep questions minimal (max 3-4 questions)
- Auto-detect as much as possible
- Make everything optional (user can skip)
- Show clear before/after of what changed
- Always run compliance check at the end
- Provide actionable next steps
