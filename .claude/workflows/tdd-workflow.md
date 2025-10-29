# Test-Driven Development Workflow

A structured approach to implementing features with Claude Code using TDD.

## Overview

Test-Driven Development (TDD) with Claude ensures:
- Clear requirements through test specifications
- No over-engineering (implement only what tests require)
- Built-in regression prevention
- Living documentation through tests

## Workflow Steps

### 1. Define Test Cases First

**Tell Claude explicitly you're using TDD:**
```
I want to add [feature] using TDD. Let's start by writing test cases
for these scenarios:
- [Scenario 1: expected input/output]
- [Scenario 2: edge case]
- [Scenario 3: error case]
```

**Be specific about testing approach:**
- Avoid mocks unless necessary
- Use test fixtures for complex data
- Test actual behavior, not implementation details

### 2. Verify Tests Fail (Red)

**Before implementing:**
```
Run the tests to confirm they fail as expected
```

This ensures:
- Tests are actually testing something
- Test framework is working correctly
- Baseline is established

### 3. Commit Tests Separately

```bash
git add tests/
git commit -m "test: add test cases for [feature]"
```

Benefits:
- Clear separation of requirements vs implementation
- Easy to review test logic independently
- Enables parallel implementation by team members

### 4. Implement Minimal Code (Green)

**Ask Claude to implement:**
```
Now implement the minimal code needed to make these tests pass.
Don't add extra features not covered by tests.
```

Emphasize:
- Keep implementation simple
- Only satisfy existing tests
- Avoid premature optimization

### 5. Verify Tests Pass

```
Run tests again and confirm they all pass
```

If tests fail:
- Debug with Claude
- Don't modify tests (they represent requirements)
- Only adjust implementation

### 6. Refactor While Green

**If code needs improvement:**
```
The tests pass, but [specific code area] could be cleaner.
Let's refactor while keeping tests passing.
```

Refactoring opportunities:
- Extract duplicate code
- Improve naming
- Simplify complex logic
- Add documentation

### 7. Commit Implementation

```bash
git add src/
git commit -m "feat: implement [feature] to pass new tests"
```

### 8. Independent Verification (Optional)

**For critical features, use subagent verification:**
```
Launch a subagent to review these tests and check if the implementation
could be gaming the tests or missing edge cases.
```

This catches:
- Test overfitting
- Missed edge cases
- Brittle test assumptions

## Example Session

```
User: I need to add password validation using TDD. Requirements:
- Minimum 8 characters
- At least one uppercase, one lowercase, one number
- No common passwords (check against top 100 list)

Claude: I'll help implement this with TDD. Let's start with test cases.

[Claude writes tests for each requirement plus edge cases]

Claude: I've written 7 test cases covering:
1. Valid password acceptance
2. Too short rejection
3. Missing uppercase rejection
4. Missing lowercase rejection
5. Missing number rejection
6. Common password rejection
7. Empty string handling

Let me run these to verify they fail...

[Tests fail as expected]

Claude: Tests fail as expected. Ready to commit?

User: Yes, commit the tests

[Claude commits tests]

User: Now implement the validation

Claude: Implementing minimal password validator...

[Claude implements PasswordValidator class]

Claude: Running tests... All 7 tests passing!

User: Great, commit the implementation

[Claude commits implementation]
```

## Tips for Success

### 1. Write Tests First (Really)
Don't let Claude implement before tests exist. This is the most common TDD mistake.

### 2. Be Explicit About Edge Cases
```
Also test edge cases: null input, empty string, very long passwords,
unicode characters, SQL injection attempts
```

### 3. Specify Test Style
```
Use pytest fixtures for test data, avoid mocking the database
```

### 4. Use Subagents for Large Features
For features requiring many tests:
```
Launch a subagent to implement the password validator using TDD,
following the requirements I specified
```

This preserves your main context window.

### 5. Iterative Addition
After initial implementation:
```
I realized we also need to handle [new requirement].
Add a test for this, verify it fails, then implement.
```

## Anti-Patterns to Avoid

### ❌ Don't: Skip the Red Phase
```
Write tests and implement the feature
```
Problem: Can't verify tests actually test anything

### ✅ Do: Explicit Red-Green-Refactor
```
1. Write tests
2. Run them (expect failures)
3. Implement to pass
4. Refactor if needed
```

### ❌ Don't: Change Tests When Implementation Fails
Tests represent requirements. If implementation doesn't match tests, fix implementation.

### ✅ Do: Only Change Tests for Requirement Changes
```
Actually, the requirement changed - [new requirement].
Update the test, confirm it fails, then adjust implementation.
```

### ❌ Don't: Over-Mock
Excessive mocking leads to brittle tests that pass even when real code breaks.

### ✅ Do: Test Real Behavior
```
Use test database fixtures instead of mocking database calls
```

## Integration with CI/CD

Run tests automatically:
```bash
# In .github/workflows/ci.yml or similar
- name: Run tests
  run: npm test  # or pytest, cargo test, etc.
```

TDD ensures CI catches regressions immediately.

## Further Reading

- Kent Beck - "Test Driven Development: By Example"
- Martin Fowler - "Refactoring"
- Classic TDD cycle: Red → Green → Refactor
