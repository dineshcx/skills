# Data

Skills for asking questions about your company's data.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[setup-bq-ask](./setup-bq-ask/SKILL.md)**: Connect bq-ask to your team's data context (a `gs://` bucket path or a git repo) and check you can query BigQuery. Run once, or again to switch contexts.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[bq-ask](./bq-ask/SKILL.md)**: Ask BigQuery questions in plain English. Runs the `bq` CLI as you, using your team's shared context, and never invents a business definition.
