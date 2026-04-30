Install the Claude Code notification hooks from this repo into `~/.claude/settings.json`.

Perform these steps exactly and in order.

1. **Detect OS.** If `$IsWindows` is true (PowerShell 7+) or `$env:OS` equals `Windows_NT` (cmd/PS5.1) — follow the **Windows branch** below. Otherwise (macOS / Linux) — follow the **Unix branch**.

---

## Unix branch (macOS / Linux)

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

---

## Windows branch

1. Get `REPO_DIR` — the absolute path of this repo (the directory containing `hooks.json` and `cli/notify.ps1`). Use forward slashes in any path you write into JSON.
2. Ensure `$env:USERPROFILE\.claude\` exists (`New-Item -ItemType Directory -Force`).
3. Install `notify.ps1` into `~/.claude/notify.ps1`:
   - Try `New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.claude\notify.ps1 -Target $REPO_DIR\cli\notify.ps1 -Force`. (Symlink to a file requires Developer Mode or admin.)
   - If that fails — fall back to `Copy-Item $REPO_DIR\cli\notify.ps1 $env:USERPROFILE\.claude\notify.ps1 -Force` and tell the user that `git pull` will not auto-update the installed copy — they need to re-run `/install-hooks` after pulling.
   - If `~/.claude/notify.ps1` already exists and is NOT a symlink to this repo's file (i.e. a real file), **ask the user** whether to overwrite — do not silently clobber custom scripts.
4. Optionally check for the `BurntToast` PowerShell module (`Get-Module -ListAvailable BurntToast`). If missing, tell the user that toasts will use a WinForms balloon fallback, and `Install-Module BurntToast -Scope CurrentUser` enables nicer Win10/11 toasts. Do not abort — `notify.ps1` has a fallback.
5. Build the Windows fragment to merge into settings.json. Resolve `$env:USERPROFILE` to the actual absolute path **at install time** (e.g. `C:/Users/jane/.claude/notify.ps1`) and use forward slashes — env-var expansion in hook commands is not guaranteed across shells on Windows. Shape:

   ```json
   {
     "hooks": {
       "Stop": [{"hooks": [{
         "type": "command",
         "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"<RESOLVED_USERPROFILE>/.claude/notify.ps1\" -Type Stop"
       }]}],
       "Notification": [{"hooks": [{
         "type": "command",
         "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"<RESOLVED_USERPROFILE>/.claude/notify.ps1\" -Type Notification"
       }]}]
     }
   }
   ```

6. Read `~/.claude/settings.json`. If the file does not exist, treat it as `{}`.
7. **Back up** the current settings file to `~/.claude/settings.json.bak.<timestamp>` (timestamp format `yyyyMMdd-HHmmss`) via `Copy-Item`. Do this before any write.
8. Merge the `hooks.Stop` and `hooks.Notification` arrays from the fragment into settings.json:
   - **Preserve ALL other top-level fields** (`env`, `statusLine`, `spinnerVerbs`, `enabledPlugins`, `language`, etc.). Touch nothing outside `hooks`.
   - If `hooks.Stop` or `hooks.Notification` already exist and the existing `command` is different (including the macOS `terminal-notifier` variant from a prior install), **ask the user** whether to (a) overwrite, (b) append alongside, or (c) skip that specific hook.
   - If an existing entry is byte-identical to the fragment, skip it as already installed.
9. Write the updated settings.json back using the Write tool. Preserve valid JSON with 2-space indentation.
10. Report to the user:
    - The path to `notify.ps1` (and whether it is a symlink or a copy)
    - Which hooks were installed / skipped / overwritten
    - The absolute path to the backup file
    - Whether BurntToast is installed (and the install command if not)
    - A reminder that changes take effect on the next Claude Code session

---

IMPORTANT: never edit settings.json blindly. Always read → back up → merge → write. If anything goes wrong, tell the user the backup path so they can restore.
