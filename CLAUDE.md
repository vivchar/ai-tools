# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A collection of 5 lightweight, language-agnostic skills for Claude Code / Copilot CLI / Gemini CLI. Designed for teams working across multiple projects and tech stacks (Flutter, Dart, Kotlin, ObjC, backend, etc.).

## Architecture

Each skill = one directory with one `SKILL.md` file (100-200 words max) under `skills/`. The `install.sh` script symlinks them into `~/.claude/skills/` and `~/.agents/skills/`.

**Skill flow:** `work-through-this` is the entry-point router that analyzes task type and invokes one of the four worker skills via the `Skill` tool:

- `/brainstorm` — explore ideas, ask questions, write spec/plan
- `/implement` — execute a plan via sequential subagents + final review
- `/debug` — hypothesis-driven bug investigation
- `/review` — code review with file:line references and severity levels

Each skill works standalone or via the router.

## Installation / Update

```bash
./install.sh        # creates symlinks
git pull && ./install.sh  # update
```

## Key Design Decisions

- **No worktrees** — skills don't manage git branches or worktrees
- **Sequential subagents only** in `/implement` — no parallel execution to avoid conflicts
- **Project verification** — skills look for a `Verification` section in the target project's CLAUDE.md for test/lint commands
- **Adaptive brainstorm** — small tasks get a plan directly, large tasks get a spec first then a plan
- **Specs/plans** are saved to `docs/superpowers/specs/` and `docs/superpowers/plans/` with date-prefixed filenames
