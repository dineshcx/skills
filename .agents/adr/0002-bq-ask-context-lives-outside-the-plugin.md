# bq-ask's context lives outside the plugin, synced at runtime

`bq-ask` needs to know what a team's data means: which dataset, how each metric is defined, which rows to exclude. That **context** changes whenever the team's apps change; the skill itself rarely does.

## Decision

- The skill ships no context. A user connects one with `setup-bq-ask`, giving a link to a Cloud Storage path or a git repo, saved in `~/.config/bq-ask/context-url`.
- `bq-ask` syncs the context into `~/.cache/bq-ask/context` at the start of every conversation (`gcloud storage rsync` or `git pull`), so a team's fix reaches everyone on their next question without a plugin update.
- The only required file is `bq-ask.md`: billing project, byte cap, and how to route a question. Its format is documented in `skills/data/bq-ask/CONTEXT-FORMAT.md`.

## Why

- **Freshness.** Shipping context inside the plugin means users only get fixes when they update the plugin, which most never do.
- **Public skill, private context.** The skill is public and generic; each team's context stays private, readable only by people with access to the bucket or repo.
- **One login.** With a bucket, the same `gcloud auth login` that runs queries also reads the context, so users need no git-host access.

## Consequences

- If the context source is unreachable, `bq-ask` answers from the last synced copy and says how old it is; with no copy at all it refuses.
- The context is untrusted with respect to the skill's rules: read-only, the byte cap, and never writing to the source hold whatever the context says.
