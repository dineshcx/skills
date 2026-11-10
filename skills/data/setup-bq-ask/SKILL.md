---
name: setup-bq-ask
description: Connect bq-ask to your team's data context (a gs:// bucket path or a git repo) and check you can query BigQuery. Run once, or again to switch contexts.
argument-hint: "[context link]"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Read(~/.cache/bq-ask/**), Read(~/.config/bq-ask/**), Edit(~/.config/bq-ask/**), Bash(gcloud storage rsync:*), Bash(git clone --depth 1:*), Bash(git -C ~/.cache/bq-ask/context:*), Bash(bq query:*), Bash(bq version), Bash(gcloud auth list:*)
---

# setup-bq-ask

Connect `bq-ask` to a context, so the user can ask data questions.

Paths:
- `CONFIG` = `~/.config/bq-ask/context-url`: one line, the context link.
- `CACHE` = `~/.cache/bq-ask/context`: the local copy of the context.
- `CONTEXT` = the folder inside `CACHE` that contains `bq-ask.md` (usually `CACHE` itself; otherwise find it with Glob `CACHE/**/bq-ask.md`).

## Steps

1. **Check the tools.** Run `bq version` and `gcloud auth list`.
   - `bq` not found: they need the Google Cloud SDK (`brew install --cask google-cloud-sdk` on macOS, or https://cloud.google.com/sdk/docs/install).
   - No active account: they need to run `gcloud auth login` with their work Google account. Stop until they have.
2. **Ask for one thing: the context link** their data team gave them, unless the arguments already include it. It's one of:
   - Cloud Storage: `gs://<bucket>/<path>`
   - git repo: `https://github.com/<org>/<repo>(.git)` or `git@github.com:<org>/<repo>.git` (any git host works)
3. **Download it.**
   - If `CONFIG` already holds a *different* link, the old copy in `CACHE` must go first: ask, then delete it (`rm -rf ~/.cache/bq-ask/context`).
   - `gs://...`: `gcloud storage rsync <link> ~/.cache/bq-ask/context --recursive --delete-unmatched-destination-objects`
   - git, no `CACHE/.git` yet: `git clone --depth 1 <link> ~/.cache/bq-ask/context`. If that fails because `CACHE` isn't empty, delete it the same way and clone again.
   - git, `CACHE/.git` exists for the same link: `git -C ~/.cache/bq-ask/context pull --ff-only`
4. **Check it's a bq-ask context.** If the download failed, explain:
   - an auth error: they need `gcloud auth login` (for a bucket) or git credentials for that host (for a repo);
   - `403`, `AccessDenied`, `not found` or `Repository not found`: their account can't read it, or the link is wrong. They should check it with whoever gave it to them.

   If there's no `bq-ask.md` anywhere in the download, it's not a bq-ask context: say so and stop. Stop in either case without saving anything.
5. **Save** the link to `CONFIG` with the Write tool.
6. **Confirm access.** Read `CONTEXT/bq-ask.md` and run `bq query --project_id=<billing_project> --use_legacy_sql=false --format=json 'SELECT SESSION_USER() AS me'`, where `billing_project` comes from its frontmatter. If it fails, explain the error (most often a missing BigQuery Job User role on the billing project).
7. **Tell them it's ready:** as which Google account, the context's version (`CONTEXT/VERSION`, or the latest git commit), and 2–3 example questions from `bq-ask.md` if it has any. They ask with `/bq-ask <question>` (`$bq-ask` in Codex), or just by asking.
