# SpecFlow: Feature Development

Streamlined spec-driven development from idea to verified implementation.

## Task

Execute SpecFlow workflow based on arguments: `$ARGUMENTS`

### Modes

**Create new feature:**
```
/feature "Add user authentication with email/password"
```

**Verify implemented feature:**
```
/feature verify 001-user-auth
```

**List all features:**
```
/feature list
```

---

## Mode 1: Create New Feature

### Step 0: Prerequisites Check

Check if `.claude/features/` directory exists:
```bash
if [ ! -d ".claude/features" ]; then
  mkdir -p .claude/features
  echo "✓ Created .claude/features/"
fi
```

Check if `manifest.md` exists:
```bash
if [ ! -f "manifest.md" ]; then
  echo "⚠️ manifest.md not found. Run /manifest init first."
  exit 1
fi
```

### Step 1: Generate Feature ID

```bash
# Find next available ID
LAST_ID=$(ls -1d .claude/features/[0-9]* 2>/dev/null | sort -n | tail -1 | grep -o '^[0-9]\+' || echo "000")
NEXT_ID=$(printf "%03d" $((10#$LAST_ID + 1)))
```

### Step 2: Extract Feature Name from Description

From `$ARGUMENTS`, create a slug:
- Example: "Add user authentication" → "user-auth"
- Remove special chars, lowercase, hyphenate

```bash
FEATURE_SLUG=$(echo "$ARGUMENTS" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
```

**Feature Directory:** `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/`

### Step 3: Phase 1 - Ideation & Spec Creation

**Display:**
```
╔══════════════════════════════════════════════════╗
║  SpecFlow: Creating Feature {NEXT_ID}           ║
╚══════════════════════════════════════════════════╝

Phase 1: Ideation & Specification
──────────────────────────────────────────────────
Feature: {ARGUMENTS}
ID: {NEXT_ID}-{FEATURE_SLUG}
```

**Ask Clarifying Questions** (use AskUserQuestion):

**Question 1:**
- Header: "Users"
- Question: "Who are the primary users of this feature?"
- Options:
  - "End users (customers)"
  - "Internal users (admins/staff)"
  - "Developers (API consumers)"
  - "Mixed (multiple user types)"

**Question 2:**
- Header: "Priority"
- Question: "What's the core value/goal of this feature?"
- Options:
  - "Security & Compliance"
  - "User Experience & Engagement"
  - "Performance & Efficiency"
  - "Business Revenue"

**Question 3 (if applicable):**
- Header: "Scope"
- Question: "Which of these are must-haves vs nice-to-haves?"
- Multi-select: true
- Options: (derive from feature description)

**Create spec.md:**
1. Load template from `.claude/templates/spec.md`
2. Replace placeholders:
   - `{FEATURE_NAME}` → User's description
   - `{FEATURE_ID}` → {NEXT_ID}-{FEATURE_SLUG}
   - `{DATE}` → Current date
3. Fill in based on user answers:
   - User Stories section with detected stories
   - Requirements (FR-001, FR-002...) derived from description
   - Success Criteria (measurable)
   - Assumptions

4. Write to `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/spec.md`

**Prompt user:**
```
✓ Spec created at .claude/features/{NEXT_ID}-{FEATURE_SLUG}/spec.md

Review the spec and:
- Type 'continue' to proceed to gap analysis
- Or edit spec.md manually first, then run /feature verify {NEXT_ID}-{FEATURE_SLUG}
```

**Wait for user response.** If "continue", proceed.

### Step 4: Phase 2 - Gap Analysis

**Display:**
```
Phase 2: Gap Analysis
──────────────────────────────────────────────────
Analyzing spec against manifest.md...
```

**Read files:**
- `manifest.md` (project constraints, tech stack)
- `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/spec.md`

**Identify gaps:**

1. **Missing Non-Functional Requirements:**
   - Check if spec mentions: performance, security, accessibility
   - Compare against manifest.md performance budgets
   - Flag missing items

2. **Manifest Conflicts:**
   - Check if spec violates tech stack constraints
   - Check if spec conflicts with architecture rules

3. **Undefined Edge Cases:**
   - Look for vague acceptance criteria
   - Missing error handling scenarios
   - Incomplete user flows

4. **Ambiguities:**
   - Requirements without clear definitions
   - Missing "MUST" vs "SHOULD" keywords

**Create gaps.md:**
1. Load template from `.claude/templates/gaps.md`
2. Fill in detected gaps:
   - Critical (blocks planning)
   - Medium (should address)
   - Low (nice to have)
3. Write to `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/gaps.md`

**Show summary:**
```
✓ Gap analysis complete

Found {N} gaps:
  🚨 CRITICAL: {count}
  ⚠️ MEDIUM: {count}
  ℹ️ LOW: {count}

Critical gaps (must address):
  - GAP-C001: {title}
  - GAP-C002: {title}
```

**If critical gaps found:**
Ask via AskUserQuestion:
- Header: "Gaps"
- Question: "Address critical gaps now or proceed anyway?"
- Options:
  - "Fix now (update spec interactively)"
  - "I'll fix manually (save gaps.md)"
  - "Proceed anyway (risky)"

**If "Fix now":** Update spec.md with gap resolutions

**Prompt:**
```
✓ Gaps documented in gaps.md

Continue to planning? (yes/no)
```

### Step 5: Phase 3 - Technical Planning

**Display:**
```
Phase 3: Technical Planning
──────────────────────────────────────────────────
Reading manifest.md for tech stack...
```

**Read manifest.md** to get:
- Approved tech stack
- Architecture constraints
- Performance budgets
- Security requirements

**Create plan.md:**
1. Load template from `.claude/templates/plan.md`
2. Fill in:
   - Architecture (components, data flow)
   - Tech Stack (from manifest)
   - Test Strategy with TDD approach
   - Data Models (derive from spec entities)
   - API Contracts (if applicable)
   - Security Considerations
3. Write to `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/plan.md`

**Show summary:**
```
✓ Technical plan created

Plan includes:
  - Architecture (components, data flow)
  - Test Strategy (TDD: RED → GREEN → REFACTOR)
  - Data Models ({N} entities)
  - Security Considerations
  - Performance targets from manifest

Review: .claude/features/{NEXT_ID}-{FEATURE_SLUG}/plan.md
```

**Prompt:**
```
Continue to task breakdown? (yes/no)
```

### Step 6: Phase 4 - Task Breakdown

**Display:**
```
Phase 4: Task Breakdown
──────────────────────────────────────────────────
Creating TDD-focused task list...
```

**Read files:**
- spec.md (requirements)
- plan.md (architecture)

**Generate tasks:**

1. **Phase 1: Setup** (4-5 tasks)
   - Create branch
   - Set up structure
   - Configure tests

2. **Phase 2: RED** (5-10 tasks based on complexity)
   - Write unit tests
   - Write integration tests
   - Ensure all FAIL

3. **Phase 3: GREEN** (based on requirements count)
   - Implement to pass tests
   - One task per major component/endpoint

4. **Phase 4: REFACTOR** (3-5 tasks)
   - Extract logic
   - Remove duplication
   - Optimize

5. **Phase 5: Integration** (based on UI/API needs)
   - Frontend integration
   - E2E tests

6. **Phase 6: Documentation** (standard)
   - API docs
   - README
   - CHANGELOG

7. **Phase 7: QA** (standard)
   - Success criteria verification
   - Security scan
   - Performance test

8. **Phase 8: Deployment** (standard)
   - Migrations
   - Feature flags
   - Rollback plan

9. **Phase 9: Verification** (standard)
   - Run /feature verify
   - Address warnings

**Create tasks.md:**
1. Load template from `.claude/templates/tasks.md`
2. Generate tasks based on spec + plan
3. Write to `.claude/features/{NEXT_ID}-{FEATURE_SLUG}/tasks.md`

**Show summary:**
```
✓ Task breakdown complete

Created {N} tasks across 9 phases:
  Phase 1 (Setup): {N} tasks
  Phase 2 (RED): {N} tasks
  Phase 3 (GREEN): {N} tasks
  Phase 4 (REFACTOR): {N} tasks
  Phase 5 (Integration): {N} tasks
  Phase 6 (Documentation): {N} tasks
  Phase 7 (QA): {N} tasks
  Phase 8 (Deployment): {N} tasks
  Phase 9 (Verification): {N} tasks

Tasks follow TDD: RED → GREEN → REFACTOR cycle
```

### Step 7: Summary & Next Steps

**Display:**
```
╔══════════════════════════════════════════════════╗
║  ✓ SpecFlow Setup Complete!                     ║
╚══════════════════════════════════════════════════╝

Feature: {FEATURE_NAME}
ID: {NEXT_ID}-{FEATURE_SLUG}

📁 Created Files:
  - .claude/features/{NEXT_ID}-{FEATURE_SLUG}/spec.md
  - .claude/features/{NEXT_ID}-{FEATURE_SLUG}/gaps.md
  - .claude/features/{NEXT_ID}-{FEATURE_SLUG}/plan.md
  - .claude/features/{NEXT_ID}-{FEATURE_SLUG}/tasks.md

📋 Summary:
  - User Stories: {N}
  - Requirements: {N}
  - Gaps Found: {N} (critical: {N})
  - Tasks: {N} (across 9 phases)
  - Estimated Effort: {calculate based on task count}

🎯 Next Steps:
  1. Review artifacts in .claude/features/{NEXT_ID}-{FEATURE_SLUG}/
  2. Start implementing tasks in tasks.md
  3. Mark tasks [X] as you complete them
  4. Run: /feature verify {NEXT_ID}-{FEATURE_SLUG} when done

💡 Pro Tips:
  - Follow TDD: Write tests FIRST (RED phase)
  - Run /test frequently
  - Update manifest.md when feature is complete

Happy coding! 🚀
```

---

## Mode 2: Verify Feature

**Invoked by:** `/feature verify {FEATURE_ID}`

### Step 1: Check Feature Exists

```bash
if [ ! -d ".claude/features/$FEATURE_ID" ]; then
  echo "❌ Feature $FEATURE_ID not found"
  echo "Available features:"
  ls -1d .claude/features/[0-9]* | xargs -n1 basename
  exit 1
fi
```

### Step 2: Load Artifacts

Read:
- `spec.md` (requirements, success criteria)
- `plan.md` (test strategy)
- `tasks.md` (task completion)

### Step 3: Run Verifications

#### 3.1: Task Completion
```bash
TOTAL_TASKS=$(grep -c '^\- \[ \]' tasks.md)
COMPLETED_TASKS=$(grep -c '^\- \[X\]' tasks.md || echo 0)
COMPLETION_PCT=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
```

#### 3.2: Test Execution
```bash
# Run tests
npm test 2>&1 | tee /tmp/test-output.txt

# Parse results
TESTS_PASSED=$(grep -o '[0-9]* passing' /tmp/test-output.txt | grep -o '[0-9]*' || echo "0")
TESTS_FAILED=$(grep -o '[0-9]* failing' /tmp/test-output.txt | grep -o '[0-9]*' || echo "0")
```

#### 3.3: Coverage Check
```bash
npm run test:coverage 2>&1 | tee /tmp/coverage.txt

# Parse coverage
COVERAGE_LINES=$(grep -oP 'Lines\s+:\s+\K[0-9.]+' /tmp/coverage.txt || echo "0")
```

#### 3.4: Requirements Verification

For each FR-XXX in spec.md:
- Check if corresponding test exists
- Check if test passes
- Mark as ✅ (met), ⚠️ (partial), or ❌ (not met)

#### 3.5: Success Criteria Check

For each SC-XXX:
- If measurable: Check actual vs target
- If boolean: Check status

#### 3.6: Manifest Alignment

- Check tech stack matches manifest
- Check performance metrics against budgets
- Check security requirements

### Step 4: Generate Verification Report

1. Load template from `.claude/templates/verification.md`
2. Fill in all metrics
3. Calculate overall score (weighted)
4. Determine status: APPROVED / APPROVED WITH WARNINGS / REJECTED
5. Write to `.claude/features/{FEATURE_ID}/verification.md`

### Step 5: Display Results

```
╔══════════════════════════════════════════════════╗
║  Verification Report: {FEATURE_ID}               ║
╚══════════════════════════════════════════════════╝

Task Completion:     {X}/100  {STATUS}
Test Coverage:       {X}/100  {STATUS}
Functional Req:      {X}/100  {STATUS}
Non-Functional Req:  {X}/100  {STATUS}
Success Criteria:    {X}/100  {STATUS}
Manifest Alignment:  {X}/100  {STATUS}

Overall Score: {X}/100

Status: {✅ APPROVED / ⚠️ APPROVED WITH WARNINGS / ❌ REJECTED}

{Show critical issues if any}
{Show warnings if any}

Recommendation:
{Clear recommendation text}

Full report: .claude/features/{FEATURE_ID}/verification.md
```

**If APPROVED:**
```
Next steps:
  1. Update manifest.md (mark feature complete)
  2. Merge to main branch
  3. Deploy to {environment}
```

**If REJECTED:**
```
Fix these issues before merge:
  - {Critical issue 1}
  - {Critical issue 2}

Re-run /feature verify {FEATURE_ID} after fixes.
```

---

## Mode 3: List Features

**Invoked by:** `/feature list`

```bash
ls -1d .claude/features/[0-9]* 2>/dev/null | while read dir; do
  ID=$(basename "$dir")
  if [ -f "$dir/spec.md" ]; then
    TITLE=$(grep "^# Feature Spec:" "$dir/spec.md" | sed 's/^# Feature Spec: //')
    STATUS=$(grep "^\*\*Status:\*\*" "$dir/spec.md" | sed 's/^\*\*Status:\*\* //')

    # Check verification status
    if [ -f "$dir/verification.md" ]; then
      VERIFIED="✅"
    else
      VERIFIED="⏳"
    fi

    echo "$ID: $TITLE ($STATUS) $VERIFIED"
  fi
done
```

**Display:**
```
Features in this project:
──────────────────────────────────────────────────
001-user-auth: Add user authentication (Complete) ✅
002-payment: Payment processing (In Progress) ⏳
003-blog: Blog system (Draft) ⏳

Legend:
  ✅ = Verified and ready
  ⏳ = Not yet verified

Run /feature verify {ID} to check status.
```

---

## Error Handling

**No manifest.md:**
```
❌ manifest.md not found!

SpecFlow requires a project manifest.
Run: /manifest init

This creates a manifest with project requirements,
tech stack, and performance budgets.
```

**Invalid feature ID:**
```
❌ Feature ID must be in format: NNN-feature-name
Example: 001-user-auth

Available features:
{List existing features}
```

**Missing templates:**
```
❌ Template files not found in .claude/templates/

Expected files:
  - spec.md
  - gaps.md
  - plan.md
  - tasks.md
  - verification.md

Run /init to install templates.
```

---

## Implementation Notes

- Use AskUserQuestion for all user interactions
- Keep phases sequential (don't jump ahead)
- Save state in markdown files (not memory)
- Always provide "continue?" prompts between phases
- Show progress indicators
- Give clear next steps at each stage
- Link to created files for user review
