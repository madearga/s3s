---
description: Seedance 2.0 shotlist workflow — smart router. With a script/treatment → builds the HTML shotlist. With a vague idea → runs the creative interview first.
---

# /s3s — Seedance 2.0 Shotlist Workflow

You are entering the s3s two-skill workflow. Route based on what the user gave you.

## Routing logic

- If `$ARGUMENTS` (or the conversation) contains a **finished script, scene breakdown, treatment, or any narrative content with concrete scenes/actions/characters** → load the **`seedance-shotlist-director`** skill and build the HTML shotlist directly. Skip the interview.
- If `$ARGUMENTS` is **vague, a one-line idea, a concept, or empty** ("I have an idea for a video about...", "help me make a film about my dog", or no args) → load the **`seedance-shotlist-interview`** skill first. It will produce a mini-treatment + brief + `@tag` element list, then hand off to `seedance-shotlist-director` to build the HTML.
- If unsure which path → ask the user one question: *"Do you already have a script or scene breakdown, or should we develop the idea together first?"* Then route accordingly. Default to interview for newbie-style phrasing.

## User input

$ARGUMENTS

## Rules

- Load the relevant skill(s) via the skill tool before acting. Do not improvise the workflow — follow the skill's SKILL.md exactly.
- English prompts only inside the HTML, even if the user writes in another language.
- Output the final `shotlist.html` to `~/Desktop/shotlist.html` on macOS (the skill's default `/mnt/user-data/outputs/` is a Linux/Higgsfield path — adapt to the user's platform).
- Open the HTML in the default browser after writing it.
- If `@tag` image references are involved, list them in the Elements block of the HTML and bind them into every prompt's Characters/Scene/CUT lines.