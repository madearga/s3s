---
name: seedance-make-character
description: "Generate locked character reference-sheet prompts for any Seedance 2.0 production. Genre-agnostic: product ad, lifestyle, drama, animation, documentary, music video. Use when the user needs a stable character image to keep a face + build identical across every cut — hero, side character, outfit variants, state variants. Trigger on 'character reference', 'character sheet', 'lock the character', 'make the hero', 'hero reference', or when asset building reaches the character step. Produces copy-ready English prompt templates (parameterized) for the split-frame sheet (face + full-body front/back, grey bg, one face) plus the face-dedup edit and outfit/state variant prompts. Returns a @tag for each character. The prompt text is also handed off to seedance-shotlist-director to embed in the HTML output."
license: MIT
user-invocable: true
tags:
  - references
  - character-sheet
  - assets
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-make-character

A locked character reference sheet keeps a face AND a full-body build identical across every cut of a Seedance 2.0 film. Without it the model drifts — the face shifts, the build changes, the wardrobe jumps. With it, every shotlist prompt references the same locked image via a `@tag` and the model anchors to it.

This skill produces **copy-ready English prompt templates** (parameterized with `[brackets]`). Fill the brackets from the brief — never ship a prompt with placeholder text. The user runs each filled prompt in GPT Image 2 / Nano Banana / Seedance character-sheet / any image model, attaches the result, names it with the `@tag`. The prompt text is also handed off to `seedance-shotlist-director` so it appears in the HTML shotlist output (Asset Reference Prompts section).

## When to use

- The user asks for a character reference sheet, hero sheet, side character sheet.
- Asset building (from interview Stage 1 or `/s3s-references` router) reaches the character step.
- The user says "lock the hero's face", "build the boss", "make a character sheet for…".

Skip if the user already has a real photo of the actual person — attach it directly with a `@tag`, do not generate.

## Recommended image model

Different image models are better at different things. Match the model to the context the user is running in — don't assume the target platform.

### In pi / opencode (no Soul Cinema / Cinematic Locations available)

The user's tools are `codex_generate_image` (GPT Image 2) and `comfyeditor_image_generate` (provider `gemini` = Nano Banana, plus `replicate`/`fal`/`wavespeed`/`kie` for Flux/Seedream). **GPT Image 2 (`codex_generate_image`) is the primary tool for everything here** — it does the base character sheet AND the edits well.

| Asset | Primary tool | Alternative |
|---|---|---|
| **Character sheet** (the split-frame base sheet) | **GPT Image 2** — `codex_generate_image` | Nano Banana — `comfyeditor_image_generate` provider `gemini` |
| **Face dedup edit** | **GPT Image 2** — `codex_generate_image` | (no good alternative — edits are GPT Image 2's strength) |
| **Outfit variant edit** | **GPT Image 2** — `codex_generate_image` | Nano Banana |
| **State variant edit** | **GPT Image 2** — `codex_generate_image` | Nano Banana |

Rule of thumb in pi/opencode: **generate the base sheet AND every edit in GPT Image 2 (`codex_generate_image`).** Use Nano Banana only if you want a softer photoreal look on the base sheet. The prompt text is the same across models — only the tool differs.

### On the target platform (Soul Cinema / Cinematic Locations available)

| Asset | Best model | Why |
|---|---|---|
| **Character sheet** (base) | **Soul Cinema** | Photoreal character stills, face + build lock |
| **Face dedup edit** | **GPT Image 2** | Strongest at image edits / inpainting |
| **Outfit variant edit** | **GPT Image 2** | Edit adherence — keeps face, swaps only garment |
| **State variant edit** | **GPT Image 2** | Edit adherence — keeps identity, applies state |

Rule of thumb On the target platform: **generate the base sheet in Soul Cinema, then run every edit in GPT Image 2.**

### Detect the context

- If the user mentions the target platform, Soul Cinema, Cinematic Locations, or is running inside the target app/platform → use the the target platform column.
- Otherwise (pi, opencode, standalone) → use the pi/opencode column. **Default to pi/opencode** when unsure — GPT Image 2 is always a safe choice for character sheets and edits.

## Output contract

For each requested character, return:
1. A `@tag` (short, lowercase, hyphenated: `@hero`, `@boss`, `@child`).
2. A copy-ready English prompt block in a code fence — the user pastes it verbatim into their image model. Fill every `[bracket]`.
3. A one-line note on what the sheet locks and whether the face-dedup edit is needed.
4. For variants (outfit / state), a separate tagged prompt (`@s_hero_athletic`, `@s_hero_wet`).
5. Hand the full set to `seedance-shotlist-director` so each reference prompt embeds in the HTML Asset Reference Prompts section, and each `@tag` binds into the shotlist prompts.

## Genre adaptation

The sheet structure is constant; adapt the **descriptive content**:

| Genre | Emphasis |
|---|---|
| Product ad | Hero + side characters; outfit variants per scene; product in hand in the sheet |
| Lifestyle / UGC | Real-feeling person, casual wardrobe, minimal variants |
| Drama / film | Multiple characters; state variants (wet, bloodied, exhausted) drive the story |
| Animation | Stylized — change the `Look:` line (e.g. "2D cel animation character sheet, flat colors, clean line art") |
| Documentary | Real subjects; prefer real photos over generated sheets |
| Music video | Performer + dancers; wardrobe + state variants per beat |

## Output format for every GPT Image 2 prompt

When generating a GPT Image 2 prompt, deliver it in this order:

1. **Director's read** — one sentence on what the image must achieve.
2. **Prompt strategy** — which sheet type this is (base / face-dedup / outfit / state / side character / extended) and why.
3. **Final GPT Image 2 prompt** — English, ready to paste. Follow the structure below.
4. **Text accuracy notes** — flag any text that must render correctly (badges, labels, signage). Most character sheets have none.
5. **Iteration suggestions** — 2–3 follow-up edits the user can try in the same conversation (e.g. "make the hair lighter", "add a visible scar on the left cheek", "change the background to pure white").

GPT Image 2 is reasoning-aware: it understands layered natural-language instructions. Write full sentences with a clear hierarchy. **Do not use keyword-list filler** like "8K, masterpiece, ultra-realistic, stunning". Put the most important details in the first ~50 words.

---

## The character sheet template

Fill `[age/ethnicity/build]`, `[hair]`, `[facial features]`, `[outfit]`, `[build]`:

```
Cinematic character reference sheet, split-frame layout, photorealistic, clean solid grey studio background.

Left panel — facial close-up: [age/ethnicity/build], [hair description], the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, [distinguishing facial features — freckles, scars, moles, glasses, none], calm neutral expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same [age/ethnicity/build] shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, they stand straight in a normal relaxed pose, arms hanging down at their sides, full height in frame head-to-toe, [build], same [outfit description]. The front view shows the face and the front of the garment; the back view shows the back of the head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view. Aspect ratio 16:9.
```

Example — **drama** (`@hero`, surgeon):

```
Cinematic character reference sheet, split-frame layout, photorealistic, clean solid grey studio background.

Left panel — facial close-up: a woman in her early 30s, Filipino, dark hair pulled into a loose bun escaping in strands, the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, dark circles under her eyes, dry lips, no makeup, calm neutral exhausted expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same woman shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, she stands straight in a normal relaxed pose, arms hanging down at their sides, full height in frame head-to-toe, slim build, same outfit — pale blue surgical scrubs creased and faintly stained at the cuff, a hospital lanyard around her neck, dark sneakers. The front view shows her face and the front of the garment; the back view shows the back of her head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view. Aspect ratio 16:9.
```

## Extended reference sheet (optional — when the user needs more than base front/back)

Add expression states, a color palette swatch row, and close-up detail breakdowns when the character will be seen in tight shots or needs palette locks:

```
Same [age/ethnicity/build] character reference sheet expanded into an organized grid on a clean white background. Include: a neutral facial close-up; expression variations showing calm, smiling, concerned, and tired; a three-view turnaround showing front, side, and back; detailed costume breakdown (upper body, lower body, footwear, accessories); and a color palette swatch row with the dominant garment and accent colors labeled. Consistent character across every cell, soft even studio lighting, true-to-life skin tones. Aspect ratio 16:9.
```

## Face dedup edit (run if the full-body panel shows a second face)

```
Erase the face from the full-body shot on the right panel.
```

The sheet has more than one face in frame, which makes the video model drift. This edit removes the duplicate so there is a single face to lock onto. Run on side-character sheets too.

## Outfit variant (`@s_hero_athletic`, `@s_hero_formal` — same face, different wardrobe)

When the character changes wardrobe for a specific scene:

```
Edit this character sheet so the same person is wearing [outfit description — e.g. a blue athletic kit with running shoes / a charcoal formal suit with a white shirt], keeping the face, hair, and identity exactly consistent across all panels. Aspect ratio 16:9.
```

## State variant (`@s_hero_wet`, `@s_hero_exhausted` — same character, mid-film state change)

When a character changes state on screen (dry → drenched, calm → bloodied, rested → exhausted), bake the state into its own locked reference:

```
same character sheet, [state description — e.g. post-run, sweaty chest, sweat stains on the shirt / soaked from the rain, water dripping from hair and clothes / post-shift, scrubs more creased, hair looser, no lanyard, barefoot on tile]. Aspect ratio 16:9.
```

## Side character (`@boss`, `@neighbour`, `@child`)

A separate sheet for any secondary character, same template, different description. Always run the face-dedup edit afterward.

## Rules

- **English prompts only.**
- **Fill every `[bracket]`** — placeholder text produces generic output. Concrete detail is what locks the reference.
- **One face per sheet** — always run the face-dedup edit if the full-body panel renders a second face.
- **Plain solid grey background** — maximizes the model's win rate.
- **`@tag` names are binding** — must match the user's Seedance Elements panel exactly.
- **Examples are patterns, not literal copy targets.** Fill from the user's brief.
- **Continuity carry** — a character's `@tag` recurs in every prompt of every scene they appear in. State variants only appear in scenes where that state is active.

## Hand-off

Pass to `seedance-shotlist-director`:
- Each `@tag` → one-line character description.
- Each reference prompt text (verbatim) → embedded in the HTML Asset Reference Prompts section.
- Which `@tag`s are **immutable continuity locks** (usually the hero's face `@hero`) — must never drift across any cut.