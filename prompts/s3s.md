---
description: Seedance 2.0 shotlist workflow — smart router. Asset request → build references. With a script/treatment → builds the HTML shotlist. With a vague idea → runs the creative interview first.
argument-hint: "[script text, idea, or paste your scene]"
---

# /s3s — Seedance 2.0 Shotlist Workflow

You are entering the s3s two-skill workflow. Route based on what the user gave you.

## Routing logic

Check for asset requests FIRST, then script vs idea:

- **Asset / reference request** — if `$ARGUMENTS` mentions locking, building, or generating an asset without yet describing a scene to shoot: "lock the hero", "build the character sheet", "product sheet for...", "location reference", "prop turnaround", "make the assets first" → invoke **`/s3s-references`** (which dispatches to `seedance-make-character` / `seedance-make-location` / `seedance-make-prop`). Skip the interview and director until the assets exist.
- **Finished script / scene breakdown / treatment** — any narrative content with concrete scenes, actions, or characters → invoke **`seedance-shotlist-director`** and build the HTML shotlist directly. Skip the interview.
- **Vague idea / one-line concept / empty** — "I have an idea for a video about...", "help me make a film about my dog", or no args → invoke **`seedance-shotlist-interview`** first. It produces a mini-treatment + brief + `@tag` element list (+ asset reference prompts if Stage 1 runs), then hands off to `seedance-shotlist-director`.
- **Unsure** → ask one question: *"Do you already have a script, do you want to develop the idea together, or do you want to build the asset references (character/product/location) first?"* Then route. Default to interview for newbie-style phrasing.

## User input

$ARGUMENTS

## Rules

- Load the relevant skill(s) from the s3s package before acting. Do not improvise the workflow — follow the skill's SKILL.md exactly.
- English prompts only inside the HTML, even if the user writes in another language.
- Output the final `shotlist.html` to `~/Desktop/shotlist.html` on macOS (the skill's default `/mnt/user-data/outputs/` is a Linux/Higgsfield path — adapt to the user's platform).
- Open the HTML in the default browser after writing it.
- If `@tag` image references are involved, list them in the Elements block of the HTML and bind them into every prompt's Characters/Scene/CUT lines.