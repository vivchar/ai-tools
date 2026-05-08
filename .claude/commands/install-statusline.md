Install the Claude Code statusline from this repo into `~/.claude/`.

Perform these steps exactly and in order.

1. **Detect OS.** If `$IsWindows` is true (PowerShell 7+) or `$env:OS` equals `Windows_NT` (cmd/PS5.1) — follow the **Windows branch** below. Otherwise (macOS / Linux) — follow the **Unix branch**.

---

## Unix branch (macOS / Linux)

1. Check that `jq` is installed (the statusline script uses it at runtime). If missing — tell the user to run `brew install jq` before proceeding, then abort.
2. Run `pwd` to get the absolute path of this repo — call it `REPO_DIR`. The script lives at `$REPO_DIR/cli/statusline.sh`.
3. Ensure `$REPO_DIR/cli/statusline.sh` exists and is executable (`chmod +x`).
4. Create `~/.claude/` if missing (`mkdir -p ~/.claude`).
5. Create a symlink: `ln -sfn $REPO_DIR/cli/statusline.sh ~/.claude/statusline.sh`. If `~/.claude/statusline.sh` already exists and is NOT a symlink (i.e. a real file), **ask the user** whether to overwrite — do not silently clobber custom scripts.
6. Read `statusline.json` from the repo root. This is the fragment to install.
7. Read `~/.claude/settings.json`. If the file does not exist, treat it as `{}`.
8. **Back up** the current settings file to `~/.claude/settings.json.bak.<timestamp>` (use `date +%Y%m%d-%H%M%S`) via `cp`. Do this before any write.
9. Merge the `statusLine` field from the fragment into settings.json:
   - **Preserve ALL other top-level fields** (`env`, `hooks`, `spinnerVerbs`, `enabledPlugins`, `language`, etc.). Touch nothing outside `statusLine`.
   - If `statusLine` already exists and differs from the fragment, **ask the user** whether to overwrite or skip. Do not silently clobber.
10. Write the updated settings.json back using the Write tool. Preserve valid JSON with 2-space indentation.
11. Report to the user:
    - The symlink path and its target
    - Whether `statusLine` was installed / skipped / overwritten
    - The absolute path to the backup file
    - A reminder to restart Claude Code to see the new statusline

---

## Windows branch

1. Get `REPO_DIR` — the absolute path of this repo (the directory containing `cli/statusline.ps1`). Use forward slashes in any path you write into JSON.
2. Ensure `$env:USERPROFILE\.claude\` exists (`New-Item -ItemType Directory -Force`).
3. Install `statusline.ps1` into `~/.claude/statusline.ps1`:
   - Try `New-Item -ItemType SymbolicLink -Path $env:USERPROFILE\.claude\statusline.ps1 -Target $REPO_DIR\cli\statusline.ps1 -Force`. (Symlink to a file requires Developer Mode or admin.)
   - If that fails — fall back to `Copy-Item $REPO_DIR\cli\statusline.ps1 $env:USERPROFILE\.claude\statusline.ps1 -Force` and tell the user that `git pull` will not auto-update the installed copy — they need to re-run `/install-statusline` after pulling.
   - If `~/.claude/statusline.ps1` already exists and is NOT a symlink to this repo's file, **ask the user** whether to overwrite — do not silently clobber.
4. Build the Windows fragment to merge into settings.json. Resolve `$env:USERPROFILE` to the actual absolute path **at install time** (e.g. `C:/Users/jane/.claude/statusline.ps1`) and use forward slashes — env-var expansion in statusline commands is not guaranteed across shells on Windows. Shape:

   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"<RESOLVED_USERPROFILE>/.claude/statusline.ps1\"",
       "padding": 2
     }
   }
   ```

5. Read `~/.claude/settings.json`. If the file does not exist, treat it as `{}`.
6. **Back up** the current settings file to `~/.claude/settings.json.bak.<timestamp>` (timestamp format `yyyyMMdd-HHmmss`) via `Copy-Item`. Do this before any write.
7. Merge the `statusLine` field from the fragment into settings.json:
   - **Preserve ALL other top-level fields** (`env`, `hooks`, `spinnerVerbs`, `enabledPlugins`, `language`, etc.). Touch nothing outside `statusLine`.
   - If `statusLine` already exists and differs (including the macOS `~/.claude/statusline.sh` variant from a prior install), **ask the user** whether to overwrite or skip.
8. Write the updated settings.json back using the Write tool. Preserve valid JSON with 2-space indentation.
9. Report to the user:
   - The path to `statusline.ps1` (and whether it is a symlink or a copy)
   - Whether `statusLine` was installed / skipped / overwritten
   - The absolute path to the backup file
   - A reminder to restart Claude Code to see the new statusline

---

IMPORTANT: never edit settings.json blindly. Always read → back up → merge → write. If anything goes wrong, tell the user the backup path so they can restore.
