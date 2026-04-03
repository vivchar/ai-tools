---
name: work-through-this
description: Use as the main entry point for any task — routes to brainstorm, implement, debug, or review based on task type
---

# Work Through This

Entry point router. Determines task type and invokes the right skill.

## Process

1. If no task provided — ask: "What are we working on?"
2. If user provides a file path — verify the file exists before routing
3. Analyze task type:
   - Vague idea, new feature, "I want to add X" → invoke `/brainstorm`
   - Ready plan exists, "execute the plan", path to plan.md → invoke `/implement`
   - Bug, error, "X doesn't work", "Y is crashing" → invoke `/debug`
   - "Look at the code", PR, "check", review → invoke `/review`
4. If task fits multiple categories (e.g. bug + feature) — ask user which to tackle first, do NOT guess
5. If unclear — ask one clarifying question, then route
6. MUST invoke target skill via `Skill` tool, passing the user's task as arguments

## Rules

- NEVER do actual work — only route to the appropriate skill
- NEVER read project files beyond what's needed to understand the task type
- MUST use `Skill` tool to invoke the target skill — do not attempt to follow the skill's process yourself
