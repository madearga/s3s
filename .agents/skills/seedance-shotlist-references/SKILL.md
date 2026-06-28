---
name: seedance-shotlist-references
description: "Generate locked reference-sheet prompts for any Seedance 2.0 / Higgsfield production — character sheets, product sheets, locations, and prop turnarounds. Genre-agnostic: works for product ads, lifestyle, drama, UGC, animation, documentary. Use when the user needs stable image references to keep characters, products, locations, or props identical across every cut before the shotlist is built. Trigger on 'character reference', 'product sheet', 'location reference', 'prop turnaround', 'build the assets', 'reference sheet', 'lock the character', or when seedance-shotlist-interview reaches its Stage 1 asset-building step. Produces copy-ready English prompt templates (parameterized) plus a @tag for each asset so the shotlist director can bind them into every prompt. Each prompt targets a single locked sheet on a plain solid grey background for maximum win rate. One face per character sheet — duplicate faces are erased in a follow-up edit."
license: MIT
user-invocable: true
tags:
  - references
  - assets
  - character-sheet
  - product-sheet
  - location
  - prop
  - seedance-20
metadata:
  version: "1.1.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-shotlist-references

Locked reference sheets are what keeps a character, product, location, or prop identical across every cut of a Seedance 2.0 film. Without them the model drifts — the face shifts, the product changes shape, the room rearranges. With them, every prompt references the same locked image via a `@tag` and the model anchors to it.

This skill produces **copy-ready English prompt templates** that generate each reference sheet. The templates are parameterized with `[brackets]` — fill them in from the brief, do not copy the example values verbatim. The user runs each filled prompt in GPT Image 2, Nano Banana, Seedance character-sheet, or any image model, attaches the result to the chat, names it with a `@tag`, and the shotlist director binds that tag into every prompt.

## When to use

- The user asks directly for a character/product/location/prop reference sheet.
- `seedance-shotlist-interview` reaches its Stage 1 asset-building step and the user has no real material yet.
- The user says "I need to lock the hero's face", "build the assets first", "give me a product sheet prompt", etc.

Do not use if the user already has real photos they will attach directly — skip reference generation and route the real images to the interview's asset intake instead.

## Output contract

For each requested asset, return:
1. A `@tag` name (short, lowercase, hyphenated, e.g. `@hero`, `@product`, `@kitchen`, `@prop_mug`).
2. A copy-ready English prompt block in a code fence — the user pastes it into their image model verbatim. **Fill the `[brackets]` from the brief; never ship a prompt with placeholder text still in it.**
3. A one-line note on what the sheet locks and any follow-up edit needed (e.g. face dedup).
4. After all sheets are generated and attached, hand off the element list (`@tag` → description) to `seedance-shotlist-director` so it can bind them into the shotlist.

---

## Adapting across genres

The four asset types below are genre-agnostic. Adapt the **descriptive content** (what goes in the `[brackets]`) to the genre — the **structure** of each sheet stays the same:

| Genre | Character sheet emphasis | Product sheet | Location | Props |
|---|---|---|---|---|
| **Product ad** | Hero + side characters; outfit variants per scene; product in hand | Always — front + 3/4 from source image | 3/4 of each room the ad moves through | The product + every recurring hero prop |
| **Lifestyle / UGC** | Real-feeling person, casual wardrobe, minimal variants | Often none (or the user's real product photo) | Real lived-in rooms, 3/4 | Phone, coffee cup, everyday objects |
| **Drama / film** | Multiple characters; state variants (wet, bloodied, exhausted) drive the story | Usually none | Establishing-shot atmosphere matters more than product clarity | Story props (letter, key, photo album) |
| **Animation** | Stylized character sheet — adjust the `Look:` line (e.g. "2D cel animation character sheet, flat colors, clean line art") | Stylized product sheet matching the art style | Stylized background plate | Stylized props |
| **Documentary** | Real subjects; prefer real photos over generated sheets | The subject's real belongings, photographed | Real locations, photographed | Real objects |
| **Music video** | Performer + dancers; wardrobe + state variants per beat | Often none | Mood-driven 3/4 locations | Instruments, mic, props that recur across beats |

When the genre is unclear, default to **product-ad** rules (the most asset-heavy case) and let the user prune.

---

## The four asset types

### 1. Character reference sheet (`@hero`, `@boss`, `@narrator`, etc.)

A split-frame sheet that locks the face AND the full-body build in one image. Plain solid grey background — nothing competes with the character. **One face per sheet.** If the full-body panel also renders a face, erase it in a follow-up edit (see Face dedup below).

Template — fill in `[age/ethnicity/build]`, `[hair]`, `[outfit]`, `[build]`:

```
Cinematic character reference sheet, split-frame layout, photorealistic.

Left panel — facial close-up: [age/ethnicity/build], [hair description], the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, [distinguishing facial features — freckles, scars, moles, glasses, none], calm neutral expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same [age/ethnicity/build] shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, they stand straight in a normal relaxed pose, arms hanging down at their sides, full height in frame head-to-toe, [build], same [outfit description]. The front view shows the face and the front of the garment; the back view shows the back of the head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view.
```

Example filled — **drama** (`@hero`, a surgeon coming home from a long shift):

```
Cinematic character reference sheet, split-frame layout, photorealistic.

Left panel — facial close-up: a woman in her early 30s, Filipino, dark hair pulled into a loose bun escaping in strands, the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, dark circles under her eyes, dry lips, no makeup, calm neutral exhausted expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same woman shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, she stands straight in a normal relaxed pose, arms hanging down at her sides, full height in frame head-to-toe, slim build, same outfit — pale blue surgical scrubs creased and faintly stained at the cuff, a hospital lanyard around her neck, dark sneakers. The front view shows her face and the front of the garment; the back view shows the back of her head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view.
```

Example filled — **product ad** (`@boss`, side character):

```
Cinematic character reference sheet, split-frame layout, photorealistic.

Left panel — facial close-up: a man in his 50s, [ethnicity], receding grey hair, the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, deep laugh lines, reading glasses pushed up on his forehead, stern neutral expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same man shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, he stands straight in a normal relaxed pose, arms hanging down at his sides, full height in frame head-to-toe, stocky build with a pot belly, same outfit — a charcoal suit, white shirt, no tie, brown leather shoes. The front view shows his face and the front of the garment; the back view shows the back of his head, hair, shoulders, jacket seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view.
```

#### Face dedup edit (run if the full-body panel shows a second face)

```
Erase the face from the full-body shot on the right panel.
```

The sheet has more than one face in frame, which makes the video model drift. This edit removes the duplicate so there is a single face to lock onto. Run the same edit on side-character sheets too.

#### Outfit variant (`@s_hero_athletic`, `@s_hero_formal` — same face, different wardrobe)

When the character changes wardrobe for a specific scene (athletic kit for a run, formal suit for an office), build a second sheet that keeps the face and identity locked but swaps the outfit:

```
Edit this character sheet so the same person is wearing [outfit description — e.g. a blue athletic kit with running shoes / a charcoal formal suit with a white shirt], keeping the face, hair, and identity exactly consistent across all panels.
```

#### State variant (`@s_hero_wet`, `@s_hero_exhausted` — same character, different physical state)

When a character changes state mid-film (dry → drenched, calm → bloodied, rested → exhausted), bake the state into its own locked reference so the face doesn't drift when the change happens on screen:

```
same character sheet, [state description — e.g. post-run, sweaty chest, sweat stains on the shirt / soaked from the rain, water dripping from hair and clothes / post-shift, scrubs more creased, hair looser, no lanyard, barefoot on tile].
```

#### Side character (`@boss`, `@neighbour`, `@child`)

A separate sheet for any secondary character, same template, different description. Always run the face-dedup edit afterward.

### 2. Product reference sheet (`@product`, `@watch`, `@device`, etc.)

A clean product sheet from a single source image, front and 3/4 views, so the model knows the product from every side. Drop the user's product image in as `@image_1`.

Template (from a source photo):

```
Make a product sheet with front and 3/4 perspective views of [product type] from @image_1.
```

For a fully original product with no source image, use a self-contained product-sheet prompt instead:

```
Product prop sheet, orthographic turnaround of a single ORIGINAL [product type] on a flat neutral light-gray studio background.

LAYOUT: the same [product] shown from multiple angles in an even grid: front view, 3/4 hero angle, side profile, top-down, rear view. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — [detailed design description: materials, colors, silhouette, signature motif, distinguishing features].

STRICTLY NO branding: no brand names, logos, swooshes, stripe-logos, wordmarks, text, trademarks, or brand-resembling motifs anywhere. Fully original and unbranded.

STYLE: photorealistic product render, ultra sharp detail, accurate materials, true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, product design presentation board.
```

Example filled — **lifestyle** (`@watch`, original wristwatch):

```
Product prop sheet, orthographic turnaround of a single ORIGINAL wristwatch on a flat neutral light-gray studio background.

LAYOUT: the same watch shown from multiple angles in an even grid: front dial view, 3/4 hero angle, side profile, case-back view, top-down. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — a minimalist automatic dress watch: 38mm brushed steel case, slim bezel, white sunburst dial, slim sword hands, no date window, brown leather strap with subtle stitch. Clean, restrained, vintage-modern.

STRICTLY NO branding: no brand names, logos, swooshes, wordmarks, text, trademarks, or brand-resembling motifs anywhere on the dial, case, crown, or strap. Fully original and unbranded.

STYLE: photorealistic product render, ultra sharp detail, accurate materials (brushed steel, sunburst lacquer, leather), true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, product design presentation board.
```

### 3. Location reference (`@kitchen`, `@street`, `@office`, `@studio`, etc.)

A 3/4 angle still of each location. The 3/4 angle gives the room depth for the camera to move through, which holds up far better than a flat head-on shot.

Template (short — for simple rooms):

```
[room type], 3/4 angle, [time of day] light, photorealistic, cinematic depth.
```

Example filled — **lifestyle** (`@kitchen`, short):

```
A modern apartment kitchen, 3/4 angle, bright clean morning daylight, photorealistic, cinematic depth.
```

Template (full establishing shot — for hero locations that need atmosphere):

```
A cinematic wide establishing shot of [location], [time of day, e.g. early morning around 8–9 AM / late afternoon golden hour / blue hour].

THE FOREGROUND: [foreground elements — overhang, furniture, props that frame the shot, or "none — the shot opens directly into the space"].

THE SPACE: [the room/area itself — surfaces, materials, key objects, their positions, what's on the walls/shelves].

THE BACKDROP: [what's beyond — windows, view, distance, haze, or "none — enclosed room"].

THE LIGHT & SKY: [natural light quality — soft, bright, hazy morning light, warm and diffused, gentle low-angle sun, soft long shadows, luminous bright sky. High pale-blue sky with thin wispy clouds. Or for interiors: "soft window light from camera-left, warm and diffused, gentle atmospheric haze"].

COLOR GRADE: a neutral, naturalistic cinematic grade — warm sunlight with balanced, slightly muted color, gentle low contrast, soft lifted blacks, subtle film-like halation in the bright hazy areas, restrained saturation, and a calm warm-neutral white balance. Real photochemical film-stock feel, understated and true-to-life — not a glossy ad look.

CAMERA & LENS: shot on a high-end cinema camera (ARRI / large-format look) with a clean spherical prime, wide establishing framing, [angle — e.g. slightly elevated angle from the stands / eye-level from the doorway], deep focus, subtle natural lens character and mild vignetting, no distortion.

Photorealistic, ultra high detail, 16:9, no on-screen text, no visible brand logos or advertising, [crowd — e.g. no crowd / a couple of tiny distant figures for scale / empty and still].
```

Example filled — **drama** (`@kitchen`, full establishing):

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

### 4. Prop reference (`@prop_mug`, `@prop_book`, `@prop_key`, etc.)

A clean prop sheet so a recurring prop stays identical cut to cut. Orthographic turnaround on neutral grey, or a clean single studio shot for simple props.

Template (simple single-view prop):

```
A [product/prop] — [detailed physical description: shape, material, color, finish, distinctive features]. Studio product shot, soft directional light, neutral background, sharp focus.
```

Example filled — **drama** (`@prop_mug`):

```
A ceramic mug with a reddish-orange pinstripe around the rim. Clean studio light, neutral background, centered, product photography.
```

Example filled — **drama** (`@prop_album`):

```
A worn leather-bound photo album, closed, brass corner brackets, a faint water ring on the cover, slightly bowed spine. Studio product shot, soft directional light, neutral background, sharp focus.
```

For complex props with multiple visible sides, use the full orthographic turnaround (same as the original-product template in section 2).

---

## Process

1. **Identify which assets the film needs.** From the brief (interview hand-off) or the script (direct path), list every character, product, location, and recurring prop that appears in more than one cut. Each gets a `@tag`.
2. **Pick the genre row** from the "Adapting across genres" table to decide what to emphasize.
3. **For each asset, pick the right template** (character sheet / product sheet / location / prop) and fill in the `[brackets]` from the brief. **Never ship a prompt with placeholder text still in it** — every bracket must be filled with concrete detail from the user's film.
4. **Generate the prompts** in order: hero character first (and run the face-dedup edit), then side characters, then product, then locations, then props.
5. **For state/outfit variants**, build a second sheet only when the character visibly changes on screen mid-film. Tag the variant (`@s_hero_athletic`, `@s_hero_wet`).
6. **Hand off the element list** to `seedance-shotlist-director`: every `@tag` → one-line description. The director binds them into every prompt's Characters/Scene/CUT lines.

## Rules

- **English prompts only.**
- **Fill every `[bracket]** — placeholder text in a shipped prompt produces generic output. Concrete detail is what locks the reference.
- **One face per character sheet** — always run the face-dedup edit if the full-body panel renders a second face.
- **Plain solid grey background** for character and product sheets — maximizes the model's win rate by removing anything that competes with the subject.
- **3/4 angle for locations** — never flat head-on; depth is what the camera needs.
- **No branding** on original product/prop sheets — original designs only, no real-brand logos or lookalikes.
- **`@tag` names are binding** — they must match exactly between this skill's output, the user's chat attachments, and the user's Seedance/Higgsfield Elements panel. That match is what auto-attaches images at generate time.
- **Continuity carry** — a character's `@tag` recurs in every prompt of every scene they appear in. State variants (`@s_hero_wet`) only appear in the scenes where that state is active.
- **Examples in this skill are patterns, not literal copy targets.** The headphones-ad source material this skill was adapted from used specific characters/locations/props; your film uses different ones. Fill from your brief, not from the examples.

## Final reminders

- Reference sheets are built **before** the shotlist, not during. Lock the assets, then write the film.
- If the user has real photos (of their actual product, pet, location), skip generation — attach the real photo directly with a `@tag` and route to the interview's asset intake. Generated sheets are for when no real material exists.
- The number of sheets scales with the film: a 1-scene UGC clip may need zero sheets (prose mode); a 6-scene product ad may need 6–10 sheets (hero + variants + product + 3 locations + 2 props); a 2-scene drama may need only a hero + one location.
- When handing off, also note which `@tag`s are **immutable continuity locks** (usually: the hero's face `@hero`, the product `@product`) — these must never drift across any cut.