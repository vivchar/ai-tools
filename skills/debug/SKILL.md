---
name: debug
description: Use when investigating a bug, error, or unexpected behavior — systematic hypothesis-driven debugging
---

# Debug

Systematic bug investigation: reproduce, hypothesize, test, fix, verify.

## Process

1. Get bug description (from args or ask)
2. MUST reproduce the bug first:
   - Run the reproduction steps or trigger the error
   - If bug does NOT reproduce — report this to user immediately, do NOT guess at fixes
3. Gather context:
   - Error messages, stack traces, logs
   - Relevant source files
   - Recent changes that might be related (`git log`)
4. Formulate 2-4 hypotheses, ordered by probability
5. Test hypotheses one at a time (most likely first):
   - Read code, add logging, run reproduction steps
   - Confirm or rule out each hypothesis before moving to next
6. Found root cause → implement fix
7. Verify fix:
   - MUST show that original reproduction steps no longer trigger the bug
   - MUST find and run related test files (by naming convention: `foo.dart` → `foo_test.dart`, `bar.ts` → `bar.test.ts`)
   - MUST run project verification (see below)

## Verification

After the fix, run verification in this order:

1. **CLAUDE.md check:** Look for `## Verification` section in the target project's CLAUDE.md. If found — run ALL listed commands
2. **Language fallback** (if no Verification section found) — detect language by project files and run standard checks:
   - `pubspec.yaml` → `dart analyze`, `flutter test`
   - `package.json` → `npm test`, `npx tsc --noEmit`
   - `build.gradle` → `./gradlew build`
   - `pyproject.toml` / `setup.py` → `pytest`
   - `go.mod` → `go build ./...`, `go test ./...`

Do NOT ask the user which tests to run — detect and run automatically.

## Rules

- NEVER guess-and-fix — always confirm root cause first
- One hypothesis at a time — don't scatter attention
- If bug doesn't reproduce — tell the user, don't invent fixes
- If all hypotheses fail — step back, gather more context, form new ones
- NEVER skip verification after fix
