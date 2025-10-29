# Project Context for Claude Code

This file is automatically loaded into Claude's context for every session in this project.

## Project Overview

<!-- Replace with your project description -->
This is a [web application / library / CLI tool / etc.] built with [tech stack].

**Key Architecture:**
- [Main framework/language]
- [Database/storage]
- [Key dependencies]

## Code Style Guidelines

### General Principles
- Follow existing patterns in the codebase
- Write self-documenting code with clear variable names
- Prefer composition over inheritance
- Keep functions small and focused (< 50 lines)

### Language-Specific
<!-- Uncomment and adapt for your stack -->

<!-- JavaScript/TypeScript
- Use TypeScript strict mode
- Prefer `const` over `let`, avoid `var`
- Use async/await over callbacks
- Follow ESLint rules configured in .eslintrc
-->

<!-- Python
- Follow PEP 8
- Use type hints for function signatures
- Prefer f-strings for formatting
- Run black formatter before commits
-->

<!-- Rust
- Run `cargo fmt` before commits
- Use `clippy` for linting
- Prefer explicit error handling with Result<T, E>
- Write documentation comments for public APIs
-->

## Testing Instructions

### Running Tests
```bash
# Run all tests
[npm test / pytest / cargo test / go test]

# Run specific test file
[command for specific test]

# Run with coverage
[coverage command]
```

### Testing Standards
- Write tests for all new features
- Maintain test coverage above [X]%
- Test edge cases: empty inputs, null values, boundary conditions
- Avoid mocks unless absolutely necessary (prefer test fixtures)
- Tests should be deterministic and fast (< 100ms per test)

### TDD Workflow (Recommended)
1. Write test cases first based on expected behavior
2. Confirm tests fail (red)
3. Write minimal code to pass tests (green)
4. Refactor while keeping tests passing
5. Commit tests and implementation separately

## Repository Etiquette

### Commit Messages
- Use conventional commits format: `type(scope): description`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- Examples:
  - `feat(auth): add password reset functionality`
  - `fix(api): handle null response in user endpoint`
  - `docs(readme): update installation instructions`

### Branch Strategy
- `main` - Production-ready code
- `develop` - Integration branch (if using gitflow)
- Feature branches: `feature/description` or `username/feature-name`
- Always create PRs for review before merging to main

### Pull Request Guidelines
- Fill out PR template completely
- Link related issues
- Request review from at least [N] team members
- Ensure CI passes before requesting review
- Address review comments before merging

## Environment Setup

### Prerequisites
```bash
# Install dependencies
[package manager install command]

# Environment variables (copy from .env.example)
cp .env.example .env

# Database setup
[migration/seed commands]
```

### Common Development Commands
```bash
# Start development server
[dev server command]

# Build for production
[build command]

# Run linter
[linter command]

# Format code
[formatter command]
```

## Common Tools & Utilities

### Project-Specific Tools
<!-- List custom scripts or tools -->
- `scripts/setup.sh` - Initial project setup
- `scripts/deploy.sh` - Deployment automation
- `scripts/db-reset.sh` - Reset local database

### Useful Commands
```bash
# Find TODO comments
grep -r "TODO" src/

# Check for unused dependencies
[dependency checker command]

# Profile performance
[profiling command]
```

## Context Management for Claude

### Scoped Searches
When searching code, always scope to relevant directories:
```bash
# Good
grep "pattern" src/ tests/

# Avoid (scans entire tree including node_modules)
grep -r "pattern" .
```

### Use /clear Command
Run `/clear` between unrelated tasks to:
- Reset context window
- Improve response quality
- Avoid context confusion

### When to Use Subagents
Launch subagents for:
- Large refactoring tasks (preserves main context)
- Independent exploratory research
- Parallel development on separate features

## Project-Specific Notes

<!-- Add project-specific information -->
### Known Issues
- [Issue 1 and workaround]
- [Issue 2 and workaround]

### Performance Considerations
- [Important performance tips]
- [Database query optimization notes]
- [Caching strategies]

### Security Notes
- Never commit `.env` files
- Sanitize user input in [specific areas]
- Use parameterized queries for database access

## Documentation

### Key Documentation Files
- `docs/architecture.md` - System architecture overview
- `docs/api.md` - API documentation
- `docs/deployment.md` - Deployment guide

### Where to Look
- **Authentication**: `src/auth/` or `lib/auth/`
- **Database models**: `src/models/` or `db/schema/`
- **API routes**: `src/routes/` or `api/`
- **Tests**: `tests/` or `__tests__/`

---

**Note**: Keep this file concise. It's loaded into context on every request, so avoid unnecessary verbosity. Focus on information Claude needs to work effectively in this codebase.

**Pro Tip**: Run this file through a prompt improver and test its effectiveness. Use emphasis keywords ("IMPORTANT", "YOU MUST") sparingly for critical guidelines.
