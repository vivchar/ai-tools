---
name: brainstorm
description: Use when exploring a new idea, feature, or unclear task — asks questions, proposes approaches, writes spec and/or plan
---

# Brainstorm

Collaborative design through structured dialogue.

## Process

1. Explore project context (CLAUDE.md, relevant files, recent commits)
2. Ask clarifying questions — one at a time, prefer multiple choice
3. Propose 2-3 approaches with trade-offs, lead with your recommendation
4. Get user approval on approach
5. Determine task size:
   - **Small** (1-3 files, clear scope) → write plan with steps directly
   - **Large** (multiple components, unclear boundaries) → write spec first, then plan
6. Save documents:
   - Spec (if needed): `docs/plan/YYYY-MM-DD-<topic>-design.md`
   - Plan: `docs/plan/YYYY-MM-DD-<topic>-plan.md`
7. Ask user to review written document(s)
8. Offer: "Shall I run `/implement`?"

## Rules

- One question per message
- Multiple choice when possible
- YAGNI — cut unnecessary features from designs
- Get approval before writing documents
