# Test Command

Run the project's test suite with best practices.

## Task

1. Run the full test suite for this project
2. If tests fail:
   - Show a clear summary of failures
   - Analyze the root cause
   - Suggest fixes if applicable
3. If tests pass:
   - Show coverage report if available
   - Highlight any tests that could be improved

## Testing Approach

- Check for existing test configuration (jest.config.js, pytest.ini, cargo test, etc.)
- Use the project's standard test command from package.json/Makefile/etc.
- Run tests in the appropriate scope: $ARGUMENTS (if provided, e.g., "src/auth")
- Avoid running tests on node_modules or build artifacts

## Output Format

Provide:
- Test execution command used
- Pass/fail summary
- Coverage percentage (if available)
- Any warnings or deprecations
- Recommendations for test improvements
