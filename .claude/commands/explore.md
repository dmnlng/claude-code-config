# Explore Codebase Command

Systematically explore the codebase to understand: $ARGUMENTS

## Task

Conduct a structured exploration of the codebase to answer the question or understand the topic specified in arguments.

## Exploration Strategy

### 1. Start with Documentation
- Check README.md, docs/, and CLAUDE.md
- Look for architecture diagrams or design docs
- Review CHANGELOG for recent changes

### 2. Identify Entry Points
- Main application files (index.js, main.py, main.rs, etc.)
- Configuration files
- Package manifests (package.json, Cargo.toml, pyproject.toml)

### 3. Follow the Code Path
- Use scoped grep to find relevant functions/classes:
  ```bash
  grep "searchterm" src/ lib/ app/
  ```
- Read key files identified
- Trace imports/dependencies

### 4. Understand Patterns
- Identify architectural patterns (MVC, microservices, etc.)
- Note coding conventions
- Document data flow

### 5. Check Tests
- Review test files for usage examples
- Understand expected behavior
- Identify test patterns

## Output Format

Provide a structured report:

### Summary
[High-level answer to the exploration question]

### Key Files
- `file/path.ext` - Brief description of role
- `another/file.ext` - Brief description

### Architecture Notes
[Relevant architectural patterns or design decisions]

### Code Examples
[If applicable, show representative code snippets with file:line references]

### Related Areas
[Other parts of the codebase that are related]

### Recommendations
[If exploring for a specific task, suggest approach]

## Best Practices

- Always use scoped searches (grep "term" src/ instead of grep -r "term" .)
- Read complete files rather than fragments when context is needed
- Use /clear between unrelated explorations
- Launch subagents for large exploration tasks to preserve main context
