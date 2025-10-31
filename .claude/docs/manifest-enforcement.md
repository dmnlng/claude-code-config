# Manifest Enforcement Guidelines

## Overview

The manifest (`manifest.md`) defines the **contract** for your project. This document explains how to enforce manifest requirements throughout development.

---

## What Gets Enforced

### 1. Performance Budgets

**From manifest.md:**
```markdown
## Performance Requirements
- Page Load (LCP): ≤ 2.5 seconds
- API Response Time: ≤ 500ms
- Time to Interactive (TTI): ≤ 3.5 seconds
```

**Enforcement Methods:**

**Local (Development):**
```bash
# Run Lighthouse audit
npm install -g @lhci/cli
lhci autorun

# Check against budgets
./.claude/scripts/check-performance.sh
```

**CI/CD (Automated):**
```yaml
# .github/workflows/performance.yml
name: Performance Budget

on: [pull_request]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
          budgetPath: ./lighthouse-budget.json
          uploadArtifacts: true
```

**lighthouse-budget.json:**
```json
{
  "timings": [
    {
      "metric": "largest-contentful-paint",
      "budget": 2500
    },
    {
      "metric": "interactive",
      "budget": 3500
    }
  ],
  "resourceSizes": [
    {
      "resourceType": "script",
      "budget": 300
    }
  ]
}
```

---

### 2. Security Requirements

**From manifest.md:**
```markdown
## Security Requirements
- User authentication (JWT/OAuth)
- Role-Based Access Control
- Data encryption at rest and in transit
- OWASP Top 10 mitigation
```

**Enforcement Methods:**

**Local:**
```bash
# Security audit
npm audit --audit-level=high

# Check security headers
./.claude/scripts/check-security-headers.sh
```

**CI/CD:**
```yaml
# .github/workflows/security.yml
name: Security Audit

on: [pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm audit --audit-level=high
      - run: npm run security:check
```

---

### 3. Test Coverage Requirements

**From manifest.md:**
```markdown
## Code Quality Standards
- Test Coverage: ≥80% lines, ≥75% branches
```

**Enforcement:**

**package.json:**
```json
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "lines": 80,
        "branches": 75,
        "functions": 75,
        "statements": 80
      }
    }
  }
}
```

**CI/CD:**
```yaml
test:
  runs-on: ubuntu-latest
  steps:
    - run: npm test -- --coverage
    - run: npm run test:threshold
```

---

### 4. Accessibility (WCAG 2.1 Level AA)

**From manifest.md:**
```markdown
## Technical Constraints
- Accessibility: WCAG 2.1 Level AA compliance
```

**Enforcement:**

**Local:**
```bash
# Lighthouse accessibility audit
lhci autorun --collect.settings.onlyCategories=accessibility

# Axe accessibility testing
npm run test:a11y
```

**CI/CD:**
```yaml
accessibility:
  steps:
    - run: npm run test:a11y
    - uses: treosh/lighthouse-ci-action@v9
      with:
        onlyCategories: accessibility
```

---

## CI/CD Pipeline Structure

### Complete `.github/workflows/manifest-enforcement.yml`

```yaml
name: Manifest Enforcement

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  performance:
    name: Performance Budgets
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run build
      - run: npm run start & npx wait-on http://localhost:3000
      - uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
          budgetPath: ./lighthouse-budget.json
          uploadArtifacts: true
      - name: Check Performance
        run: |
          if [ -f ".claude/scripts/check-performance.sh" ]; then
            ./.claude/scripts/check-performance.sh
          fi

  security:
    name: Security Audit
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm audit --audit-level=high
      - name: Check Security Headers
        run: |
          if [ -f ".claude/scripts/check-security-headers.sh" ]; then
            ./.claude/scripts/check-security-headers.sh
          fi

  tests:
    name: Test Coverage
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm test -- --coverage
      - name: Check Coverage Threshold
        run: npm run test:coverage

  accessibility:
    name: Accessibility (WCAG AA)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run build
      - run: npm run start & npx wait-on http://localhost:3000
      - uses: treosh/lighthouse-ci-action@v9
        with:
          urls: |
            http://localhost:3000
          onlyCategories: accessibility
      - name: Require Score ≥ 90
        run: |
          # Check Lighthouse score
          # Fail if < 90

  lint:
    name: Code Quality
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
```

---

## Feature Verification Integration

When running `/feature verify`, the script checks manifest alignment:

```bash
# .claude/scripts/verify-feature.sh

# Check performance budgets
if grep -q "Performance Requirements" manifest.md; then
  # Extract LCP target
  LCP_TARGET=$(grep -oP 'LCP.*≤\s*\K[0-9.]+' manifest.md || echo "2.5")

  # Run Lighthouse
  ACTUAL_LCP=$(run_lighthouse_and_extract_lcp)

  if [ "$ACTUAL_LCP" -gt "$LCP_TARGET" ]; then
    echo "❌ Performance budget violation: LCP $ACTUAL_LCP > $LCP_TARGET"
    SCORE=$((SCORE - 10))
  fi
fi

# Check security requirements
if grep -q "npm audit" manifest.md; then
  VULNS=$(npm audit --audit-level=high --json | jq '.metadata.vulnerabilities.high + .metadata.vulnerabilities.critical')
  if [ "$VULNS" -gt 0 ]; then
    echo "❌ Security vulnerabilities: $VULNS high/critical"
    SCORE=$((SCORE - 15))
  fi
fi

# Check test coverage
if grep -q "Test Coverage.*≥.*80" manifest.md; then
  COVERAGE=$(npm test -- --coverage --silent | grep -oP 'All files.*\K[0-9.]+' || echo "0")
  if [ "$(echo "$COVERAGE < 80" | bc)" -eq 1 ]; then
    echo "❌ Coverage below threshold: $COVERAGE% < 80%"
    SCORE=$((SCORE - 10))
  fi
fi
```

---

## Deployment Gates

### Example: Vercel Deployment with Checks

**vercel.json:**
```json
{
  "buildCommand": "npm run build && npm run verify:manifest",
  "framework": "nextjs"
}
```

**package.json:**
```json
{
  "scripts": {
    "verify:manifest": "bash ./.claude/scripts/verify-manifest-compliance.sh"
  }
}
```

**`.claude/scripts/verify-manifest-compliance.sh`:**
```bash
#!/bin/bash
# Verifies deployment meets manifest requirements

set -e

echo "Verifying manifest compliance before deployment..."

# Performance
npm run lighthouse:check || { echo "❌ Performance budget failed"; exit 1; }

# Security
npm audit --audit-level=high || { echo "❌ Security audit failed"; exit 1; }

# Tests
npm test -- --coverage || { echo "❌ Tests failed"; exit 1; }

# Accessibility
npm run a11y:check || { echo "❌ Accessibility failed"; exit 1; }

echo "✅ All manifest requirements met"
```

---

## Monitoring & Alerts

### Production Monitoring

**Setup:**
1. **Performance Monitoring**: Vercel Analytics, New Relic, Datadog
2. **Error Tracking**: Sentry
3. **Uptime Monitoring**: UptimeRobot, Pingdom

**Alert on Violations:**
- LCP > 2.5s → Slack alert
- API response time > 500ms → PagerDuty
- Error rate > 1% → Email + Slack

**Example: Sentry Integration**
```javascript
// sentry.config.js
Sentry.init({
  tracesSampleRate: 1.0,
  beforeSend(event) {
    // Check if error violates manifest
    // e.g., API timeout > 500ms
    if (event.type === 'transaction' && event.duration > 500) {
      // Alert team
      notifySlack('Manifest violation: API timeout');
    }
    return event;
  },
});
```

---

## Summary

**Enforcement Levels:**

1. **Local Development:**
   - Run `.claude/scripts/verify-feature.sh`
   - Pre-commit hooks (optional)

2. **CI/CD (Pull Requests):**
   - Automated checks on every PR
   - Blocks merge if failing

3. **Deployment Gates:**
   - Vercel/Netlify build checks
   - Fail deployment if budgets violated

4. **Production Monitoring:**
   - Real-time alerts
   - Dashboard tracking

**Result:**
Manifest becomes **enforced contract**, not just documentation.
