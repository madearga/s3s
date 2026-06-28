---
description: "Generate locked reference-sheet prompts for Seedance 2.0 / Higgsfield — character sheets, product sheets, locations, prop turnarounds, plus outfit/state variants. Run BEFORE the shotlist to lock every asset. Hands off a @tag element list to the director."
argument-hint: "[describe the film / paste the brief — what characters, product, locations, props]"
---

# /s3s-references — Reference Sheet Generator

Load the **`seedance-shotlist-references`** skill and run it on the user's input below. Follow the skill's SKILL.md exactly.

## User input

$ARGUMENTS

## What this produces

Copy-ready English prompts for each locked reference sheet the film needs:
- **Character sheet** (`@hero`, `@boss`) — split-frame face + full-body front/back, grey bg, one face (face-dedup edit included)
- **Outfit variant** (`@s_hero_athletic`) — same face, different wardrobe
- **State variant** (`@s_hero_wet`) — same character, mid-film state change
- **Product sheet** (`@headphones`) — front + 3/4 from a source image, or original-design turnaround
- **Location** (`@kitchen`, `@stadium`) — 3/4 angle establishing shot (never flat head-on)
- **Prop** (`@moka_pot`, `@mug`) — clean studio shot or orthographic turnaround

## Rules

- Identify every character, product, location, and recurring prop from the input. Each gets a `@tag`.
- English prompts only.
- One face per character sheet — include the face-dedup edit when the full-body panel renders a second face.
- Plain solid grey background for character + product sheets.
- No branding on original product/prop sheets.
- After all sheets are generated and the user attaches them, hand off the element list (`@tag` → one-line description) to `seedance-shotlist-director` so it can bind them into the shotlist HTML.
- If the user already has real photos of their actual product/person/place, skip generation — tell them to attach the real photo with a `@tag` and go straight to the director.