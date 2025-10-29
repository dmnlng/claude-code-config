# Code Review Command

Perform a comprehensive code review of recent changes or specified files.

## Task

Review the code in: $ARGUMENTS (or recent uncommitted changes if no arguments)

## Review Checklist

### 1. Code Quality
- [ ] Functions are small and focused
- [ ] Variable names are clear and descriptive
- [ ] No code duplication (DRY principle)
- [ ] Appropriate error handling
- [ ] Edge cases considered

### 2. Testing
- [ ] Tests exist for new functionality
- [ ] Tests cover edge cases
- [ ] Tests are deterministic and fast
- [ ] No overfitting to implementation details

### 3. Security
- [ ] No hardcoded secrets or credentials
- [ ] User input is sanitized
- [ ] SQL queries are parameterized
- [ ] Authentication/authorization properly implemented

### 4. Performance
- [ ] No obvious performance bottlenecks
- [ ] Database queries are optimized
- [ ] Appropriate use of caching
- [ ] No memory leaks

### 5. Maintainability
- [ ] Code follows project conventions
- [ ] Comments explain "why", not "what"
- [ ] Dependencies are justified
- [ ] Breaking changes are documented

### 6. Documentation
- [ ] README updated if needed
- [ ] API changes documented
- [ ] CHANGELOG updated for user-facing changes

## Output Format

Provide:
1. **Summary**: Overall code quality assessment
2. **Issues Found**: List of specific issues with file:line references
3. **Recommendations**: Prioritized suggestions for improvements
4. **Praise**: Highlight well-written code patterns
