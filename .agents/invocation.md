# Model-invoked vs user-invoked

Every `SKILL.md` in this repo is a skill. The one axis that splits them is **invocation**, who can reach it:

- **User-invoked**: reachable **only by the human typing its name**. Set `disable-model-invocation: true` in the frontmatter (Claude Code) and `policy.allow_implicit_invocation: false` in `agents/openai.yaml` (Codex). The `description` is **human-facing**: a one-line summary read by a person browsing slash commands. No trigger lists. Setup skills (`setup-bq-ask`) are always user-invoked: they write configuration, so only the human should start them.
- **Model-invoked**: reachable by **model or user**. The default: omit `disable-model-invocation` and the `policy` block. The `description` is **model-facing** and keeps rich trigger phrasing ("Use when someone asks…") so auto-invocation fires. The test: _could the model usefully reach for this on its own?_ `bq-ask` passes, because people ask data questions without naming the skill.

Every skill carries an `agents/openai.yaml` beside its `SKILL.md`, with Codex UI metadata: `interface.display_name` and `interface.short_description`, and for user-invoked skills the `policy.allow_implicit_invocation: false` that pairs with `disable-model-invocation`. Keep the two in sync: a skill is user-invoked in both harnesses or neither.

## Dependencies between them

A model-invoked skill can never call a user-invoked one. When a skill needs a user-invoked skill to have run first (`bq-ask` needs `setup-bq-ask`), phrase it as an instruction for the human: "tell the user to run `/setup-bq-ask` and stop". Only do this for hard dependencies, where the skill can't work at all without it.

To invoke another **model-invoked** skill, tell the agent to call the Skill tool with its name (`Call the Skill tool with "bq-ask"`), not a `../other-skill/FILE.md` link. Shared reference docs live inside the skill that owns them (`bq-ask/CONTEXT-FORMAT.md`).
