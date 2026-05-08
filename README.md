# AI Tools

Lightweight, language-agnostic skills, hooks and statusline for Claude Code / Copilot CLI / Gemini CLI. Designed for teams working across multiple projects and tech stacks.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| `work-through-this` | `/work-through-this [task]` | Entry point — analyzes task type, routes to the right skill, asks if ambiguous |
| `brainstorm` | `/brainstorm [idea]` | Reads project context, asks questions, proposes approaches, writes spec/plan |
| `implement` | `/implement [path/to/plan.md]` | Execute plan via subagents with verification after each step |
| `debug` | `/debug [bug description]` | Reproduce first, then hypothesize → test → fix → verify |
| `review` | `/review [PR number / branch]` | Full-diff code review with file:line references, severity levels, test coverage checks |

## Installation

### macOS / Linux

```bash
git clone <repo-url>
cd ai-tools
./install.sh
```

### Windows

```powershell
git clone <repo-url>
cd ai-tools
.\install.ps1
```

Or double-click `install.cmd`. The script tries `SymbolicLink` first (needs Developer Mode on Win11 or admin) and falls back to `Junction` (no privileges required) — both work transparently for skill discovery.

Both installers create symlinks/junctions in `~/.claude/skills/` (Claude Code) and `~/.agents/skills/` (Copilot CLI, Codex, Gemini CLI).

Optional extras — run from inside the cloned repo via `claude`:

| What | Command | What it does |
|---|---|---|
| Notification hooks | `/install-hooks` | Adds `Stop` + `Notification` hooks to `~/.claude/settings.json` |
| Statusline | `/install-statusline` | Symlinks `cli/statusline.sh` to `~/.claude/` and adds `statusLine` to settings |

Both extras back up your `settings.json` before touching it, preserve all other fields, and have matching `/uninstall-*` commands.

## Update

```bash
git pull               # macOS/Linux & Windows when symlinks/junctions worked
```

Skills are symlinks/junctions, so `git pull` is enough — no re-install needed. Hooks and statusline re-install only if their source files change. On Windows, if `notify.ps1` / `statusline.ps1` were copied (because symlink fell back), re-run `/install-hooks` / `/install-statusline` after `git pull`.

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

Notification hooks for Claude Code.

**macOS** — requires `terminal-notifier` and `jq`:

```bash
brew install terminal-notifier jq
```

**Windows** — uses PowerShell with `cli/notify.ps1`. Optionally install [BurntToast](https://github.com/Windos/BurntToast) for nicer Win10/11 toasts (otherwise falls back to a WinForms balloon):

```powershell
Install-Module BurntToast -Scope CurrentUser
```

Inside the cloned repo:

```
claude
/install-hooks      # merge Stop + Notification hooks into settings.json
/uninstall-hooks    # remove them
```

The slash-commands detect your OS and install the right variant. What you get on either platform:
- **Stop** — plays a sound and shows a notification when Claude finishes responding
- **Notification** — plays a sound and shows the message when Claude is waiting for input

Manual install — copy the `hooks` object from [`hooks.json`](hooks.json) (macOS) into your `~/.claude/settings.json` by hand. Windows manual install: see the JSON fragment in [`.claude/commands/install-hooks.md`](.claude/commands/install-hooks.md).

## Statusline

Custom statusline with model, git branch and context-window progress bar.

**macOS** — bash script, requires `jq`:

```bash
brew install jq
```

**Windows** — pure PowerShell, no external deps. ANSI colors require Windows Terminal or any modern conhost.

Inside the cloned repo:

```
claude
/install-statusline      # links cli/statusline.{sh,ps1} into ~/.claude/ and adds statusLine to settings
/uninstall-statusline    # removes the link and settings entry
```

The install symlinks/junctions the script into `~/.claude/`, so editing the script in the repo updates everywhere (when symlink succeeded). Restart Claude Code to see changes.

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
