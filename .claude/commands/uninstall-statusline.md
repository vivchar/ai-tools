Uninstall the Claude Code statusline (the one from this repo) from `~/.claude/`.

Steps:

1. **Detect OS.** If `$IsWindows` is true or `$env:OS` equals `Windows_NT` — Windows; otherwise Unix. Both branches do the same logical work but on different files.
2. Identify the installed file:
   - **Unix:** `~/.claude/statusline.sh`. If it is a symlink pointing at this repo's `cli/statusline.sh`, remove it (`rm`). If it exists but is not such a symlink, **do not remove** — tell the user it looks like a custom script and ask whether to delete.
   - **Windows:** `~/.claude/statusline.ps1`. If it is a symlink to this repo's `cli/statusline.ps1`, or a byte-identical copy of it, remove it (`Remove-Item`). Otherwise — ask the user before deleting.
3. Read `~/.claude/settings.json`. If missing or has no `statusLine` field — nothing more to do, tell the user and stop.
4. **Back up** settings to `~/.claude/settings.json.bak.<timestamp>` before any write (`cp` on Unix with `%Y%m%d-%H%M%S`; `Copy-Item` on Windows with `yyyyMMdd-HHmmss`).
5. Read `statusline.json` from the repo root for reference. Treat the current `statusLine` as removable if its `command` matches **either** the Unix variant (`~/.claude/statusline.sh`) **or** the Windows variant (`powershell ... %USERPROFILE%/.claude/statusline.ps1`). If it differs, **ask the user** whether to remove anyway or keep.
6. If the entry is removable, delete the `statusLine` key entirely.
7. **Preserve all other top-level fields.**
8. Write the updated settings.json back (2-space indent).
9. Report what was removed (the `statusline.sh`/`statusline.ps1` file + settings key) and the backup path.
