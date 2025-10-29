# Bootstrap Claude Code Configuration

Set up Claude Code best practices configuration in this project with a single command.

## Task

Perform a fully automated, self-contained bootstrap to install Claude Code optimization in this project.

## IMPORTANT: Check for Existing Configuration First

**Before doing anything else, check if configuration already exists:**

```bash
ls -la .claude/settings.local.json 2>/dev/null
```

**If .claude/settings.local.json exists:**
1. Run `/compliance` first to check current status
2. Show user the compliance score
3. Ask user via AskUserQuestion:
   - "Configuration exists (Score: X/100). What do you want to do?"
   - Options:
     - "Update/fix existing config (recommended if score < 90)"
     - "Full reinstall (backup old config)"
     - "Cancel - keep current config"

**If user chooses cancel:** Stop here.

## Step 1: Download Template from GitHub

Use the remote-install.sh script to download the latest template:

```bash
# Script will download to /tmp and return path
TEMPLATE_PATH=$(./.claude/scripts/remote-install.sh 2>/dev/null || bash <(curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/.claude/scripts/remote-install.sh))
```

**If download fails:**
- Try alternative: Check if ~/claude-code-template exists
- If that fails too: Show error and ask user to provide template path

## Step 2: Detect Project Information

Run auto-detection (non-interactive):

```bash
# Detect project type
if [ -f "package.json" ]; then PROJECT_TYPE="JavaScript/TypeScript"
elif [ -f "Cargo.toml" ]; then PROJECT_TYPE="Rust"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then PROJECT_TYPE="Python"
elif [ -f "go.mod" ]; then PROJECT_TYPE="Go"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then PROJECT_TYPE="Java"
else PROJECT_TYPE="Unknown"
fi

# Detect test framework
# ... (similar detection logic)
```

## Step 3: Ask User Questions (Maximum 2-3 questions!)

Use AskUserQuestion tool for ONLY the most important decisions:

**Question 1: Workflows (Multi-Select)**
- Header: "Workflows"
- Question: "Which workflows do you want to enable?"
- Options:
  - TDD Workflow - "Red-Green-Refactor development pattern"
  - Visual Iteration - "UI development with screenshots"
  - Multi-Claude - "Parallel development with git worktrees"
- Multi-select: true

**Question 2: Additional Features (Only if unclear)**
- Header: "Features"
- Question: "Enable MCP server integration?"
- Options:
  - Yes - "Configure MCP servers (Puppeteer, filesystem, etc.)"
  - No - "Skip for now (can add later)"
- Multi-select: false

**DO NOT ask about:**
- Project type (auto-detected)
- Testing framework (auto-detected)
- Git integration (auto-detected)

## Step 4: Install Configuration Files

Run the installation (use remote-install.sh which handles this):

```bash
bash "$TEMPLATE_PATH/.claude/scripts/setup.sh" "$TEMPLATE_PATH"
```

**This will:**
- Create .claude/ directory structure
- Copy all scripts, commands, workflows
- Customize CLAUDE.md based on detected project type
- Set up .gitignore
- Make scripts executable

## Step 5: Customize Based on User Answers

**Based on workflow selections:**
- Update CLAUDE.md to mention enabled workflows
- No changes needed (all workflow docs are copied anyway)

**Based on MCP answer:**
- If yes: Uncomment MCP examples in settings.local.json
- If no: Leave commented (user can enable later)

## Step 6: Run Compliance Check

Verify installation:

```bash
./.claude/scripts/compliance-check.sh
```

Show user the compliance score. Should be 90+/100.

## Step 7: Git Integration (Optional)

**If this is a git repository:**

Ask user via AskUserQuestion:
- Header: "Git"
- Question: "Create a git commit for this configuration?"
- Options:
  - Yes - "Commit .claude/ and CLAUDE.md (recommended for team sharing)"
  - No - "Skip (I'll commit manually)"

**If yes:**
```bash
git add .claude/ CLAUDE.md .gitignore
git commit -m "chore: bootstrap Claude Code configuration

- Token optimization with bash validation hook
- Project-specific CLAUDE.md for $PROJECT_TYPE
- Custom slash commands for workflows
- Estimated token savings: ~82% per session"
```

## Step 8: Show Success Message with RESTART REMINDER

**CRITICAL: User MUST restart Claude for hooks to load!**

Display this message prominently:

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║  🚀 Claude Code Configuration Installed Successfully!    ║
║                                                           ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  ⚠️  IMPORTANT: You MUST restart Claude now!            ║
║                                                           ║
║  Hooks are only loaded at startup. Without restart,      ║
║  token optimization will NOT work!                       ║
║                                                           ║
║  Steps to restart:                                        ║
║  1. Press Ctrl+C (or Cmd+C on Mac)                       ║
║  2. Run 'claude' again                                    ║
║  3. Try: /doctor to verify everything works              ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

📊 What was installed:

✅ .claude/scripts/validate-bash.sh - Token optimization hook
✅ .claude/ignore - Blocklist with {X} patterns
✅ .claude/settings.local.json - Hooks + permissions
✅ CLAUDE.md - Project context for {PROJECT_TYPE}
✅ {N} slash commands: /test, /review, /explore, /doctor, etc.
✅ {N} workflow guides in .claude/workflows/

⚡ Estimated Token Savings: ~82% per session

🎯 After Restart:
- Run /doctor to verify setup
- Run /compliance to see your score (should be 90+)
- Run /optimize-tokens for detailed analysis
- Try /test, /review, /explore commands

📚 Learn More:
- Workflow guides: .claude/workflows/
- Token analyzer: .claude/scripts/check-token-usage.sh
- Full docs: README.md
```

## Error Handling

**Template download fails:**
- Check if ~/claude-code-template exists as fallback
- If that fails: Provide manual git clone instructions
- Offer to continue with partial setup

**jq not installed:**
- Warn that bash validation won't work
- Provide installation instructions (sudo apt install jq / brew install jq)
- Offer to continue anyway

**Permission errors:**
- Show chmod commands to fix
- Offer to apply automatically

**Files already exist:**
- Already handled in Step 1 via compliance check
- If user chose "Full reinstall": Backup to .claude.backup.{timestamp}/

## Validation Before Success

Verify all critical files exist:
- [ ] .claude/settings.local.json
- [ ] .claude/scripts/validate-bash.sh (executable)
- [ ] .claude/ignore
- [ ] CLAUDE.md
- [ ] .claude/commands/ has at least 5 .md files
- [ ] .claude/workflows/ has at least 2 .md files

If any missing: Show error, don't claim success.

## Notes for Implementation

- Keep user interaction minimal (max 2-3 questions)
- Auto-detect everything possible
- Show progress clearly (use step numbers)
- Make restart reminder VERY PROMINENT
- Test validation should be comprehensive
- Provide fallback for every potential failure point
