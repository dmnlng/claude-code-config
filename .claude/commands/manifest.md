# Project Manifest Management

Create and manage the project manifest - the source of truth for requirements, tech stack, and constraints.

## Task

Manage project manifest based on arguments: `$ARGUMENTS`

### Modes

**Initialize new manifest:**
```
/manifest init
```

**Update existing manifest:**
```
/manifest update
```

**Show current manifest:**
```
/manifest show
```

---

## Mode 1: Initialize Manifest

**Invoked by:** `/manifest init`

### Step 1: Check if Exists

```bash
if [ -f "manifest.md" ]; then
  echo "⚠️ manifest.md already exists"
  # Ask if user wants to overwrite
  exit 1
fi
```

Ask via AskUserQuestion:
- Header: "Overwrite"
- Question: "manifest.md exists. Overwrite or update?"
- Options:
  - "Overwrite (backup existing)"
  - "Update (merge with existing)"
  - "Cancel"

### Step 2: Gather Project Information

Ask via AskUserQuestion (multiple questions):

**Question 1: Project Type**
- Header: "Project Type"
- Question: "What type of project is this?"
- Options:
  - "Web Application"
  - "Mobile App"
  - "API Service"
  - "Library/Package"
  - "CLI Tool"
  - "Desktop Application"

**Question 2: Primary Stack**
- Header: "Stack"
- Question: "What's your primary technology stack?"
- Options:
  - "JavaScript/TypeScript (Node.js, React)"
  - "Python (Django, Flask, FastAPI)"
  - "Rust (Actix, Rocket)"
  - "Go (Gin, Echo)"
  - "Java/Kotlin (Spring Boot)"
  - ".NET (ASP.NET Core)"

**Question 3: Database**
- Header: "Database"
- Question: "Which database(s) will you use?"
- Multi-select: true
- Options:
  - "PostgreSQL"
  - "MySQL/MariaDB"
  - "MongoDB"
  - "Redis"
  - "SQLite"
  - "None (stateless)"

**Question 4: Deployment Target**
- Header: "Deployment"
- Question: "Where will this be deployed?"
- Options:
  - "AWS (EC2, ECS, Lambda)"
  - "Google Cloud"
  - "Azure"
  - "Vercel/Netlify (static/serverless)"
  - "Self-hosted/VPS"
  - "Not decided yet"

**Question 5: Performance Priority**
- Header: "Performance"
- Question: "What's your performance priority?"
- Options:
  - "High (strict budgets, optimize aggressively)"
  - "Medium (reasonable targets)"
  - "Low (functionality over speed)"

### Step 3: Detect Project Details

Auto-detect from codebase:
```bash
# Detect language
if [ -f "package.json" ]; then LANG="JavaScript/TypeScript"
elif [ -f "Cargo.toml" ]; then LANG="Rust"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then LANG="Python"
elif [ -f "go.mod" ]; then LANG="Go"
fi

# Detect test framework
if [ -f "package.json" ]; then
  if grep -q "jest" package.json; then TEST_FW="Jest"
  elif grep -q "vitest" package.json; then TEST_FW="Vitest"
  fi
elif [ -f "pyproject.toml" ]; then
  if grep -q "pytest" pyproject.toml; then TEST_FW="Pytest"
  fi
fi
```

### Step 4: Create Manifest

Load template from `.claude/templates/manifest.md` and fill:
- Project Type (from Q1)
- Vision (template placeholder - user fills later)
- Tech Stack (from Q2 + auto-detection)
- Database (from Q3)
- Deployment (from Q4)
- Performance Budgets (based on Q5)
  - High: LCP ≤1.5s, CLS ≤0.05
  - Medium: LCP ≤2.5s, CLS ≤0.10
  - Low: LCP ≤4.0s, CLS ≤0.25

Write to `manifest.md`

### Step 5: Show Summary

```
╔══════════════════════════════════════════════════╗
║  ✓ Project Manifest Created!                    ║
╚══════════════════════════════════════════════════╝

Location: manifest.md

📋 Summary:
  - Project Type: {type}
  - Stack: {stack}
  - Database: {db}
  - Deployment: {deployment}
  - Performance: {priority} priority

🎯 Next Steps:
  1. Review manifest.md
  2. Fill in Vision and Business Goals sections
  3. Add mandatory features list
  4. Customize performance budgets if needed
  5. Commit to git (this is your project constitution)

💡 Pro Tip:
  manifest.md is read by /feature to ensure alignment.
  Keep it updated as decisions are made!

Start creating features: /feature "your feature description"
```

---

## Mode 2: Update Manifest

**Invoked by:** `/manifest update`

### Step 1: Check Exists

```bash
if [ ! -f "manifest.md" ]; then
  echo "❌ manifest.md not found. Run /manifest init first."
  exit 1
fi
```

### Step 2: What to Update

Ask via AskUserQuestion:
- Header: "Update"
- Question: "What do you want to update?"
- Multi-select: true
- Options:
  - "Mark feature as complete"
  - "Add new mandatory feature"
  - "Update tech stack"
  - "Update performance budgets"
  - "Update deployment target"

### Step 3: Interactive Update

**If "Mark feature as complete":**
1. List features from `.claude/features/`
2. Ask which one to mark complete
3. Update manifest.md:
   ```markdown
   - [X] {Feature Name} ({ID}) ✅ Completed {DATE}
   ```

**If "Add new mandatory feature":**
1. Ask for feature name
2. Add to manifest.md:
   ```markdown
   - [ ] {Feature Name}
   ```

**If "Update tech stack":**
1. Show current stack
2. Ask what to add/remove
3. Update manifest.md

**If "Update performance budgets":**
1. Show current budgets
2. Ask for new values
3. Update manifest.md

### Step 4: Show Changes

```
✓ Manifest updated

Changes made:
  - Marked feature 001-user-auth as complete ✅
  - Updated LCP budget: 2.5s → 2.0s

Review: manifest.md
```

---

## Mode 3: Show Manifest

**Invoked by:** `/manifest show`

```bash
if [ ! -f "manifest.md" ]; then
  echo "❌ manifest.md not found. Run /manifest init first."
  exit 1
fi

# Display key sections
cat manifest.md
```

Or show structured summary:
```
Project Manifest Summary
──────────────────────────────────────────────────
Vision: {Extract from manifest}

Tech Stack:
  - Frontend: {stack}
  - Backend: {stack}
  - Database: {db}
  - Testing: {framework}

Mandatory Features:
  ✅ {Completed features}
  ⏳ {Pending features}

Performance Budgets:
  - LCP: ≤ {target}s
  - CLS: ≤ {target}
  - TTFB: ≤ {target}ms

Security Requirements:
  - {List from manifest}

Full manifest: manifest.md
```

---

## Error Handling

**Templates not found:**
```
❌ Manifest template not found in .claude/templates/

Expected: .claude/templates/manifest.md

Run /init to install templates.
```

**No git repository:**
```
⚠️ Not a git repository

It's recommended to version-control your manifest.

Initialize git? (y/n)
```

---

## Implementation Notes

- manifest.md is the source of truth for all features
- /feature reads manifest.md to get tech stack and constraints
- Keep manifest updated as project evolves
- Commit manifest.md to share with team
- Use manifest as project constitution (like speckit)
