---
name: implement
description: Use when you have an implementation plan to execute — dispatches subagents per task, runs final review
---

# Implement

Execute a plan task-by-task via subagents, with a final review at the end.

## Process

1. Read plan (path from args, or ask user)
2. Create task list from plan steps
3. For each task sequentially:
   - Dispatch a subagent with full task text and relevant project context
   - Subagent implements, runs tests, commits
   - If subagent has questions — answer and re-dispatch
4. After ALL tasks — dispatch one review-subagent:
   - Read the spec/plan
   - Review all changes against it (completeness + correctness)
   - Check code quality
   - Report issues with specific file:line references
5. If review finds problems — fix and re-review
6. Run project verification commands (from CLAUDE.md Verification section, if present)

## Subagent Prompt Structure

Each implementation subagent gets:
- Full task text copied from the plan (don't make subagent read the file)
- Project context: key files, patterns to follow
- Clear constraint: only change what the task requires

## Rules

- Sequential execution only — no parallel subagents (avoids conflicts)
- Never skip the final review
- If a subagent is blocked — provide more context or break the task down
