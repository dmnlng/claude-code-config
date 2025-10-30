# Implementation Verification: {FEATURE_NAME}

**Feature ID:** {FEATURE_ID}
**Verified:** {DATE}
**Verifier:** Claude Code SpecFlow
**Status:** {DRAFT / IN_REVIEW / APPROVED / REJECTED}

---

## 1. Task Completion Status

### Overall Progress
- **Total Tasks:** {N}
- **Completed:** {N}/{N} ({X}%)
- **In Progress:** {N}
- **Blocked:** {N}
- **Skipped:** {N} (with justification)

### Phase Breakdown
| Phase | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| Setup | {N} | {N}/{N} ({X}%) | {STATUS} |
| RED (Tests) | {N} | {N}/{N} ({X}%) | {STATUS} |
| GREEN (Implementation) | {N} | {N}/{N} ({X}%) | {STATUS} |
| REFACTOR | {N} | {N}/{N} ({X}%) | {STATUS} |
| Integration | {N} | {N}/{N} ({X}%) | {STATUS} |
| Documentation | {N} | {N}/{N} ({X}%) | {STATUS} |
| QA | {N} | {N}/{N} ({X}%) | {STATUS} |
| Deployment Prep | {N} | {N}/{N} ({X}%) | {STATUS} |
| Verification | {N} | {N}/{N} ({X}%) | {STATUS} |

**Task Completion Score:** {X}/100

---

## 2. Test Coverage & Results

### Test Execution
```
Unit Tests:        {N}/{N} passing ({X}%)
Integration Tests: {N}/{N} passing ({X}%)
E2E Tests:         {N}/{N} passing ({X}%)

Total:             {N}/{N} passing ({X}%)
```

### Coverage Metrics
```
Lines:      {X}% (target: ≥80%)  {✅/⚠️/❌}
Branches:   {X}% (target: ≥75%)  {✅/⚠️/❌}
Functions:  {X}% (target: ≥90%)  {✅/⚠️/❌}
Statements: {X}% (target: ≥80%)  {✅/⚠️/❌}
```

### Uncovered Areas
- {File/Component}: {X}% covered - {Reason if acceptable}
- {File/Component}: {X}% covered - {Action needed}

**Test Coverage Score:** {X}/100

---

## 3. Requirements Verification

### Functional Requirements

#### Met Requirements ✅
- FR-001: {Description} - Verified by {Test ID}
- FR-002: {Description} - Verified by {Test ID}

#### Partially Met Requirements ⚠️
- FR-XXX: {Description}
  - **Issue:** {What's missing or incomplete}
  - **Impact:** {HIGH/MEDIUM/LOW}
  - **Action:** {What needs to be done}

#### Unmet Requirements ❌
- FR-XXX: {Description}
  - **Reason:** {Why not implemented}
  - **Blocker:** {YES/NO}
  - **Plan:** {Defer to v2 / Fix before merge / etc.}

**Functional Requirements Score:** {N}/{N} met ({X}%)

### Non-Functional Requirements

#### Performance ⚡
- NFR-001: {Metric} ≤ {Target} - Measured: {Actual} {✅/⚠️/❌}
- NFR-002: {Metric} ≥ {Target} - Measured: {Actual} {✅/⚠️/❌}

#### Security 🔒
- NFR-XXX: {Requirement} - {Status} {✅/⚠️/❌}
- Security scan result: {Vulnerabilities found}

#### Accessibility ♿
- NFR-XXX: WCAG 2.1 AA - {Status} {✅/⚠️/❌}
- Violations found: {N} (see details below)

#### Other NFRs
- NFR-XXX: {Requirement} - {Status} {✅/⚠️/❌}

**Non-Functional Requirements Score:** {N}/{N} met ({X}%)

---

## 4. Success Criteria Verification

### Measurable Outcomes
- SC-001: {Criteria with target} - Measured: {Actual} {✅/⚠️/❌}
  - **Test Method:** {How it was measured}
  - **Evidence:** {Link to test results / metrics}

- SC-002: {Criteria} - Status: {PASS/FAIL} {✅/❌}
  - **Test Method:** {How it was verified}

**Success Criteria Score:** {N}/{N} achieved ({X}%)

---

## 5. Manifest Alignment Check

### Technology Stack Compliance
- ✅ Uses approved tech stack from manifest.md
- ✅ Follows architecture constraints
- ⚠️ Deviation: {Description of any deviation and justification}

### Performance Budget Compliance
| Metric | Budget | Actual | Status |
|--------|--------|--------|--------|
| {Metric} | ≤ {Target} | {Actual} | {✅/⚠️/❌} |
| {Metric} | ≥ {Target} | {Actual} | {✅/⚠️/❌} |

### Security Requirements Compliance
- ✅ {Requirement} implemented
- ❌ {Requirement} not implemented - {Reason}

**Manifest Alignment Score:** {X}/100

---

## 6. Code Quality Assessment

### Linting & Formatting
```bash
$ npm run lint
{Output showing pass/fail and any warnings}
```
**Linter Issues:** {N} errors, {N} warnings

### Type Safety (if TypeScript)
```bash
$ npm run type-check
{Output}
```
**Type Errors:** {N}

### Code Review Checklist
- [ ] No commented-out code
- [ ] No console.log/debug statements
- [ ] No hardcoded secrets or API keys
- [ ] Error handling comprehensive
- [ ] Edge cases handled
- [ ] Code follows project style guide
- [ ] Functions are focused and single-purpose
- [ ] Complex logic has comments
- [ ] No unnecessary dependencies added

**Code Quality Score:** {X}/100

---

## 7. Documentation Completeness

### Required Documentation
- [ ] API documentation (OpenAPI/Swagger/etc.)
- [ ] README.md updated
- [ ] CHANGELOG.md entry added
- [ ] manifest.md updated
- [ ] Inline code comments for complex logic
- [ ] User-facing documentation (if applicable)

### Documentation Quality
- Clarity: {GOOD/NEEDS_IMPROVEMENT}
- Completeness: {GOOD/NEEDS_IMPROVEMENT}
- Examples provided: {YES/NO}

**Documentation Score:** {X}/100

---

## 8. Outstanding Issues

### Critical Issues (Blockers) 🚨
{List critical issues that MUST be fixed before merge}

1. **{Issue Title}**
   - **Severity:** CRITICAL
   - **Description:** {What's wrong}
   - **Impact:** {Why this blocks merge}
   - **Action Required:** {What must be done}
   - **Assigned To:** {Who will fix}
   - **ETA:** {When}

### Medium Issues (Should Fix) ⚠️
{List important issues that should be addressed}

1. **{Issue Title}**
   - **Severity:** MEDIUM
   - **Description:** {What's wrong}
   - **Impact:** {Why this matters}
   - **Recommendation:** {What should be done}

### Low Issues (Nice to Fix) ℹ️
{List minor issues or improvements}

1. **{Issue Title}**
   - **Severity:** LOW
   - **Description:** {What could be better}
   - **Recommendation:** {Suggested improvement}

---

## 9. Deployment Readiness

### Pre-Deployment Checklist
- [ ] All tests passing
- [ ] Database migrations created and tested
- [ ] Environment variables documented
- [ ] Feature flag configured (if applicable)
- [ ] Rollback plan documented
- [ ] Monitoring/alerts configured
- [ ] Stakeholder approval obtained

### Deployment Risk Assessment
**Risk Level:** {LOW / MEDIUM / HIGH}

**Risks Identified:**
1. {Risk description} - Mitigation: {How it's addressed}
2. {Risk description} - Mitigation: {How it's addressed}

**Rollback Strategy:**
{How to rollback if deployment fails}

---

## 10. Overall Assessment

### Scores Summary

| Category | Score | Weight | Weighted |
|----------|-------|--------|----------|
| Task Completion | {X}/100 | 20% | {X} |
| Test Coverage | {X}/100 | 20% | {X} |
| Functional Req | {X}/100 | 15% | {X} |
| Non-Functional Req | {X}/100 | 15% | {X} |
| Success Criteria | {X}/100 | 10% | {X} |
| Manifest Alignment | {X}/100 | 10% | {X} |
| Code Quality | {X}/100 | 5% | {X} |
| Documentation | {X}/100 | 5% | {X} |

**Overall Score:** {X}/100

### Verification Status

**Status:** {Choose one}
- ✅ **APPROVED FOR MERGE** - All critical criteria met
- ⚠️ **APPROVED WITH WARNINGS** - Minor issues, can merge with follow-up tasks
- ❌ **REJECTED** - Critical issues must be resolved before merge
- 🔄 **NEEDS REVIEW** - Requires stakeholder review before decision

### Recommendation

{Provide clear recommendation with justification}

**If APPROVED:**
- Proceed with merge to {branch}
- Deploy to {environment}
- Create follow-up issues for warnings (if any)

**If REJECTED:**
- Address critical issues: {list IDs}
- Re-run verification after fixes
- Estimated time to fix: {estimate}

---

## 11. Follow-Up Actions

### Immediate Actions (Before Merge)
- [ ] {Action required before merge}
- [ ] {Action required before merge}

### Post-Merge Actions
- [ ] {Action to do after merge}
- [ ] {Action to do after merge}

### Technical Debt Created
- {Description of technical debt}
  - **Issue:** {Link to tracking issue}
  - **Priority:** {HIGH/MEDIUM/LOW}
  - **Target Resolution:** {Version/Sprint}

---

## 12. Verification Signatures

**Feature Developer:**
- Name: {Name}
- Date: {Date}
- Sign-off: {YES/NO}

**Code Reviewer:**
- Name: {Name}
- Date: {Date}
- Sign-off: {YES/NO}

**QA Tester:**
- Name: {Name}
- Date: {Date}
- Sign-off: {YES/NO}

**Stakeholder/Product Owner:**
- Name: {Name}
- Date: {Date}
- Approval: {YES/NO}

---

## 13. Manifest Update

After successful merge, update manifest.md:

```markdown
### Mandatory Features
- [X] {Feature Name} ({FEATURE_ID}) ✅ Completed {DATE}
  - Score: {X}/100
  - Tests: {N} passing
  - Coverage: {X}%
```

---

**Verification Complete:** {DATE}
**Next Review:** {When to review again if applicable}
**Archived:** {YES/NO}
