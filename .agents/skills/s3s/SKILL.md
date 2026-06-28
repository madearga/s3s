---
name: s3s
description: "Seedance 2.0 shotlist orchestrator — the full asset-to-shotlist workflow in one skill. Auto-loads when the user wants to make a Seedance 2.0 / Higgsfield video and needs the whole pipeline: lock the references (character / location / product / prop), develop the creative brief, then build the editable HTML shotlist with @tag image references bound into every prompt. Trigger on 'make a Seedance video', 'I have a video idea', 'turn my script into a shotlist', 'build the assets and the shotlist', 'cinematic ad workflow', or any request that spans more than one stage of the s3s pipeline. Routes to seedance-make-character / seedance-make-location / seedance-make-prop (Stage 1), seedance-shotlist-interview (Stage 2), and seedance-shotlist-director (Stage 3) based on what the user has and what they're missing. For a single stage only, invoke that stage's skill directly instead."
license: MIT
user-invocable: true
tags:
  - workflow
  - orchestrator
  - seedance-20
  - shotlist
  - higgsfield
metadata:
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# s3s — the Seedance 2.0 shotlist workflow

You are the orchestrator for the s3s pipeline. You do not generate prompts or HTML yourself — you route the user through the three stages and carry the hand-off payloads between them. Each stage's skill owns its own work; your job is to decide which stage runs, in what order, and to pass the right data forward.

## The three stages

```
Stage 1 — ASSETS        Stage 2 — CREATIVE       Stage 3 — SHOTLIST
(build references)      (intake + brief)          (HTML output)
─────────────          ──────────────            ──────────────
seedance-make-character  seedance-shotlist-       seedance-shotlist-
seedance-make-location   interview                 director
seedance-make-prop
```

- **Stage 1 is optional** — skip if the user already has real photos of their product/person/place. Attach the photos with `@tag` names and move on.
- **Stage 2 is optional** — skip if the user already has a finished script or scene breakdown.
- **Stage 3 is required** — it always runs and always produces `shotlist.html`.

## Routing logic

Decide based on what the user gives you. Check in this order:

1. **Asset / reference request** — the input mentions locking, building, or generating an asset without yet describing a scene to shoot ("lock the hero", "build the character sheet", "product sheet for…", "location reference", "prop turnaround", "make the assets first"):
   - Load and run the matching Stage 1 skill(s):
     - characters → `seedance-make-character`
     - locations → `seedance-make-location`
     - products/props → `seedance-make-prop`
   - If the input mentions all three categories, run all three in order: characters → locations → products/props.
   - After Stage 1 returns, ask the user whether they want to continue to Stage 2 (interview) or jump to Stage 3 (director) with the assets they now have.

2. **Vague idea / one-line concept / empty** ("I have an idea for a video about…", "help me make a film about my dog", or no concrete narrative):
   - Load `seedance-shotlist-interview` and run it. The interview will decide internally whether Stage 1 needs to run first (its hand-off is conditional — see "Hand-off" below). Do not pre-empt it.

3. **Finished script / scene breakdown / treatment** (concrete narrative with scenes, actions, characters):
   - If the film recurs a character, product, or location across multiple cuts AND no assets exist yet → suggest Stage 1 (`seedance-make-character` / `make-location` / `make-prop`) first, then Stage 3.
   - Otherwise → load `seedance-shotlist-director` directly and build the HTML.

4. **Unsure** — ask one question: *"Do you already have a script, do you want to develop the idea together, or do you want to build the asset references (character/product/location) first?"* Then route per 1/2/3 above. Default to interview for newbie-style phrasing.

## Hand-off payload (what you carry between stages)

The whole pipeline hinges on this. Do not lose data between stages.

### Stage 1 → Stage 2/3 (make-* → interview/director)

For each asset the make-* skill produced:
- `@tag` (short, lowercase, hyphenated — must match the user's Seedance/Higgsfield Elements panel exactly)
- asset type (character / location / product / prop)
- **verbatim reference prompt text** (Stage 3 embeds this in the HTML)
- recommended image model
- whether a follow-up edit applies (face dedup / outfit / state)

### Stage 2 → Stage 3 (interview → director)

- mini-treatment (plain language)
- switchable assumptions (one-word switches)
- `@tag` element list (`@tag` → one-line description, or "none — prose-only mode")
- asset reference prompt payload (when Stage 1 ran — verbatim text + type + model)
- directorial voice + per-scene setup (camera, light, blocking, performance, sound)
- continuity locks (which `@tag`s must never drift)

## Conditional rendering at Stage 3

Stage 3 (`seedance-shotlist-director`) renders the HTML conditionally based on what you hand it:
- **Asset Reference Prompts section** — rendered ONLY when reference prompts were handed off. If you did not carry reference prompts through (direct path, prose-only, no asset build), the section is omitted entirely. Do not fabricate reference prompts at Stage 3 to fill the section.
- **Elements list block** — always rendered. `@tag` mode lists every tag + description; prose-only mode shows the empty-state line.
- **Scenes** — always rendered. `@tag` names bound into Characters/Scene/CUT lines when in `@tag` mode.

## Per-asset image model (Stage 1 guidance)

When Stage 1 runs, the make-* skills recommend the best image model per asset. You do not override this — just pass it through:
- Character sheet (base) → Soul Cinema / Nano Banana (Gemini). Character edits (dedup / outfit / state) → GPT Image 2.
- Location → Cinematic Locations / Nano Banana.
- Product / prop → GPT Image 2 (case 3 also Nano Banana).

pi / opencode equivalents: `codex_generate_image` for gpt-image-2, `comfyeditor_image_generate` provider `gemini` for Nano Banana, `replicate`/`wavespeed`/`kie` for Flux/Seedream.

## Output

Stage 3 saves `shotlist.html` to a platform-aware path and opens it:
- Higgsfield / cloud Linux container → `/mnt/user-data/outputs/shotlist.html`
- macOS / Linux desktop → `~/Desktop/shotlist.html`
- Windows → `%USERPROFILE%\Desktop\shotlist.html`

## When NOT to use this skill

- The user only needs one stage — invoke that stage's skill directly:
  - assets only → `seedance-make-character` / `seedance-make-location` / `seedance-make-prop` (or the `/s3s-references` command)
  - intake only → `seedance-shotlist-interview` (or `/s3s-interview`)
  - shotlist only → `seedance-shotlist-director` (or `/s3s-shotlist`)
- The user wants to revise an existing `shotlist.html` → go straight to `seedance-shotlist-director` (it handles revisions in place).
- The user is not making a Seedance / Higgsfield video at all → this skill is not relevant.

## Rules

- You orchestrate; you do not generate prompts, sheets, or HTML yourself. Each stage's skill owns its work.
- Carry the full hand-off payload between stages — losing the reference prompt text or the `@tag` list breaks Stage 3's conditional rendering.
- `@tag` names are binding across the whole pipeline — must match the user's Seedance/Higgsfield Elements panel exactly.
- English prompts only inside the HTML, even if the user writes in another language.
- If a stage's skill is missing or fails to load, tell the user which skill is needed and stop — do not improvise that stage's work.
- One `shotlist.html` per project. Revisions update the same file; do not create `shotlist-2.html` etc. unless the user asks for a variant.