---
name: seedance-shotlist-analyze
description: "Reverse-engineer a reference video into a Seedance 2.0 production brief. Use when the user has a video file, ad, reel, or clip they want analyzed into style, camera, motion, continuity, @tag asset needs, and a shotlist-ready hand-off for the s3s workflow. Trigger on 'analyze this video', 'reverse engineer this ad', 'extract the prompt from this clip', 'break down this reel', or any request to study an existing video before recreating it."
license: MIT
user-invocable: true
tags:
  - analyze
  - reverse-engineering
  - brief
  - shotlist
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-29"
  parent: "s3s"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-shotlist-analyze

Use this when the user already has a **video reference** and wants to turn it into a production-ready brief for the rest of s3s.

## What this skill does

Takes an existing clip and turns it into:

1. **Director's read** — what the clip is trying to achieve
2. **Style analysis** — genre, look, lighting, color, surface, duration feel
3. **Camera analysis** — lens feel, shot scale, movement, framing logic
4. **Motion analysis** — subject action, object interaction, pacing, rhythm
5. **Continuity locks** — which character / prop / location details must not drift
6. **Asset needs** — what should become `@tag` references in s3s
7. **Shotlist-ready hand-off** — concise brief for `seedance-shotlist-interview` or `seedance-shotlist-director`

## Output format

Always return these sections in order:

### 1. Director's read

One paragraph. What is the clip doing emotionally and commercially?

### 2. Style analysis

- Genre / mode (UGC, commercial, documentary, music video, drama, etc.)
- Style Prefix preset recommendation (cinematic photoreal / commercial / UGC phone / anime / documentary / music video)
- Color and light summary
- Surface recommendation (9:16, 16:9, etc.)
- Total duration feel (single 15s scene, multi-clip, one-take, etc.)

### 3. Camera + motion breakdown

Break the clip into timestamped beats if possible:

- `0:00–0:05` — shot scale, camera motion, subject motion, key action
- `0:05–0:10` — ...
- `0:10–0:15` — ...

Use plain English. If exact timestamps are unknown, use ordered beats instead.

### 4. Continuity locks

List the details that must stay identical across recreation:

- character appearance / wardrobe
- hero prop design
- location geography
- time of day / weather / light angle
- any recurring hand positions, eyeline, or product orientation

### 5. Recommended `@tag` asset list

Only list assets that should become reusable references:

- `@hero` — one-line description
- `@product` — one-line description
- `@kitchen` — one-line description

Skip assets that do not need locking.

### 6. Shotlist-ready hand-off

Provide a compact block the next s3s stage can use directly:

- title
- directorial voice
- style prefix preset
- element list
- scene/beat summary
- duration target

## Rules

- If the user only wants analysis, stop after the report.
- If the user wants to **recreate** the clip, recommend the next step:
  - references needed → `seedance-make-character` / `make-location` / `make-prop`
  - just need a brief → `seedance-shotlist-interview`
  - already have enough detail → `seedance-shotlist-director`
- Do not invent technical certainty you cannot see. Use phrases like "appears to be", "reads like", "likely" when needed.
- Keep it practical. The goal is recreation, not film-school theory.
