## What it does

`bq-ask` answers a data question in plain English: "how many tasks were delivered last week?", "what did we spend on tokens by model last month?". It writes the SQL, runs it with the `bq` CLI **as you**, and replies with the number and one sentence of assumptions, so someone who can't read SQL can still check the answer.

The defining constraint is that **it never invents a business definition**. It learns what your data means (which dataset, what "active customer" means, which rows always get excluded) from a **context**: a folder of Markdown files your team maintains in a Cloud Storage bucket or a git repo. If the context doesn't define a term, it says so instead of guessing. The skill itself holds no company information; each team brings its own context.

## When to reach for it

Model-invoked: ask a data question in plain words and the agent picks it up, or call it directly with `/bq-ask <question>` (`$bq-ask` in Codex).

| You want | Use |
|---|---|
| A count, rate, trend, lookup or comparison over your team's data | `bq-ask` |
| To connect to a context for the first time, or switch to another one | [`setup-bq-ask`](https://github.com/dineshcx/skills/blob/main/docs/data/setup-bq-ask.md) |
| To write or change a context | [Context format](https://github.com/dineshcx/skills/blob/main/skills/data/bq-ask/CONTEXT-FORMAT.md) |

## Prerequisites

- The Google Cloud SDK, signed in with `gcloud auth login`.
- A context link from your data team, connected once with `/setup-bq-ask`.
- BigQuery Job User on the context's billing project, and Data Viewer on its datasets.

## What it guarantees

These hold whatever the context says:

- **Read-only.** It runs only `SELECT` queries, plus `bq ls` and `bq show`.
- **No surprise cost.** Every query carries a `--maximum_bytes_billed` cap (5 GB unless the context sets another), and it asks before raising it.
- **Always current.** It syncs the context at the start of every conversation, so your team's fixes reach you without updating anything.
- **Degrades honestly.** If the context source can't be reached, it uses the last copy and says how old it is. With no copy at all, it refuses rather than guessing.

## Common questions

**Why did it give me two numbers?** The question had more than one reasonable reading (created vs delivered, UTC vs local time, which week), so it ran each and showed them side by side. Pick the one you meant; if the same choice keeps coming up, ask your data team to define it in the context.

**The answer is wrong. What do I do?** Say so. It gives you a short block with your question, the dataset, its SQL and your correction, to paste to whoever maintains the context. Fixing the context fixes it for everyone.

**Can it change data?** No. It runs `SELECT` only, whatever you or the context ask, and most users only have read access anyway.

**Does it see data I can't?** No. Queries run as your Google account, with your permissions.

## It's working if

- Every answer opens with the number, followed by one sentence naming the definition, dataset, time range and filters.
- It says "the context doesn't define X" instead of producing a plausible-looking number.
- After your data team publishes a context fix, the next conversation uses it.

## Where it fits

A **reach-for-it-anytime standalone**, with [`setup-bq-ask`](https://github.com/dineshcx/skills/blob/main/docs/data/setup-bq-ask.md) as its run-once setup.
