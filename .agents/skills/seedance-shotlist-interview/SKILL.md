---
name: seedance-shotlist-interview
description: "Newbie-friendly creative intake for the Seedance 2.0 shotlist workflow. Use this skill FIRST when the user has a vague idea, a rough concept, or no script yet — and wants help turning it into a film before the shotlist is built. Trigger on phrases like 'I have an idea for a video', 'help me plan a film', 'I don't have a script', 'let's brainstorm a video', 'interview me', 'turn my idea into a shotlist', or any request where the user clearly needs creative development before prompt writing. Default assumption: the user has zero cinematography, videography, or storytelling background. This skill produces a mini-treatment, switchable assumptions, a production brief, and a named element list (@tags) — then hands off to seedance-shotlist-director to build the HTML shotlist. Do NOT use this skill if the user already arrives with a finished script, scene breakdown, or treatment — go straight to seedance-shotlist-director instead."
license: MIT
user-invocable: true
tags:
  - creative-direction
  - interview
  - brief
  - prep
  - seedance-20
metadata:
  version: "1.0.0"
  updated: "2026-06-28"
  parent: "seedance-shotlist-director"
  author: "madearga"
  repository: "https://github.com/madearga/s3s"
---

# seedance-shotlist-interview

This is the front door for users who carry an idea they care about and no vocabulary to ask for it. The job is not extracting answers — it is making them feel their idea was already a film and someone finally saw it. Success sounds like "that's exactly what I meant."

When the idea is already rich (the user pasted a script, scene breakdown, or treatment), **skip this skill entirely** and route directly to `seedance-shotlist-director`.

## Intent

Quality bar: every question must be answerable by someone who has never heard the words "shot," "aspect ratio," or "blocking." As the story evolves, the questions disappear — every answer becomes memory, every reaction to a draft becomes direction, and nothing already decided is ever asked again.

## Question Quality Rules

1. **Ask in pictures, not parameters.** Offer two to four vivid options the user can pick by feel: `Should this feel like a movie scene, a real moment caught on a phone, a polished ad, or a cartoon?` Never: `What camera style and aspect ratio?`
2. **One batch, never an interrogation:** at most five numbered questions in a single message so the user can answer everything in one reply. Follow up only when an answer creates a real fork.
3. **Every question ships with a default.** End it with `(not sure? I'll go with [default] — it works well)`. "I don't know" is always a valid answer; it simply selects the default and never stalls the interview.
4. **One question, one decision.** Never bundle two asks into one sentence, and never ask anything whose answer would not change the prompt.
5. **Keep their words.** If the user says "swooshy," say "swooshy" back — and translate it into camera language silently, inside the brief.
6. **Expert detect:** if the user speaks production language fluently (shot list, lens, deliverables, LUT, coverage) or works for an agency or production, drop plain mode and run the professional intake instead (collect deliverables, territory, aspect ratio, approval owner, rights, post/delivery needs).

## Priority Question Pool

Each plain question secretly decides a production parameter the user never has to know about. Skip every question the idea already answers. Never exceed five questions in one batch.

| # | Ask (plain) | Secretly decides | Default if unsure |
|---|---|---|---|
| 1 | Who or what is the star of this video — one person, pet, product, or place? | subject anchor | the most concrete noun in their idea |
| 2 | What happens? What is different at the end compared to the start? | action beat, duration | one simple action with a visible ending |
| 3 | Where does it happen, and what time of day? | scene, light source | the most natural place for the action, late warm daylight |
| 4 | What should someone feel watching it — excited, calm, moved, amused, amazed, or tense? | camera, light, sound, pace | calm and warm |
| 5 | Where will people watch it — phone apps like TikTok/Reels (tall screen), or YouTube/TV (wide screen)? | aspect ratio, pacing | tall 9:16 |
| 6 | Is this one complete clip, two or three connected clips, a longer scene that should be divided, or are you unsure? | standalone vs sequence | unsure means plan the full story but finalize one clip at a time |
| 7 | How must the complete story end? | final story outcome | a visible changed state |
| 8 | Do you already have an accepted previous clip or final frame this must continue from? | continuation source gate | no source means do not invent continuation state |
| 9 | Which details must never change across clips — face, wardrobe, product, place, direction, sound, or something else? | immutable continuity locks (→ @tag asset binding) | subject identity and exact reference tags |

When real material likely exists (a business, product, pet, person, or place the user owns), the reference question takes one of the five slots — swap out question 3: `Do you have photos, clips, or sound of the real [subject]? Real material keeps the video looking like yours.` The batch never exceeds five questions total. Map anything they provide to named `@tag` references (see Asset Intake below).

## Feeling-to-Film Translation

Translate everyday answers into production language inside the brief — never out loud as a quiz.

| User says | Brief writes |
|---|---|
| epic, cinematic, movie-like | wide establishing frame, one slow push-in, low warm sun, rising score |
| cozy, warm, nice | close framing, soft window light, gentle motion, quiet room tone |
| funny | locked camera, deadpan timing, one absurd visible beat, dry single SFX |
| like an ad, professional, clean | controlled hero light on the subject, tidy background, one polished camera move |
| sad, emotional, moving | stillness, a little distance, cool soft light, sparse sound |
| creepy, tense | slow camera, shadow and doorways, off-screen sound, held silence |
| cute | camera low at subject height, bright soft light, small bouncy motions |
| dreamy | drifting camera, haze and glow, slow motion on a single beat |

## Direct the Scene, Don't Decorate It

The feeling answer is not a style label to sprinkle on; it is the input to a directorial decision. Run the Director's Read silently on the idea: what is the scene doing (function and turn), whose experience are we in, who holds power, and what is felt but unsaid. From the genre, the chosen feeling, any reference look the user loves, and where it will be watched, set one directorial voice for the whole project and keep it. Then every scene gets a coherent setup — camera, lens, light, blocking, performance, and sound all serving one intention — rather than a generic "cinematic" look. Write the result into the brief in director language; never quiz the user about voice, lenses, or ratios.

When the idea has more than one scene, give each scene its own read and setup but the same voice, and plan how the look should tighten toward the turning point so the finished story feels authored by one hand. Performance is written as one true visible gesture per beat, not as an emotion word.

## Asset Intake & @tag Binding

When the user has real material (photos of a product, a person, a pet, a place, props), or when continuity locks from question 9 require stable references, collect them **in a separate batch after the first interview round** — never bundle asset questions into the 5-question creative batch.

Ask the user to attach each image and give it a short `@name`:
- `@hero` — main character sheet (face + full-body)
- `@kitchen` — location, 3/4 angle for depth
- `@headphones` — product sheet, front + 3/4 views
- `@sneakers` — prop turnaround

The `@name` chosen here is binding: the same `@tag` will appear in the shotlist prompts (via `seedance-shotlist-director`) AND in the user's Seedance/Higgsfield Elements panel, so images auto-attach when generating.

If the user has no real material yet, offer to build reference sheets first (Stage 1 below) using GPT Image 2 / Nano Banana / Seedance character sheets. Default to skipping asset intake if the user has nothing to attach — the shotlist director works fine with prose-only character anchors.

## Stage 1 — Asset Building (optional, when user has no reference images)

For each missing reference, generate a locked sheet before the shotlist is built:

- **Character sheet** — split-frame: facial close-up (entire head in frame, nothing cropped) + full-body front + full-body back. Plain solid grey background for high win rate. One face per sheet — erase any duplicate face from the full-body panel. Same wardrobe across all panels. Example: `Cinematic character reference sheet, split-frame layout, photorealistic. Left panel — facial close-up: [description], entire head fully in frame. Right panel — full-body front and back views side by side: same person, same outfit, full height head-to-toe. Clean studio character sheet, plain solid grey background, soft diffused cinematic lighting.`
- **Location** — 3/4 angle for depth (never flat head-on): `Modern [room], 3/4 angle, [time of day] light, photorealistic.`
- **Prop sheet** — orthographic turnaround on neutral grey: `Product prop sheet, orthographic turnaround of [object] on flat neutral light-gray studio background. Same object shown from multiple angles in an even grid: side profile, top-down, 3/4 hero, rear, bottom. Soft even studio product lighting.`

Each generated sheet gets a `@name` and is attached to the chat before the shotlist director runs.

## Propose, Then Adjust

After one round of answers — or zero rounds, if the idea is already rich — stop asking and show:

1. **Mini-treatment:** two or three plain sentences describing the finished video exactly as a viewer would see it. No production vocabulary.
2. **Assumptions made**, each with a one-word switch: `I assumed warm late-afternoon light — say "night" and I'll relight it.`
3. **Element list:** the named `@tag` references collected so far (or "none yet — we'll build them in Stage 1").
4. **Production brief** beneath, in full director language: directorial voice, per-scene intention + coherent setup (camera, light, blocking, performance, sound), core scene, mood, continuity locks, aspect ratio, audio intent.

Reacting to a draft is easier than answering questions: a non-expert says "yes, but slower" far more readily than they specify pacing. Treat their reaction as the second interview round. Adjust the mini-treatment and brief in place; never re-ask what they already answered.

## Process

1. **Build a safe draft premise immediately** from the user input — never make them start from a blank page.
2. **Run the priority question pool in one batch**, skipping every question the idea already answers. Max 5 questions.
3. **Identify the genre path:** product, lifestyle, drama, music video, landscape, commercial, animation, UGC, or experimental. Derive one directorial voice from that path plus the chosen feeling, reference look, and surface. Run the Director's Read on each scene to fix its intention and coherent setup.
4. **If the user is a filmmaker/agency/producer/editor/client-review owner:** collect deliverables, territory, aspect ratio, approval owner, rights, and post/delivery needs.
5. **If real material exists or continuity locks require references:** run Asset Intake in a separate batch. Map each attached image to a `@tag`. If nothing exists yet and the user wants locked references, run Stage 1 to build the sheets first.
6. **Propose** the mini-treatment + switchable assumptions + element list + production brief. Adjust on reaction (round 2).
7. **Hand off to `seedance-shotlist-director`** — pass the brief, the directorial voice, the per-scene setup, and the `@tag` element list. The director skill builds the HTML shotlist with `@tag` binding in every prompt.

## Output Contract

Return:
- Mini-treatment in plain language
- Assumptions with one-word switches
- Element list (`@tag` → description, or "none — prose-only mode")
- Concept summary
- Production phase
- Reference asset request (what's still missing, what to build in Stage 1)
- The chosen directorial voice
- Each scene's intention and coherent setup (camera, light, blocking, performance, sound)
- Core scene, mood, camera intent, sound intent
- Continuity locks (which `@tag`s must never drift)
- Safety/rights notes if relevant
- Deliverables if known (expert mode)
- **Next step: hand off to `seedance-shotlist-director`** to generate the HTML shotlist

Do not ask a long questionnaire when the user already supplied enough information to write the brief. Do not generate the HTML shotlist in this skill — that is the director's job. This skill stops at the brief + element list and routes forward.