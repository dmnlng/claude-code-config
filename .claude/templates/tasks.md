# Task Breakdown: {FEATURE_NAME}

**Feature ID:** {FEATURE_ID}
**Spec:** {FEATURE_ID}/spec.md
**Plan:** {FEATURE_ID}/plan.md
**Created:** {DATE}
**Status:** Not Started

**TDD Discipline:** RED → GREEN → REFACTOR

---

## Phase 1: Setup & Environment

**Goal:** Prepare development environment and foundational code

- [ ] T001: Create feature branch `{FEATURE_ID}-{feature-name}`
- [ ] T002: Set up directory structure per plan.md
- [ ] T003: Initialize {database/ORM} schema for {entities}
- [ ] T004: Configure test environment ({test framework})
- [ ] T005: Create test fixtures/factories

**Checkpoint:** ✅ Environment ready, can write tests

---

## Phase 2: RED - Write Failing Tests

**Goal:** Define expected behavior through tests BEFORE implementation

### Unit Tests
- [ ] T006: [RED] Write test: `{function}()` should {behavior}
- [ ] T007: [RED] Write test: `{function}()` should reject {invalid input}
- [ ] T008: [RED] Write test: `{service}.{method}()` should {behavior}

### Integration Tests
- [ ] T009: [RED] Write test: `{METHOD} {endpoint}` returns 200 with valid data
- [ ] T010: [RED] Write test: `{METHOD} {endpoint}` returns 400 for {error case}
- [ ] T011: [RED] Write test: Database transaction {scenario}

**Checkpoint:** ✅ All tests written and FAILING (as expected)

**Verify RED:** Run `npm test` → All new tests should FAIL

---

## Phase 3: GREEN - Implement to Pass Tests

**Goal:** Write minimal code to make tests pass

### Core Implementation
- [ ] T012: [GREEN] Implement `{function/service/model}`
- [ ] T013: [GREEN] Implement `{API endpoint}`
- [ ] T014: [GREEN] Add input validation for {fields}
- [ ] T015: [GREEN] Implement {business logic}
- [ ] T016: [GREEN] Add error handling for {scenarios}

**Checkpoint:** ✅ All tests PASSING

**Verify GREEN:** Run `npm test` → All tests should PASS ✅

---

## Phase 4: REFACTOR - Clean & Optimize

**Goal:** Improve code quality while keeping tests green

- [ ] T017: [REFACTOR] Extract {logic} into reusable function
- [ ] T018: [REFACTOR] Remove duplication in {area}
- [ ] T019: [REFACTOR] Improve error messages and logging
- [ ] T020: [REFACTOR] Add JSDoc/TypeDoc comments
- [ ] T021: [REFACTOR] Optimize {database queries/algorithm}

**Checkpoint:** ✅ Code clean, tests still PASSING

**Verify REFACTOR:** Run `npm test` → All tests must remain PASSING ✅

---

## Phase 5: Integration & E2E Tests

**Goal:** Verify feature works end-to-end

### Frontend Integration (if applicable)
- [ ] T022: Create {UI component}
- [ ] T023: Connect component to {API/service}
- [ ] T024: Add loading/error states
- [ ] T025: Implement {user interaction}

### E2E Tests
- [ ] T026: [E2E] Write test: User can {complete user story 1}
- [ ] T027: [E2E] Write test: Error handling for {scenario}
- [ ] T028: [E2E] Implement and verify test passes

**Checkpoint:** ✅ Feature works end-to-end

---

## Phase 6: Documentation & Polish

**Goal:** Prepare feature for review and deployment

- [ ] T029: Write API documentation ({OpenAPI/Swagger})
- [ ] T030: Update README.md with {feature usage}
- [ ] T031: Add CHANGELOG entry
- [ ] T032: Update manifest.md (mark feature status)
- [ ] T033: Create user-facing documentation (if needed)
- [ ] T034: Add inline code comments for complex logic

**Checkpoint:** ✅ Feature documented and ready for review

---

## Phase 7: Quality Assurance

**Goal:** Verify all success criteria met

### Success Criteria Verification
- [ ] T035: Verify SC-001: {criteria} ≥ {target}
- [ ] T036: Verify SC-002: {criteria} ≤ {target}
- [ ] T037: Verify SC-003: {criteria}

### Non-Functional Requirements
- [ ] T038: Performance test: {metric} meets target
- [ ] T039: Security scan: No vulnerabilities
- [ ] T040: Accessibility test: WCAG 2.1 AA compliant (if UI)

### Final Checks
- [ ] T041: Code review (self or peer)
- [ ] T042: Run full test suite: `npm test`
- [ ] T043: Run linter: `npm run lint`
- [ ] T044: Check test coverage: ≥80%

**Checkpoint:** ✅ All quality gates passed

---

## Phase 8: Deployment Preparation

**Goal:** Prepare for production deployment

- [ ] T045: Create database migrations (if needed)
- [ ] T046: Test migrations on staging DB
- [ ] T047: Update environment variables documentation
- [ ] T048: Create feature flag (if gradual rollout)
- [ ] T049: Prepare rollback plan
- [ ] T050: Update deployment checklist

**Checkpoint:** ✅ Ready for deployment

---

## Phase 9: Verification & Sign-off

**Goal:** Final verification before merge

- [ ] T051: Run `/feature verify {FEATURE_ID}`
- [ ] T052: Address any verification warnings
- [ ] T053: Get stakeholder sign-off (if required)
- [ ] T054: Merge to main branch

**Checkpoint:** ✅ Feature complete and merged

---

## Progress Tracking

| Phase | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| **1. Setup** | 5 | 0/5 (0%) | ⚪ Not Started |
| **2. RED** | 6 | 0/6 (0%) | ⚪ Not Started |
| **3. GREEN** | 5 | 0/5 (0%) | ⚪ Not Started |
| **4. REFACTOR** | 5 | 0/5 (0%) | ⚪ Not Started |
| **5. Integration** | 7 | 0/7 (0%) | ⚪ Not Started |
| **6. Documentation** | 6 | 0/6 (0%) | ⚪ Not Started |
| **7. QA** | 10 | 0/10 (0%) | ⚪ Not Started |
| **8. Deployment** | 6 | 0/6 (0%) | ⚪ Not Started |
| **9. Verification** | 4 | 0/4 (0%) | ⚪ Not Started |
| **TOTAL** | 54 | 0/54 (0%) | ⚪ Not Started |

---

## Task Dependencies

```
T001 → T002 → T003 → T004 → T005
          ↓
       T006-T011 (RED phase - can work in parallel)
          ↓
       T012-T016 (GREEN phase - sequential)
          ↓
       T017-T021 (REFACTOR - can work in parallel)
          ↓
       T022-T028 (Integration)
          ↓
       T029-T034 (Documentation - can work in parallel)
          ↓
       T035-T044 (QA - sequential verification)
          ↓
       T045-T050 (Deployment prep)
          ↓
       T051-T054 (Final verification)
```

---

## TDD Reminders

### RED Phase ✋
- **DO:** Write tests that describe desired behavior
- **DO:** Ensure tests FAIL for the right reason
- **DON'T:** Write implementation code yet
- **DON'T:** Make tests pass prematurely

### GREEN Phase ✅
- **DO:** Write minimal code to make tests pass
- **DO:** Focus on making it work, not perfect
- **DON'T:** Over-engineer solutions
- **DON'T:** Skip tests to "save time"

### REFACTOR Phase ♻️
- **DO:** Improve code structure and readability
- **DO:** Remove duplication
- **DO:** Keep tests passing throughout
- **DON'T:** Change behavior (tests must stay green)
- **DON'T:** Add new features (that's a new cycle)

---

## Notes

- Update this file as you complete tasks (mark [X])
- If stuck, consult plan.md or spec.md
- Add new tasks if scope expands (discuss first)
- Remove tasks if no longer needed (document why)
- Run `/feature verify {FEATURE_ID}` when all tasks complete

---

**Last Updated:** {DATE}
**Next Review:** {When to review progress}
