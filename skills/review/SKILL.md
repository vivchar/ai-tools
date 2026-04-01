---
name: review
description: Use when reviewing code changes — PR, branch diff, or recent commits
---

# Review

Code review: read diff, find issues, report concisely.

## Process

1. Determine what to review:
   - PR number → `gh pr diff <number>`
   - Branch → `git diff main...<branch>`
   - "recent changes" → `git diff` or `git log --oneline -10` then pick range
   - No argument → ask what to review
2. Read the full diff
3. Check for:
   - Logic errors and edge cases
   - Style consistency with surrounding code
   - Potential bugs (null safety, off-by-one, race conditions)
   - Security issues (injection, exposed secrets)
   - Missing error handling at system boundaries
4. Output report:
   - List issues with `file:line` references
   - Severity: critical / important / nit
   - For each issue — what's wrong and suggested fix
   - End with summary: approve / request changes

## Rules

- Focus on what matters — skip trivial nits if there are real issues
- Be specific — "potential NPE at foo.dart:42" not "check for nulls"
- Don't rewrite the code — point out the problem, suggest direction
