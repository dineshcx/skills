# Ship every skill as one plugin from the repo root

The repo is its own marketplace (`dineshcx`, in `.claude-plugin/marketplace.json`) with exactly one plugin, `dineshcx-skills`, whose source is the repo root (`"source": "./"`). `.claude-plugin/plugin.json` lists the promoted skills one by one in its `skills` array.

## Why one plugin, not one per skill

- **One install, every skill.** Users run one `install` and get new skills as they ship, with no second command per skill.
- **Commands read naturally.** Claude Code and Codex namespace plugin skills as `plugin:skill`. With one plugin per skill, a skill named after its plugin shows as `bq-ask:bq-ask`. With one plugin, it's `dineshcx-skills:bq-ask`, and the bare `/bq-ask` still works when nothing else claims the name.
- **Curated by list.** The explicit `skills` array ships exactly the promoted set and nothing from `in-progress/` or `deprecated/`.

The cost: users can't install one skill without the rest. Anyone who wants only one uses skills.sh (`npx skills add dineshcx/skills`), which lets them pick.

## Why it works on Codex

Codex reads `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`, including the `skills` array, so no `.codex-plugin/` manifest is needed. Verified 2026-11-10 on Codex CLI 0.160.0: `codex plugin marketplace add` then `codex plugin add dineshcx-skills@dineshcx` installs both skills, and `$setup-bq-ask` and `$bq-ask` run. If a future Codex stops reading the array, add `.codex-plugin/plugin.json` pointing at a folder that holds only promoted skills.

## Invariants

- Every promoted skill is in the `skills` array and in the top-level `README.md`; nothing else is.
- Run `claude plugin validate .` after touching either manifest; its one expected warning is that `CLAUDE.md` at the root isn't loaded as plugin context, which is fine because `CLAUDE.md` is for working on this repo, not for users.
