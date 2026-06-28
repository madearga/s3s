---
name: seedance-make-prop
description: "Generate locked product and prop reference prompts for any Seedance 2.0 / Higgsfield production. Genre-agnostic. Use when the user needs a stable product or prop image to keep it identical across every cut — a hero product, a recurring prop, or an original unbranded design. Trigger on 'product reference', 'product sheet', 'prop turnaround', 'lock the product', 'make the prop', or when asset building reaches the product/prop step. Produces copy-ready English prompt templates (parameterized) — front + 3/4 from a source image, an original-design orthographic turnaround (no branding), or a simple single-view studio shot. Returns a @tag per asset and hands the prompt text to seedance-shotlist-director to embed in the HTML output."
license: MIT
user-invocable: true
tags:
  - references
  - product-sheet
  - prop
  - turnaround
  - assets
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-make-prop

A locked product or prop reference keeps an object identical across every cut of a Seedance 2.0 film. Without it the product changes shape, the prop jumps between takes, the colors shift. With it, every shotlist prompt references the same locked image via a `@tag` and the model anchors the object.

This skill produces **copy-ready English prompt templates** (parameterized) for three prop cases: (1) a product sheet from a real source photo, (2) an original unbranded design turnaround, (3) a simple single-view studio shot. Fill the brackets from the brief. The user runs each filled prompt in an image model, attaches the result, names it with the `@tag`. The prompt text is also handed off to `seedance-shotlist-director` so it appears in the HTML shotlist output (Asset Reference Prompts section).

## When to use

- The user asks for a product sheet, prop reference, prop turnaround, lock the product.
- Asset building reaches the product/prop step.
- The user says "make the headphones sheet", "lock the mug", "turnaround for the backpack".

Skip if the user already has a real photo of the actual product/prop — attach it directly with a `@tag`. (Case 1 below still helps by normalizing the photo into a clean sheet.)

## Recommended image model

Products and props split by case. GPT Image 2 is the primary tool in both pi/opencode and Higgsfield for product/prop sheets.

### In pi / opencode

| Case | Primary tool | Alternative |
|---|---|---|
| **Case 1 — from a real source photo** (`@image_1`) | **GPT Image 2** — `codex_generate_image` | Nano Banana — `comfyeditor_image_generate` provider `gemini` |
| **Case 2 — original unbranded turnaround** | **GPT Image 2** — `codex_generate_image` | Nano Banana |
| **Case 3 — simple single-view prop** | **GPT Image 2** — `codex_generate_image` or **Nano Banana** — `comfyeditor_image_generate` provider `gemini` | either works |

Rule of thumb in pi/opencode: **products and props go to GPT Image 2 (`codex_generate_image`).** It handles both the from-photo sheet (case 1) and the original-design turnaround with strict no-branding (case 2) better than the cinematic models. Use Nano Banana only for case 3 when you want a softer photoreal look on a simple prop.

### In Higgsfield

| Case | Best model | Why |
|---|---|---|
| **Case 1 — from a real source photo** (`@image_1`) | **GPT Image 2** | Best at image-to-image: turns one photo into a clean multi-view sheet |
| **Case 2 — original unbranded turnaround** | **GPT Image 2** | Strongest instruction adherence — respects "no branding", renders clean studio product sheets |
| **Case 3 — simple single-view prop** | **GPT Image 2** or **Nano Banana** | Either works for a single clean studio shot |

Rule of thumb in Higgsfield: **products and props go to GPT Image 2.** Use Nano Banana only for case 3 when you want a softer photoreal look.

### Detect the context

- If the user mentions Higgsfield or is running inside the Higgsfield app → use the Higgsfield section.
- Otherwise → use the pi/opencode section. **Default to pi/opencode** when unsure.

If the user already has a real photo of the actual product, case 1 (GPT Image 2) still helps by normalizing it into a clean sheet — but you can also attach the raw photo directly with a `@tag` and skip generation.

## Output contract

For each requested product/prop, return:
1. A `@tag` (short, lowercase, hyphenated: `@product`, `@headphones`, `@prop_mug`, `@sneakers`).
2. A copy-ready English prompt block in a code fence — fill every `[bracket]`. Pick the right case (source photo / original design / simple single-view).
3. A one-line note on what the sheet locks.
4. Hand the full set to `seedance-shotlist-director` so each reference prompt embeds in the HTML Asset Reference Prompts section, and each `@tag` binds into the shotlist Scene/CUT lines.

## Genre adaptation

The sheet structure is constant; adapt the **object and detail**:

| Genre | Emphasis |
|---|---|
| Product ad | The hero product — always; front + 3/4 from a source photo; every recurring hero prop |
| Lifestyle / UGC | The user's real product photo (case 1) + everyday objects (mug, phone, keys) |
| Drama / film | Story props (letter, key, photo album, weapon) — simple single-view often enough |
| Animation | Stylized prop sheet matching the art style — adjust the `STYLE:` line |
| Documentary | Real belongings, photographed — prefer real photos |
| Music video | Instruments, mics, props that recur across beats |

## Case 1 — Product sheet from a real source photo

Drop the user's product image in as `@image_1`:

```
Make a product sheet with front and 3/4 perspective views of [product type] from @image_1.
```

## Case 2 — Original unbranded design (orthographic turnaround)

For a fully original product with no source image:

```
Product prop sheet, orthographic turnaround of a single ORIGINAL [product type] on a flat neutral light-gray studio background.

LAYOUT: the same [product] shown from multiple angles in an even grid: front view, 3/4 hero angle, side profile, top-down, rear view. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — [detailed design description: materials, colors, silhouette, signature motif, distinguishing features].

STRICTLY NO branding: no brand names, logos, swooshes, stripe-logos, wordmarks, text, trademarks, or brand-resembling motifs anywhere. Fully original and unbranded.

STYLE: photorealistic product render, ultra sharp detail, accurate materials, true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, product design presentation board.
```

Example — **lifestyle** (`@watch`, original wristwatch):

```
Product prop sheet, orthographic turnaround of a single ORIGINAL wristwatch on a flat neutral light-gray studio background.

LAYOUT: the same watch shown from multiple angles in an even grid: front dial view, 3/4 hero angle, side profile, case-back view, top-down. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — a minimalist automatic dress watch: 38mm brushed steel case, slim bezel, white sunburst dial, slim sword hands, no date window, brown leather strap with subtle stitch. Clean, restrained, vintage-modern.

STRICTLY NO branding: no brand names, logos, swooshes, wordmarks, text, trademarks, or brand-resembling motifs anywhere on the dial, case, crown, or strap. Fully original and unbranded.

STYLE: photorealistic product render, ultra sharp detail, accurate materials (brushed steel, sunburst lacquer, leather), true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, product design presentation board.
```

## Case 3 — Simple single-view studio shot (for simple props)

For a prop that doesn't need a full turnaround (a mug, a book, a key):

```
A [product/prop] — [detailed physical description: shape, material, color, finish, distinctive features]. Studio product shot, soft directional light, neutral background, sharp focus.
```

Example — **drama** (`@prop_mug`):

```
A ceramic mug with a reddish-orange pinstripe around the rim. Clean studio light, neutral background, centered, product photography.
```

Example — **drama** (`@prop_album`):

```
A worn leather-bound photo album, closed, brass corner brackets, a faint water ring on the cover, slightly bowed spine. Studio product shot, soft directional light, neutral background, sharp focus.
```

## Rules

- **English prompts only.**
- **Fill every `[bracket]`** — placeholder text produces generic output.
- **No branding** on original product/prop sheets (case 2) — original designs only, no real-brand logos or lookalikes.
- **Plain solid grey background** for product/prop sheets — maximizes the model's win rate.
- **One `@tag` per object** — must match the user's Seedance/Higgsfield Elements panel exactly.
- **Continuity carry** — a product/prop `@tag` recurs in every prompt of every scene where the object is visible.
- **Examples are patterns, not literal copy targets.** Fill from the user's brief.

## Hand-off

Pass to `seedance-shotlist-director`:
- Each `@tag` → one-line object description.
- Each reference prompt text (verbatim) → embedded in the HTML Asset Reference Prompts section.
- Flag which `@tag` is the **immutable continuity lock** (usually the hero product `@product`) — must never drift across any cut.