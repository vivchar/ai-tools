Uninstall the Claude Code statusline (the one from this repo) from `~/.claude/`.

Steps:

1. Check `~/.claude/statusline.sh`:
   - If it is a symlink pointing at this repo's `cli/statusline.sh`, remove it (`rm ~/.claude/statusline.sh`).
   - If it exists but is not a symlink, or points elsewhere, **do not remove it** — tell the user it looks like a custom script and ask whether to delete.
2. Read `~/.claude/settings.json`. If missing or has no `statusLine` field — nothing more to do, tell the user and stop.
3. **Back up** settings to `~/.claude/settings.json.bak.<timestamp>` before any write.
4. Read `statusline.json` from the repo root to identify the fragment we originally installed.
5. If the current `statusLine` in settings.json matches the fragment, delete the `statusLine` key entirely. If it differs, **ask the user** whether to remove anyway or keep.
6. **Preserve all other top-level fields.**
7. Write the updated settings.json back (2-space indent).
8. Report what was removed (symlink + settings key) and the backup path.
