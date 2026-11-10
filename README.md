<img src="assets/icon.svg" width="64" height="64" alt="">

# dineshcx/skills

My agent skills for **Claude Code** and **Codex**. Small, focused, and each one does a single job well.

## Installation

A plugin updates itself. [skills.sh](https://skills.sh) copies editable files into your project, and you update them by hand. Pick one per agent, because installing both gives you every skill twice.

### 1. Get the skills

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add dineshcx/skills
claude plugin install dineshcx-skills@dineshcx
```

Update with `claude plugin marketplace update dineshcx`.

</details>

<details>
<summary><strong>Codex</strong></summary>

```bash
codex plugin marketplace add dineshcx/skills
codex plugin add dineshcx-skills@dineshcx
```

Updates itself at startup.

</details>

<details>
<summary><strong>Any other agent, or editable files</strong> (manual updates)</summary>

```bash
npx skills@latest add dineshcx/skills -a <agent>  # cursor, opencode, windsurf, ...; omit -a to choose
```

To update, run `npx skills@latest update`, and re-run `add` to pick up new skills.

</details>

### 2. Run the setup for the skills you use

| Skill | Setup |
|---|---|
| `bq-ask` | `/setup-bq-ask` (`$setup-bq-ask` in Codex), with the context link your data team gave you |

<details>
<summary><strong>Codex: skip approval prompts for bq-ask</strong></summary>

Codex's sandbox blocks network access, so each `gcloud`, `git` or `bq` call needs approval. To allow them, add to `~/.codex/rules/default.rules`:

```
prefix_rule(pattern=["gcloud", "storage", "rsync"], decision="allow")
prefix_rule(pattern=["git", "-C", "~/.cache/bq-ask/context"], decision="allow")
prefix_rule(pattern=["bq", "query"], decision="allow")
prefix_rule(pattern=["bq", "ls"], decision="allow")
prefix_rule(pattern=["bq", "show"], decision="allow")
```

</details>

## Reference

### Data

Ask questions about your company's data in plain English. [Bucket README](./skills/data/README.md).

#### User-invoked

- **[setup-bq-ask](./skills/data/setup-bq-ask/SKILL.md)**: Connect bq-ask to your team's data context (a `gs://` bucket path or a git repo) and check you can query BigQuery. [Docs](./docs/data/setup-bq-ask.md).

#### Model-invoked

- **[bq-ask](./skills/data/bq-ask/SKILL.md)**: Ask BigQuery questions in plain English. Runs the `bq` CLI as you, using your team's shared context, and never invents a business definition. [Docs](./docs/data/bq-ask.md). Teams writing a context: see the [Context format](./skills/data/bq-ask/CONTEXT-FORMAT.md).

## License

[MIT](./LICENSE)
