# AI Tools

Lightweight, language-agnostic skills and hooks for Claude Code / Copilot CLI / Gemini CLI. Designed for teams working across multiple projects and tech stacks.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| `work-through-this` | `/work-through-this [task]` | Entry point — analyzes task type, routes to the right skill, asks if ambiguous |
| `brainstorm` | `/brainstorm [idea]` | Reads project context, asks questions, proposes approaches, writes spec/plan |
| `implement` | `/implement [path/to/plan.md]` | Execute plan via subagents with verification after each step |
| `debug` | `/debug [bug description]` | Reproduce first, then hypothesize → test → fix → verify |
| `review` | `/review [PR number / branch]` | Full-diff code review with file:line references, severity levels, test coverage checks |

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

- **`work-through-this`** analyzes your task and routes to the appropriate skill. If task is ambiguous (bug + feature) — asks which to tackle first
- **`brainstorm`** reads project's CLAUDE.md first, adapts to task size: small tasks get a plan directly, large tasks get a spec first
- **`implement`** dispatches one subagent per task step with verification after each, then a review-subagent checks everything at the end
- **`debug`** reproduces the bug first, then tests hypotheses one at a time, most probable first
- **`review`** reads the full diff and reports issues by severity (critical / important / nit), flags missing test coverage

## Hooks

Optional notification hooks for Claude Code (macOS). Requires `terminal-notifier` and `jq`:

```bash
brew install terminal-notifier jq
```

**Install via slash-command** (run inside this repo):

```
claude
/install-hooks
```

Claude reads `hooks.json`, backs up your current `~/.claude/settings.json`, and merges the `Stop` / `Notification` hooks in — preserving everything else in your settings.

**Uninstall:**

```
/uninstall-hooks
```

**Manual install** — copy the `hooks` object from [`hooks.json`](hooks.json) into your `~/.claude/settings.json` by hand.

What you get:
- **Stop** — plays `Glass` sound and shows a notification when Claude finishes responding
- **Notification** — plays `Ping` sound and shows the message when Claude is waiting for input

## Project Verification

Skills that run verification (implement, debug) look for a `Verification` section in your project's `CLAUDE.md`. Example:

```markdown
## Verification
- `npm test`
- `npm run lint`
```

If no Verification section is found, skills auto-detect the language and run standard checks:

| Project marker | Language | Commands |
|---|---|---|
| `pubspec.yaml` | Dart/Flutter | `dart analyze`, `flutter test` |
| `package.json` | JS/TS | `npm test`, `npx tsc --noEmit` |
| `build.gradle` | Kotlin/Java | `./gradlew build` |
| `pyproject.toml` / `setup.py` | Python | `pytest` |
| `go.mod` | Go | `go build ./...`, `go test ./...` |
