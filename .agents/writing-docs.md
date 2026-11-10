# Writing docs pages

Every promoted skill has a human-facing **docs page** at `docs/<bucket>/<skill-name>.md`, mirroring its bucket under `skills/`. The page is not the skill and not a copy of `SKILL.md`: it orients one reader around one skill, so they know what it does, when to reach for it, and where it sits.

Act whenever a promoted skill is added, renamed, or has its behaviour changed: create or re-sync its page. A rename moves the file too. A promoted skill removed outright keeps its page, opened with `> **Archived.** Removed in <version>; use <replacement>.`

Every link is absolute (`https://github.com/dineshcx/skills/blob/main/...`), so pages work wherever they're published. There is no H1. A page carries no install commands; those live in the README, worded per [the install block](./install-block.md).

## Page structure

In this order. Delete optional sections that don't apply.

- `## What it does` (always): one or two plain paragraphs. Lead with the skill's job, then its **defining constraint**: the one fact that makes it behave differently from the obvious default (`bq-ask` never invents a business definition).
- `## When to reach for it` (always): the invocation mode (user-invoked or model-invoked, and how to call it), then the trigger boundary. Branches go in a table or list, never a paragraph.
- `## Prerequisites` (optional): tooling, access, or a setup skill that must run first.
- Free-form middle (optional): what the skill guarantees, its leading words.
- `## Common questions` (optional, but a page without it is unfinished): the questions real users ask, answered for their situation. Hunt them from issues and feedback.
- `## It's working if` (optional): the observable tells that the skill is doing its job, in terms a user can see.
- `## Where it fits` (always): its role (a **run-once setup**, a **reach-for-it-anytime standalone**, a **chain step**) and the one or two neighbours that matter, linked.

## Conventions

- Explain the **why**, not the process. Never reproduce the `SKILL.md` steps.
- Never name the author; state each claim on its own.
- Never name a real company, dataset, bucket or person. Examples use placeholders (`Acme`, `gs://<bucket>/<path>`).
- Keep the page low-load: no spare headings, no restated links.
