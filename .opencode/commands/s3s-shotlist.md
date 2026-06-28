---
description: Seedance 2.0 shotlist director — build the HTML shotlist directly from a script/treatment you already have. Skips the interview.
argument-hint: "[paste your script or scene breakdown]"
---

# /s3s-shotlist — Build Shotlist from Script

Load the **`seedance-shotlist-director`** skill and build the HTML shotlist directly from the user's input below. Follow the skill's SKILL.md exactly. Skip the interview — the user already has narrative content.

## User input

$ARGUMENTS

## Rules

- Read the input as a director: find the dramatic shape, block scenes, decide prompt count per scene (each prompt = 15 seconds; split long scenes into 3a/3b/3c).
- If the user attached named images (`@hero`, `@kitchen`, etc.) or named them in chat, use `@tag` binding mode + render the Elements list block in the HTML. Otherwise use prose-only mode + the Elements empty-state block.
- Style Prefix verbatim at the top of every prompt. Characters, Scene (geo-spatial), CUT 1/2/3 with acting beats, eye-line, lighting, camera motivation.
- English prompts only inside the HTML, even if the user writes in another language.
- Output `shotlist.html` to `~/Desktop/shotlist.html` on macOS (adapt the skill's `/mnt/user-data/outputs/` default to the user's platform). Open it in the default browser after writing.