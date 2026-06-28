---
description: Seedance 2.0 creative interview — for vague ideas with no script yet. Produces a mini-treatment + brief + @tag element list, then builds the shotlist HTML.
---

# /s3s-interview — Creative Interview (newbie-friendly)

Load the **`seedance-shotlist-interview`** skill and run it on the user's input below. Follow the skill's SKILL.md exactly.

## User input

$ARGUMENTS

## Rules

- Max 5 questions in one batch. Every question ships with a default ("not sure? I'll go with [default]").
- Ask in pictures, not parameters. Never use words like "aspect ratio", "blocking", "shot" unless the user is a pro.
- If the user speaks production language fluently, switch to pro intake (deliverables, territory, aspect ratio, approval owner, rights).
- After one round of answers (or zero if the idea is already rich), propose: mini-treatment + switchable assumptions + `@tag` element list + production brief.
- Then load **`seedance-shotlist-director`** to build the HTML shotlist from the brief. Do not build the HTML inside this command — that is the director's job.
- Output `shotlist.html` to `~/Desktop/shotlist.html` on macOS. Open it in the default browser.
- English prompts only inside the HTML.