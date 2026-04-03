---
name: brainstorm
description: Use when exploring a new idea, feature, or unclear task — asks questions, proposes approaches, writes spec and/or plan
---

# Brainstorm

Collaborative design through structured dialogue.

## Process

1. MUST read CLAUDE.md of the target project before asking any questions
2. Explore project context (relevant files, recent commits)
3. Assess scope: if project touches >5 independent components — propose breaking into sub-tasks before diving in
4. Ask clarifying questions — one at a time, prefer multiple choice
5. Propose 2-3 approaches with trade-offs, lead with your recommendation
6. Get user approval on approach
7. Determine task size:
   - **Small** (1-3 files, clear scope) → write plan with steps directly
   - **Large** (multiple components, unclear boundaries) → write spec first, then plan
8. Save documents:
   - Spec (if needed): `docs/plan/YYYY-MM-DD-<topic>-design.md`
   - Plan: `docs/plan/YYYY-MM-DD-<topic>-plan.md`
9. Ask user to review written document(s)
10. Offer: "Shall I run `/implement`?"

## Plan Quality

Every step in the plan MUST be concrete:
- Name specific files to create or modify
- Describe what changes to make, not just "update X"
- If a step is vague — it's not ready

## Rules

- One question per message
- Multiple choice when possible
- YAGNI — cut unnecessary features from designs
- Get approval before writing documents
- NEVER write code or start implementation — only spec/plan
