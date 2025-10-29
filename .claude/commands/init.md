# Initialize Claude Code Configuration

**Note:** This command is deprecated in favor of `/bootstrap`.

## Task

### If $ARGUMENTS is empty

Show this message and redirect to `/bootstrap`:

```
╔══════════════════════════════════════════════════╗
║  /init has been replaced by /bootstrap           ║
╚══════════════════════════════════════════════════╝

The /init command has been streamlined and renamed.

Please use: /bootstrap

The new /bootstrap command:
  ✅ Downloads template from GitHub automatically
  ✅ Fewer questions (auto-detects project settings)
  ✅ Self-contained (no local template needed)
  ✅ Faster setup

Would you like me to run /bootstrap now?
```

Then use the SlashCommand tool to run `/bootstrap`.

---

### If $ARGUMENTS contains a template path

**Backwards compatibility mode:** User provided a local template path.

Run the old init flow using the provided template path:

```bash
TEMPLATE_PATH="$ARGUMENTS"
```

Then proceed with the original init logic (see below).

---

## Original Init Logic (for backwards compatibility)

**Only use this if user explicitly provided a template path.**

### Step 1: Check Prerequisites & Existing Configuration

1. **Check if configuration already exists**
   ```bash
   ls -la .claude/ 2>/dev/null
   ```

   **If .claude/ directory exists:**
   - First run `/compliance` to show current configuration status
   - Display compliance report with score
   - Ask user via AskUserQuestion:
     - "Update existing configuration?" (recommended if score < 80)
     - "Full reinstall (backup old config)?"
     - "Cancel and keep current config?"

2. Check if `jq` is installed (required for bash validation)
   ```bash
   which jq
   ```
   If not installed, provide installation instructions

3. Check if this is a git repository
   ```bash
   git rev-parse --git-dir 2>/dev/null
   ```

### Step 2: Ask User Questions

Use the AskUserQuestion tool (maximum 3 questions):

1. **Workflows** (Multi-select)
   - TDD Workflow
   - Visual Iteration (UI)
   - Multi-Claude Setup

2. **MCP Integration**
   - Enable MCP servers
   - Skip for now

3. **Git Commit**
   - Create commit after installation
   - Skip (I'll commit manually)

### Step 3: Install Configuration Files

```bash
# Verify template path exists
if [ ! -d "$TEMPLATE_PATH/.claude" ]; then
    echo "ERROR: Template not found at $TEMPLATE_PATH"
    echo "Use /bootstrap instead (downloads automatically)"
    exit 1
fi

# Run setup script from template
bash "$TEMPLATE_PATH/.claude/scripts/setup.sh" "$TEMPLATE_PATH"
```

### Step 4: Customize Based on Answers

- Update CLAUDE.md based on selections
- Configure MCP if requested
- Create git commit if requested

### Step 5: Show Success Message

Display completion message with restart reminder:

```
╔══════════════════════════════════════════════════╗
║  ✓ Configuration Installed                       ║
╚══════════════════════════════════════════════════╝

⚠️  IMPORTANT: Restart Claude now!

1. Press Ctrl+C
2. Run 'claude' again
3. Try /doctor to verify

💡 Tip: Next time use /bootstrap (no template path needed!)
```

---

## Implementation Notes

- **Default behavior:** Redirect to `/bootstrap`
- **With template path:** Use old init flow for backwards compatibility
- Always remind user to restart Claude
- Suggest `/bootstrap` for future use
