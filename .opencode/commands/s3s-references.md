---
description: "Asset building router — lock characters, locations, and products/props before the shotlist. Dispatches to make-character / make-location / make-prop based on what you describe. Hands off @tags + reference prompts to the director (which embeds them in the HTML)."
argument-hint: "[describe the film's assets — characters, locations, products, props]"
---

# /s3s-references — Asset Building Router

Route the user's input to the right make-* skill(s) from the s3s package. Follow each skill's SKILL.md exactly.

## Routing

Scan `$ARGUMENTS` for asset mentions. Load and run the matching skill(s):

- **Characters** — any person, hero, side character, performer, narrator, "the boss", "a 20yo man", "the surgeon", outfit/state variants → load **`seedance-make-character`**.
- **Locations** — any room, place, setting, "the kitchen", "a stadium", "Brooklyn street", establishing shot → load **`seedance-make-location`**.
- **Products / props** — any object, product, "the headphones", "a mug", "running shoes", "the album", turnaround → load **`seedance-make-prop`**.

If the input mentions all three categories (typical for a full asset build), load and run all three in order: characters → locations → products/props.

If the user already has a real photo of an asset (their actual product/person/place), skip generation for that asset — tell them to attach the real photo with a `@tag` and move on.

## User input

$ARGUMENTS

## Rules

- English prompts only.
- Fill every `[bracket]` in the templates from the brief — never ship placeholder text.
- One face per character sheet (run the face-dedup edit when needed).
- 3/4 angle for every location (never flat head-on).
- No branding on original product/prop sheets.
- Collect every `@tag` and every reference prompt text. Hand them all off to `seedance-shotlist-director`:
  - `@tag` → one-line description (binds into the shotlist Characters/Scene/CUT lines)
  - reference prompt text (verbatim) → embedded in the HTML Asset Reference Prompts section