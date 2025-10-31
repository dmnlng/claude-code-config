# Project Manifest: {PROJECT_NAME}

**Project Type:** {PROJECT_TYPE}
**Created:** {DATE}
**Last Updated:** {DATE}
**Status:** Active

---

## Vision

> {VISION_PLACEHOLDER}
>
> **Instructions:** Replace this section with your project's high-level vision. What problem does this solve? What is the end goal? Keep it to 2-3 sentences that anyone can understand.

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
