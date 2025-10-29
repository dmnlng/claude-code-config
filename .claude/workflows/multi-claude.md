# Multi-Claude Parallel Development

Run multiple Claude Code instances in parallel for independent work streams using git worktrees.

## Overview

Multi-Claude development enables:
- **Parallel feature development** - Work on multiple features simultaneously
- **Independent verification** - One Claude writes, another reviews
- **Context isolation** - Keep separate concerns in separate context windows
- **Experimentation** - Try different approaches without conflicts

## Setup: Git Worktrees

### What are Git Worktrees?

Git worktrees allow multiple working directories from the same repository:
- Share the same git history
- Independent working states
- No need to stash/commit when switching contexts

### Creating Worktrees

```bash
# From your main project directory
cd ~/projects/myapp

# Create worktrees for different features
git worktree add ../myapp-feature-auth feature/auth
git worktree add ../myapp-feature-ui feature/ui-redesign
git worktree add ../myapp-refactor refactor/database
git worktree add ../myapp-scratch main  # experimental scratchpad

# List all worktrees
git worktree list
```

**Result:**
```
~/projects/myapp/              (main branch)
~/projects/myapp-feature-auth/ (feature/auth branch)
~/projects/myapp-feature-ui/   (feature/ui-redesign branch)
~/projects/myapp-refactor/     (refactor/database branch)
~/projects/myapp-scratch/      (main branch)
```

### Launch Claude in Each Worktree

Open separate terminal sessions:

```bash
# Terminal 1: Main development
cd ~/projects/myapp
claude

# Terminal 2: Auth feature
cd ~/projects/myapp-feature-auth
claude

# Terminal 3: UI redesign
cd ~/projects/myapp-feature-ui
claude

# Terminal 4: Verification/review
cd ~/projects/myapp-scratch
claude
```

## Workflow Patterns

### Pattern 1: Writer + Reviewer

**Claude 1 (Writer):**
```
Implement the password reset feature with email verification
```

**Claude 2 (Reviewer):**
```
Review the password reset implementation in ../myapp-feature-auth/
Check for security issues and test coverage
```

Benefits:
- Independent verification
- Catches issues the writer might miss
- Fresh perspective on code quality

### Pattern 2: Parallel Features

**Claude 1:**
```
Implement OAuth authentication (feature/auth branch)
```

**Claude 2:**
```
Redesign dashboard UI (feature/ui-redesign branch)
```

**Claude 3:**
```
Optimize database queries (refactor/database branch)
```

Benefits:
- 3x development speed for independent features
- No merge conflicts during development
- Each Claude has full context for its feature

### Pattern 3: Exploration + Implementation

**Claude 1 (Explorer):**
```
Research how authentication is currently implemented.
Document the patterns and dependencies.
Create implementation recommendations in docs/auth-refactor.md
```

**Claude 2 (Implementer):**
```
Following the recommendations in docs/auth-refactor.md,
implement the new authentication system
```

Benefits:
- Exploration doesn't pollute implementation context
- Clear separation of research and execution
- Implementation has documented guidance

### Pattern 4: Test + Code Separation

**Claude 1 (Test Writer):**
```
Write comprehensive test suite for the payment processor
following TDD approach. Don't implement yet.
```

**Claude 2 (Implementer):**
```
Implement the payment processor to pass the tests in
../myapp-tests/tests/payment/
```

Benefits:
- Pure TDD workflow
- Tests truly independent from implementation
- No bias from knowing implementation details

## Inter-Claude Communication

### Using Files as Communication

**Shared scratchpad file:**
```bash
# Claude 1 writes notes
echo "Auth API endpoints should use /api/v2/auth/* prefix" > .claude/notes.txt

# Claude 2 reads notes
cat .claude/notes.txt
```

**TODO files:**
```markdown
# .claude/todos.md

## For Claude 1 (Auth):
- [ ] Implement OAuth provider integration
- [ ] Add rate limiting to login endpoint
- [x] Create user session management

## For Claude 2 (UI):
- [ ] Design login form component
- [ ] Add loading states
- [ ] Implement error handling
```

### Shared Documentation

Create living documentation that all Claudes update:
```markdown
# docs/decisions.md

## 2024-01-15: Authentication Strategy
**Decided by:** Claude (Auth worktree)
**Decision:** Use JWT with refresh tokens
**Rationale:** Balance of security and UX

## 2024-01-15: UI Framework
**Decided by:** Claude (UI worktree)
**Decision:** Migrate to shadcn/ui components
**Rationale:** Better accessibility, smaller bundle
```

## Best Practices

### 1. Clear Boundaries

Assign each Claude a specific domain:
- **Claude A**: Backend API
- **Claude B**: Frontend components
- **Claude C**: Database & migrations
- **Claude D**: Testing & QA

### 2. Merge Frequently

Avoid long-lived branches:
```bash
# In each worktree, periodically sync with main
git fetch origin
git merge origin/main

# Or rebase for linear history
git rebase origin/main
```

### 3. Use Worktree for Experiments

Before risky refactoring:
```bash
git worktree add ../myapp-experiment main
cd ../myapp-experiment
claude

# Experiment freely, discard if it doesn't work
cd ..
git worktree remove myapp-experiment
```

### 4. Coordinate via PRs

Each worktree creates its own PR:
- Easier to review
- Independent merge decisions
- Clear ownership

## Example: Full Multi-Claude Session

```bash
# Setup
git worktree add ../app-auth feature/oauth
git worktree add ../app-tests feature/oauth-tests
git worktree add ../app-review main

# Terminal 1: Test writer
cd ../app-tests
claude
> "Write test cases for OAuth login flow with Google and GitHub providers"

# Terminal 2: Implementation
cd ../app-auth
claude
> "Implement OAuth login to pass tests in ../app-tests/"

# Terminal 3: Code review
cd ../app-review
claude
> "Review the OAuth implementation in ../app-auth/ for security issues"

# After all Claudes complete
cd ~/projects/app
git pull --all  # Update main with latest

cd ../app-auth
git rebase main
git push

cd ../app-tests
git rebase main
git push

# Create PRs
gh pr create --title "feat: add OAuth login" --base main --head feature/oauth
gh pr create --title "test: OAuth test suite" --base main --head feature/oauth-tests
```

## Advanced: Claude Orchestration

Create a "conductor" script:

```bash
#!/bin/bash
# scripts/multi-claude.sh

# Start multiple Claude sessions with predefined tasks

# Claude 1: Feature A
osascript -e 'tell app "Terminal"
    do script "cd ~/projects/app-feature-a && claude -p \"Implement feature A\""
end tell'

# Claude 2: Feature B
osascript -e 'tell app "Terminal"
    do script "cd ~/projects/app-feature-b && claude -p \"Implement feature B\""
end tell'

# Claude 3: Tests
osascript -e 'tell app "Terminal"
    do script "cd ~/projects/app-tests && claude -p \"Write tests for features A and B\""
end tell'
```

## Limitations & Considerations

### Resource Usage
- Each Claude instance consumes tokens independently
- Monitor usage across all instances
- Close idle sessions

### Merge Conflicts
- Coordinate on shared files (package.json, migrations, etc.)
- Use git merge strategies
- Communicate via shared docs

### Complexity
- Start with 2-3 Claudes maximum
- Only for truly independent work
- Not needed for small projects

## Cleanup

Remove worktrees when done:
```bash
# List worktrees
git worktree list

# Remove specific worktree
git worktree remove ../app-feature-auth

# Remove and delete branch
git worktree remove ../app-feature-ui
git branch -d feature/ui-redesign
```

## Resources

- `git worktree --help` for git documentation
- GitHub CLI (`gh`) for PR management
- tmux/screen for terminal session management

---

**Pro Tip**: Use multi-Claude for complex features that would otherwise exceed the context window. The isolation actually improves code quality by forcing clear interfaces between components.
