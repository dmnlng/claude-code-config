# Project Manifest: {PROJECT_NAME}

**Project Type:** {PROJECT_TYPE}
**Created:** {DATE}
**Last Updated:** {DATE}
**Status:** Active
**Framework:** reqflow (Requirements-Driven Development Framework)

---

## Vision

> {VISION_PLACEHOLDER}
>
> **Instructions for Manual/LLM Filling:** Replace this section with your project's high-level vision. What problem does this solve? What is the end goal? Keep it to 2-3 sentences that anyone can understand. Focus on the "why" and desired outcome.

**Example:**
> Build a secure, high-performance task management platform that helps remote teams coordinate work without cluttering their workflow. Users should be able to create, assign, and track tasks in under 10 seconds per action.

---

## Business Goals

### Primary Objectives
- {GOAL_PLACEHOLDER}
- {GOAL_PLACEHOLDER}
- {GOAL_PLACEHOLDER}

**Instructions:** List 3-5 measurable business goals. Focus on outcomes, not features.

**Examples:**
- Onboard 1,000 active users in first 6 months
- Achieve 95% uptime SLA
- Reduce customer support tickets by 40% through self-service features
- Generate $50k MRR by end of Q4

---

## Users & Stakeholders (WHO)

### Primary Users
- **{USER_TYPE}**: {Description of needs and goals}

**Instructions:** Define who will use this system and what they need.

**Example:**
- **Project Managers**: Need to see team progress at a glance, assign tasks, and generate reports
- **Developers**: Need to update task status without leaving their IDE
- **Executives**: Need high-level metrics and trends for strategic planning

### Stakeholders
- **Product Owner**: {Name/Role}
- **Technical Lead**: {Name/Role}
- **Key Stakeholders**: {Names/Roles}

---

## Mandatory Features (WHAT)

### Core Features (Must Have for v1.0)
- [ ] {FEATURE_PLACEHOLDER}
- [ ] {FEATURE_PLACEHOLDER}
- [ ] {FEATURE_PLACEHOLDER}

**Instructions:** List features that MUST be implemented. Mark [X] when feature is complete and verified.

**Format:** `- [ ] Feature Name (feature-id) - Brief description`

**Example:**
- [ ] User Authentication (001-user-auth) - Email/password login with JWT tokens
- [ ] Task Creation (002-task-create) - Create tasks with title, description, assignee, due date
- [ ] Dashboard View (003-dashboard) - Real-time view of all active tasks

### Future Features (Nice to Have)
- {FEATURE_PLACEHOLDER}
- {FEATURE_PLACEHOLDER}

**Instructions:** Features for v2.0+ or when capacity allows.

---

## Technology Stack (HOW)

### Detected Stack
{DETECTED_STACK_PLACEHOLDER}

### Frontend
- **Framework**: {FRONTEND_FRAMEWORK}
- **State Management**: {STATE_MANAGEMENT}
- **UI Library**: {UI_LIBRARY}
- **Build Tool**: {BUILD_TOOL}

### Backend
- **Language/Runtime**: {BACKEND_LANGUAGE}
- **Framework**: {BACKEND_FRAMEWORK}
- **API Style**: {API_STYLE}
- **Authentication**: {AUTH_METHOD}

### Database
- **Primary Database**: {DATABASE}
- **Caching**: {CACHE_LAYER}
- **ORM/Query Builder**: {ORM}

### Testing
- **Unit Tests**: {TEST_FRAMEWORK}
- **Integration Tests**: {INTEGRATION_FRAMEWORK}
- **E2E Tests**: {E2E_FRAMEWORK}
- **Coverage Target**: ≥80% lines, ≥75% branches

### DevOps
- **CI/CD**: {CI_CD_PLATFORM}
- **Deployment**: {DEPLOYMENT_METHOD}
- **Monitoring**: {MONITORING_TOOL}
- **Logging**: {LOGGING_SERVICE}

---

## Deployment & Hosting (WHERE)

### Deployment Target
**Platform:** {DEPLOYMENT_PLATFORM}

**Environment Strategy:**
- **Development**: {DEV_ENV}
- **Staging**: {STAGING_ENV}
- **Production**: {PROD_ENV}

### Infrastructure
- **Hosting**: {HOSTING_PROVIDER}
- **CDN**: {CDN_PROVIDER}
- **DNS**: {DNS_PROVIDER}
- **SSL/TLS**: {SSL_PROVIDER}

### Scaling Strategy
- **Horizontal Scaling**: {YES/NO - method}
- **Load Balancing**: {LOAD_BALANCER}
- **Auto-scaling**: {AUTOSCALE_POLICY}

---

## Performance Budgets

### Priority Level
**Performance Priority:** {PERFORMANCE_PRIORITY}

### Web Vitals (if applicable)
- **LCP (Largest Contentful Paint)**: ≤ {LCP_TARGET}s
- **FID (First Input Delay)**: ≤ {FID_TARGET}ms
- **CLS (Cumulative Layout Shift)**: ≤ {CLS_TARGET}

### API Performance
- **Response Time (p95)**: ≤ {API_P95_TARGET}ms
- **Response Time (p99)**: ≤ {API_P99_TARGET}ms
- **Throughput**: ≥ {THROUGHPUT_TARGET} req/s

### Database Performance
- **Query Time (p95)**: ≤ {DB_P95_TARGET}ms
- **Connection Pool**: {POOL_SIZE} connections
- **Max Queries per Request**: ≤ {MAX_QUERIES}

### Asset Budgets
- **JavaScript Bundle**: ≤ {JS_BUDGET}kb (gzipped)
- **CSS Bundle**: ≤ {CSS_BUDGET}kb (gzipped)
- **Images**: WebP/AVIF, ≤ {IMAGE_BUDGET}kb per image

**Instructions:** Adjust these targets based on your performance priority:
- **High Priority**: LCP ≤1.5s, CLS ≤0.05, API p95 ≤200ms
- **Medium Priority**: LCP ≤2.5s, CLS ≤0.10, API p95 ≤500ms
- **Low Priority**: LCP ≤4.0s, CLS ≤0.25, API p95 ≤1000ms

---

## Security Requirements

### Authentication & Authorization
- [ ] {AUTH_REQUIREMENT}
- [ ] {AUTH_REQUIREMENT}

**Examples:**
- [ ] Implement JWT with 15-minute access tokens and refresh token rotation
- [ ] Enforce role-based access control (RBAC) with least-privilege principle
- [ ] Require MFA for admin accounts

### Data Protection
- [ ] {DATA_PROTECTION_REQUIREMENT}
- [ ] {DATA_PROTECTION_REQUIREMENT}

**Examples:**
- [ ] Encrypt sensitive data at rest using AES-256
- [ ] Use TLS 1.3 for all data in transit
- [ ] Implement database-level encryption for PII fields

### Compliance
- **Regulations**: {COMPLIANCE_REQUIREMENTS}
- **Data Retention**: {RETENTION_POLICY}
- **Privacy Policy**: {PRIVACY_URL}

**Examples:**
- **Regulations**: GDPR, CCPA
- **Data Retention**: User data deleted within 30 days of account deletion
- **Privacy Policy**: https://example.com/privacy

### Security Practices
- [ ] Regular dependency vulnerability scanning
- [ ] Automated security testing in CI/CD
- [ ] Input validation and sanitization for all user inputs
- [ ] Rate limiting on all public endpoints
- [ ] OWASP Top 10 mitigation strategies implemented

---

## Constraints & Trade-offs

### Technical Constraints
- {CONSTRAINT}: {Reason and impact}

**Examples:**
- **No Server-Side Sessions**: Stateless architecture required for horizontal scaling
- **PostgreSQL Only**: Team expertise, existing infrastructure
- **Max Response Size**: 5MB to ensure mobile compatibility

### Resource Constraints
- **Team Size**: {N} developers
- **Budget**: {BUDGET}
- **Timeline**: {TIMELINE}

### Known Limitations
- {LIMITATION}: {Why this is acceptable}

**Example:**
- **Real-time Updates Delayed by 5s**: Polling instead of WebSockets to reduce infrastructure complexity in v1.0. Will migrate to WebSockets in v2.0.

---

## Architecture Principles

### Design Decisions
- {PRINCIPLE}: {Rationale}

**Examples:**
- **API-First Design**: Frontend and backend developed independently with OpenAPI contract
- **Event-Driven Architecture**: Decouple services using message queue for scalability
- **Repository Pattern**: Abstract data layer for easier testing and future database migrations

### Code Quality Standards
- **Test Coverage**: ≥80% lines, ≥75% branches
- **Linting**: {LINTER} with zero tolerance for errors
- **Type Safety**: {TYPE_SYSTEM} strict mode enabled
- **Documentation**: All public APIs documented with examples

---

## Quality Assurance & Testing Strategy

### Test Case Documentation Standards

**IMPORTANT:** All features must document:
1. **Test Cases** - What will be tested
2. **Expected Results** - What should happen
3. **Actual Results** - What actually happened during implementation
4. **Pass/Fail Status** - Whether test passed

Each feature directory (`.claude/features/{feature-id}/`) will contain:
- `test-plan.md` - Planned test cases before implementation
- `test-results.md` - Actual test results after implementation

### Testing Levels

#### 1. Unit Testing
**Framework:** {UNIT_TEST_FRAMEWORK}

**Standards:**
- One test file per source file (`file.ts` → `file.test.ts`)
- Minimum 80% line coverage, 75% branch coverage
- Test pure functions with multiple input scenarios
- Mock external dependencies
- Fast execution (< 100ms per test)

**Example Test Case Documentation:**
```markdown
### Test Case: UT-001 - User Email Validation
**Function:** `validateEmail(email: string): boolean`
**Test Cases:**
1. Valid email formats
2. Invalid email formats (missing @, no domain, etc.)
3. Edge cases (empty string, null, undefined)

**Expected Results:**
- Valid emails return `true`
- Invalid emails return `false`
- Edge cases handled gracefully (no crashes)

**Actual Results:** ✅ PASS
- All 15 test cases passed
- Coverage: 100% lines, 100% branches
- Execution time: 45ms
```

#### 2. Integration Testing
**Framework:** {INTEGRATION_TEST_FRAMEWORK}

**Standards:**
- Test interactions between modules/services
- Use test database (not production)
- Test API endpoints with real HTTP requests
- Verify database transactions
- Test authentication/authorization flows

**Example Test Case Documentation:**
```markdown
### Test Case: IT-002 - User Registration Flow
**Scenario:** Complete user registration from form submission to database entry

**Test Steps:**
1. POST /api/auth/register with valid user data
2. Verify response status 201
3. Check user exists in database
4. Verify password is hashed (not plaintext)
5. Verify email confirmation sent

**Expected Results:**
- API returns 201 with user object (no password)
- User record exists in `users` table
- Password field contains bcrypt hash
- Email sent to user's email address

**Actual Results:** ✅ PASS
- All assertions passed
- Response time: 245ms (within 500ms budget)
- Email sent successfully to test inbox
```

#### 3. End-to-End Testing
**Framework:** {E2E_TEST_FRAMEWORK}

**Standards:**
- Test complete user workflows
- Run in browser automation (Playwright, Cypress, etc.)
- Test critical paths only (not exhaustive)
- Run in CI before deployment

**Example Test Case Documentation:**
```markdown
### Test Case: E2E-003 - Task Creation and Assignment
**User Story:** As a project manager, I can create a task and assign it to a team member

**Test Steps:**
1. Login as project manager
2. Navigate to Tasks page
3. Click "New Task" button
4. Fill form: title, description, assignee, due date
5. Click "Create Task"
6. Verify task appears in task list
7. Verify assignee receives notification

**Expected Results:**
- Task created successfully
- Task visible in task list with correct data
- Assignee receives email notification
- Page redirects to task detail view

**Actual Results:** ✅ PASS
- Task created in 1.2s
- All fields correctly saved
- Email notification sent (verified in Mailhog)
- Redirect worked as expected
```

#### 4. Performance Testing
**Tools:** {PERFORMANCE_TEST_TOOLS}

**Standards:**
- Load testing for peak traffic scenarios
- Stress testing to find breaking points
- Measure response times (p50, p95, p99)
- Test database query performance

**Example Test Case Documentation:**
```markdown
### Test Case: PERF-004 - API Endpoint Performance Under Load
**Endpoint:** GET /api/tasks
**Load:** 1000 concurrent users, 10 requests per second

**Expected Results:**
- p95 response time ≤ 500ms
- p99 response time ≤ 1000ms
- 0% error rate
- Database connection pool stable (< 80% utilization)

**Actual Results:** ⚠️ PARTIAL PASS
- p95: 450ms ✅
- p99: 1200ms ❌ (exceeded by 200ms)
- Error rate: 0.2% (2 timeouts) ❌
- DB pool: 65% utilization ✅

**Action Items:**
- Add database query index on `tasks.user_id`
- Implement Redis caching for frequently accessed tasks
- Retest after optimization
```

#### 5. Security Testing
**Tools:** {SECURITY_TEST_TOOLS}

**Standards:**
- OWASP Top 10 vulnerability testing
- Dependency vulnerability scanning
- Penetration testing for critical features
- Authentication/authorization testing

**Example Test Case Documentation:**
```markdown
### Test Case: SEC-005 - SQL Injection Prevention
**Target:** All database queries

**Test Cases:**
1. Inject SQL in login form
2. Inject SQL in search parameters
3. Inject SQL in URL parameters
4. Test with parameterized queries

**Expected Results:**
- All SQL injection attempts fail
- No database errors exposed to user
- All queries use parameterized statements

**Actual Results:** ✅ PASS
- All 50 injection attempts blocked
- Error messages sanitized
- Prisma ORM prevents raw SQL injection
```

### Test Execution Strategy

#### Pre-Commit Testing
Run automatically via git hooks:
```bash
npm run lint        # Linting
npm run type-check  # TypeScript checks
npm run test:unit   # Unit tests (fast)
```

#### Pre-Push Testing
Run before pushing to remote:
```bash
npm run test:integration  # Integration tests
npm run test:coverage     # Coverage report
```

#### CI/CD Testing Pipeline
Run on every pull request:
```yaml
1. Lint & Type Check
2. Unit Tests (all)
3. Integration Tests (all)
4. E2E Tests (critical paths)
5. Performance Tests (smoke)
6. Security Scans (dependencies)
7. Build Verification
```

#### Pre-Deployment Testing
Run before production deployment:
```bash
npm run test:e2e:full      # All E2E tests
npm run test:performance   # Load testing
npm run security:scan      # Security audit
```

### Test Results Tracking

**Location:** `.claude/features/{feature-id}/test-results.md`

**Format:**
```markdown
# Test Results: {Feature Name}

**Feature ID:** {feature-id}
**Test Date:** {DATE}
**Tested By:** {NAME/LLM}
**Test Environment:** {ENV}

## Summary
- **Total Test Cases:** 45
- **Passed:** 42 ✅
- **Failed:** 2 ❌
- **Skipped:** 1 ⏭️
- **Overall Status:** ⚠️ NEEDS FIXES

## Unit Tests
| Test ID | Description | Expected | Actual | Status |
|---------|-------------|----------|--------|--------|
| UT-001 | Email validation | Valid/Invalid detection | All cases passed | ✅ PASS |
| UT-002 | Password hashing | Bcrypt hash returned | Hash returned | ✅ PASS |
| UT-003 | Token generation | JWT token generated | Token valid | ✅ PASS |

## Integration Tests
| Test ID | Description | Expected | Actual | Status |
|---------|-------------|----------|--------|--------|
| IT-001 | User registration | 201 + user object | 201 returned | ✅ PASS |
| IT-002 | Login flow | JWT token returned | Token expired | ❌ FAIL |
| IT-003 | Password reset | Email sent | Email sent | ✅ PASS |

## E2E Tests
| Test ID | Description | Expected | Actual | Status |
|---------|-------------|----------|--------|--------|
| E2E-001 | Complete signup | User created | User created | ✅ PASS |
| E2E-002 | Task creation | Task in DB | Task in DB | ✅ PASS |

## Performance Tests
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| p95 Response Time | ≤500ms | 450ms | ✅ PASS |
| p99 Response Time | ≤1000ms | 1200ms | ❌ FAIL |
| Error Rate | 0% | 0.2% | ⚠️ WARN |

## Failures & Action Items

### IT-002: Login Flow Token Expiry (CRITICAL)
**Issue:** JWT token expires immediately after generation
**Root Cause:** `expiresIn` config set to 0 instead of "15m"
**Fix:** Update `auth.config.ts` line 12
**Assignee:** {NAME}
**Target:** {DATE}

### PERF: p99 Response Time Exceeded
**Issue:** 99th percentile exceeds budget by 200ms
**Root Cause:** Database query without index
**Fix:** Add index on `tasks.user_id`
**Assignee:** {NAME}
**Target:** {DATE}

## Test Coverage Report
```
File                | % Stmts | % Branch | % Funcs | % Lines |
--------------------|---------|----------|---------|---------|
All files           |   82.5  |   76.3   |   85.1  |   82.1  |
 auth/              |   95.2  |   88.4   |   100   |   94.8  |
  login.ts          |   100   |   100    |   100   |   100   |
  register.ts       |   92.3  |   80.0   |   100   |   91.7  |
 tasks/             |   78.1  |   70.2   |   80.0  |   77.9  |
  create.ts         |   85.0  |   75.0   |   100   |   84.6  |
  list.ts           |   72.5  |   66.7   |   66.7  |   72.2  |
```

**Coverage Status:** ✅ MEETS THRESHOLD (≥80% lines, ≥75% branches)

## Sign-Off

- [ ] All critical tests pass
- [ ] Test coverage meets requirements (≥80%)
- [ ] Performance budgets met
- [ ] Security tests pass
- [ ] No known blockers

**Approved By:** {NAME}
**Approval Date:** {DATE}
```

### Regression Testing

**Trigger:** Before every release and when fixing bugs

**Process:**
1. Run full test suite (unit + integration + E2E)
2. Verify no previously passing tests now fail
3. Document any new failures
4. Fix regressions before release

---

## Acceptance Criteria & Definition of Done

### Feature Acceptance Criteria Template

For each feature, define clear acceptance criteria:

```markdown
## Acceptance Criteria: {Feature Name}

### Functional Requirements (Must Have)
- [ ] FR-1: User can {action} by {method}
- [ ] FR-2: System responds with {expected behavior}
- [ ] FR-3: Data is persisted to {storage}

### Non-Functional Requirements
- [ ] NFR-1: Response time ≤ {time}
- [ ] NFR-2: Handles {n} concurrent users
- [ ] NFR-3: Accessible (WCAG {level})

### Edge Cases
- [ ] EC-1: Handles empty input gracefully
- [ ] EC-2: Validates malformed data
- [ ] EC-3: Prevents duplicate entries

### Success Criteria
- [ ] SC-1: All unit tests pass (coverage ≥80%)
- [ ] SC-2: Integration tests pass
- [ ] SC-3: Manual testing completed
- [ ] SC-4: Code review approved
- [ ] SC-5: Documentation updated
```

### Definition of Done (DoD)

A feature is considered "Done" when ALL criteria are met:

#### Code Complete
- [ ] All functionality implemented per spec
- [ ] Code follows style guide and passes linter
- [ ] No compiler errors or warnings
- [ ] Type safety enforced (if applicable)

#### Testing Complete
- [ ] Unit tests written and passing (≥80% coverage)
- [ ] Integration tests written and passing
- [ ] E2E tests written and passing (critical paths)
- [ ] Manual testing performed and documented
- [ ] Regression testing shows no broken existing features

#### Documentation Complete
- [ ] Code comments added for complex logic
- [ ] API documentation updated
- [ ] User-facing documentation updated (if applicable)
- [ ] CLAUDE.md updated with new files/structure
- [ ] Changelog entry added

#### Quality Assurance
- [ ] Code review completed and approved
- [ ] No high/critical security vulnerabilities
- [ ] Performance budgets met
- [ ] Accessibility requirements met (if applicable)
- [ ] Browser/device compatibility verified (if applicable)

#### Deployment Ready
- [ ] Feature flag implemented (if needed)
- [ ] Database migrations created and tested
- [ ] Environment variables documented
- [ ] CI/CD pipeline passes all checks
- [ ] Staging environment tested

#### Sign-Off
- [ ] Product owner approval (if required)
- [ ] Stakeholder demo completed (if required)
- [ ] Feature marked complete in manifest

**DoD Checklist Enforcement:** Run `/feature verify {feature-id}` to automatically check DoD compliance.

---

## Feature Roadmap & Dependencies

### Features Overview

Track all features and their dependencies:

```markdown
- [x] 001-project-setup (COMPLETED 2024-01-15)
  - Depends on: None (foundation)
  - Blocks: ALL features

- [ ] 002-user-authentication (IN PROGRESS)
  - Depends on: 001-project-setup ✅
  - Blocks: 003-appointments, 004-member-management
  - Status: ⏳ In development

- [ ] 003-appointments-management (BLOCKED)
  - Depends on: 001-project-setup ✅, 002-user-authentication ❌
  - Status: 🚫 Blocked by 002
```

**Status Icons:**
- ✅ Completed
- ⏳ In Progress
- 🚫 Blocked
- ⏸️  Paused
- 📋 Planned

### Dependency Rules

**IMPORTANT:** `/feature` command checks dependencies before allowing new features:

```bash
/feature "appointments management"

❌ ERROR: Feature dependencies not met
   Required: 002-user-authentication (❌ not complete)

   Complete blocking features first:
   1. /feature implement 002-user-authentication
   2. /feature verify 002-user-authentication
   3. /manifest update (mark 002 complete)
```

---

## Feature Development Workflow

This project uses **SpecFlow** for feature development:

### Creating a New Feature
```bash
/feature "Feature description"
```

This will guide you through:
1. **Ideation**: Gather requirements and create spec
2. **Gap Analysis**: Identify spec gaps and conflicts
3. **Planning**: Create technical design
4. **Task Breakdown**: Generate TDD-focused task list (RED → GREEN → REFACTOR)
5. **Implementation**: Follow task list
6. **Verification**: Run `/feature verify {feature-id}`

### Verifying Implementation
```bash
/feature verify {feature-id}
```

Verification checks:
- Task completion (20% weight)
- Test coverage (20% weight)
- Functional requirements (15% weight)
- Non-functional requirements (15% weight)
- Success criteria (10% weight)
- Manifest alignment (10% weight)
- Code quality (5% weight)
- Documentation (5% weight)

**Pass Criteria:** ≥80/100 overall score, all critical requirements met

### Updating Manifest
When a feature is verified and merged, update this manifest:

```bash
/manifest update
```

Mark the feature as complete:
```markdown
- [X] Feature Name (feature-id) ✅ Completed {DATE}
```

---

## Open Questions & Clarifications

**Status:** See `.claude/questions.md` for detailed tracking

### Critical Questions (Blocking Development)
{LIST_CRITICAL_QUESTIONS}

**Instructions:** List any critical questions that must be resolved before feature development. Full details in `.claude/questions.md`.

**Example:**
- 🔴 Q1: Authentication strategy not finalized (OAuth vs JWT vs sessions)
- 🔴 Q3: Third-party payment gateway selection pending

### Readiness Checklist

Before starting feature development, ensure:

- [ ] **Vision Clarity**: Project vision is clearly articulated (2-3 sentences)
- [ ] **Business Goals Defined**: At least 3 measurable business goals documented
- [ ] **Users Identified**: Primary users and their needs are defined
- [ ] **Core Features Listed**: At least 3 must-have features identified for v1.0
- [ ] **Tech Stack Decided**: Frontend, backend, database, and testing frameworks chosen
- [ ] **Deployment Target Known**: Hosting platform and environment strategy defined
- [ ] **Performance Priorities Set**: Performance budgets defined based on priority level
- [ ] **Security Requirements Clear**: Auth, data protection, and compliance needs documented
- [ ] **Critical Questions Resolved**: No blocking questions remain in `.claude/questions.md`
- [ ] **First Feature Ready**: First feature idea identified for `/feature` command

**Readiness Score:** {X}/10 items completed

**Status:**
- ✅ **Ready** (10/10) - Start feature development with `/feature`
- ⚠️ **Mostly Ready** (7-9/10) - Review incomplete items, decide if blockers
- 🚫 **Not Ready** (<7/10) - Complete remaining items before `/feature`

---

## Change Log

### v1.0.0 (Target: {TARGET_DATE})
- Initial release with core features

### Decision Log
**{DATE}** - {Decision made and rationale}

**Example:**
**2024-01-15** - Chose PostgreSQL over MongoDB for strong relational data integrity requirements in task dependencies

---

## Maintenance Notes

### Regular Reviews
- **Monthly**: Review feature progress, update completion status
- **Quarterly**: Review performance budgets, adjust if needed
- **Major Changes**: Document all tech stack changes and architectural decisions

### Contact
- **Technical Questions**: {CONTACT}
- **Product Questions**: {CONTACT}

---

**Note**: This manifest is the source of truth for project requirements and constraints. All features created with `/feature` will reference this manifest to ensure alignment with project goals and technical standards.

**Last Review:** {DATE}
**Next Review:** {NEXT_REVIEW_DATE}
