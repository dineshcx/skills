Skills are organized into bucket folders under `skills/`:

- `data/`: asking questions about company data
- `in-progress/`: beta: public on purpose, feedback wanted, not shipped in the plugin
- `deprecated/`: no longer used

Create a new bucket only when a skill fits none of these. Name it for the work it supports (`engineering/`, `productivity/`), add it to this list, and give it a `README.md`.

Every skill outside `in-progress/` and `deprecated/` (the **promoted** buckets) must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`'s `skills` array (the plugin ships exactly the promoted set). Skills in `in-progress/` and `deprecated/` must not appear in either.

Install commands are copied verbatim from [.agents/install-block.md](./.agents/install-block.md). `.claude-plugin/marketplace.json` is the repo's own marketplace, named `dineshcx`, and its one plugin, `dineshcx-skills`, is the repo root. Claude Code and Codex both install from it. Run `claude plugin validate .` after touching either manifest; its one expected warning is that `CLAUDE.md` at the root isn't loaded as plugin context, which is fine because `CLAUDE.md` is for working on this repo, not for users. [ADR 0001](./.agents/adr/0001-one-plugin-from-the-repo-root.md) records why.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`. The promoted buckets' `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**; `in-progress/` uses a flat list.

Promoted skills also have a human-facing docs page at `docs/<bucket>/<skill-name>.md` (the docs tree mirrors the promoted bucket folders under `skills/`). When you add, rename, or change the behaviour of a promoted skill, create or re-sync its docs page following [.agents/writing-docs.md](./.agents/writing-docs.md). Skills in `in-progress/` and `deprecated/` get **no** docs page.

Every `SKILL.md` is either user-invoked (`disable-model-invocation: true` plus `policy.allow_implicit_invocation: false` in `agents/openai.yaml`, reachable only by the human) or model-invoked (model- or user-reachable). See [.agents/invocation.md](./.agents/invocation.md).

A skill that needs one-time configuration gets a separate user-invoked `setup-<skill>` skill, and the skill itself tells the user to run it when the configuration is missing (`bq-ask` → `setup-bq-ask`).

Skills hold no company or personal information: anything team-specific (datasets, definitions, credentials, internal names) lives in configuration the user provides at setup, such as bq-ask's context. Before committing, check that no `SKILL.md`, docs page or example names a real company, dataset, bucket or person.

To (re)link every skill outside `deprecated/` into the local harness skill directories (`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each entry is a symlink into this repo, so a `git pull` keeps installed skills current; re-run the script after adding, removing, or renaming a skill. Don't use it alongside the installed plugin, or you get every skill twice.

Versioning: every change that users should get needs a changeset (`npx changeset`). On merge to `main`, the Release workflow opens a "chore: version skills" PR that bumps `package.json`, copies the version into `.claude-plugin/plugin.json` (`scripts/sync-plugin-version.mjs`), and updates `CHANGELOG.md`. Codex reinstalls only when that version changes.

No em-dashes anywhere.
