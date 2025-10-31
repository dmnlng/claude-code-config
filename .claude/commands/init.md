# Comprehensive Project Initialization

Complete setup for your project including Claude Code configuration, project manifest, and development readiness validation.

**Note:** This command is for comprehensive project setup. If you haven't installed yet, run:
```bash
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash
```

---

## Task

Perform fully automated project bootstrap covering:
1. Automatic Claude Code configuration (based on project detection)
2. Automatic Git repository setup
3. Interactive project manifest creation (vision, goals, tech stack)
4. Open questions tracking
5. Development readiness validation
6. Automatic git commit

This is typically run **once** after installation. The process is streamlined - Claude will auto-configure settings and only ask questions about **your project** (not about config options).

---

## Step 1: Welcome & Prerequisites Check

### Show Welcome Message

```
╔══════════════════════════════════════════════════╗
║  Comprehensive Project Initialization           ║
╚══════════════════════════════════════════════════╝

This will guide you through:
  1. Claude Code configuration
  2. Git repository setup
  3. Project manifest creation
  4. Readiness validation

Estimated time: 5-10 minutes

Let's get started!
```

### Verify Installation

```bash
if [ ! -f ".claude/settings.local.json" ]; then
    echo "ERROR: Claude Code configuration not installed yet!"
    echo ""
    echo "Please install first:"
    echo "curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash"
    echo ""
    echo "Then restart Claude and run /init"
    exit 1
fi
```

If not installed, show error and exit.

---

## Step 2: Detect Current Setup

Auto-detect existing configuration:

```bash
# Detect project type
if [ -f "package.json" ]; then PROJECT_TYPE="JavaScript/TypeScript"
elif [ -f "Cargo.toml" ]; then PROJECT_TYPE="Rust"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then PROJECT_TYPE="Python"
elif [ -f "go.mod" ]; then PROJECT_TYPE="Go"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then PROJECT_TYPE="Java"
elif [ -f "Gemfile" ]; then PROJECT_TYPE="Ruby"
elif [ -f "composer.json" ]; then PROJECT_TYPE="PHP"
else PROJECT_TYPE="Unknown"
fi

# Check git
IS_GIT_REPO=$(git rev-parse --git-dir 2>/dev/null && echo "Yes" || echo "No")

# Check manifest
HAS_MANIFEST=$([ -f "manifest.md" ] && echo "Yes" || echo "No")

# Check CLAUDE.md customization
if grep -q "\[.*\]" CLAUDE.md 2>/dev/null; then
    CLAUDE_MD_STATUS="Contains placeholders"
else
    CLAUDE_MD_STATUS="Customized"
fi
```

### Display Current Status

```
╔══════════════════════════════════════════════════╗
║  Current Project Status                          ║
╚══════════════════════════════════════════════════╝

  Project Type: {PROJECT_TYPE}
  Git Repository: {IS_GIT_REPO}
  Manifest: {HAS_MANIFEST}
  CLAUDE.md: {CLAUDE_MD_STATUS}

We'll help you complete the missing pieces.
```

---

## Step 3: Automatic Configuration Setup

**Purpose:** Automatically configure CLAUDE.md based on detected project type and sensible defaults.

### Auto-Detect and Apply Configuration

No questions needed - automatically configure based on best practices:

**Actions:**
1. **Detect Project Type** (from Step 2)
2. **Update CLAUDE.md automatically:**
   - Replace `[web application / library / CLI tool / etc.]` with detected type
   - Set workflow to "Test-Driven Development (TDD)" (default best practice)
   - Set team size to "Solo developer" (can be changed later)
   - Fill in test commands based on detected stack
   - Update tech stack placeholders with detected values

**Example Auto-Configuration:**
```bash
# For JavaScript/TypeScript project:
- Project type: JavaScript/TypeScript project
- Test command: npm test
- Build command: npm run build
- Linter: npm run lint

# For Python project:
- Project type: Python project
- Test command: pytest
- Linter: ruff check .
- Formatter: black .
```

**Show what was configured:**
```
✅ Configuration Applied:
  • Project Type: {PROJECT_TYPE}
  • Workflow: Test-Driven Development (TDD)
  • Team Size: Solo developer
  • Test Framework: {DETECTED_TEST_FRAMEWORK}
  • CLAUDE.md updated with project-specific settings

You can manually edit CLAUDE.md later to adjust these settings.
```

**Note:** No workflows or MCP server configuration needed upfront - users can add these later if needed.

---

## Step 4: Git Repository Setup

**IMPORTANT:** Always set up Git unless it already exists.

### Check Git Status

```bash
if git rev-parse --git-dir >/dev/null 2>&1; then
    echo "✅ Git repository already initialized"
    git status --short
else
    echo "📦 Git repository not found"
fi
```

### If Git Not Initialized:

```bash
git init
echo "✅ Git repository initialized"
```

### Create Initial Commit (if needed)

```bash
# Check if there are uncommitted changes
if git status --porcelain | grep -q .; then
    # Add Claude Code configuration files
    git add .claude/ CLAUDE.md .gitignore

    # Create initial commit
    git commit -m "chore: initialize Claude Code configuration

Configuration includes:
- Token optimization with .claude/ignore (91 patterns)
- Bash validation hook for security
- 9 slash commands for development workflow
- 3 workflow guides (TDD, Visual, Multi-Claude)
- CLAUDE.md with project context

Estimated token savings: ~82% per session

🤖 Generated with Claude Code
https://claude.com/claude-code"

    echo "✅ Initial commit created"
else
    echo "ℹ️  No changes to commit"
fi
```

**Show Git Status:**

```bash
git log -1 --oneline
echo ""
echo "Git repository is ready for feature development."
```

---

## Step 5: Comprehensive Manifest Creation

**Purpose:** Create the project manifest - the source of truth for requirements, tech stack, and constraints.

### Check if Manifest Exists

```bash
if [ -f "manifest.md" ]; then
    echo "⚠️  manifest.md already exists"
    # Ask if user wants to overwrite or skip
fi
```

### Manifest Creation Flow

Show explanation:

```
╔══════════════════════════════════════════════════╗
║  Project Manifest Creation                       ║
╚══════════════════════════════════════════════════╝

The manifest is your project's "constitution" - a single source
of truth for:
  • Project vision and business goals
  • Tech stack and architecture decisions
  • Mandatory features for v1.0
  • Performance budgets and security requirements
  • Constraints and trade-offs

All features created with /feature will reference this manifest
to ensure alignment with project goals.

This will take 5-7 minutes. Let's begin!
```

### Ask Comprehensive Questions

#### Question 1: Project Vision & Type

**Question: "What type of project are you building?"**
- Header: "Project Type"
- Options:
  - "Web Application" - "Full-stack web app with frontend and backend"
  - "API Service" - "Backend API or microservice"
  - "CLI Tool" - "Command-line interface application"
  - "Library/Package" - "Reusable library or framework"
  - "Mobile App" - "iOS/Android application"
  - "Desktop App" - "Desktop application (Electron, etc.)"

Follow up with:

**"What problem does this project solve? (2-3 sentences)"**
- Free text input
- This becomes the Vision section
- Prompt with example: "Build a secure, high-performance task management platform..."

#### Question 2: Primary Users

**"Who are the primary users of this system?"**
- Free text input (can be multiple)
- Examples: "Project Managers, Developers, Executives"

#### Question 3: Core Features

**"List 3-5 must-have features for v1.0 (comma-separated):"**
- Free text input
- Example: "User authentication, Task creation, Dashboard view"
- These become the Core Features checklist

#### Question 4: Tech Stack Details

Based on detected PROJECT_TYPE, ask specific questions:

**Frontend Framework (if applicable):**
- Options: "React", "Vue", "Angular", "Svelte", "Next.js", "None/Other"

**Backend Framework:**
- Options based on language:
  - JS/TS: "Express", "Fastify", "NestJS", "Next.js API", "Other"
  - Python: "FastAPI", "Django", "Flask", "Other"
  - Go: "Gin", "Echo", "Chi", "Standard lib", "Other"
  - Rust: "Axum", "Actix-web", "Rocket", "Other"

**Database:**
- Options: "PostgreSQL", "MySQL", "MongoDB", "SQLite", "Redis", "None", "Other"

**Testing Framework:**
- Auto-detect or ask based on language
- Examples: "Jest", "pytest", "go test", "cargo test"

#### Question 5: Deployment Target

**"Where will this be deployed?"**
- Options:
  - "Cloud (AWS/GCP/Azure)"
  - "Vercel/Netlify"
  - "Docker/Kubernetes"
  - "Serverless"
  - "On-premise"
  - "Not decided yet"

#### Question 6: Performance Priority

**"What is your performance priority level?"**
- Header: "Performance"
- Options:
  - "High" - "Critical (fintech, gaming, high-traffic). LCP ≤1.5s, API ≤200ms"
  - "Medium" - "Important (most web apps). LCP ≤2.5s, API ≤500ms"
  - "Low" - "Acceptable (internal tools, MVPs). LCP ≤4.0s, API ≤1000ms"

#### Question 7: Security & Compliance

**"What are your security/compliance requirements?"**
- Header: "Security"
- Options (multi-select):
  - "User Authentication (JWT/OAuth)"
  - "Role-Based Access Control"
  - "Data Encryption (at rest and in transit)"
  - "GDPR/CCPA Compliance"
  - "PCI-DSS (payments)"
  - "HIPAA (healthcare)"
  - "SOC 2"
  - "Basic security only"

#### Question 8: Team & Timeline

**"What is your target timeline for v1.0?"**
- Free text: "3 months", "Q4 2024", etc.

**"Team size?"** (already asked in Step 3, reuse if answered)

#### Question 9: Known Constraints

**"Are there any technical constraints or limitations?"**
- Free text (optional)
- Examples: "Must use PostgreSQL (company standard)", "No external APIs allowed"

#### Question 10: Business Goals

**"What are 2-3 measurable business goals?"**
- Free text input
- Examples: "Onboard 1,000 users in 6 months", "Achieve 95% uptime SLA"

### Generate manifest.md

Read template from `.claude/templates/manifest.md` and populate:

```bash
cp .claude/templates/manifest.md manifest.md
```

Replace all placeholders with gathered information:
- `{PROJECT_NAME}` - Extract from directory name or ask
- `{PROJECT_TYPE}` - From Question 1
- `{DATE}` - Current date
- `{VISION_PLACEHOLDER}` - From Question 1 vision
- `{GOAL_PLACEHOLDER}` - From Question 10
- `{USER_TYPE}` - From Question 2
- `{FEATURE_PLACEHOLDER}` - From Question 3 (create checklist)
- `{DETECTED_STACK_PLACEHOLDER}` - Auto-detected info
- All tech stack fields from Question 4
- `{DEPLOYMENT_PLATFORM}` - From Question 5
- `{PERFORMANCE_PRIORITY}` - From Question 6
- Performance budget values based on priority
- Security requirements from Question 7
- `{CONSTRAINT}` - From Question 9
- `{TIMELINE}` - From Question 8
- `{TARGET_DATE}` - From Question 8

**Show Success:**

```
✅ manifest.md created successfully!

📊 Your Project Manifest:
  • Vision: [first 60 chars of vision]...
  • Core Features: {N} features identified
  • Tech Stack: {Frontend} + {Backend} + {Database}
  • Performance: {PRIORITY} priority
  • Timeline: {TIMELINE}

This manifest is now the source of truth for your project.
Use /feature to start building features aligned with this vision.
```

---

## Step 6: Open Questions Tracking

After manifest creation, identify any unresolved questions.

### Ask About Open Questions

```
╔══════════════════════════════════════════════════╗
║  Open Questions & Clarifications                 ║
╚══════════════════════════════════════════════════╝

Let's document any unresolved questions or areas that need
clarification before development starts.

Examples of common questions:
  • Which third-party services to integrate?
  • Specific authentication provider (Auth0, Firebase, custom)?
  • Exact database schema design?
  • Which cloud region for deployment?
  • Rate limiting strategy?
```

**Ask: "Do you have any unresolved questions or areas needing clarification?"**
- Options:
  - "Yes, let me list them"
  - "No, everything is clear"

### If Yes, Collect Questions

For each question, ask:

**"Describe the question:"**
- Free text input

**"What category is this?"**
- Options: "Technical", "Business", "Deployment", "Third-Party", "Performance", "Security"

**"How critical is this?"**
- Options:
  - "Critical (blocks development)"
  - "High (should resolve soon)"
  - "Medium (has workaround)"
  - "Low (can defer)"

### Create .claude/questions.md

Copy template and populate with questions:

```bash
cp .claude/templates/questions.md .claude/questions.md
```

Populate the appropriate sections based on priority:
- Critical → "Critical Questions (Blocking Development)"
- High → "High Priority Questions"
- Medium → "Medium Priority Questions"
- Low → "Low Priority Questions"

**Update manifest.md** Open Questions section:

List critical questions in the manifest so they're visible:

```markdown
### Critical Questions (Blocking Development)
- 🔴 Q1: [Question title] (See .claude/questions.md for details)
```

**Show Summary:**

```
✅ Open questions documented

📋 Questions Summary:
  🔴 Critical: {N} questions
  🟡 High: {N} questions
  🟢 Medium/Low: {N} questions

All questions tracked in .claude/questions.md

IMPORTANT: Resolve critical questions before starting /feature development.
```

---

## Step 7: Development Readiness Validation

Perform comprehensive readiness check against the manifest checklist.

### Calculate Readiness Score

Based on manifest "Readiness Checklist" (10 items):

```bash
SCORE=0

# Check each item
[ "$VISION" != "" ] && ((SCORE++)) # Vision defined
[ ${#BUSINESS_GOALS[@]} -ge 3 ] && ((SCORE++)) # ≥3 goals
[ "$USERS" != "" ] && ((SCORE++)) # Users identified
[ ${#CORE_FEATURES[@]} -ge 3 ] && ((SCORE++)) # ≥3 features
[ "$FRONTEND" != "" ] || [ "$BACKEND" != "" ] && ((SCORE++)) # Stack chosen
[ "$DEPLOYMENT" != "Not decided yet" ] && ((SCORE++)) # Deployment known
[ "$PERFORMANCE_PRIORITY" != "" ] && ((SCORE++)) # Performance set
[ ${#SECURITY_REQS[@]} -gt 0 ] && ((SCORE++)) # Security documented
[ $CRITICAL_QUESTIONS_COUNT -eq 0 ] && ((SCORE++)) # No critical questions
[ ${#CORE_FEATURES[@]} -ge 1 ] && ((SCORE++)) # First feature idea ready

READINESS_PERCENT=$((SCORE * 10))
```

### Run Compliance Check

```bash
if [ -x ".claude/scripts/compliance-check.sh" ]; then
    ./.claude/scripts/compliance-check.sh
fi
```

### Run Token Optimization Validation

```bash
# Check if token optimization hook is working
if [ -x ".claude/scripts/validate-token-optimization.sh" ]; then
    echo "Validating token optimization..."
    ./.claude/scripts/validate-token-optimization.sh
fi
```

### Display Readiness Report

```
╔══════════════════════════════════════════════════╗
║  Development Readiness Report                    ║
╚══════════════════════════════════════════════════╝

📊 Readiness Score: {SCORE}/10 ({READINESS_PERCENT}%)

Checklist Status:
  ✅ Vision Clarity: {STATUS}
  ✅ Business Goals Defined: {STATUS}
  ✅ Users Identified: {STATUS}
  ✅ Core Features Listed: {STATUS}
  ✅ Tech Stack Decided: {STATUS}
  ✅ Deployment Target Known: {STATUS}
  ✅ Performance Priorities Set: {STATUS}
  ✅ Security Requirements Clear: {STATUS}
  {STATUS_ICON} Critical Questions Resolved: {STATUS}
  ✅ First Feature Ready: {STATUS}

Claude Code Configuration:
  ✅ Compliance Score: {COMPLIANCE_SCORE}/100
  ✅ Token Optimization: Active
  ✅ Bash Validation: Active
  ✅ Git Repository: Initialized

Overall Status:
```

**If Score = 10/10:**
```
  ✅ READY FOR DEVELOPMENT

  Your project is fully configured and ready for feature development!
  Start building with: /feature "your first feature"
```

**If Score = 7-9/10:**
```
  ⚠️  MOSTLY READY

  You can start development, but review incomplete items:
  {LIST_INCOMPLETE_ITEMS}

  Decide if these are blockers or can be resolved during development.
  When ready: /feature "your first feature"
```

**If Score < 7/10:**
```
  🚫 NOT READY

  Complete these critical items before starting development:
  {LIST_INCOMPLETE_ITEMS}

  Run /manifest update to fill in missing information.
  Run /init again when ready.
```

---

## Step 8: Automatic Git Commit

**Purpose:** Automatically commit all initialization artifacts to git.

### Create Comprehensive Commit

No questions - automatically commit everything:

```bash
# Stage all initialization files
git add .claude/ CLAUDE.md manifest.md .gitignore

# Add questions.md if it was created
if [ -f ".claude/questions.md" ]; then
    git add .claude/questions.md
fi

# Create comprehensive commit
git commit -m "chore: complete project initialization

Project Setup:
- Project Type: {PROJECT_TYPE}
- Tech Stack: {FRONTEND} + {BACKEND} + {DATABASE}
- Deployment: {DEPLOYMENT}
- Timeline: {TIMELINE}

Artifacts Created:
- manifest.md: Project vision, goals, tech stack, constraints
- .claude/questions.md: Open questions tracking ({N} questions)
- CLAUDE.md: Auto-configured for TDD workflow
- .claude/: Token optimization (91 patterns), hooks, commands

Configuration:
- Bash validation hook: Active
- Token optimization: ~82% savings per session
- Development workflow: Test-Driven Development

Readiness Score: {SCORE}/10 ({STATUS})

🤖 Generated with Claude Code
https://claude.com/claude-code"

echo "✅ Initialization committed to git"
```

**Show Commit:**
```bash
git log -1 --stat
```

---

## Step 9: Final Summary & Next Steps

Display comprehensive summary:

```
╔══════════════════════════════════════════════════╗
║  ✅ Project Initialization Complete!            ║
╚══════════════════════════════════════════════════╝

📦 Your Project:
  • Name: {PROJECT_NAME}
  • Type: {PROJECT_TYPE}
  • Tech: {TECH_SUMMARY}
  • Timeline: {TIMELINE}

📝 Files Created:
  • manifest.md - Project source of truth
  • .claude/questions.md - Open questions ({N} total)
  • CLAUDE.md - Customized project context
  • .gitignore - Updated for Claude Code
  • Git: {N} commits created

📊 Status:
  • Readiness: {SCORE}/10 ({STATUS})
  • Compliance: {COMPLIANCE_SCORE}/100
  • Token Optimization: ✅ Active (~82% savings)
  • Git Repository: ✅ Initialized

🎯 Next Steps:

1. Review Your Manifest:
   Open manifest.md and verify all information is correct.
   Update with: /manifest update

2. Resolve Critical Questions (if any):
   See .claude/questions.md for {N} open questions.
   Update status as you clarify them.

3. Start Building Features:
   Run: /feature "your first feature"

   This will guide you through:
   • Spec creation
   • Gap analysis
   • Technical planning
   • TDD task breakdown

4. Verify Completed Features:
   Run: /feature verify {feature-id}
   Then: /manifest update to mark complete

📚 Available Commands:
  /doctor          - Quick health check
  /compliance      - Full configuration audit
  /test            - Run your test suite
  /review <path>   - Code review
  /feature "..."   - Create new feature
  /manifest        - Manage project manifest

📖 Workflow Guides:
  .claude/workflows/tdd-workflow.md
  .claude/workflows/visual-iteration.md
  .claude/workflows/multi-claude.md

💡 Pro Tips:
  • Keep CLAUDE.md concise (it's loaded every session)
  • Update manifest.md as project evolves
  • Mark questions as resolved in questions.md
  • Run /compliance monthly to check configuration health
  • Use /feature verify before merging features

🎉 Happy Building!

Your project is now ready for structured, spec-driven development
with Claude Code. Start with your first feature and follow the
TDD workflow for best results.
```

---

## Error Handling

### Configuration Not Installed
```
❌ Claude Code configuration not found!

Please install first:
curl -sSL https://raw.githubusercontent.com/dmnlng/claude-code-config/main/install.sh | bash

Then restart Claude and run /init
```

### jq Not Installed
```
⚠️  jq not installed

Some features require jq for JSON processing.

Install:
  Linux: sudo apt install jq
  macOS: brew install jq

Continue anyway? (y/n)
```

### Git Not Available
```
❌ Git is not installed

Git is required for this initialization process.

Install git and run /init again.
```

### Manifest Already Exists
```
⚠️  manifest.md already exists

Options:
  1. Keep existing manifest (skip creation)
  2. Backup and create new manifest
  3. Update existing manifest (TODO: not yet implemented)

Choose: [1/2/3]
```

---

## Implementation Notes

### Keep Questions Minimal
- Max 10-15 questions total
- Auto-detect as much as possible
- Allow "Not decided yet" / "Skip" options
- Show progress indicator (Question 3/10)

### Make Everything Optional
- User can skip any section
- Defaults should be sensible
- Can run /manifest update later to fill gaps

### Show Clear Before/After
- Display what changed
- Show file diffs for CLAUDE.md if modified
- Summarize all created artifacts

### Always Validate
- Compliance check at the end
- Token optimization verification
- Git status check
- Readiness score calculation

### Provide Actionable Next Steps
- Clear guidance on what to do next
- Link to relevant commands
- Show workflow guides

---

**Note:** This comprehensive /init replaces the previous lightweight customization flow. It sets up everything needed for structured feature development with Claude Code.
