<img src="assets/icon.svg" width="64" height="64" alt="">

# dineshcx/skills

My skills for **Claude Code** and **Codex CLI**, published as one plugin, `dineshcx`. In Claude Code they show up as `/dineshcx:<skill>`; in Codex, as `$dineshcx:<skill>`.

## Skills

| Skill | What it does |
|---|---|
| [`bq-ask`](docs/bq-ask.md) | Ask BigQuery questions in plain English. Runs the `bq` CLI as you, using your team's shared context from a bucket or git repo. |

## Install

The plugin installs globally, so it works in any folder.

**Claude Code:**
```
/plugin marketplace add dineshcx/skills
/plugin install dineshcx@dineshcx
```

**Codex:**
```sh
codex plugin marketplace add dineshcx/skills
codex plugin add dineshcx@dineshcx
```

Then follow the skill's own setup; for example, [bq-ask's](docs/bq-ask.md#install).

## Updates

- **Claude Code:** `/plugin marketplace update dineshcx`
- **Codex:** `codex plugin marketplace upgrade`

## Layout

```
.claude-plugin/marketplace.json     the marketplace (read by both Claude Code and Codex)
plugin/.claude-plugin/plugin.json   the dineshcx plugin; bump version on every change
plugin/skills/<skill>/SKILL.md      one folder per skill
docs/<skill>.md                     each skill's guide
```

To add a skill, create `plugin/skills/<name>/SKILL.md` and `docs/<name>.md`, add a row to the table above, and bump the version.
