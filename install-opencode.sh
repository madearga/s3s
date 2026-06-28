#!/usr/bin/env bash
# install-opencode.sh — make s3s skills + commands available globally in opencode.
# Idempotent + self-cleaning: safe to re-run. Creates symlinks, never copies,
# so `pi update` / `git pull` keeps opencode in sync automatically. Also removes
# dangling symlinks for skills/commands that no longer exist in the repo.
set -euo pipefail

CLONE_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DEST="${HOME}/.agents/skills"
COMMANDS_DEST="${HOME}/.config/opencode/commands"

mkdir -p "$SKILLS_DEST" "$COMMANDS_DEST"

echo "Linking skills → $SKILLS_DEST"
# Remove dangling symlinks pointing into this clone (skill deleted from repo)
find "$SKILLS_DEST" -maxdepth 1 -type l -lname "$CLONE_DIR/*" ! -path "$CLONE_DIR/*" 2>/dev/null | while read -r link; do
  if [[ ! -e "$link" ]]; then rm -f "$link"; echo "  ✗ removed dangling $(basename "$link")"; fi
done
for skill_dir in "$CLONE_DIR"/.agents/skills/*/; do
  [[ -e "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  link="$SKILLS_DEST/$name"
  if [[ -L "$link" || -d "$link" ]]; then rm -rf "$link"; fi
  ln -s "$skill_dir" "$link"
  echo "  ✓ $name"
done

echo "Linking commands → $COMMANDS_DEST"
# Remove dangling command symlinks pointing into this clone
find "$COMMANDS_DEST" -maxdepth 1 -type l -lname "$CLONE_DIR/*" 2>/dev/null | while read -r link; do
  if [[ ! -e "$link" ]]; then rm -f "$link"; echo "  ✗ removed dangling $(basename "$link" .md)"; fi
done
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
echo "  - Slash commands available: /s3s  /s3s-references  /s3s-interview  /s3s-shotlist"