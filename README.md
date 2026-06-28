# s3s

Seedance 2.0 shotlist workflow — creative interview + HTML shotlist director with `@tag` image reference binding. Dual-compatible: runs in **pi** and **opencode**.

## What's inside

- **seedance-shotlist-interview** — newbie-friendly creative intake. Max 5 questions per batch (each with a default), feeling-to-film translation, Director's Read per scene, optional asset building (character/location/prop sheets), `@tag` element list. Output: mini-treatment + switchable assumptions + production brief. Hands off to the director.
- **seedance-shotlist-director** — builds an editable HTML shotlist from a script, treatment, or interview brief. Each prompt = 15 seconds; long scenes split into `3a/3b/3c`. Global Style Prefix, per-scene checkboxes (localStorage), Copy buttons, optional Elements list of `@tag` image references that auto-attach in Seedance/Higgsfield.

## Two entry paths

1. **Vague idea, no script** → interview runs first, produces a brief, then director builds the HTML.
2. **Script/treatment ready** → director builds the HTML directly, skips the interview.

`@tag` names in prompts match the user's Seedance/Higgsfield Elements panel, so images auto-attach at generate time.

## Install

### pi

```bash
pi install https://github.com/madearga/s3s
```

Slash commands (after restart): `/s3s` (smart router), `/s3s-interview`, `/s3s-shotlist`.

### opencode

After `pi install` (or a plain `git clone`), link skills + commands into opencode's global discovery paths:

```bash
~/.pi/agent/git/github.com/madearga/s3s/install-opencode.sh
```

The script symlinks (never copies), so `pi update --extensions` or `git pull` keeps opencode in sync automatically. Restart opencode afterwards.

Slash commands: `/s3s`, `/s3s-interview`, `/s3s-shotlist`. Skills also auto-load via opencode's `skill` tool when you describe a video task without invoking a command.

### opencode (project-local, no global install)

Clone this repo as your project root. opencode auto-discovers `.agents/skills/*/SKILL.md` and `.opencode/commands/*.md` within the project worktree — no symlink needed.

## Repo layout

```
s3s/
├── package.json              # pi manifest (skills + prompts)
├── install-opencode.sh       # opencode global symlinks
├── prompts/                  # pi slash commands
│   ├── s3s.md  s3s-interview.md  s3s-shotlist.md
├── .opencode/commands/       # opencode slash commands
│   ├── s3s.md  s3s-interview.md  s3s-shotlist.md
└── .agents/skills/           # skills (pi manifest + opencode discovery)
    ├── seedance-shotlist-director/SKILL.md
    └── seedance-shotlist-interview/SKILL.md
```

## Usage

```
/s3s Anna comes home soaking wet from the rain. Marco is on the couch, looks up, says nothing. She walks past him to the bedroom.
/s3s-interview I have an idea about a surgeon coming home from a 36-hour shift
/s3s-shotlist [paste your script]
```

Or just describe your video task in plain language — the agent picks the right skill via description matching.

## License

MIT