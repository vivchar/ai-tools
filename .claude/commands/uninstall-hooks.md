Uninstall the Claude Code notification hooks (the ones from this repo's `hooks.json`) from `~/.claude/settings.json`.

Steps:

1. Read `hooks.json` from the repo root — these are the exact command strings to match and remove.
2. Read `~/.claude/settings.json`. If missing or has no `hooks` field — nothing to do, tell the user and stop.
3. **Back up** settings to `~/.claude/settings.json.bak.<timestamp>` before any write.
4. Remove from `hooks.Stop` and `hooks.Notification` any entry whose `command` matches one of the commands in `hooks.json`.
5. Cleanup:
   - If `hooks.Stop` becomes an empty array, delete the `Stop` key.
   - Same for `hooks.Notification`.
   - If the whole `hooks` object becomes empty, delete `hooks`.
6. **Preserve all other top-level fields.**
7. Write the updated settings.json back (2-space indent).
8. Report which entries were removed and the backup path. If nothing matched, tell the user no changes were made.
