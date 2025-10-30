# Implementation Plan: {FEATURE_NAME}

**Feature ID:** {FEATURE_ID}
**Spec:** {FEATURE_ID}/spec.md
**Created:** {DATE}
**Status:** Draft

---

## Architecture

### Component Structure
```
{Show directory structure for this feature}
src/features/{feature-name}/
├── components/
├── services/
├── models/
├── api/
└── __tests__/
```

### Data Flow
1. {Step 1 of the user flow}
2. {Step 2}
3. {etc.}

### System Integration
- **Integrates with:** {Existing systems/features}
- **APIs consumed:** {External/internal APIs}
- **Events emitted:** {Event names and payloads}

---

## Tech Stack (from manifest.md)

- **Language:** {from manifest}
- **Framework:** {from manifest}
- **Database:** {from manifest}
- **Authentication:** {if applicable}
- **Testing:** {test frameworks}
- **Libraries:** {key dependencies}

---

## Test Strategy (TDD Approach)

### Unit Tests (Write FIRST - RED phase)
```typescript
describe('{Component/Service}', () => {
  it('should {behavior}')
  it('should {edge case}')
  it('should throw when {error condition}')
})
```

**Coverage Target:** ≥80% lines, ≥75% branches

### Integration Tests
```typescript
describe('{API Endpoint}', () => {
  it('should return 200 with valid data')
  it('should return 400 for invalid input')
  it('should handle {integration scenario}')
})
```

### E2E Tests (Playwright/Cypress)
```typescript
test('{User flow}', async ({ page }) => {
  // Full user journey test
})
```

**Test Data:**
- Use fixtures in `__tests__/fixtures/`
- Seed test database with `setup.sql`
- Mock external APIs with {mocking library}

---

## Data Model

```prisma
// or SQL/TypeScript/etc depending on stack
model {EntityName} {
  id           String   @id @default(uuid())
  {field}      {Type}
  {field}      {Type}
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt
}
```

### Relationships
- {Entity1} → {Entity2}: {relationship type}
- {Entity2} → {Entity3}: {relationship type}

### Indexes
- {field}: {reason for index}
- {compound index}: {reason}

### Migrations
- Migration: `{timestamp}_{description}.sql`
- Rollback strategy: {how to rollback}

---

## API Contracts

### {METHOD} {endpoint}

**Request:**
```json
{
  "field": "value"
}
```

**Response (2xx):**
```json
{
  "data": {},
  "meta": {}
}
```

**Errors:**
- 400: {error scenario}
- 401: {error scenario}
- 404: {error scenario}
- 500: {error scenario}

**Rate Limiting:** {requests per time period}
**Authentication:** {required/optional, method}

---

## Security Considerations

### Authentication & Authorization
- {How auth is handled}
- {Permission requirements}

### Input Validation
- {Validation rules}
- {Sanitization approach}

### Data Protection
- {Encryption at rest/in transit}
- {PII handling}

### Common Vulnerabilities
- **XSS:** {Mitigation}
- **CSRF:** {Mitigation}
- **SQLi:** {Mitigation}
- **Rate Limiting:** {Implementation}

---

## Performance Considerations

### Performance Targets (from manifest.md)
- Response time: p95 ≤ {X}ms
- Database queries: ≤ {N} per request
- Cache hit rate: ≥ {X}%

### Optimization Strategies
- {Caching approach}
- {Database query optimization}
- {Asset optimization}

### Monitoring
- Metrics to track: {list}
- Alerts on: {thresholds}

---

## Error Handling

### Error Classification
- **Client Errors (4xx):** {How to handle}
- **Server Errors (5xx):** {How to handle}
- **External Service Failures:** {Fallback strategy}

### Logging
- **Level:** {DEBUG/INFO/WARN/ERROR}
- **Format:** {structured/plain}
- **Sensitive Data:** {What NOT to log}

---

## Dependencies & Prerequisites

### Required Features
- {Feature} must be completed first
- {Service} must be available

### Environment Setup
```bash
# Commands to set up local environment
{commands}
```

### Third-Party Services
- {Service name}: {purpose, API key required?}
- {Service name}: {purpose, fallback if unavailable}

---

## Implementation Phases

### Phase 1: Setup & Foundation
- Tasks: T001-T00X
- Duration: {estimate}
- Deliverables: {what's ready}

### Phase 2: RED - Write Tests
- Tasks: T00X-T0XX
- Duration: {estimate}
- Deliverables: Failing test suite

### Phase 3: GREEN - Implementation
- Tasks: T0XX-T0XX
- Duration: {estimate}
- Deliverables: Passing tests, working feature

### Phase 4: REFACTOR - Optimization
- Tasks: T0XX-T0XX
- Duration: {estimate}
- Deliverables: Clean, optimized code

### Phase 5: Integration & Verification
- Tasks: T0XX-T0XX
- Duration: {estimate}
- Deliverables: E2E tests, documentation

---

## Deployment Strategy

### Database Changes
- Migrations: {list}
- Rollback plan: {procedure}
- Data migration: {if needed}

### Feature Flags
- Flag name: `{feature-flag-name}`
- Rollout: {gradual/instant}
- Rollback: {how to disable}

### Monitoring Post-Deploy
- Check: {metrics to watch}
- Alert on: {error conditions}
- Rollback trigger: {conditions}

---

## Documentation Requirements

- [ ] API documentation (OpenAPI/Swagger)
- [ ] User documentation (if user-facing)
- [ ] README updates
- [ ] CHANGELOG entry
- [ ] manifest.md update

---

## Open Questions

1. {Question that needs answering before implementation}
2. {Technical decision to be made}
3. {Clarification needed from stakeholders}

---

## Notes

{Additional context, design decisions, trade-offs, references}
