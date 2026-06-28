#!/usr/bin/env bash
# install-opencode.sh — make s3s skills + commands available globally in opencode.
# Idempotent: safe to re-run. Creates symlinks, never copies, so `pi update` / `git pull`
# keeps opencode in sync automatically.
set -euo pipefail

CLONE_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DEST="${HOME}/.agents/skills"
COMMANDS_DEST="${HOME}/.config/opencode/commands"

mkdir -p "$SKILLS_DEST" "$COMMANDS_DEST"

echo "Linking skills → $SKILLS_DEST"
for skill_dir in "$CLONE_DIR"/.agents/skills/*/; do
  name="$(basename "$skill_dir")"
  link="$SKILLS_DEST/$name"
  if [[ -L "$link" || -d "$link" ]]; then rm -rf "$link"; fi
  ln -s "$skill_dir" "$link"
  echo "  ✓ $name"
done

echo "Linking commands → $COMMANDS_DEST"
for cmd_file in "$CLONE_DIR"/.opencode/commands/*.md; do
  [[ -e "$cmd_file" ]] || continue
  name="$(basename "$cmd_file")"
  link="$COMMANDS_DEST/$name"
  if [[ -L "$link" || -f "$link" ]]; then rm -f "$link"; fi
  ln -s "$cmd_file" "$link"
  echo "  ✓ /${name%.md}"
done

echo
echo "Done. Restart opencode (or start a new session) and:"
echo "  - Skills auto-load via the skill tool when you describe a video task"
echo "  - Slash commands available: /s3s  /s3s-interview  /s3s-shotlist"