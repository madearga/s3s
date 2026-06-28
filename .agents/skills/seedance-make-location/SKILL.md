---
name: seedance-make-location
description: "Generate locked location reference prompts for any Seedance 2.0 production. Genre-agnostic. Use when the user needs a stable location image to keep a room/place identical across every cut. Trigger on 'location reference', 'lock the location', 'make the kitchen', 'establishing shot', 'location sheet', or when asset building reaches the location step. Produces copy-ready English prompt templates (parameterized) — a short 3/4 template for simple rooms and a full atmospheric establishing-shot template for hero locations. The 3/4 angle is mandatory (never flat head-on) because depth is what the camera needs to move through. Returns a @tag per location and hands the prompt text to seedance-shotlist-director to embed in the HTML output."
license: MIT
user-invocable: true
tags:
  - references
  - location
  - establishing-shot
  - assets
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-make-location

A locked location reference keeps a room or place identical across every cut of a Seedance 2.0 film. Without it the room rearranges, the windows move, the props shift. With it, every shotlist prompt references the same locked image via a `@tag` and the model anchors the space.

This skill produces **copy-ready English prompt templates** (parameterized). Fill the brackets from the brief. The user runs each filled prompt in an image model, attaches the result, names it with the `@tag`. The prompt text is also handed off to `seedance-shotlist-director` so it appears in the HTML shotlist output (Asset Reference Prompts section).

## When to use

- The user asks for a location reference, establishing shot, location sheet.
- Asset building reaches the location step.
- The user says "lock the kitchen", "make the stadium", "establishing shot for the office".

Skip if the user already has a real photo of the actual place — attach it directly with a `@tag`.

## Recommended image model

Locations are photoreal cinematic stills. Match the model to the context the user is running in.

### In pi / opencode (no Cinematic Locations available)

| Asset | Primary tool | Alternative |
|---|---|---|
| **Location still** (short or full establishing) | **Nano Banana** — `comfyeditor_image_generate` provider `gemini` | GPT Image 2 — `codex_generate_image`; Flux Pro — `replicate`/`wavespeed`; Seedream — `kie` |

Rule of thumb in pi/opencode: **generate every location in Nano Banana (`comfyeditor_image_generate` provider `gemini`).** GPT Image 2 can render a room but tends toward a clean studio look; locations need lived-in atmosphere and natural light, which Nano Banana handles better.

### On the target platform (Cinematic Locations available)

| Asset | Best model | Why |
|---|---|---|
| **Location still** | **Cinematic Locations** | Photoreal cinematic depth, natural light, atmospheric haze — what the camera needs |

Rule of thumb On the target platform: **generate every location in Cinematic Locations.** GPT Image 2 tends toward a clean studio look; locations need lived-in atmosphere.

### Detect the context

- If the user mentions the target platform, Cinematic Locations, or is running inside the target app/platform → use the the target platform column.
- Otherwise → use the pi/opencode column. **Default to pi/opencode** when unsure.

If the user has a real photo of the actual place, skip generation — attach it with a `@tag`.

## Output contract

For each requested location, return:
1. A `@tag` (short, lowercase, hyphenated: `@kitchen`, `@stadium`, `@street`).
2. A copy-ready English prompt block in a code fence — fill every `[bracket]`.
3. A one-line note on what the location locks (time of day, mood, depth).
4. Hand the full set to `seedance-shotlist-director` so each reference prompt embeds in the HTML Asset Reference Prompts section, and each `@tag` binds into the shotlist Scene lines.

## Genre adaptation

The 3/4 angle is constant; adapt the **atmosphere and detail**:

| Genre | Emphasis |
|---|---|
| Product ad | 3/4 of each room the ad moves through; product-relevant surfaces clear |
| Lifestyle / UGC | Real lived-in rooms, 3/4, natural clutter |
| Drama / film | Establishing-shot atmosphere matters more than product clarity; light and mood carry the scene |
| Animation | Stylized background plate matching the art style — adjust the `Look:`/`STYLE:` line |
| Documentary | Real locations, photographed; prefer real photos |
| Music video | Mood-driven 3/4 locations; lighting/color are the star |

## The 3/4 rule (mandatory)

The 3/4 angle gives the room depth for the camera to move through, which holds up far better than a flat head-on shot. **Every location prompt uses a 3/4 angle.** Never flat head-on.

## Short template — for simple rooms

```
[room type], 3/4 angle, [time of day] light, photorealistic, cinematic depth.
```

Example — **lifestyle** (`@kitchen`):

```
A modern apartment kitchen, 3/4 angle, bright clean morning daylight, photorealistic, cinematic depth.
```

## Full establishing-shot template — for hero locations that need atmosphere

Fill `[location]`, `[time of day]`, foreground/space/backdrop/light/angle/crowd:

```
A cinematic wide establishing shot of [location], [time of day, e.g. early morning around 8–9 AM / late afternoon golden hour / blue hour / pre-dawn].

THE FOREGROUND: [foreground elements — overhang, furniture, props that frame the shot, or "none — the shot opens directly into the space"].

THE SPACE: [the room/area itself — surfaces, materials, key objects, their positions, what's on the walls/shelves].

THE BACKDROP: [what's beyond — windows, view, distance, haze, or "none — enclosed room"].

THE LIGHT & SKY: [natural light quality — soft, bright, hazy morning light, warm and diffused, gentle low-angle sun, soft long shadows, luminous bright sky. High pale-blue sky with thin wispy clouds. Or for interiors: "soft window light from camera-left, warm and diffused, gentle atmospheric haze"].

COLOR GRADE: a neutral, naturalistic cinematic grade — warm sunlight with balanced, slightly muted color, gentle low contrast, soft lifted blacks, subtle film-like halation in the bright hazy areas, restrained saturation, and a calm warm-neutral white balance. Real photochemical film-stock feel, understated and true-to-life — not a glossy ad look.

CAMERA & LENS: shot on a high-end cinema camera (ARRI / large-format look) with a clean spherical prime, wide establishing framing, [angle — e.g. slightly elevated angle from the stands / eye-level from the doorway], deep focus, subtle natural lens character and mild vignetting, no distortion.

Photorealistic, ultra high detail, 16:9, no on-screen text, no visible brand logos or advertising, [crowd — e.g. no crowd / a couple of tiny distant figures for scale / empty and still].
```

Example — **drama** (`@kitchen`, full establishing):

```
A cinematic wide establishing shot of a modest Jakarta apartment kitchen, 5am pre-dawn.

THE FOREGROUND: a low tile counter stage-left, a stovetop moka pot and two ceramic cups on it.

THE SPACE: narrow galley kitchen opening off a living room — pale yellow tile counter, dark wood cabinets, a single window above the sink stage-right, thin curtains. A folded batik blanket draped over the couch arm is just visible through the doorway behind.

THE BACKDROP: through the window, deep blue city light and street haze.

THE LIGHT & SKY: pre-dawn — deep blue window light, a single warm street lamp glow catching the curtain edge. No artificial light on. Quiet, still atmosphere.

COLOR GRADE: a neutral, naturalistic cinematic grade — cool blue dominant with a single warm accent from the street lamp, soft lifted blacks, restrained saturation, calm pre-dawn white balance. Real photochemical film-stock feel, understated and true-to-life.

CAMERA & LENS: shot on a high-end cinema camera (ARRI / large-format look) with a clean spherical prime, wide establishing framing, eye-level from the doorway, deep focus, subtle natural lens character and mild vignetting, no distortion.

Photorealistic, ultra high detail, 16:9, no on-screen text, no visible brand logos or advertising, empty and still.
```

## Rules

- **English prompts only.**
- **Fill every `[bracket]`** — placeholder text produces generic output.
- **3/4 angle always** — never flat head-on; depth is what the camera needs.
- **One `@tag` per location** — must match the user's Seedance Elements panel exactly.
- **Continuity carry** — a location's `@tag` recurs in every prompt of every scene set in that location.
- **Examples are patterns, not literal copy targets.** Fill from the user's brief.

## Hand-off

Pass to `seedance-shotlist-director`:
- Each `@tag` → one-line location description (room, time of day, mood).
- Each reference prompt text (verbatim) → embedded in the HTML Asset Reference Prompts section.