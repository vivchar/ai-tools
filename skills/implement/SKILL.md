---
name: implement
description: Use when you have an implementation plan to execute — dispatches subagents per task, runs final review
---

# Implement

Execute a plan task-by-task via subagents, with verification and a final review.

## Process

1. Read plan (path from args, or ask user)
2. Create task list from plan steps
3. For each task sequentially:
   - Dispatch a subagent with full task text and relevant project context
   - Subagent implements and commits
   - Subagent MUST run verification after its changes (see Verification below)
   - If verification fails — subagent fixes until green, does NOT proceed broken
   - If subagent has questions — answer and re-dispatch
4. After ALL tasks — dispatch one review-subagent:
   - Read the spec/plan
   - Review all changes against it (completeness + correctness)
   - Check code quality
   - Report issues with specific file:line references
5. If review finds problems — fix and re-review
6. Run full project verification one final time

## Verification

After each subagent's changes AND at the end, run verification in this order:

1. **CLAUDE.md check:** Look for `## Verification` section in the target project's CLAUDE.md. If found — run ALL listed commands
2. **Language fallback** (if no Verification section found) — detect language by project files and run standard checks:
   - `pubspec.yaml` → `dart analyze`, `flutter test`
   - `package.json` → `npm test`, `npx tsc --noEmit`
   - `build.gradle` → `./gradlew build`
   - `pyproject.toml` / `setup.py` → `pytest`
   - `go.mod` → `go build ./...`, `go test ./...`
3. **Related tests:** Find test files matching changed files by naming convention (`foo.dart` → `foo_test.dart`, `bar.ts` → `bar.test.ts` / `bar.spec.ts`) and run them

Do NOT ask the user which tests to run — detect and run automatically.

## Subagent Prompt Structure

Each implementation subagent gets:
- Full task text copied from the plan (don't make subagent read the file)
- Project context: key files, patterns to follow
- Verification instructions (copy the Verification section above)
- Clear constraint: only change what the task requires

## Rules

- Sequential execution only — no parallel subagents (avoids conflicts)
- NEVER skip verification — every subagent must verify, plus final verification
- NEVER proceed to next task if current task's tests are failing
- If a subagent is blocked — provide more context or break the task down
