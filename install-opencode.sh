#!/usr/bin/env bash
# install-opencode.sh — make s3s skills + commands available globally in opencode.
# Idempotent + self-cleaning + SAFE: safe to re-run. Creates symlinks, never copies,
# so `pi update` / `git pull` keeps opencode in sync automatically. Removes only
# symlinks it owns (never a user's real skill/command directory or file). Aborts
# with a clear error if a real (non-symlink) file/dir occupies a target path.
set -euo pipefail

CLONE_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DEST="${HOME}/.agents/skills"
COMMANDS_DEST="${HOME}/.config/opencode/commands"

mkdir -p "$SKILLS_DEST" "$COMMANDS_DEST"

# Safe removal: only delete symlinks. A real file/dir at the target is the user's
# — refuse to clobber it; print a warning and skip.
safe_remove() {
  local link="$1" kind="$2"
  if [[ -L "$link" ]]; then
    rm -f "$link"
  elif [[ -e "$link" ]]; then
    echo "  ⚠ skip: $kind '$link' is a real $( [[ -d "$link" ]] && echo directory || echo file ), not a symlink. Leaving it untouched. Remove it manually if you want s3s to manage it." >&2
    return 1
  fi
  return 0
}

echo "Linking skills → $SKILLS_DEST"
# Remove dangling symlinks pointing into this clone (skill deleted from repo)
find "$SKILLS_DEST" -maxdepth 1 -type l -lname "$CLONE_DIR/*" 2>/dev/null | while read -r link; do
  if [[ ! -e "$link" ]]; then rm -f "$link"; echo "  ✗ removed dangling $(basename "$link")"; fi
done
for skill_dir in "$CLONE_DIR"/.agents/skills/*/; do
  [[ -e "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  link="$SKILLS_DEST/$name"
  if ! safe_remove "$link" "skill"; then echo "  ⊘ $name (kept existing)"; continue; fi
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
  if ! safe_remove "$link" "command"; then echo "  ⊘ /${name%.md} (kept existing)"; continue; fi
  ln -s "$cmd_file" "$link"
  echo "  ✓ /${name%.md}"
done

echo
echo "Done. Restart opencode (or start a new session) and:"
echo "  - Skills auto-load via the skill tool when you describe a video task"
echo "  - Slash commands available: /s3s  /s3s-references  /s3s-interview  /s3s-shotlist"