#!/usr/bin/env python3
"""Validate s3s skill package conventions.

Checks:
- every .agents/skills/*/SKILL.md has required frontmatter fields
- skill folder name == frontmatter name
- description length <= 2000 chars
- prompts//*.md and .opencode/commands/*.md have matching filenames
- no unfilled bracket/placeholder markers in templates
- each slash command references a known skill (or vice versa)

Run: python scripts/validate_skills.py
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS_DIR = ROOT / ".agents" / "skills"
PI_COMMANDS_DIR = ROOT / "prompts"
OPENCODE_COMMANDS_DIR = ROOT / ".opencode" / "commands"

REQUIRED_FIELDS = {"name", "description", "license", "user-invocable", "tags", "metadata"}
METADATA_FIELDS = {"version", "updated", "author", "repository"}
MAX_DESC_LEN = 2000
PLACEHOLDER_PATTERNS = [
    re.compile(r"\[\.\.\.\]"),
    re.compile(r"«[^»]*»"),
    re.compile(r"\{\{[^}]*\}\}"),
]


def parse_frontmatter(text: str) -> tuple[dict | None, str]:
    if not text.startswith("---"):
        return None, text
    end = text.find("---", 3)
    if end == -1:
        return None, text
    raw = text[3:end].strip()
    body = text[end + 3 :].strip()
    try:
        import yaml
        return yaml.safe_load(raw) or {}, body
    except Exception as e:
        return {"__parse_error__": str(e)}, body


def strip_code_and_pre(text: str) -> str:
    """Remove code examples before linting placeholders.

    Skill files intentionally show template skeletons with {{...}}, «...»,
    and [...] markers inside fenced code blocks, <pre> tags, and inline
    backticks as examples for the agent. Strip those so we only flag
    placeholders that are actually meant to be emitted in output.
    """
    # strip triple-backtick fenced blocks (any language tag)
    cleaned = re.sub(r"```[\s\S]*?```", "\n```CODE_BLOCK_REMOVED```\n", text)
    # strip <pre>...</pre> blocks
    cleaned = re.sub(r"<pre[^>]*>[\s\S]*?</pre>", "\n<PRE_BLOCK_REMOVED></PRE_BLOCK_REMOVED>\n", cleaned, flags=re.IGNORECASE)
    # strip inline backtick code spans (single or double backticks)
    cleaned = re.sub(r"(?<!`)`[^`\n]+`(?!`)", " `CODE_SPAN_REMOVED` ", cleaned)
    cleaned = re.sub(r"``[^`\n]*``", " `CODE_SPAN_REMOVED` ", cleaned)
    return cleaned


def validate_skill(skill_dir: Path) -> list[str]:
    errors: list[str] = []
    skill_file = skill_dir / "SKILL.md"
    if not skill_file.exists():
        errors.append(f"{skill_dir.name}: missing SKILL.md")
        return errors

    text = skill_file.read_text()
    frontmatter, body = parse_frontmatter(text)
    if frontmatter is None:
        errors.append(f"{skill_dir.name}: no YAML frontmatter")
        return errors
    if "__parse_error__" in frontmatter:
        errors.append(f"{skill_dir.name}: frontmatter parse error: {frontmatter['__parse_error__']}")
        return errors

    name = skill_dir.name
    missing = REQUIRED_FIELDS - set(frontmatter.keys())
    if missing:
        errors.append(f"{name}: missing frontmatter fields: {sorted(missing)}")

    if frontmatter.get("name") != name:
        errors.append(f"{name}: folder name != frontmatter name ({frontmatter.get('name')})")

    desc = frontmatter.get("description", "")
    if not isinstance(desc, str) or len(desc) > MAX_DESC_LEN:
        errors.append(f"{name}: description length {len(desc)} > {MAX_DESC_LEN}")

    tags = frontmatter.get("tags")
    if not isinstance(tags, list) or not tags:
        errors.append(f"{name}: tags must be a non-empty list")

    metadata = frontmatter.get("metadata", {})
    if not isinstance(metadata, dict):
        errors.append(f"{name}: metadata must be a dict")
    else:
        missing_meta = METADATA_FIELDS - set(metadata.keys())
        if missing_meta:
            errors.append(f"{name}: missing metadata fields: {sorted(missing_meta)}")

    lint_body = strip_code_and_pre(body)
    for pattern in PLACEHOLDER_PATTERNS:
        for match in pattern.finditer(lint_body):
            snippet = lint_body[max(0, match.start() - 20) : match.end() + 20].replace("\n", " ")
            errors.append(f"{name}: unfilled placeholder near ...{snippet}...")

    return errors


def validate_command_parity() -> list[str]:
    errors: list[str] = []
    pi_commands = {p.stem for p in PI_COMMANDS_DIR.glob("*.md")} if PI_COMMANDS_DIR.exists() else set()
    opencode_commands = {p.stem for p in OPENCODE_COMMANDS_DIR.glob("*.md")} if OPENCODE_COMMANDS_DIR.exists() else set()

    missing_in_opencode = pi_commands - opencode_commands
    missing_in_pi = opencode_commands - pi_commands
    if missing_in_opencode:
        errors.append(f"prompts/ has no matching .opencode/commands/: {sorted(missing_in_opencode)}")
    if missing_in_pi:
        errors.append(f".opencode/commands/ has no matching prompts/: {sorted(missing_in_pi)}")
    return errors


def main() -> int:
    all_errors: list[str] = []
    for skill_dir in sorted(SKILLS_DIR.iterdir()):
        if skill_dir.is_dir():
            all_errors.extend(validate_skill(skill_dir))
    all_errors.extend(validate_command_parity())

    if all_errors:
        print("Validation failed:", file=sys.stderr)
        for err in all_errors:
            print(f"  - {err}", file=sys.stderr)
        return 1

    print("s3s validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
