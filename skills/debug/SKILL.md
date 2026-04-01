---
name: debug
description: Use when investigating a bug, error, or unexpected behavior — systematic hypothesis-driven debugging
---

# Debug

Systematic bug investigation: hypothesize, test, fix, verify.

## Process

1. Get bug description (from args or ask)
2. Gather context:
   - Error messages, stack traces, logs
   - Relevant source files
   - Recent changes that might be related (`git log`)
3. Formulate 2-4 hypotheses, ordered by probability
4. Test hypotheses one at a time (most likely first):
   - Read code, add logging, run reproduction steps
   - Confirm or rule out each hypothesis before moving to next
5. Found root cause → implement fix
6. Verify: reproduction no longer occurs + project verification commands pass

## Rules

- Never guess-and-fix — always confirm root cause first
- One hypothesis at a time — don't scatter attention
- If all hypotheses fail — step back, gather more context, form new ones
