---
name: seedance-shotlist-variations
description: "Generate multiple shot/composition options for one Seedance 2.0 moment while keeping the same character, prop, and scene intent. Use when the user wants 5-10 variations for one beat before locking the final shotlist: camera alternatives, framing options, mood variants, or prompt options for the same moment. Trigger on 'give me variations', '10 composition options', 'different ways to shoot this', 'camera options for this scene', or any request to explore one moment before committing to the final shotlist."
license: MIT
user-invocable: true
tags:
  - variations
  - composition
  - previsualization
  - shotlist
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-29"
  parent: "s3s"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-shotlist-variations

Use this when the user already has **one scene / beat / moment** and wants multiple ways to shoot it before building the final shotlist.

## What this skill does

For one moment, generate **5 or 10** variations that keep the same:

- scene intent
- `@tag` assets
- continuity locks

...but change the **camera / composition / emphasis**.

## Input expected

- one scene or beat in plain language
- optional `@tag` assets (`@hero`, `@product`, `@kitchen`, etc.)
- optional style preset / directorial voice
- optional count (`5` or `10`; default `10`)

If the user gives a whole script, ask which scene or moment they want variants for.

## Output format

Return these sections in order:

### 1. Director's read

One sentence on what the moment must communicate.

### 2. Locked constants

List what stays fixed across all variations:

- style prefix preset
- `@tag` assets
- action beat
- continuity locks
- duration target

### 3. Variations

Provide numbered options. Each variation must include:

- **variation title**
- **why this one works** (one line)
- **final prompt** in English, ready to paste

Change only the shot design variables:

- shot scale
- lens feel
- angle
- camera motion
- framing / negative space
- light emphasis

Keep the scene/action itself the same.

## Variation ladder

Spread the options across useful differences. Do not make 10 tiny rewrites of the same shot.

Aim to cover:

1. close-up hero detail
2. medium action clarity
3. wide environmental version
4. low-angle dominance
5. overhead / top-down graphic version
6. over-shoulder subjective version
7. product-hero emphasis
8. performance/emotion emphasis
9. one-take variant
10. bold / stylized variant that still fits the brief

## Rules

- English prompts only.
- Reuse the same `@tag` names exactly.
- Keep one dominant style anchor. Do not change the project into a different film.
- If the user only wants 3 or 5, compress the ladder and keep the widest spread.
- If the user likes one variation, recommend sending that variation into `seedance-shotlist-director` as the chosen scene prompt seed.
