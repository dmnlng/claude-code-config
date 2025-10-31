#!/bin/bash
# Feature Verification Script
# Performs automated verification of feature implementation against spec
# Usage: ./.claude/scripts/verify-feature.sh <feature-id>

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
FEATURE_ID="${1:-}"
FEATURE_DIR=".claude/features/${FEATURE_ID}"
SCORE=0
MAX_SCORE=0
ERRORS=()
WARNINGS=()
PASSED=()

# Helper Functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
    PASSED+=("$1")
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    WARNINGS+=("$1")
}

log_error() {
    echo -e "${RED}✗${NC} $1"
    ERRORS+=("$1")
}

add_score() {
    local points=$1
    SCORE=$((SCORE + points))
    MAX_SCORE=$((MAX_SCORE + points))
}

skip_score() {
    local points=$1
    MAX_SCORE=$((MAX_SCORE + points))
}

# Validation
if [ -z "$FEATURE_ID" ]; then
    echo -e "${RED}Error: Feature ID required${NC}"
    echo "Usage: $0 <feature-id>"
    echo "Example: $0 001-project-setup"
    exit 1
fi

if [ ! -d "$FEATURE_DIR" ]; then
    echo -e "${RED}Error: Feature directory not found: $FEATURE_DIR${NC}"
    exit 1
fi

# Header
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Feature Verification: ${FEATURE_ID}${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Phase 1: Documentation Checks (20 points)
echo -e "${CYAN}Phase 1: Documentation Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check spec.md exists
if [ -f "${FEATURE_DIR}/spec.md" ]; then
    log_success "spec.md exists"
    add_score 5
else
    log_error "spec.md missing"
    skip_score 5
fi

# Check gaps.md exists
if [ -f "${FEATURE_DIR}/gaps.md" ]; then
    log_success "gaps.md exists"
    add_score 5
else
    log_error "gaps.md missing"
    skip_score 5
fi

# Check plan.md exists
if [ -f "${FEATURE_DIR}/plan.md" ]; then
    log_success "plan.md exists"
    add_score 5
else
    log_error "plan.md missing"
    skip_score 5
fi

# Check tasks.md exists
if [ -f "${FEATURE_DIR}/tasks.md" ]; then
    log_success "tasks.md exists"
    add_score 5
else
    log_error "tasks.md missing"
    skip_score 5
fi

echo ""

# Phase 2: File Existence Checks (20 points)
echo -e "${CYAN}Phase 2: File Existence Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract required files from spec.md if it exists
if [ -f "${FEATURE_DIR}/spec.md" ]; then
    # Check for common project files based on feature type

    # package.json (for Node.js projects)
    if grep -q "package.json" "${FEATURE_DIR}/spec.md" || grep -q "npm" "${FEATURE_DIR}/spec.md"; then
        if [ -f "package.json" ]; then
            log_success "package.json exists"
            add_score 5
        else
            log_warning "package.json not found (may not be required yet)"
            skip_score 5
        fi
    fi

    # Prisma schema (for database features)
    if grep -q "prisma" "${FEATURE_DIR}/spec.md" || grep -q "Prisma" "${FEATURE_DIR}/spec.md"; then
        if [ -f "prisma/schema.prisma" ]; then
            log_success "prisma/schema.prisma exists"
            add_score 5
        else
            log_warning "prisma/schema.prisma not found"
            skip_score 5
        fi
    fi

    # Docker compose (for containerization features)
    if grep -q "docker-compose" "${FEATURE_DIR}/spec.md" || grep -q "Docker" "${FEATURE_DIR}/spec.md"; then
        if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
            log_success "docker-compose.yml exists"
            add_score 5
        else
            log_warning "docker-compose.yml not found"
            skip_score 5
        fi
    fi

    # Next.js config (for Next.js projects)
    if grep -q "next.config" "${FEATURE_DIR}/spec.md" || grep -q "Next.js" "${FEATURE_DIR}/spec.md"; then
        if [ -f "next.config.js" ] || [ -f "next.config.mjs" ]; then
            log_success "next.config.js exists"
            add_score 5
        else
            log_warning "next.config.js not found"
            skip_score 5
        fi
    fi
else
    log_warning "Skipping file checks (spec.md not found)"
    skip_score 20
fi

echo ""

# Phase 3: Dependency Checks (15 points)
echo -e "${CYAN}Phase 3: Dependency Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "package.json" ]; then
    # Check if node_modules exists
    if [ -d "node_modules" ]; then
        log_success "node_modules directory exists"
        add_score 5
    else
        log_warning "node_modules not found - run npm install"
        skip_score 5
    fi

    # Check for security vulnerabilities
    if command -v npm &> /dev/null; then
        log_info "Running npm audit..."
        if npm audit --audit-level=high --production 2>&1 | grep -q "found 0"; then
            log_success "No high/critical vulnerabilities"
            add_score 5
        else
            log_warning "Security vulnerabilities detected (run npm audit for details)"
            skip_score 5
        fi
    else
        log_warning "npm not found, skipping audit"
        skip_score 5
    fi

    # Check if package-lock.json exists
    if [ -f "package-lock.json" ]; then
        log_success "package-lock.json exists"
        add_score 5
    else
        log_warning "package-lock.json missing"
        skip_score 5
    fi
else
    log_info "No package.json found, skipping dependency checks"
    skip_score 15
fi

echo ""

# Phase 4: Code Quality Checks (20 points)
echo -e "${CYAN}Phase 4: Code Quality Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "package.json" ]; then
    # TypeScript type checking
    if grep -q "\"typescript\":" package.json; then
        if [ -f "tsconfig.json" ]; then
            log_success "tsconfig.json exists"
            add_score 3

            if command -v npm &> /dev/null && grep -q "\"type-check\":" package.json; then
                log_info "Running type check..."
                if npm run type-check --silent 2>&1 | grep -q -E "(error TS|found 0 errors)"; then
                    if npm run type-check --silent 2>&1 | grep -q "found 0 errors"; then
                        log_success "TypeScript: 0 errors"
                        add_score 7
                    else
                        log_error "TypeScript errors found"
                        skip_score 7
                    fi
                else
                    log_warning "Type check script incomplete"
                    skip_score 7
                fi
            else
                log_warning "No type-check script found"
                skip_score 7
            fi
        else
            log_warning "TypeScript used but no tsconfig.json"
            skip_score 10
        fi
    else
        log_info "TypeScript not used, skipping type checks"
        skip_score 10
    fi

    # ESLint
    if grep -q "\"eslint\":" package.json; then
        if command -v npm &> /dev/null && grep -q "\"lint\":" package.json; then
            log_info "Running ESLint..."
            if npm run lint --silent 2>&1; then
                log_success "ESLint: 0 errors"
                add_score 5
            else
                log_error "ESLint errors found"
                skip_score 5
            fi
        else
            log_warning "No lint script found"
            skip_score 5
        fi
    else
        log_info "ESLint not configured, skipping"
        skip_score 5
    fi

    # Prettier
    if grep -q "\"prettier\":" package.json; then
        if [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ] || [ -f "prettier.config.js" ]; then
            log_success "Prettier configured"
            add_score 5
        else
            log_warning "Prettier installed but no config found"
            skip_score 5
        fi
    else
        log_info "Prettier not configured"
        skip_score 5
    fi
else
    log_info "No package.json, skipping quality checks"
    skip_score 20
fi

echo ""

# Phase 5: Test Verification (20 points)
echo -e "${CYAN}Phase 5: Test Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "package.json" ]; then
    # Check for test framework
    if grep -q -E "(jest|vitest|mocha)" package.json; then
        log_success "Test framework detected"
        add_score 5

        # Run tests
        if grep -q "\"test\":" package.json; then
            if command -v npm &> /dev/null; then
                log_info "Running tests..."
                if npm test --silent 2>&1; then
                    log_success "All tests passing"
                    add_score 10
                else
                    log_error "Tests failing"
                    skip_score 10
                fi
            else
                log_warning "npm not available"
                skip_score 10
            fi
        else
            log_warning "No test script found"
            skip_score 10
        fi

        # Check for test coverage
        if grep -q "\"test:coverage\":" package.json; then
            log_success "Coverage script available"
            add_score 5
        else
            log_warning "No coverage script"
            skip_score 5
        fi
    else
        log_warning "No test framework detected"
        skip_score 20
    fi
else
    log_info "No package.json, skipping tests"
    skip_score 20
fi

echo ""

# Phase 6: Build Verification (10 points)
echo -e "${CYAN}Phase 6: Build Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "package.json" ]; then
    if grep -q "\"build\":" package.json; then
        if command -v npm &> /dev/null; then
            log_info "Running build..."
            if timeout 300 npm run build --silent 2>&1 > /dev/null; then
                log_success "Build successful"
                add_score 10
            else
                log_error "Build failed"
                skip_score 10
            fi
        else
            log_warning "npm not available"
            skip_score 10
        fi
    else
        log_info "No build script found"
        skip_score 10
    fi
else
    log_info "No package.json, skipping build"
    skip_score 10
fi

echo ""

# Phase 7: Runtime Verification (15 points)
echo -e "${CYAN}Phase 7: Runtime Verification${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

log_info "Runtime checks require manual verification"
log_info "  - Start dev server: npm run dev"
log_info "  - Verify application loads at http://localhost:3000"
log_info "  - Check for console errors"
log_info "  - Test critical user flows"
skip_score 15

echo ""

# Calculate Final Score
PERCENTAGE=0
if [ $MAX_SCORE -gt 0 ]; then
    PERCENTAGE=$(( (SCORE * 100) / MAX_SCORE ))
fi

# Summary
echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Verification Summary                            ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Feature:${NC} $FEATURE_ID"
echo -e "${BLUE}Score:${NC} $SCORE / $MAX_SCORE ($PERCENTAGE%)"
echo ""

# Status Badge
if [ $PERCENTAGE -ge 90 ]; then
    echo -e "${GREEN}Status: ✅ APPROVED${NC}"
    STATUS="APPROVED"
elif [ $PERCENTAGE -ge 70 ]; then
    echo -e "${YELLOW}Status: ⚠️  APPROVED WITH WARNINGS${NC}"
    STATUS="APPROVED_WITH_WARNINGS"
else
    echo -e "${RED}Status: ❌ REJECTED${NC}"
    STATUS="REJECTED"
fi

echo ""

# Details
if [ ${#PASSED[@]} -gt 0 ]; then
    echo -e "${GREEN}✓ Passed (${#PASSED[@]}):${NC}"
    for item in "${PASSED[@]}"; do
        echo "  • $item"
    done
    echo ""
fi

if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠ Warnings (${#WARNINGS[@]}):${NC}"
    for item in "${WARNINGS[@]}"; do
        echo "  • $item"
    done
    echo ""
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
    echo -e "${RED}✗ Errors (${#ERRORS[@]}):${NC}"
    for item in "${ERRORS[@]}"; do
        echo "  • $item"
    done
    echo ""
fi

# Recommendations
echo -e "${CYAN}Recommendations:${NC}"
if [ $PERCENTAGE -lt 90 ]; then
    echo "  • Address errors and warnings above"
    echo "  • Review spec.md for implementation requirements"
    echo "  • Ensure all tasks in tasks.md are completed"
fi
if [ ${#ERRORS[@]} -eq 0 ] && [ ${#WARNINGS[@]} -gt 0 ]; then
    echo "  • Consider addressing warnings for production readiness"
fi
if [ $STATUS = "APPROVED" ]; then
    echo "  • Feature is ready for merge"
    echo "  • Run: /manifest update to mark feature complete"
fi

echo ""

# Create verification report
VERIFICATION_FILE="${FEATURE_DIR}/verification.md"
cat > "$VERIFICATION_FILE" <<EOF
# Verification Report: $FEATURE_ID

**Date:** $(date +%Y-%m-%d)
**Status:** $STATUS
**Score:** $SCORE / $MAX_SCORE ($PERCENTAGE%)

---

## Summary

$(if [ $PERCENTAGE -ge 90 ]; then
    echo "✅ Feature verification **PASSED**. All critical checks completed successfully."
elif [ $PERCENTAGE -ge 70 ]; then
    echo "⚠️  Feature verification **PASSED WITH WARNINGS**. Review warnings before production."
else
    echo "❌ Feature verification **FAILED**. Address errors before proceeding."
fi)

---

## Verification Results

### Documentation (20 points)
- spec.md: $([ -f "${FEATURE_DIR}/spec.md" ] && echo "✅" || echo "❌")
- gaps.md: $([ -f "${FEATURE_DIR}/gaps.md" ] && echo "✅" || echo "❌")
- plan.md: $([ -f "${FEATURE_DIR}/plan.md" ] && echo "✅" || echo "❌")
- tasks.md: $([ -f "${FEATURE_DIR}/tasks.md" ] && echo "✅" || echo "❌")

### Implementation
- Files Created: Review file existence checks above
- Dependencies: $([ -d "node_modules" ] && echo "✅ Installed" || echo "⚠️ Not installed")
- Type Checking: $([ -f "tsconfig.json" ] && echo "Configured" || echo "Not configured")
- Linting: $(grep -q "\"eslint\":" package.json 2>/dev/null && echo "Configured" || echo "Not configured")
- Tests: $(grep -q "\"test\":" package.json 2>/dev/null && echo "Configured" || echo "Not configured")

---

## Passed Checks (${#PASSED[@]})

$(for item in "${PASSED[@]}"; do echo "- ✅ $item"; done)

---

## Warnings (${#WARNINGS[@]})

$(for item in "${WARNINGS[@]}"; do echo "- ⚠️ $item"; done)

---

## Errors (${#ERRORS[@]})

$(for item in "${ERRORS[@]}"; do echo "- ❌ $item"; done)

---

## Next Steps

$(if [ $STATUS = "APPROVED" ]; then
    echo "1. Merge feature branch to main"
    echo "2. Run: \`/manifest update\` to mark feature complete"
    echo "3. Deploy to staging environment"
    echo "4. Perform manual QA testing"
elif [ $STATUS = "APPROVED_WITH_WARNINGS" ]; then
    echo "1. Review and address warnings (optional)"
    echo "2. Consider fixing before production deployment"
    echo "3. Merge if acceptable for current milestone"
    echo "4. Run: \`/manifest update\` when complete"
else
    echo "1. Review errors listed above"
    echo "2. Address critical issues"
    echo "3. Re-run verification: \`./.claude/scripts/verify-feature.sh $FEATURE_ID\`"
    echo "4. Do not merge until verification passes"
fi)

---

**Generated by:** Claude Code Verification Script
**Script Version:** 1.0.0
EOF

log_success "Verification report saved: $VERIFICATION_FILE"

# Exit with appropriate code
if [ "$STATUS" = "REJECTED" ]; then
    exit 1
else
    exit 0
fi
