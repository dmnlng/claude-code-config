# Test Plan: {FEATURE_NAME}

**Feature ID:** {FEATURE_ID}
**Created:** {DATE}
**Author:** {AUTHOR}
**Status:** Draft

---

## Test Strategy Overview

### Testing Objectives
- {OBJECTIVE_1}
- {OBJECTIVE_2}
- {OBJECTIVE_3}

**Example:**
- Verify all user authentication flows work correctly
- Ensure data validation prevents invalid inputs
- Confirm API responses match specification
- Validate performance meets requirements (≤500ms response time)

### Test Scope

#### In Scope
- {SCOPE_ITEM_1}
- {SCOPE_ITEM_2}

**Example:**
- User registration with email/password
- Login with valid/invalid credentials
- JWT token generation and validation
- Password reset flow
- Session management

#### Out of Scope
- {OUT_OF_SCOPE_1}
- {OUT_OF_SCOPE_2}

**Example:**
- OAuth integration (planned for v2.0)
- Multi-factor authentication (future feature)
- Load testing beyond 1000 concurrent users

### Test Environment
- **Development:** {DEV_ENV_DETAILS}
- **Testing:** {TEST_ENV_DETAILS}
- **CI/CD:** {CI_DETAILS}

**Example:**
- **Development:** Local PostgreSQL 14, Node.js 20, Next.js 14
- **Testing:** Docker containers (postgres:14, node:20-alpine)
- **CI/CD:** GitHub Actions with test database

---

## Unit Tests

### UT-001: {Test Name}
**Component:** {Component/Function Name}
**Priority:** 🔴 Critical / 🟡 Important / 🟢 Nice-to-have

**Description:**
{Brief description of what this test validates}

**Test Cases:**
1. {Test case 1 description}
2. {Test case 2 description}
3. {Test case 3 description}

**Expected Results:**
- {Expected result 1}
- {Expected result 2}
- {Expected result 3}

**Acceptance Criteria:**
- [ ] All test cases pass
- [ ] Code coverage ≥80%
- [ ] No console errors/warnings
- [ ] Execution time <100ms

---

### UT-002: {Test Name}
**Component:** {Component/Function Name}
**Priority:** 🔴 Critical

**Description:**
{Brief description}

**Test Cases:**
1. {Test case 1}
2. {Test case 2}

**Expected Results:**
- {Expected result 1}
- {Expected result 2}

**Acceptance Criteria:**
- [ ] All test cases pass
- [ ] Code coverage ≥80%

---

**Example Unit Test:**

### UT-001: Email Validation
**Component:** `utils/validation.ts` - `validateEmail()`
**Priority:** 🔴 Critical

**Description:**
Validates that the email validation function correctly identifies valid and invalid email formats according to RFC 5322 standard.

**Test Cases:**
1. Valid email formats (simple, with subdomains, with special chars)
2. Invalid formats (missing @, no domain, spaces, multiple @)
3. Edge cases (empty string, null, undefined, very long email)
4. International domains (unicode, punycode)

**Expected Results:**
- Valid emails return `true`
- Invalid emails return `false`
- Edge cases handled gracefully (no exceptions thrown)
- International domains supported

**Acceptance Criteria:**
- [ ] All 20+ test cases pass
- [ ] Code coverage 100%
- [ ] No console errors
- [ ] Execution time <50ms

---

## Integration Tests

### IT-001: {Test Name}
**Feature:** {Feature Name}
**Priority:** 🔴 Critical / 🟡 Important / 🟢 Nice-to-have

**Description:**
{Brief description of integration scenario}

**Test Steps:**
1. {Step 1}
2. {Step 2}
3. {Step 3}
4. {Step 4}

**Expected Results:**
- {Expected result 1}
- {Expected result 2}
- {Expected result 3}

**Acceptance Criteria:**
- [ ] All steps complete successfully
- [ ] Response time ≤{target}ms
- [ ] Database state is correct
- [ ] No side effects on other features

**Dependencies:**
- {Required service/database/API}
- {Test data fixtures}

---

### IT-002: {Test Name}
**Feature:** {Feature Name}
**Priority:** 🟡 Important

**Description:**
{Brief description}

**Test Steps:**
1. {Step 1}
2. {Step 2}

**Expected Results:**
- {Expected result 1}

**Acceptance Criteria:**
- [ ] All steps complete

---

**Example Integration Test:**

### IT-001: User Registration Flow
**Feature:** User Authentication
**Priority:** 🔴 Critical

**Description:**
Tests the complete user registration flow from form submission to database persistence and email confirmation.

**Test Steps:**
1. POST `/api/auth/register` with valid user data (email, password, name)
2. Verify response status is 201 Created
3. Verify response body contains user object (without password)
4. Query database to confirm user record exists
5. Verify password is hashed (bcrypt format)
6. Check email service for confirmation email
7. Verify JWT token is included in response

**Expected Results:**
- API returns 201 status code
- Response includes: `{ id, email, name, createdAt }` (no password)
- User record exists in `users` table
- Password field contains bcrypt hash (starts with `$2b$`)
- Email sent to user's address with confirmation link
- JWT token is valid and contains user ID
- Response time ≤500ms

**Acceptance Criteria:**
- [ ] All 7 steps pass
- [ ] Response time ≤500ms (p95)
- [ ] Database transaction completes
- [ ] Email sends successfully
- [ ] No sensitive data in logs

**Dependencies:**
- PostgreSQL test database
- SMTP test server (Mailhog/Ethereal)
- Test fixtures: None (creates new user)

---

## End-to-End Tests

### E2E-001: {Test Name}
**User Story:** As a {user type}, I can {action} so that {benefit}
**Priority:** 🔴 Critical / 🟡 Important / 🟢 Nice-to-have

**Description:**
{Brief description of user workflow}

**Test Steps:**
1. {User action 1}
2. {User action 2}
3. {User action 3}
4. {Verification step}

**Expected Results:**
- {Expected UI behavior 1}
- {Expected data change 1}
- {Expected notification/feedback}

**Acceptance Criteria:**
- [ ] User completes workflow successfully
- [ ] UI updates reflect changes
- [ ] Data persisted correctly
- [ ] No JavaScript errors in console

**Browser/Device Coverage:**
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

---

**Example E2E Test:**

### E2E-001: Complete User Signup and Login Flow
**User Story:** As a new user, I can sign up and log in so that I can access my account
**Priority:** 🔴 Critical

**Description:**
Tests the complete user journey from visiting the landing page, signing up for an account, receiving confirmation email, and logging in.

**Test Steps:**
1. Navigate to homepage (`/`)
2. Click "Sign Up" button
3. Fill registration form (email: `test@example.com`, password: `SecurePass123!`, name: `Test User`)
4. Click "Create Account" button
5. Verify redirect to `/dashboard` or confirmation page
6. Check email inbox for confirmation email
7. Click confirmation link in email
8. Verify account is activated
9. Log out
10. Log back in with same credentials
11. Verify redirect to `/dashboard`
12. Verify user name appears in header

**Expected Results:**
- Sign up form validates inputs
- Account created successfully (success message shown)
- Redirect to dashboard after signup
- Confirmation email received within 5 seconds
- Email contains valid confirmation link
- Clicking link activates account
- Login succeeds with correct credentials
- Dashboard loads with user data
- User name visible in navigation

**Acceptance Criteria:**
- [ ] All 12 steps complete without errors
- [ ] Total flow time <30 seconds
- [ ] UI is responsive and accessible
- [ ] No JavaScript console errors
- [ ] Works across all target browsers

**Browser/Device Coverage:**
- [ ] Chrome 120+ (desktop)
- [ ] Firefox 120+ (desktop)
- [ ] Safari 17+ (desktop)
- [ ] Mobile Safari iOS 16+
- [ ] Chrome Mobile Android 13+

---

## Performance Tests

### PERF-001: {Test Name}
**Component/Endpoint:** {API endpoint or component}
**Priority:** 🔴 Critical / 🟡 Important / 🟢 Nice-to-have

**Description:**
{Brief description of performance test}

**Test Parameters:**
- **Load:** {number} concurrent users
- **Duration:** {time}
- **Ramp-up:** {time}

**Metrics to Measure:**
- Response time (p50, p95, p99)
- Throughput (requests/second)
- Error rate
- Resource utilization (CPU, memory, DB connections)

**Expected Results:**
- p95 response time ≤{target}ms
- p99 response time ≤{target}ms
- Error rate ≤{target}%
- Throughput ≥{target} req/s

**Acceptance Criteria:**
- [ ] p95 within budget
- [ ] p99 within budget
- [ ] Error rate acceptable
- [ ] No memory leaks
- [ ] Database connections stable

---

**Example Performance Test:**

### PERF-001: API Endpoint Load Test
**Component/Endpoint:** `GET /api/tasks`
**Priority:** 🔴 Critical

**Description:**
Measures API performance under realistic load to ensure response times meet SLA requirements.

**Test Parameters:**
- **Load:** 1000 concurrent users
- **Duration:** 5 minutes
- **Ramp-up:** 30 seconds (0 → 1000 users)
- **Request rate:** 10 requests/second per user

**Metrics to Measure:**
- Response time (p50, p95, p99)
- Throughput (total requests/second)
- Error rate (4xx, 5xx)
- Database query time
- Database connection pool usage
- API server CPU/memory usage

**Expected Results:**
- p50 response time ≤200ms
- p95 response time ≤500ms
- p99 response time ≤1000ms
- Error rate ≤0.1%
- Throughput ≥8000 req/s
- DB connection pool <80% utilization

**Acceptance Criteria:**
- [ ] p95 ≤500ms (critical)
- [ ] p99 ≤1000ms (critical)
- [ ] Error rate ≤0.1%
- [ ] No server crashes
- [ ] No database connection exhaustion
- [ ] Memory usage stable (no leaks)

---

## Security Tests

### SEC-001: {Test Name}
**Category:** {Authentication / Authorization / Data Protection / etc.}
**Priority:** 🔴 Critical / 🟡 Important / 🟢 Nice-to-have

**Description:**
{Brief description of security test}

**Test Cases:**
1. {Security test case 1}
2. {Security test case 2}
3. {Security test case 3}

**Expected Results:**
- {Security expectation 1}
- {Security expectation 2}

**Acceptance Criteria:**
- [ ] All attack vectors blocked
- [ ] Sensitive data protected
- [ ] Error messages don't leak info
- [ ] Audit logs capture attempts

---

**Example Security Test:**

### SEC-001: SQL Injection Prevention
**Category:** Data Protection / Injection Attacks
**Priority:** 🔴 Critical

**Description:**
Tests all database query entry points to ensure SQL injection attacks are prevented.

**Test Cases:**
1. Inject SQL in login form (email field, password field)
2. Inject SQL in search parameters (`?search='; DROP TABLE users;--`)
3. Inject SQL in URL parameters (`/users/1' OR '1'='1`)
4. Inject SQL in JSON body fields
5. Test with various SQL injection payloads (UNION, blind injection, time-based)
6. Verify parameterized queries used throughout codebase

**Expected Results:**
- All SQL injection attempts fail (no execution)
- Database errors not exposed to user
- Generic error messages returned ("Invalid input")
- All queries use ORM or parameterized statements
- Audit log captures injection attempts
- No data leakage from error responses

**Acceptance Criteria:**
- [ ] All 50+ injection payloads blocked
- [ ] Zero successful injections
- [ ] Error messages sanitized
- [ ] Code review confirms parameterized queries
- [ ] Prisma ORM prevents raw SQL injection
- [ ] WAF rules (if applicable) block common patterns

---

## Regression Tests

### REG-001: {Feature Name} Regression
**Original Feature:** {Feature ID and name}
**Priority:** 🟡 Important

**Description:**
Ensures that {feature} still works after recent changes to {related feature}.

**Test Cases:**
1. {Regression test case 1}
2. {Regression test case 2}

**Expected Results:**
- {Feature still works as before}
- {No broken functionality}

**Acceptance Criteria:**
- [ ] All original tests still pass
- [ ] No performance degradation
- [ ] No new bugs introduced

---

## Test Data Requirements

### Test Users
```json
{
  "admin_user": {
    "email": "admin@test.com",
    "password": "AdminPass123!",
    "role": "ADMIN"
  },
  "regular_user": {
    "email": "user@test.com",
    "password": "UserPass123!",
    "role": "USER"
  },
  "test_user_new": {
    "email": "newuser@test.com",
    "password": "NewPass123!",
    "role": "USER"
  }
}
```

### Test Database Fixtures
- {Fixture 1}: {Description}
- {Fixture 2}: {Description}

**Example:**
- `users.sql`: 10 test users with various roles
- `tasks.sql`: 50 sample tasks assigned to test users
- `auth_tokens.sql`: Valid and expired JWT tokens

### External Service Mocks
- {Service 1}: {Mock strategy}
- {Service 2}: {Mock strategy}

**Example:**
- Email service: Use Mailhog for local testing, Ethereal for CI
- Payment gateway: Use Stripe test mode with test cards
- External API: Use MSW (Mock Service Worker) with predefined responses

---

## Test Execution Schedule

### Phase 1: Unit Tests (Continuous)
- **When:** On every commit (git hooks)
- **Duration:** <2 minutes
- **Pass Criteria:** 100% pass, coverage ≥80%

### Phase 2: Integration Tests (Pre-Push)
- **When:** Before pushing to remote
- **Duration:** <5 minutes
- **Pass Criteria:** 100% pass

### Phase 3: E2E Tests (CI/CD)
- **When:** On pull request
- **Duration:** <15 minutes
- **Pass Criteria:** All critical paths pass

### Phase 4: Performance Tests (Nightly)
- **When:** Daily at 2 AM
- **Duration:** <30 minutes
- **Pass Criteria:** All metrics within budget

### Phase 5: Security Scan (Weekly)
- **When:** Every Sunday
- **Duration:** <1 hour
- **Pass Criteria:** No high/critical vulnerabilities

---

## Test Metrics & Reporting

### Success Criteria
- **Unit Tests:** 100% pass, ≥80% coverage
- **Integration Tests:** 100% pass
- **E2E Tests:** ≥95% pass (allow flaky test retries)
- **Performance Tests:** All metrics within budget
- **Security Tests:** Zero critical vulnerabilities

### Exit Criteria
A feature is ready for production when:
- [ ] All critical tests pass (🔴 priority)
- [ ] All important tests pass (🟡 priority)
- [ ] Test coverage ≥80%
- [ ] No high/critical security issues
- [ ] Performance budgets met
- [ ] Regression tests pass

### Test Report Location
- **Test Results:** `.claude/features/{FEATURE_ID}/test-results.md`
- **Coverage Report:** `coverage/lcov-report/index.html`
- **Performance Report:** `.claude/features/{FEATURE_ID}/performance-report.json`

---

## Risk Assessment

### High Risk Areas
- {Risk 1}: {Mitigation strategy}
- {Risk 2}: {Mitigation strategy}

**Example:**
- **Payment Processing:** Extra validation, test with Stripe test mode, manual verification
- **Password Reset:** Rate limiting, email verification, security audit
- **Data Migration:** Backup database, rollback plan, test on staging first

### Known Limitations
- {Limitation 1}
- {Limitation 2}

**Example:**
- Email delivery times may vary (5-60 seconds)
- Performance tests limited to 1000 concurrent users (infrastructure constraint)
- E2E tests don't cover mobile app (web only in v1.0)

---

## Approval & Sign-Off

- [ ] Test plan reviewed by tech lead
- [ ] Test plan approved by product owner
- [ ] Test environment set up and verified
- [ ] Test data prepared
- [ ] Ready to begin testing

**Reviewed By:** {NAME}
**Approved By:** {NAME}
**Approval Date:** {DATE}

---

**Next Steps:**
1. Set up test environment
2. Create test fixtures and mock data
3. Implement tests according to plan
4. Execute tests and document results in `test-results.md`
5. Fix any failures and retest
6. Generate final test report
