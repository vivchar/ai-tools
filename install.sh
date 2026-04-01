#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

# Claude Code
CLAUDE_SKILLS="$HOME/.claude/skills"
mkdir -p "$CLAUDE_SKILLS"

# Other agents (Copilot CLI, Codex, Gemini CLI)
AGENTS_SKILLS="$HOME/.agents/skills"
mkdir -p "$AGENTS_SKILLS"

echo "Installing skills from $SKILLS_DIR..."

for skill_dir in "$SKILLS_DIR"/*/; do
  name=$(basename "$skill_dir")

  ln -sfn "$skill_dir" "$CLAUDE_SKILLS/$name"
  ln -sfn "$skill_dir" "$AGENTS_SKILLS/$name"

  echo "  ✓ $name"
done

echo ""
echo "Done. Installed $(ls -d "$SKILLS_DIR"/*/ | wc -l | tr -d ' ') skills."
echo "To update — git pull && ./install.sh"
