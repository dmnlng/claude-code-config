# Guided Feature Implementation

**Command:** `/feature implement <feature-id>`

## Purpose

Guides you step-by-step through implementing a feature using TDD (Test-Driven Development). Executes tasks from `tasks.md` one by one, generating code, running tests, and verifying at each step.

---

## Task

Implement feature `$ARGUMENTS` in guided TDD mode.

Example: `/feature implement 001-project-setup`

---

## Mode: Guided TDD Implementation

### Step 1: Validate Feature

```bash
FEATURE_ID="$1"

if [ -z "$FEATURE_ID" ]; then
  echo "❌ Feature ID required"
  echo "Usage: /feature implement <feature-id>"
  exit 1
fi

FEATURE_DIR=".claude/features/$FEATURE_ID"

if [ ! -d "$FEATURE_DIR" ]; then
  echo "❌ Feature $FEATURE_ID not found"
  echo ""
  echo "Available features:"
  ls -1d .claude/features/[0-9]* 2>/dev/null | xargs -n1 basename || echo "  (none)"
  exit 1
fi
```

### Step 2: Check Prerequisites

**Verify all required artifacts exist:**

```bash
REQUIRED_FILES=("spec.md" "gaps.md" "plan.md" "tasks.md")
MISSING=()

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$FEATURE_DIR/$file" ]; then
    MISSING+=("$file")
  fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "❌ Missing required files:"
  for file in "${MISSING[@]}"; do
    echo "  - $file"
  done
  echo ""
  echo "Run /feature \"$FEATURE_ID\" first to generate specs"
  exit 1
fi
```

**Check for blocking Critical Questions:**

```bash
if [ -f ".claude/questions.md" ]; then
  CRITICAL_OPEN=$(grep -c '🔴.*Status.*Open' .claude/questions.md 2>/dev/null || echo 0)

  if [ $CRITICAL_OPEN -gt 0 ]; then
    echo "⚠️  WARNING: $CRITICAL_OPEN critical questions still open"
    echo ""
    grep '🔴' .claude/questions.md | grep 'Open' | head -3
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Cancelled. Resolve questions first with:"
      echo "  /manifest resolve Q<number>"
      exit 0
    fi
  fi
fi
```

### Step 3: Load Tasks

Parse `tasks.md` to extract all tasks:

```bash
# Count tasks
TOTAL_TASKS=$(grep -c '^- \[ \]' "$FEATURE_DIR/tasks.md" 2>/dev/null || echo 0)
COMPLETED_TASKS=$(grep -c '^- \[X\]' "$FEATURE_DIR/tasks.md" 2>/dev/null || echo 0)
REMAINING_TASKS=$((TOTAL_TASKS - COMPLETED_TASKS))

echo "╔══════════════════════════════════════════════════╗"
echo "║  Guided Implementation: $FEATURE_ID"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Progress: $COMPLETED_TASKS / $TOTAL_TASKS tasks completed"
echo "Remaining: $REMAINING_TASKS tasks"
echo ""
```

### Step 4: Detect Project Type & Generate Boilerplate

**For setup features (001-project-setup, etc.), generate initial code:**

```bash
if echo "$FEATURE_ID" | grep -q "setup\|init\|foundation"; then
  echo "🔧 Detecting project type from spec..."
  echo ""

  # Parse spec.md for tech stack
  SPEC_FILE="$FEATURE_DIR/spec.md"

  if grep -q "Next.js" "$SPEC_FILE"; then
    PROJECT_TYPE="nextjs-prisma"
    echo "Detected: Next.js + Prisma project"
  elif grep -q "Express" "$SPEC_FILE"; then
    PROJECT_TYPE="express-prisma"
    echo "Detected: Express + Prisma project"
  elif grep -q "FastAPI" "$SPEC_FILE"; then
    PROJECT_TYPE="fastapi-postgres"
    echo "Detected: FastAPI + PostgreSQL project"
  else
    PROJECT_TYPE="unknown"
    echo "⚠️  Could not auto-detect project type"
    echo ""
    read -p "Enter project type (nextjs-prisma/express-prisma/fastapi-postgres): " PROJECT_TYPE
  fi

  if [ "$PROJECT_TYPE" != "unknown" ]; then
    echo ""
    read -p "Generate boilerplate code for $PROJECT_TYPE? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      if [ -x ".claude/scripts/generate-boilerplate.sh" ]; then
        ./.claude/scripts/generate-boilerplate.sh "$PROJECT_TYPE"
        echo ""
        echo "✅ Boilerplate generated"
        echo ""
      else
        echo "⚠️  Boilerplate generator not found"
      fi
    fi
  fi
fi
```

### Step 5: Task-by-Task Execution Loop

**Iterate through uncompleted tasks:**

```bash
CURRENT_TASK_NUM=$((COMPLETED_TASKS + 1))

while [ $CURRENT_TASK_NUM -le $TOTAL_TASKS ]; do
  # Extract task description
  TASK_LINE=$(sed -n "${CURRENT_TASK_NUM}p" "$FEATURE_DIR/tasks.md")
  TASK_DESC=$(echo "$TASK_LINE" | sed 's/^- \[ \] \*\*TASK-[0-9]*:\*\* //')

  echo "─────────────────────────────────────────────────"
  echo "Task $CURRENT_TASK_NUM/$TOTAL_TASKS: $TASK_DESC"
  echo "─────────────────────────────────────────────────"
  echo ""

  # Show task details
  echo "📋 Task Details:"
  echo "$TASK_LINE"
  echo ""

  # Ask how to proceed
  echo "Options:"
  echo "  [i] Implement this task (with guidance)"
  echo "  [s] Skip (mark as done manually)"
  echo "  [v] View task details"
  echo "  [q] Quit implementation"
  echo ""
  read -p "Choose action: " -n 1 -r ACTION
  echo
  echo ""

  case "$ACTION" in
    i|I)
      # GUIDED IMPLEMENTATION
      implement_task "$CURRENT_TASK_NUM" "$TASK_DESC" "$FEATURE_DIR"
      ;;
    s|S)
      # SKIP - Mark as done
      mark_task_complete "$CURRENT_TASK_NUM" "$FEATURE_DIR"
      ;;
    v|V)
      # VIEW DETAILS
      show_task_details "$CURRENT_TASK_NUM" "$FEATURE_DIR"
      continue
      ;;
    q|Q)
      # QUIT
      echo "Implementation paused"
      echo "Resume with: /feature implement $FEATURE_ID"
      exit 0
      ;;
    *)
      echo "Invalid option, try again"
      continue
      ;;
  esac

  CURRENT_TASK_NUM=$((CURRENT_TASK_NUM + 1))
  echo ""
done
```

### Step 6: Guided Task Implementation

**Function: `implement_task()`**

This is where the magic happens - Claude guides you through TDD:

```bash
implement_task() {
  local task_num=$1
  local task_desc=$2
  local feature_dir=$3

  echo "🎯 Implementing: $task_desc"
  echo ""

  # Determine task phase
  if echo "$task_desc" | grep -q -i "test\|spec"; then
    PHASE="RED"
    echo "📍 Phase: RED (Write Failing Test)"
  elif echo "$task_desc" | grep -q -i "implement\|create\|add"; then
    PHASE="GREEN"
    echo "📍 Phase: GREEN (Make Test Pass)"
  elif echo "$task_desc" | grep -q -i "refactor\|improve\|clean"; then
    PHASE="REFACTOR"
    echo "📍 Phase: REFACTOR (Improve Code)"
  else
    PHASE="GENERAL"
    echo "📍 Phase: GENERAL"
  fi

  echo ""

  # Task-specific guidance
  case "$PHASE" in
    RED)
      echo "✍️  Write a test that fails for: $task_desc"
      echo ""
      echo "Test file suggestions:"
      suggest_test_file "$task_desc"
      echo ""
      echo "I'll help you write the test..."
      # [Claude generates test code here based on task description]
      ;;

    GREEN)
      echo "✅ Implement code to make tests pass: $task_desc"
      echo ""
      echo "Implementation file suggestions:"
      suggest_impl_file "$task_desc"
      echo ""
      echo "I'll help you implement this..."
      # [Claude generates implementation code]
      ;;

    REFACTOR)
      echo "🔧 Refactor code while keeping tests green: $task_desc"
      echo ""
      echo "I'll help you improve the code..."
      # [Claude suggests refactorings]
      ;;

    GENERAL)
      echo "🛠️  Implementing: $task_desc"
      echo ""
      # [Claude helps with general task]
      ;;
  esac

  # After implementation, verify
  echo ""
  read -p "Run tests to verify? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "package.json" ] && grep -q '"test"' package.json; then
      npm test
    fi
  fi

  echo ""
  read -p "Mark task as complete? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    mark_task_complete "$task_num" "$feature_dir"
    echo "✅ Task completed"

    # Git commit after each task (optional)
    read -p "Commit changes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git add -A
      git commit -m "feat($FEATURE_ID): $task_desc

TDD Phase: $PHASE

Task $task_num/$TOTAL_TASKS completed

🤖 Generated with Claude Code"
      echo "✅ Changes committed"
    fi
  fi
}

suggest_test_file() {
  local task=$1
  # Intelligent suggestion based on task description
  # e.g., "Create User model" → __tests__/models/user.test.ts
  echo "  __tests__/unit/..."
  echo "  __tests__/integration/..."
}

suggest_impl_file() {
  local task=$1
  # Intelligent suggestion based on task description
  echo "  lib/..."
  echo "  app/..."
}

mark_task_complete() {
  local task_num=$1
  local feature_dir=$2

  # Replace [ ] with [X] for the specific task
  sed -i "${task_num}s/\[ \]/[X]/" "$feature_dir/tasks.md"
}
```

### Step 7: Completion & Verification

After all tasks are complete:

```
╔══════════════════════════════════════════════════╗
║  Feature Implementation Complete!                ║
╚══════════════════════════════════════════════════╝

All tasks completed: $TOTAL_TASKS/$TOTAL_TASKS ✅

Next Steps:
  1. Run verification: /feature verify $FEATURE_ID
  2. Review verification report
  3. If approved, update manifest: /manifest update

You can also:
  - Run tests: npm test
  - Check coverage: npm run test:coverage
  - Lint code: npm run lint
  - Type check: npm run type-check
```

---

## Implementation Notes

**For Claude implementing this command:**

1. **Parse tasks.md** carefully to extract task descriptions
2. **Use task context** (from spec.md, plan.md) to generate relevant code
3. **Follow TDD phases** strictly:
   - RED: Write test first (must fail)
   - GREEN: Write minimal code to pass
   - REFACTOR: Improve while tests stay green
4. **Generate actual code** - Don't just suggest, actually create files
5. **Verify after each step** - Run tests, check for errors
6. **Commit incrementally** - After each task or phase
7. **Update CLAUDE.md** as you create new files/structure

**Code Generation Strategy:**
- Read spec.md for requirements
- Read plan.md for technical details (file paths, architecture)
- Read tasks.md for step-by-step instructions
- Generate code that matches the plan
- Use templates from `.claude/templates/boilerplate/` for initial setup
- Follow manifest.md tech stack and constraints

---

## Example Session

```bash
$ /feature implement 001-project-setup

╔══════════════════════════════════════════════════╗
║  Guided Implementation: 001-project-setup        ║
╚══════════════════════════════════════════════════╝

Progress: 0 / 54 tasks completed
Remaining: 54 tasks

🔧 Detecting project type from spec...
Detected: Next.js + Prisma project

Generate boilerplate code for nextjs-prisma? (y/n) y

✅ Boilerplate generated
  • package.json
  • docker-compose.yml
  • prisma/schema.prisma
  • tsconfig.json
  • next.config.mjs
  • .env.example

─────────────────────────────────────────────────
Task 1/54: Create Next.js project
─────────────────────────────────────────────────

Options:
  [i] Implement this task (with guidance)
  [s] Skip (mark as done manually)
  [q] Quit

Choose action: i

🎯 Implementing: Create Next.js project
📍 Phase: GENERAL

Boilerplate already generated! ✅

This task includes:
  ✓ package.json created
  ✓ Next.js dependencies listed
  ✓ TypeScript configured

Mark task as complete? (y) y
✅ Task completed

Commit changes? (y) y
✅ Changes committed

[... continues for all 54 tasks ...]
```

---

## Error Handling

**Feature not found:**
```
❌ Feature 001-project-setup not found
```

**Missing spec/plan:**
```
❌ Missing required files:
  - spec.md
  - plan.md
Run /feature "001-project-setup" first
```

**Critical questions open:**
```
⚠️  WARNING: 2 critical questions still open

Q1: Frontend framework selection
Q3: Authentication strategy

Continue anyway? (y/n)
```

---

**Pro Tip:** This guided mode is perfect for solo developers who want step-by-step TDD guidance. It's like pair programming with Claude!
