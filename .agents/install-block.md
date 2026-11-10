# The canonical install block

One install story, one wording. `README.md` and `.changeset/*` must say **this** and nothing else. Change it here first, then propagate. Docs pages carry no install commands.

## Managed installs first

Lead with installs that update themselves. Fall back to skills.sh, labelled "manual updates", for agents that have no plugin install. Both Claude Code and Codex install from this repo's own marketplace, `.claude-plugin/marketplace.json`, and reinstall only when the `version` in `.claude-plugin/plugin.json` changes. The Release workflow sets that version, so users get a release when the "chore: version skills" PR merges.

| Agent         | Route                        | Updates itself?                                                  |
| ------------- | ---------------------------- | ---------------------------------------------------------------- |
| Claude Code   | `@dineshcx` marketplace      | No, run `claude plugin marketplace update dineshcx` (or enable auto-update for the marketplace in `/plugin`) |
| Codex         | `@dineshcx` marketplace      | Yes, at startup                                                  |
| Everyone else | skills.sh                    | No. Run `npx skills update`, and re-run `add` for new skills     |

## Claude Code

<canonical-block name="claude-code">

```bash
claude plugin marketplace add dineshcx/skills
claude plugin install dineshcx-skills@dineshcx
```

Update with `claude plugin marketplace update dineshcx`.

</canonical-block>

## Codex

<canonical-block name="codex">

```bash
codex plugin marketplace add dineshcx/skills
codex plugin add dineshcx-skills@dineshcx
```

Updates itself at startup.

</canonical-block>

## Any other agent

<canonical-block name="skills-sh">

```bash
npx skills@latest add dineshcx/skills -a <agent>  # cursor, opencode, windsurf, ...; omit -a to choose
```

To update, run `npx skills@latest update`, and re-run `add` to pick up new skills.

</canonical-block>
