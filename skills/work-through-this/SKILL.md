---
name: work-through-this
description: Use as the main entry point for any task — routes to brainstorm, implement, debug, or review based on task type
---

# Work Through This

Entry point router. Determines task type and invokes the right skill.

## Process

1. If no task provided — ask: "What are we working on?"
2. Analyze task type:
   - Vague idea, new feature, "I want to add X" → invoke `/brainstorm`
   - Ready plan exists, "execute the plan", path to plan.md → invoke `/implement`
   - Bug, error, "X doesn't work", "Y is crashing" → invoke `/debug`
   - "Look at the code", PR, "check", review → invoke `/review`
3. If unclear — ask one clarifying question, then route
4. Invoke target skill via `Skill` tool, passing the user's task as arguments

## Rules

- Do NOT do any actual work — only route
- Do NOT read project files beyond what's needed to understand the task type
- If task fits multiple categories — ask user which direction
