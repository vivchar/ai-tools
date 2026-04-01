#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
TARGET="$CLAUDE_DIR/statusline.sh"
SOURCE="$SCRIPT_DIR/cli/statusline.sh"

mkdir -p "$CLAUDE_DIR"

# Install statusline
ln -sfn "$SOURCE" "$TARGET"
chmod +x "$SOURCE"
echo "  ✓ statusline.sh → $TARGET"

# Configure settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

# Add statusLine config via jq
if command -v jq &>/dev/null; then
  jq '.statusLine = {"type": "command", "command": "~/.claude/statusline.sh", "padding": 2}' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
  echo "  ✓ statusLine configured in settings.json"
else
  echo "  ⚠ jq not found — add this to ~/.claude/settings.json manually:"
  echo '    "statusLine": {"type": "command", "command": "~/.claude/statusline.sh", "padding": 2}'
fi

echo ""
echo "Done. Restart Claude Code to see the status line."
