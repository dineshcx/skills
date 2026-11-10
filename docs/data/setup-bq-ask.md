## What it does

`setup-bq-ask` connects [`bq-ask`](https://github.com/dineshcx/skills/blob/main/docs/data/bq-ask.md) to your team's data context. It asks for one thing, the **context link**, downloads the context, checks it's a real bq-ask context, saves the link to `~/.config/bq-ask/context-url`, and runs a test query to confirm you can use BigQuery.

The defining constraint is that **it saves nothing until everything checks out**. If the link is wrong, you can't read it, or it isn't a bq-ask context, it explains why and leaves your current setup as it was.

## When to reach for it

User-invoked: only you can run it, with `/setup-bq-ask` (`$setup-bq-ask` in Codex). You can pass the link directly: `/setup-bq-ask gs://<bucket>/<path>`.

| Situation | What happens |
|---|---|
| First time using `bq-ask` | Run it once with the link your data team gave you |
| `bq-ask` says it isn't set up | Run it |
| Switching to another team's context | Run it with the new link; it asks before replacing the old copy |
| The context's git history was rewritten | Run it again to re-download |

The link is one of:

- a Cloud Storage path: `gs://<bucket>/<path>`
- a git repo: `https://github.com/<org>/<repo>` or `git@github.com:<org>/<repo>.git` (any git host)

## Prerequisites

- The Google Cloud SDK (`brew install --cask google-cloud-sdk` on macOS), signed in with `gcloud auth login`. It checks both and tells you what's missing.
- For a git link, git credentials for that host.

## Common questions

**Where do I get the link?** From whoever maintains your team's context. If you're the one creating it, see the [Context format](https://github.com/dineshcx/skills/blob/main/skills/data/bq-ask/CONTEXT-FORMAT.md).

**Bucket or git repo: which should a team use?** A bucket, if your users have Google accounts but not access to your git host: one `gcloud auth login` then covers both the context and BigQuery.

**It says "not a bq-ask context".** The link points at something without a `bq-ask.md` file. Check the link with whoever gave it to you.

## It's working if

- It ends by naming the Google account you're signed in as, the context's version, and a few example questions.
- `/bq-ask` answers right after, without asking you to set up again.

## Where it fits

The **run-once setup** for [`bq-ask`](https://github.com/dineshcx/skills/blob/main/docs/data/bq-ask.md). Run it again only to switch contexts.
