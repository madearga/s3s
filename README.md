# s3s

Seedance 2.0 shotlist workflow — **video analysis** + **shot variations** + **reference sheets** + **creative interview** + **HTML shotlist director** with `@tag` image reference binding. Dual-compatible: runs in **pi** and **opencode**.

## What's inside — 8 skills, 6 slash commands

### Skills (`.agents/skills/`)

| Skill | Job |
|---|---|
| **seedance-shotlist-analyze** | Reverse-engineer a reference clip into a practical recreation brief: style, camera, motion, continuity locks, recommended `@tag` assets, and a shotlist-ready hand-off. |
| **seedance-shotlist-variations** | Generate 5–10 shot/composition alternatives for one scene or beat while keeping the same `@tag` assets, style, and continuity. |
| **seedance-make-character** | Generate locked character-sheet prompts (split-frame face + full-body, grey bg, one face) + face-dedup edit + outfit/state variants. Base sheet → Soul Cinema / Nano Banana; edits → GPT Image 2. |
| **seedance-make-location** | Generate locked location prompts (short + full establishing shot, 3/4 angle mandatory). → Cinematic Locations / Nano Banana. |
| **seedance-make-prop** | Generate locked product/prop prompts (from-source-photo sheet / original unbranded turnaround / simple single-view). → GPT Image 2. |
| **seedance-shotlist-interview** | Newbie-friendly creative intake. Max 5 questions per batch (each with a stated concrete default), feeling-to-film translation, Director's Read per scene. Routes Stage 1 asset building to the 3 make-* skills and carries reference prompt text in the hand-off. |
| **seedance-shotlist-director** | Builds an editable HTML shotlist from a script, treatment, or interview brief. 15-second prompts, split scenes (`3a/3b/3c`), Style Prefix, per-scene checkboxes (localStorage), Copy buttons (with file:// fallback), optional Elements list of `@tag` references, and a **conditional Asset Reference Prompts** section that renders only when reference prompts were handed off. |

### Slash commands

| Command | Routes to |
|---|---|
| `/s3s` | Smart router — asset request → make-* skills; script/treatment → director; vague idea → interview |
| `/s3s-analyze` | Reverse-engineer a reference clip into a shotlist-ready brief |
| `/s3s-variations` | Generate 5–10 camera/composition options for one moment |
| `/s3s-references` | Asset router → dispatches to make-character / make-location / make-prop based on input |
| `/s3s-interview` | Force interview path (newbie intake) |
| `/s3s-shotlist` | Force director path (build HTML from existing script) |

## The full workflow

```
/s3s-analyze     →  reverse-engineer a reference clip into a practical brief
        │
        ├─ optional: /s3s-variations for 5–10 ways to shoot one moment
        ↓
/s3s-references  →  lock every asset (character / product / location / prop) into @tag sheets
        │           (make-character / make-location / make-prop, each in its best image model)
        ↓  (@tag element list + verbatim reference prompt text)
/s3s-interview   →  creative intake → mini-treatment + brief + directorial voice
        │           (or skip if you already have a script)
        ↓
/s3s-shotlist    →  build the HTML shotlist:
        │             - Asset Reference Prompts section (conditional — only if Stage 1 ran)
        │             - Style Prefix
        │             - Elements list (@tags)
        │             - Scenes with @tags bound into every prompt
        ↓
   shotlist.html  →  copy prompts into Seedance, images auto-attach by @tag name
```

## Three entry paths

1. **Reference clip first** → `/s3s-analyze`, optionally `/s3s-variations`, then `/s3s-references` / `/s3s-shotlist`.
2. **Vague idea, no script, no assets** → `/s3s-references` first (lock assets), then `/s3s-interview`, then `/s3s-shotlist`.
3. **Script/treatment ready, no assets** → `/s3s-references` (if the film recurs characters/product), then `/s3s-shotlist`.
4. **Already have real photos** of your product/person/place → skip references, attach the photos with `@tag` names, go straight to `/s3s-interview` or `/s3s-shotlist`.

`@tag` names in prompts match the user's Seedance Elements panel, so images auto-attach at generate time.

## Per-asset model differentiation

Not everything goes to one image model. Each make-* skill maps its asset type to the best tool:

| Asset | Best model |
|---|---|
| Character sheet (base) | Soul Cinema / Nano Banana (Gemini) |
| Character edits (dedup / outfit / state) | GPT Image 2 |
| Location | Cinematic Locations / Nano Banana |
| Product / prop (all cases) | GPT Image 2 (case 3 also Nano Banana) |

pi / opencode equivalents: `codex_generate_image` for gpt-image-2, `comfyeditor_image_generate` provider `gemini` for Nano Banana, `replicate`/`wavespeed`/`kie` for Flux/Seedream.

## Install

### pi

```bash
pi install https://github.com/madearga/s3s
```

Slash commands (after restart): `/s3s`, `/s3s-analyze`, `/s3s-variations`, `/s3s-references`, `/s3s-interview`, `/s3s-shotlist`.

### opencode

After `pi install` (or a plain `git clone`), link skills + commands into opencode's global discovery paths:

```bash
~/.pi/agent/git/github.com/madearga/s3s/install-opencode.sh
```

The script symlinks (never copies) and self-cleans dangling symlinks when a skill/command is removed from the repo, so `pi update --extensions` or `git pull` keeps opencode in sync automatically. Restart opencode afterwards.

Slash commands: `/s3s`, `/s3s-analyze`, `/s3s-variations`, `/s3s-references`, `/s3s-interview`, `/s3s-shotlist`. Skills also auto-load via opencode's `skill` tool when you describe a task without invoking a command.

### opencode (project-local, no global install)

Clone this repo as your project root. opencode auto-discovers `.agents/skills/*/SKILL.md` and `.opencode/commands/*.md` within the project worktree — no symlink needed.

## Repo layout

```
s3s/
├── package.json              # pi manifest (skills + prompts)
├── install-opencode.sh       # opencode global symlinks (idempotent, self-cleaning)
├── prompts/                  # pi slash commands (6)
├── .opencode/commands/       # opencode slash commands (6, same names)
└── .agents/skills/           # skills (pi manifest + opencode discovery)
    ├── seedance-shotlist-analyze/SKILL.md
    ├── seedance-shotlist-variations/SKILL.md
    ├── seedance-make-character/SKILL.md
    ├── seedance-make-location/SKILL.md
    ├── seedance-make-prop/SKILL.md
    ├── seedance-shotlist-interview/SKILL.md
    └── seedance-shotlist-director/SKILL.md
```

## Usage

```
/s3s-analyze https://example.com/reference-ad.mp4
/s3s-variations A man places a ceramic mug on a wooden cafe counter and looks up at camera — give me 10 ways to shoot this.
/s3s-references A headphone ad: hero is a 20yo man with curly auburn hair, product is cream over-ear ANC headphones, locations are a sage kitchen + Brooklyn street + stadium + office, props are running shoes + backpack + moka pot + mug
/s3s-interview I have an idea about a surgeon coming home from a 36-hour shift
/s3s-shotlist Anna comes home soaking wet from the rain. Marco is on the couch, looks up, says nothing. She walks past him to the bedroom.
/s3s [anything — router decides]
```

Or describe your task in plain language — the agent picks the right skill via description matching.

## License

MIT
