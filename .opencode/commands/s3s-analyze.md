---
description: Reverse-engineer a reference video into a Seedance 2.0 brief, @tag asset list, continuity locks, and a shotlist-ready hand-off.
argument-hint: "[video URL, file path, or describe the clip to analyze]"
---

# /s3s-analyze — Reverse-engineer a Video

Load **`seedance-shotlist-analyze`** from the s3s package and run it on the user's reference clip below.

## User input

$ARGUMENTS

## Rules

- Output a practical recreation brief, not theory.
- Return: Director's read → Style analysis → Camera + motion breakdown → Continuity locks → Recommended `@tag` assets → Shotlist-ready hand-off.
- If the user wants recreation, recommend the next step in the s3s workflow (references / interview / shotlist).
- Do not build HTML inside this command.
