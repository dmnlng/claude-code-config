# Quick Start - 2 Steps Only!

## Step 1: Run /bootstrap

```bash
cd your-project
claude
> /bootstrap
```

Wait for installation to complete (~30 seconds).

## Step 2: Restart Claude

```bash
# Exit (Ctrl+C)
^C

# Restart
claude

# Verify it works
> /doctor
```

**Expected output:**
```
✅ settings.local.json
✅ validate-bash.sh
✅ .claude/ignore
✅ CLAUDE.md
✅ Bash validation hook active
✅ Token optimization working

Status: 🟢 ALL SYSTEMS GO
```

## Done! 🎉

You just saved ~82% tokens per session.

**Try these:**
```bash
> /test              # Run your tests
> /review src/       # Code review
> /compliance        # See your score
```

---

## What Just Happened?

1. `/bootstrap` downloaded the template from GitHub
2. Auto-detected your project type (JS/Python/Rust/etc.)
3. Installed all configuration files
4. Set up token optimization hooks
5. Customized CLAUDE.md for your stack

**Result:** Claude now skips `node_modules/`, `.git/`, `dist/`, etc.

---

## Need Help?

- Run `/doctor` - Quick diagnostic
- Run `/compliance` - Full audit
- Check README.md - Complete guide
- See `.claude/workflows/` - Team workflows

---

## Share With Team

```bash
git add .claude/ CLAUDE.md .gitignore
git commit -m "chore: add Claude Code optimization"
git push
```

Team members just need to run `/bootstrap` in their clones!
