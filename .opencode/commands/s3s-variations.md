---
description: Generate 5-10 composition / camera variations for one Seedance 2.0 moment while keeping the same @tags and scene intent.
argument-hint: "[one scene / beat to explore]"
---

# /s3s-variations — Composition Variations for One Moment

Load **`seedance-shotlist-variations`** from the s3s package and run it on the user's scene/beat below.

## User input

$ARGUMENTS

## Rules

- Default to 10 variations unless the user asked for fewer.
- Keep style, `@tag` assets, scene intent, continuity, and duration fixed.
- Vary camera, framing, angle, lens feel, and emphasis only.
- Return: Director's read → Locked constants → Numbered variations with why-it-works + final prompt.
- Do not build HTML inside this command.
