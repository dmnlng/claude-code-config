# Spec Gap Analysis: {FEATURE_NAME}

**Feature ID:** {FEATURE_ID}
**Analyzed:** {DATE}
**Spec Version:** {VERSION}
**Analyzer:** Claude Code SpecFlow

---

## Critical Gaps (Must Address Before Planning)

### GAP-C001: {Gap Title}
**Missing from spec:**
- {What is not defined}
- {What is unclear or ambiguous}

**Recommendation:**
{Suggested addition to spec - be specific with requirement ID}

**Impact:** HIGH - {Why this is critical}

**Action Required:** YES

---

## Medium Gaps (Should Address)

### GAP-M001: {Gap Title}
**Missing from spec:**
- {What is not defined}

**Recommendation:**
{Suggested addition}

**Impact:** MEDIUM - {Why this matters}

**Action Required:** RECOMMENDED

---

## Low Gaps (Nice to Have)

### GAP-L001: {Gap Title}
**Missing from spec:**
- {What is not defined}

**Recommendation:**
{Suggested addition or mark as out-of-scope}

**Impact:** LOW - {Why this is minor}

**Action Required:** OPTIONAL

---

## Manifest Conflicts

### CONFLICT-001: {Conflict Title}
**Spec says:** {What the spec defines}
**Manifest says:** {What manifest.md requires}
**Conflict:** {Why these are incompatible}

**Resolution Required:** YES
**Recommendation:** {How to resolve - usually align with manifest}

---

## Missing Acceptance Criteria

**User Story:** {Story ID}
**Issue:** Acceptance criteria are vague or missing
**Recommendation:** Add specific Given/When/Then scenarios

---

## Ambiguities Detected

### AMBIG-001: {Ambiguous Requirement ID}
**Text:** "{Quote from spec}"
**Issue:** {Why this is ambiguous}
**Clarification Needed:** {What question to ask}

---

## Summary

| Category | Count | Status |
|----------|-------|--------|
| **Critical Gaps** | {N} | ⚠️ Must address |
| **Medium Gaps** | {N} | 💡 Recommended |
| **Low Gaps** | {N} | ℹ️ Optional |
| **Manifest Conflicts** | {N} | 🚨 Resolve |
| **Ambiguities** | {N} | ❓ Clarify |

**Overall Assessment:**
{READY / NEEDS WORK / CRITICAL ISSUES}

---

## Action Plan

1. **Immediate Actions (Before Planning):**
   - [ ] Address GAP-C001: {title}
   - [ ] Resolve CONFLICT-001: {title}

2. **Recommended Actions:**
   - [ ] Address GAP-M001: {title}
   - [ ] Clarify AMBIG-001: {title}

3. **Optional Improvements:**
   - [ ] Consider GAP-L001: {title}

---

## Updated Spec Required?

**YES / NO**

If YES:
- Update spec.md with critical gap resolutions
- Add new requirement IDs as needed
- Re-run gap analysis after updates
- Mark this gaps.md as RESOLVED when complete

---

## Verification

After addressing gaps:
- [ ] All critical gaps resolved
- [ ] All manifest conflicts resolved
- [ ] Ambiguities clarified
- [ ] Spec updated and reviewed
- [ ] Ready to proceed to planning phase

**Gap Analysis Status:** PENDING / RESOLVED
