# Claude Code Template - Token Optimized

**Save ~82% tokens per session** with this production-ready Claude Code configuration.

Prevents Claude from wasting tokens on `node_modules`, build artifacts, and git internals through intelligent bash validation and read permissions.

Based on [Anthropic's Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices) + community optimizations.

---

## 🚀 Quick Start (2 Steps)

### 1. Install Configuration

In your project directory:

```bash
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash
```

This will:
- Download template from GitHub
- Auto-detect your project (JS/Python/Rust/Go/etc.)
- Install all configuration files
- Customize CLAUDE.md for your stack
- Set up token optimization

### 2. Restart Claude

**IMPORTANT:** Hooks only load at startup!

```bash
# Exit (Ctrl+C or Cmd+C)
^C

# Restart
claude

# Verify
> /doctor
```

**That's it!** ✅

### Optional: Customize Further

```bash
> /init
```

Interactively customize:
- Workflow guides (TDD, Visual, Multi-Claude)
- MCP server integrations
- CLAUDE.md for your team
- Create git commit

---

## What Gets Installed

```
your-project/
├── .claude/
│   ├── settings.local.json      # Hooks + Permissions
│   ├── ignore                    # Token blocklist (node_modules, .git, etc.)
│   ├── scripts/
│   │   ├── validate-bash.sh     # 🔑 Token optimization hook
│   │   ├── check-token-usage.sh # Token analyzer
│   │   ├── compliance-check.sh  # Config validator
│   │   └── remote-install.sh    # GitHub downloader
│   ├── commands/                 # Slash commands
│   │   ├── init.md              # /init - Customize config
│   │   ├── doctor.md            # /doctor - Quick check
│   │   ├── test.md              # /test - Run tests
│   │   ├── review.md            # /review - Code review
│   │   ├── explore.md           # /explore - Codebase exploration
│   │   ├── compliance.md        # /compliance - Config audit
│   │   └── optimize-tokens.md   # /optimize-tokens - Token analysis
│   └── workflows/                # Team guides
│       ├── tdd-workflow.md      # Test-Driven Development
│       ├── visual-iteration.md  # UI dev with screenshots
│       └── multi-claude.md      # Parallel development
├── CLAUDE.md                     # Project context (auto-loaded)
└── .gitignore                    # (updated with .claude/logs/)
```

---

## How It Works

### Problem: Token Waste

Claude Code has two permission systems:
- **Read() Permissions** - Block direct file access
- **Bash Commands** - Can bypass Read() completely

Commands like `grep -r`, `find .` scan your entire project tree including:
- `node_modules/` → 15M tokens
- `.git/objects/` → 3M tokens
- `dist/`, `build/` → 2M tokens

**Result:** 85% of your tokens wasted on dependencies.

### Solution: Two-Layer Protection

**Layer 1: Read() Deny Patterns**
```json
{
  "permissions": {
    "deny": [
      "Read(**/node_modules/**)",
      "Read(**/.git/objects/**)",
      // ... 50+ patterns
    ]
  }
}
```

**Layer 2: Bash Validation Hook** (the magic!)
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "command": "bash .claude/scripts/validate-bash.sh"
      }]
    }]
  }
}
```

**Before every bash command:**
1. ✅ Whitelist check (git, npm, etc. → instant pass)
2. ✅ Scope check (`grep pattern src/` → allowed)
3. ✅ Pattern check (blocks `.git/objects/`, `node_modules/`)
4. ❌ Block unsafe commands (`grep -r pattern .`)

**Examples:**
```bash
# ✅ Allowed
git status
grep "error" src/ lib/
find src/ -name "*.ts"

# ❌ Blocked
grep -r "error" .        # Unscoped search
find . -name "*.ts"      # Scans everything
cat node_modules/foo.js  # Blocked path
```

---

## Token Savings

### Before (Default Claude Code)
```
Session: 18,000,000 tokens
├─ node_modules/:  15,000,000 tokens (83%)
├─ .git/objects/:   2,000,000 tokens (11%)
├─ dist/:           1,000,000 tokens (6%)
└─ Actual code:        50,000 tokens (0.3%)

Result: Hit usage limit after 1-2 sessions
```

### After (With Template)
```
Session: 50,000 tokens
└─ Actual code: 50,000 tokens (100%)

Result: 40+ sessions before limit
```

**~99.7% token savings!**

---

## Custom Commands

After installation, try:

```bash
/doctor              # Quick health check
/compliance          # Full config audit (score 0-100)
/optimize-tokens     # See what's consuming tokens
/test                # Run your test suite
/review src/auth/    # Code review for directory
/explore "database"  # Explore codebase by topic
```

---

## Workflow Guides

Team-tested patterns in `.claude/workflows/`:

**🔴 TDD Workflow** - Red-Green-Refactor with Claude
- Write tests first
- Verify they fail
- Implement minimal code
- Refactor while green

**🎨 Visual Iteration** - UI development with screenshots
- Screenshot current state
- Describe desired changes
- Claude implements
- Repeat

**⚡ Multi-Claude** - Parallel development with git worktrees
- Work on multiple features simultaneously
- Separate Claude sessions per worktree
- Independent context per feature

Read: `.claude/workflows/*.md`

---

## SpecFlow: Spec-Driven Development

**NEW:** Streamlined feature development from idea to verified implementation.

SpecFlow adds a complete spec-driven workflow to this template, guiding you through:
- Requirements gathering and specification
- Automated gap analysis
- Technical planning with TDD focus
- Task breakdown (RED → GREEN → REFACTOR)
- Comprehensive verification

### Quick Start

**1. Create Project Manifest (once per project):**
```bash
> /manifest init
```

Interactively creates `manifest.md` - your project's constitution:
- Vision and business goals
- Tech stack and constraints
- Mandatory features
- Performance budgets
- Security requirements

**2. Create a New Feature:**
```bash
> /feature "Add user authentication with email/password"
```

SpecFlow guides you through 5 phases:

**Phase 1: Ideation & Specification**
- Asks clarifying questions (users, priority, scope)
- Creates `.claude/features/001-user-auth/spec.md`
- Defines user stories, requirements, success criteria

**Phase 2: Gap Analysis** (unique to SpecFlow)
- Analyzes spec against manifest.md
- Identifies missing NFRs, conflicts, ambiguities
- Creates `gaps.md` with critical/medium/low priorities

**Phase 3: Technical Planning**
- Reads manifest.md for tech stack and constraints
- Creates `plan.md` with architecture, test strategy, data models
- Aligns with performance budgets and security requirements

**Phase 4: Task Breakdown**
- Generates TDD-focused task list in `tasks.md`
- 9 phases: Setup → RED (tests) → GREEN (implement) → REFACTOR → Integration → Docs → QA → Deployment → Verification
- ~50 tasks across complete development lifecycle

**Phase 5: Summary**
- Shows what was created
- Provides next steps

**3. Implement the Feature:**

Follow the task list in `.claude/features/001-user-auth/tasks.md`:
- Mark tasks as `[X]` when complete
- Follow TDD discipline: RED → GREEN → REFACTOR
- Run `/test` frequently

**4. Verify Implementation:**
```bash
> /feature verify 001-user-auth
```

Runs comprehensive checks:
- Task completion (100%)
- Test coverage (≥80%)
- All functional requirements met
- Non-functional requirements (performance, security)
- Success criteria achieved
- Manifest alignment

**Outputs verification score (0-100) and status:**
- ✅ APPROVED FOR MERGE (≥80, all critical met)
- ⚠️ APPROVED WITH WARNINGS (minor issues)
- ❌ REJECTED (critical issues)

**5. Update Manifest:**
```bash
> /manifest update
```

Mark feature as complete in manifest.md.

### SpecFlow Commands

```bash
/manifest init                    # Create project manifest
/manifest update                  # Update manifest (mark features complete)
/manifest show                    # View manifest summary

/feature "description"            # Create new feature (guided workflow)
/feature verify 001-feature-id    # Verify implementation
/feature list                     # List all features
```

### Feature Artifacts

Each feature creates 5 documents in `.claude/features/NNN-feature-name/`:

1. **spec.md** - Feature specification
   - User stories with priorities
   - Functional/non-functional requirements
   - Success criteria (measurable)
   - Assumptions and dependencies

2. **gaps.md** - Gap analysis (unique to SpecFlow)
   - Critical gaps that block planning
   - Medium issues to address
   - Low priority improvements
   - Manifest conflicts

3. **plan.md** - Technical implementation plan
   - Architecture and data flow
   - Test strategy (TDD-focused)
   - Data models and API contracts
   - Security and performance considerations

4. **tasks.md** - Executable task breakdown
   - 9-phase TDD workflow
   - RED → GREEN → REFACTOR cycles
   - Checkboxes to track progress
   - Phase completion percentages

5. **verification.md** - Post-implementation report
   - Test results and coverage
   - Requirements verification (FR/NFR)
   - Success criteria measurements
   - Overall score and recommendation

### Why SpecFlow?

**Prevents common issues:**
- ❌ Vague requirements → ✅ Clear spec with measurable criteria
- ❌ Scope creep → ✅ Gap analysis catches missing requirements early
- ❌ Architecture misalignment → ✅ Validated against manifest.md
- ❌ Untested code → ✅ TDD-enforced (write tests first)
- ❌ "Done but broken" → ✅ Comprehensive verification before merge

**Integrates with token optimization:**
- All artifacts in `.claude/features/` (not bloating main context)
- Manifest read once per feature (efficient)
- Clear phase boundaries (use `/clear` between phases)

**Example Project Structure:**
```
your-project/
├── manifest.md                           # Project constitution
├── .claude/
│   ├── features/
│   │   ├── 001-user-auth/
│   │   │   ├── spec.md
│   │   │   ├── gaps.md
│   │   │   ├── plan.md
│   │   │   ├── tasks.md
│   │   │   └── verification.md
│   │   └── 002-payment/
│   │       └── ...
│   └── templates/                        # Templates for artifacts
│       ├── manifest.md
│       ├── spec.md
│       ├── gaps.md
│       ├── plan.md
│       ├── tasks.md
│       └── verification.md
└── ...
```

### TDD Discipline

SpecFlow enforces Test-Driven Development:

**RED Phase** - Write failing tests first:
```bash
- [ ] T006: [RED] Write test: authenticateUser() should return JWT
- [ ] T007: [RED] Write test: authenticateUser() should reject invalid password
```
Checkpoint: All tests FAIL (verify with `npm test`)

**GREEN Phase** - Make tests pass:
```bash
- [ ] T012: [GREEN] Implement authenticateUser() function
- [ ] T013: [GREEN] Add password validation
```
Checkpoint: All tests PASS

**REFACTOR Phase** - Improve code quality:
```bash
- [ ] T017: [REFACTOR] Extract password hashing to utility
- [ ] T018: [REFACTOR] Remove duplication in error handling
```
Checkpoint: Tests still PASS, code cleaner

### SpecFlow vs Traditional

**Traditional Approach:**
```
Idea → Start coding → Realize spec unclear → Back to requirements
→ Missing tests → Broken in production → Hotfix → Technical debt
```

**SpecFlow Approach:**
```
Idea → Spec with criteria → Gap analysis → Plan with TDD
→ Tasks (RED-GREEN-REFACTOR) → Implement → Verify → Merge
→ Update manifest → Next feature
```

**Result:** Higher quality, fewer bugs, less rework.

---

## Supported Frameworks

Auto-detected and pre-configured:

- **JavaScript/TypeScript:** Node.js, Deno, Bun
- **Python:** pip, poetry, virtualenv
- **Rust:** Cargo
- **Go:** Go modules
- **Java:** Maven, Gradle
- **.NET:** NuGet
- **Ruby:** Bundler

Missing your stack? `.claude/ignore` and `CLAUDE.md` are easy to customize.

---

## Troubleshooting

### Command Blocked Unexpectedly

```bash
ERROR: Command contains blocked pattern from .claude/ignore
Blocked command: grep -r "search" .

Tip: Use scoped searches instead:
  grep 'search' src/ lib/
```

**Solution:** Scope your command to specific directories.

### Hooks Not Working

**Check if Claude was restarted:**
```bash
# Exit and restart Claude
^C
claude
```

Hooks only load at startup!

**Verify hook is configured:**
```bash
> /doctor
```

Should show: `✅ Bash validation hook active`

### jq Not Installed

Bash validation requires `jq`:

```bash
# Linux
sudo apt install jq

# macOS
brew install jq

# Windows
choco install jq
```

### Want to Disable Temporarily

```bash
# Rename settings to disable
mv .claude/settings.local.json .claude/settings.local.json.backup

# Re-enable
mv .claude/settings.local.json.backup .claude/settings.local.json
# Then restart Claude!
```

---

## Customization

### Add Project-Specific Patterns

Edit `.claude/ignore`:

```bash
# Your custom patterns
my-large-dataset/
*.sqlite
experimental/
```

### Add Safe Commands

Edit `.claude/scripts/validate-bash.sh`:

```bash
# Line 21: Add to SAFE_COMMANDS
SAFE_COMMANDS="^(git|npm|yarn|pnpm|YOUR_TOOL)$"
```

### Customize CLAUDE.md

`CLAUDE.md` is loaded on every Claude session. Keep it concise!

**Good:**
- Code style rules
- Test commands
- Common workflows
- Project-specific conventions

**Bad:**
- Entire architecture docs (link instead)
- Redundant info (Claude knows general practices)
- Over 300 lines (use `/clear` instead)

---

## Team Sharing

Configuration is git-ready. Share with your team:

```bash
git add .claude/ CLAUDE.md .gitignore
git commit -m "chore: add Claude Code optimization

- Token savings: ~82% per session
- Custom workflows for team
- Auto-configured for our stack"

git push
```

Team members just run the install command in their clones:
```bash
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash
```

---

## Advanced

### Manual Installation

If you prefer not using the one-liner:

```bash
# Clone template
git clone https://github.com/dmnlng/claude-code-config.git ~/claude-template

# Run setup script
cd your-project
bash ~/claude-template/.claude/scripts/setup.sh
```

### Custom Template Source

Use a forked or modified template:

```bash
# From your fork
curl -sSL https://raw.githubusercontent.com/yourname/your-fork/main/install.sh | bash

# Or clone and run locally
git clone https://github.com/yourname/your-fork.git ~/my-template
cd your-project
bash ~/my-template/.claude/scripts/setup.sh
```

### CI/CD Integration

Use headless mode:

```bash
claude --dangerously-skip-permissions \
  -p "run tests and fix failures" \
  --output-format stream-json
```

See `.claude/settings.local.json` for MCP server configuration examples.

---

## Resources

**Documentation:**
- [Claude Code Docs](https://docs.claude.com/claude-code)
- [Anthropic Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)

**Workflow Guides (in this template):**
- `.claude/workflows/tdd-workflow.md`
- `.claude/workflows/visual-iteration.md`
- `.claude/workflows/multi-claude.md`

**Scripts:**
- `.claude/scripts/check-token-usage.sh` - Analyze what consumes tokens
- `.claude/scripts/compliance-check.sh` - Audit configuration (0-100 score)
- `.claude/scripts/validate-bash.sh` - Token optimization logic

---

## Credits

Based on:
- [Reddit: Claude Code Usage Limit Hack](https://www.reddit.com/r/ClaudeAI/comments/1oh95lh/claude_code_usage_limit_hack/)
- [Anthropic: Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)

Extended with workflows, automation, and team collaboration features.

---

## License

MIT License - See [LICENSE](LICENSE) file for details.

---

## Quick Reference

```bash
# Setup
/init                         # Customize configuration
/doctor                       # Verify setup
/compliance                   # Audit config (score)

# Daily use
/test                         # Run tests
/review <path>                # Code review
/explore "<topic>"            # Explore codebase
/optimize-tokens              # Token analysis

# Maintenance
.claude/scripts/check-token-usage.sh     # Analyze tokens
.claude/scripts/compliance-check.sh      # Check config
```

**Remember:** Restart Claude after any configuration changes!

---

**Questions?** Check `.claude/workflows/` for guides or run `/doctor` for diagnostics.
