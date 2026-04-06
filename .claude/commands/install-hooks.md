Install the Claude Code notification hooks from this repo into `~/.claude/settings.json`.

Perform these steps exactly and in order.

1. Check that `terminal-notifier` is installed (`/opt/homebrew/bin/terminal-notifier` or `which terminal-notifier`). If missing — stop and tell the user to run `brew install terminal-notifier`, then abort.
2. Check that `jq` is installed (the hook commands use it at runtime). If missing — tell the user to run `brew install jq` before proceeding.
3. Read `hooks.json` from the repo root. This is the fragment to install — the `hooks.Stop` and `hooks.Notification` entries, fully inlined (no file paths to substitute).
4. Read `~/.claude/settings.json`. If the file does not exist, treat it as `{}`.
5. **Back up** the current settings file to `~/.claude/settings.json.bak.<timestamp>` (use `date +%Y%m%d-%H%M%S`) via `cp`. Do this before any write.
6. Merge the `hooks.Stop` and `hooks.Notification` arrays from the fragment into settings.json:
   - **Preserve ALL other top-level fields** (`env`, `statusLine`, `spinnerVerbs`, `enabledPlugins`, `language`, etc.). Touch nothing outside `hooks`.
   - If `hooks.Stop` or `hooks.Notification` already exist and the existing `command` is different from what this fragment installs, **ask the user** whether to (a) overwrite, (b) append alongside, or (c) skip that specific hook. Do not silently clobber.
   - If an existing entry is byte-identical to the fragment, skip it as already installed.
7. Write the updated settings.json back using the Write tool. Preserve valid JSON with 2-space indentation.
8. Report to the user:
   - Which hooks were installed / skipped / overwritten
   - The absolute path to the backup file
   - A reminder that changes take effect on the next Claude Code session

IMPORTANT: never edit settings.json blindly. Always read → back up → merge → write. If anything goes wrong, tell the user the backup path so they can restore.
