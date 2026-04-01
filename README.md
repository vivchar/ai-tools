# AI Tools

Lightweight, language-agnostic skills for Claude Code / Copilot CLI / Gemini CLI. Designed for teams working across multiple projects and tech stacks.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| `work-through-this` | `/work-through-this [task]` | Entry point — determines task type, routes to the right skill |
| `brainstorm` | `/brainstorm [idea]` | Explore idea, ask questions, propose approaches, write spec/plan |
| `implement` | `/implement [path/to/plan.md]` | Execute plan via subagents, final review at the end |
| `debug` | `/debug [bug description]` | Hypothesis-driven debugging: gather context → hypothesize → test → fix |
| `review` | `/review [PR number / branch]` | Code review with specific file:line references |

## Installation

```bash
git clone <repo-url>
cd ai-tools
./install.sh
```

Creates symlinks in `~/.claude/skills/` (Claude Code) and `~/.agents/skills/` (Copilot CLI, Codex, Gemini CLI).

## Update

```bash
git pull && ./install.sh
```

## Usage

Start with the entry point:

```
/work-through-this add user authentication
```

Or call any skill directly:

```
/brainstorm new caching layer for API responses
/implement docs/plans/2026-04-01-caching-plan.md
/debug login fails after token refresh
/review 42
```

## How It Works

- **`work-through-this`** analyzes your task and routes to the appropriate skill
- **`brainstorm`** adapts to task size: small tasks get a plan directly, large tasks get a spec first
- **`implement`** dispatches one subagent per task step, then a review-subagent checks everything at the end
- **`debug`** tests hypotheses one at a time, most probable first
- **`review`** reads the diff and reports issues by severity (critical / important / nit)

## Project Verification

Skills that run verification (implement, debug) look for a `Verification` section in your project's `CLAUDE.md`. Example:

```markdown
## Verification
- `npm test`
- `npm run lint`
```

## Design Docs

- [Design spec](docs/2026-04-01-custom-skills-design.md)
- [Implementation plan](docs/2026-04-01-custom-skills-plan.md)
