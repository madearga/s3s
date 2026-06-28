---
name: seedance-shotlist-references
description: "Generate locked reference-sheet prompts for Seedance 2.0 / Higgsfield production — character sheets, product sheets, locations, and prop turnarounds. Use when the user needs stable image references to keep characters, products, locations, or props identical across every cut before the shotlist is built. Trigger on 'character reference', 'product sheet', 'location reference', 'prop turnaround', 'build the assets', 'reference sheet', 'lock the character', or when seedance-shotlist-interview reaches its Stage 1 asset-building step. Produces copy-ready English prompts for GPT Image 2 / Nano Banana / Seedance character-sheet generation, plus a @tag for each asset so the shotlist director can bind them into every prompt. Each prompt targets a single locked sheet on a plain solid grey background for maximum win rate. One face per character sheet — duplicate faces are erased in a follow-up edit."
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
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-shotlist-references

Locked reference sheets are what keeps a character, product, location, or prop identical across every cut of a Seedance 2.0 film. Without them the model drifts — the face shifts, the product changes shape, the room rearranges. With them, every prompt references the same locked image via a `@tag` and the model anchors to it.

This skill produces **copy-ready English prompts** that generate each reference sheet. The user runs each prompt in GPT Image 2, Nano Banana, Seedance character-sheet, or any image model, attaches the result to the chat, names it with a `@tag`, and the shotlist director binds that tag into every prompt.

## When to use

- The user asks directly for a character/product/location/prop reference sheet.
- `seedance-shotlist-interview` reaches its Stage 1 asset-building step and the user has no real material yet.
- The user says "I need to lock the hero's face", "build the assets first", "give me a product sheet prompt", etc.

Do not use if the user already has real photos they will attach directly — skip reference generation and route the real images to the interview's asset intake instead.

## Output contract

For each requested asset, return:
1. A `@tag` name (short, lowercase, hyphenated, e.g. `@hero`, `@headphones`, `@kitchen`, `@sneakers`).
2. A copy-ready English prompt block in a code fence — the user pastes it into their image model verbatim.
3. A one-line note on what the sheet locks and any follow-up edit needed (e.g. face dedup).
4. After all sheets are generated and attached, hand off the element list (`@tag` → description) to `seedance-shotlist-director` so it can bind them into the shotlist.

---

## The four asset types

### 1. Character reference sheet (`@hero`, `@boss`, etc.)

A split-frame sheet that locks the face AND the full-body build in one image. Plain solid grey background — nothing competes with the character. **One face per sheet.** If the full-body panel also renders a face, erase it in a follow-up edit (see Face dedup below).

Template — fill in `[description]`, `[outfit]`, `[build]`:

```
Cinematic character reference sheet, split-frame layout, photorealistic.

Left panel — facial close-up: [description], the entire head fully inside the frame including all the hair, nothing cropped, real skin texture with subtle pores, calm neutral expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same [description] shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, they stand straight in a normal relaxed pose, arms hanging down at their sides, full height in frame head-to-toe, [build], same [outfit]. The front view shows the face and the front of the garment; the back view shows the back of the head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view.
```

Example filled (`@hero`):

```
Cinematic character reference sheet, split-frame layout, photorealistic.

Left panel — facial close-up: a 20-year-old white American young man, fair skin tone, the entire head fully inside the frame including all the hair, nothing cropped, short curly auburn hair, soft natural freckles across nose and cheeks, real skin texture with subtle pores, calm neutral expression, looking straight into lens. Shot on 85mm portrait lens, shallow depth of field, soft cinematic key light with gentle fill.

Right panel — full-body front and back views side by side: the same young man shown twice within this panel — on the left, a full-body front view facing the camera; on the right, a full-body back view photographed from directly behind. In both, he stands straight in a normal relaxed pose, arms hanging down at his sides, full height in frame head-to-toe, tall lean build (1.85m), fair skin, short curly auburn hair, same streetwear outfit — short-sleeve button-down shirt open over a white tank top, light-wash faded blue jeans, black Converse sneakers. The front view shows his face and the front of the garment; the back view shows the back of his head, hair, shoulders, garment seams and the rear of the pants and shoes. Both figures matched in framing, scale and lighting for consistency. Shot on 35mm lens, even full-length lighting.

Look: clean studio character sheet, plain solid grey background, consistent character across all views, soft diffused cinematic lighting, muted natural color grade, fine detail, true-to-life skin tones, vertical divider lines separating each view.
```

#### Face dedup edit (run if the full-body panel shows a second face)

```
Erase the face from the full-body shot on the right panel.
```

The sheet has more than one face in frame, which makes the video model drift. This edit removes the duplicate so there is a single face to lock onto. Run the same edit on side-character sheets too.

#### Outfit variant (`@s_hero` — same face, different wardrobe)

When the character changes wardrobe for a specific scene (athletic kit for a stadium run, formal suit for an office), build a second sheet that keeps the face and identity locked but swaps the outfit:

```
Edit this character sheet so the same person is wearing [outfit description], keeping the face, hair, and identity exactly consistent across all panels.
```

#### State variant (`@s_hero_wet` — same character, different physical state)

When a character changes state mid-film (dry → drenched, clean → bloodied, calm → exhausted), bake the state into its own locked reference so the face doesn't drift when the change happens on screen:

```
same character sheet, [state description — e.g. post-run, sweaty chest, sweat stains on the shirt / soaked from the rain, water dripping from hair and clothes].
```

#### Side character (`@boss`)

A separate sheet for any secondary character, same template, different description. Always run the face-dedup edit afterward.

### 2. Product reference sheet (`@headphones`, `@watch`, etc.)

A clean product sheet from a single source image, front and 3/4 views, so the model knows the product from every side. Drop the user's product image in as `@image_1`.

Template:

```
Make a product sheet with front and 3/4 perspective views of [product] from @image_1.
```

For a fully original product with no source image, use a self-contained product-sheet prompt instead:

```
Product prop sheet, orthographic turnaround of a single ORIGINAL [product type] on a flat neutral light-gray studio background.

LAYOUT: the same [product] shown from multiple angles in an even grid: front view, 3/4 hero angle, side profile, top-down, rear view. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — [detailed design description: materials, colors, silhouette, signature motif].

STRICTLY NO branding: no brand names, logos, swooshes, stripe-logos, wordmarks, text, trademarks, or brand-resembling motifs anywhere. Fully original and unbranded.

STYLE: photorealistic product render, ultra sharp detail, accurate materials, true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, product design presentation board.
```

Example (`@sneakers` — original running shoe):

```
Product prop sheet, orthographic turnaround of a single ORIGINAL running shoe on a flat neutral light-gray studio background.

LAYOUT: the same shoe shown from multiple angles in an even grid: lateral side profile, medial side profile, top-down into the laces, front three-quarter hero angle, rear/heel view, and bottom outsole view. Consistent scale, even spacing, soft contact shadow under each, soft even studio product lighting.

DESIGN — a "super-trainer" that blends a fast performance racing shoe with a plush comfort trainer: tall energetic responsive foam midsole with a smooth propulsive rocker, soft rounded sculpted edges, visible soft foam thickness, generously padded tongue and plush heel collar, lightweight breathable engineered mesh upper with sleek bonded overlays.

COLORWAY — crisp off-white / cream base across upper and midsole, with a bold sunset orange-to-coral accent sweeping dynamically along the lateral midsole and side panel, plus sharp black detailing around the eyestay/laces and a thin black outsole.

SIGNATURE: a single ownable sweeping arc / wing line where the upper meets the midsole as the recognizable design motif.

STRICTLY NO branding: no brand names, logos, swooshes, stripe-logos, wordmarks, text, trademarks, or brand-resembling motifs anywhere on the shoe, laces, tongue, sole, or sheet. Fully original and unbranded.

STYLE: photorealistic 3D product render, ultra sharp detail, accurate materials (knit/mesh, soft responsive foam, rubber), true-to-life color, soft cinematic studio lighting, flat light-gray seamless background, footwear design presentation board.
```

### 3. Location reference (`@kitchen`, `@stadium`, `@street`, `@office`)

A 3/4 angle still of each location. The 3/4 angle gives the room depth for the camera to move through, which holds up far better than a flat head-on shot. Establishing-shot prompt for depth and mood:

Template (short):

```
[room type], 3/4 angle, [time of day] light, photorealistic, cinematic depth.
```

Template (full establishing shot, for hero locations that need atmosphere):

```
A cinematic wide establishing shot of [location], [time of day, e.g. early morning around 8–9 AM].

THE FOREGROUND: [foreground elements — overhang, furniture, props that frame the shot].

THE SPACE: [the room/area itself — surfaces, materials, key objects, their positions].

THE BACKDROP: [what's beyond — windows, view, distance, haze].

THE LIGHT & SKY: [natural light quality — soft, bright, hazy morning light, warm and diffused, gentle low-angle sun, soft long shadows, luminous bright sky. High pale-blue sky with thin wispy clouds].

COLOR GRADE: a neutral, naturalistic cinematic grade — warm sunlight with balanced, slightly muted color, gentle low contrast, soft lifted blacks, subtle film-like halation in the bright hazy areas, restrained saturation, calm warm-neutral white balance. Real photochemical film-stock feel, understated and true-to-life — not a glossy ad look.

CAMERA & LENS: shot on a high-end cinema camera (ARRI / large-format look) with a clean spherical prime, wide establishing framing, [angle], deep focus, subtle natural lens character and mild vignetting, no distortion.

Photorealistic, ultra high detail, 16:9, no on-screen text, no visible brand logos or advertising, no crowd.
```

Example (`@stadium`):

```
A cinematic wide establishing shot of a quiet open-air track-and-field stadium on a city riverfront, early morning around 8–9 AM. The view is taken from the shaded upper grandstand, looking out across the track and field toward the water and a distant skyline. Almost empty and still.

THE FOREGROUND & ROOF: in the top of the frame, the underside of a large dark cantilever grandstand roof with an exposed steel lattice truss structure cuts across the shot, framing the scene and casting the near seating in cool shadow. Below it, long curving rows of empty grandstand seats (muted gray and dark tones) sweep down toward the track, catching warm light at the edges.

THE TRACK: a classic warm terracotta / brick-red all-weather running track with crisp white lane lines, curving around the field. Faint painted lane numbers. A couple of tiny distant figures stand on the track for scale. Clean and well-kept.

THE FIELD: a large lush green natural-grass field inside the track, freshly mowed with subtle mowing patterns and white markings, with tall white rugby/football goalposts standing on the grass. A low dark electronic scoreboard sits at the far end.

THE BACKDROP: beyond the far side, a calm wide river separates the stadium from a distant urban skyline — a long row of tall high-rise apartment towers and low-rise buildings along the far bank, softened by morning haze. A tall stadium floodlight tower rises near the center against the sky. Green trees line the waterfront.

THE LIGHT & SKY: soft, bright, hazy morning light, warm and diffused, with gentle low-angle sun creating soft long shadows and a luminous bright sky near the horizon. A high pale-blue sky with thin wispy clouds. Fresh, calm, peaceful early-morning atmosphere.

COLOR GRADE: a neutral, naturalistic cinematic grade — warm sunlight with balanced, slightly muted color, gentle low contrast, soft lifted blacks, subtle film-like halation in the bright hazy areas, restrained saturation, and a calm warm-neutral white balance. Real photochemical film-stock feel, understated and true-to-life, lived-in and documentary-realistic — not a glossy ad look.

CAMERA & LENS: shot on a high-end cinema camera (ARRI / large-format look) with a clean spherical prime, wide establishing framing, slightly elevated angle from the stands, deep focus, subtle natural lens character and mild vignetting, no distortion.

Photorealistic, ultra high detail, 16:9, no on-screen text, no visible brand logos or advertising, no crowd.
```

### 4. Prop reference (`@moka_pot`, `@mug`, `@backpack`, etc.)

A clean prop sheet so a recurring prop stays identical cut to cut. Orthographic turnaround on neutral grey:

Template:

```
A [product/prop] — [detailed physical description: shape, material, color, finish, distinctive features]. Studio product shot, soft directional light, neutral background, sharp focus.
```

Example (`@moka_pot`):

```
A stovetop moka pot — eight-sided, high-gloss black base, matte cream top chamber, black handle and knob, brass safety valve on the lower half. Studio product shot, soft directional light, neutral background, sharp focus.
```

Example (`@mug`):

```
A ceramic mug with a reddish-orange pinstripe around the rim. Clean studio light, neutral background, centered, product photography.
```

For complex props with multiple visible sides, use the full orthographic turnaround (same as the original-product template in section 2).

---

## Process

1. **Identify which assets the film needs.** From the brief (interview hand-off) or the script (direct path), list every character, product, location, and recurring prop that appears in more than one cut. Each gets a `@tag`.
2. **For each asset, pick the right template** (character sheet / product sheet / location / prop) and fill in the description from the brief.
3. **Generate the prompts** in order: hero character first (and run the face-dedup edit), then side characters, then product, then locations, then props.
4. **For state/outfit variants**, build a second sheet only when the character visibly changes on screen mid-film. Tag the variant (`@s_hero_athletic`, `@s_hero_wet`).
5. **Hand off the element list** to `seedance-shotlist-director`: every `@tag` → one-line description. The director binds them into every prompt's Characters/Scene/CUT lines.

## Rules

- **English prompts only.**
- **One face per character sheet** — always run the face-dedup edit if the full-body panel renders a second face.
- **Plain solid grey background** for character and product sheets — maximizes the model's win rate by removing anything that competes with the subject.
- **3/4 angle for locations** — never flat head-on; depth is what the camera needs.
- **No branding** on original product/prop sheets — original designs only, no real-brand logos or lookalikes.
- **`@tag` names are binding** — they must match exactly between this skill's output, the user's chat attachments, and the user's Seedance/Higgsfield Elements panel. That match is what auto-attaches images at generate time.
- **Continuity carry** — a character's `@tag` recurs in every prompt of every scene they appear in. State variants (`@s_hero_wet`) only appear in the scenes where that state is active.

## Final reminders

- Reference sheets are built **before** the shotlist, not during. Lock the assets, then write the film.
- If the user has real photos (of their actual product, pet, location), skip generation — attach the real photo directly with a `@tag` and route to the interview's asset intake. Generated sheets are for when no real material exists.
- The number of sheets scales with the film: a 1-scene UGC clip may need zero sheets (prose mode); a 6-scene product ad may need 6–10 sheets (hero + variants + product + 3 locations + 2 props).
- When handing off, also note which `@tag`s are **immutable continuity locks** (usually: the hero's face `@hero`, the product `@headphones`) — these must never drift across any cut.