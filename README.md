# s3s

Seedance 2.0 shotlist workflow — **reference sheets** + **creative interview** + **HTML shotlist director** with `@tag` image reference binding. Dual-compatible: runs in **pi** and **opencode**. Patterns adapted from the [Higgsfield cinematic ad workflow](https://higgsfield.ai/blog/cinematic_headphones).

## What's inside — 3 skills

| Skill | Job | Slash command |
|---|---|---|
| **seedance-shotlist-references** | Generate locked reference-sheet prompts (character / product / location / prop + outfit & state variants) before the film is shot. One face per sheet, grey bg, 3/4 locations, no branding. | `/s3s-references` |
| **seedance-shotlist-interview** | Newbie-friendly creative intake. Max 5 questions per batch (each with a default), feeling-to-film translation, Director's Read per scene. Output: mini-treatment + switchable assumptions + brief + `@tag` element list. Routes Stage 1 asset building to the references skill. | `/s3s-interview` |
| **seedance-shotlist-director** | Builds an editable HTML shotlist from a script, treatment, or interview brief. Each prompt = 15 seconds; long scenes split into `3a/3b/3c`. Style Prefix, per-scene checkboxes (localStorage), Copy buttons, Elements list of `@tag` references that auto-attach in Seedance/Higgsfield. | `/s3s-shotlist` |

`/s3s` is the smart router — script/treatment → director, vague idea → interview, asset request → references.

## The full workflow

```
/s3s-references  →  lock every asset (character, product, location, prop) into @tag sheets
        │
        ↓  (element list of @tags)
/s3s-interview   →  creative intake → mini-treatment + brief + directorial voice
        │           (or skip if you already have a script)
        ↓
/s3s-shotlist    →  build the HTML shotlist, @tags bound into every prompt
        │
        ↓
   shotlist.html  →  copy prompts into Seedance, images auto-attach by @tag name
```

## Two entry paths (three if you need references)

1. **Vague idea, no script, no assets** → `/s3s-references` first (lock assets), then `/s3s-interview`, then `/s3s-shotlist`.
2. **Script/treatment ready, no assets** → `/s3s-references` (if the film recurs characters/product), then `/s3s-shotlist`.
3. **Already have real photos** of your product/person/place → skip references, attach the photos with `@tag` names, go straight to `/s3s-interview` or `/s3s-shotlist`.

`@tag` names in prompts match the user's Seedance/Higgsfield Elements panel, so images auto-attach at generate time.

## Install

### pi

```bash
pi install https://github.com/madearga/s3s
```

Slash commands (after restart): `/s3s`, `/s3s-references`, `/s3s-interview`, `/s3s-shotlist`.

### opencode

After `pi install` (or a plain `git clone`), link skills + commands into opencode's global discovery paths:

```bash
~/.pi/agent/git/github.com/madearga/s3s/install-opencode.sh
```

The script symlinks (never copies), so `pi update --extensions` or `git pull` keeps opencode in sync automatically. Restart opencode afterwards. Run it again after this update to pick up the new `seedance-shotlist-references` skill and `/s3s-references` command.

Slash commands: `/s3s`, `/s3s-references`, `/s3s-interview`, `/s3s-shotlist`. Skills also auto-load via opencode's `skill` tool when you describe a task without invoking a command.

### opencode (project-local, no global install)

Clone this repo as your project root. opencode auto-discovers `.agents/skills/*/SKILL.md` and `.opencode/commands/*.md` within the project worktree — no symlink needed.

## Repo layout

```
s3s/
├── package.json              # pi manifest (skills + prompts)
├── install-opencode.sh       # opencode global symlinks (idempotent)
├── prompts/                  # pi slash commands
│   ├── s3s.md  s3s-references.md  s3s-interview.md  s3s-shotlist.md
├── .opencode/commands/       # opencode slash commands (same names)
│   ├── s3s.md  s3s-references.md  s3s-interview.md  s3s-shotlist.md
└── .agents/skills/           # skills (pi manifest + opencode discovery)
    ├── seedance-shotlist-references/SKILL.md
    ├── seedance-shotlist-interview/SKILL.md
    └── seedance-shotlist-director/SKILL.md
```

## Usage

```
/s3s-references A headphone ad: hero is a 20yo man with curly auburn hair, product is cream over-ear ANC headphones, locations are a sage kitchen + Brooklyn street + stadium + office, props are running shoes + backpack + moka pot + mug
/s3s-interview I have an idea about a surgeon coming home from a 36-hour shift
/s3s-shotlist Anna comes home soaking wet from the rain. Marco is on the couch, looks up, says nothing. She walks past him to the bedroom.
/s3s [anything — router decides]
```

Or describe your task in plain language — the agent picks the right skill via description matching.

## License

MIT