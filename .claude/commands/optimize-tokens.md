# Token Optimization Command

Analyze the project for potential token usage optimization opportunities.

## Task

Identify files and directories that may be consuming excessive tokens in Claude Code sessions.

## Analysis Steps

1. **Check .claude/ignore patterns**
   - Verify all dependency directories are blocked
   - Look for missing build artifact patterns
   - Check for large data files or logs

2. **Analyze project structure**
   - Find large files (> 1000 lines) that could be refactored
   - Identify generated code that should be ignored
   - Look for vendored dependencies

3. **Review bash command usage**
   - Check recent git history for unscoped grep/find commands
   - Suggest scoped alternatives

4. **Test validation hook**
   - Verify .claude/scripts/validate-bash.sh is executable
   - Test with sample blocked commands

## Recommendations

Provide:
- List of directories/files to add to .claude/ignore
- Suggested permission deny patterns for settings.local.json
- Best practices for scoped searches in this project
- Estimate of potential token savings

## Example Output

```
Token Optimization Report
========================

Current Issues:
- vendor/ directory not in .claude/ignore (est. 15k tokens)
- .next/ build directory accessible (est. 8k tokens)
- Large generated file: src/generated/schema.ts (est. 3k tokens)

Recommendations:
1. Add to .claude/ignore:
   vendor/
   .next/
   src/generated/

2. Add to settings.local.json deny patterns:
   "Read(**/vendor/)"
   "Read(**/.next/)"

Estimated Token Savings: 26,000 tokens per session (~74% reduction)
```
