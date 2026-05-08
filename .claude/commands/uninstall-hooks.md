Uninstall the Claude Code notification hooks (the ones from this repo's `hooks.json`) from `~/.claude/settings.json`.

Steps:

1. **Detect OS.** If `$IsWindows` is true or `$env:OS` equals `Windows_NT` — Windows; otherwise Unix. The matching/cleanup logic is the same on both platforms but the file paths and the second cleanup step differ.
2. Read `hooks.json` from the repo root — these are the macOS command strings to match. Also derive the Windows command strings as they would be installed by `/install-hooks` on Windows (powershell calling `%USERPROFILE%/.claude/notify.ps1` with `-Type Stop` or `-Type Notification`). Match against **both sets** so a Windows user who once installed on macOS (or vice versa) gets a clean removal.
3. Read `~/.claude/settings.json`. If missing or has no `hooks` field — nothing to do, tell the user and stop.
4. **Back up** settings to `~/.claude/settings.json.bak.<timestamp>` before any write (use `cp` on Unix, `Copy-Item` on Windows; timestamp `%Y%m%d-%H%M%S` / `yyyyMMdd-HHmmss`).
5. Remove from `hooks.Stop` and `hooks.Notification` any entry whose `command` matches one of the macOS or Windows commands described above.
6. Cleanup:
   - If `hooks.Stop` becomes an empty array, delete the `Stop` key.
   - Same for `hooks.Notification`.
   - If the whole `hooks` object becomes empty, delete `hooks`.
7. **Preserve all other top-level fields.**
8. Write the updated settings.json back (2-space indent).
9. **Windows only:** if `~/.claude/notify.ps1` exists and is either a symlink pointing at this repo's `cli/notify.ps1` *or* a byte-identical copy of it, remove it. If it differs, do not remove — tell the user it looks customized and ask whether to delete.
10. Report which entries were removed, whether `notify.ps1` was removed (Windows), and the backup path. If nothing matched, tell the user no changes were made.
