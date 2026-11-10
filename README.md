<img src="assets/icon.svg" width="64" height="64" alt="">

# bq-ask

Ask BigQuery questions in plain English from **Claude Code** or **Codex CLI**:

```
/bq-ask how many orders were refunded last week?      # Claude Code
$bq-ask how many orders were refunded last week?      # Codex
```

The agent runs the `bq` CLI **as you**, so it only sees what your Google account can see. It learns what your data means (which dataset, what "active customer" means, which rows to exclude) from a **context**: a folder of Markdown files your team keeps in a Cloud Storage bucket or a git repo. The skill holds no company information; each team brings its own context.

## Install

1. Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (`brew install --cask google-cloud-sdk` on macOS) and sign in:
   ```sh
   gcloud auth login
   ```
2. Install the plugin. It installs globally, so it works in any folder.
   - **Claude Code:**
     ```
     /plugin marketplace add dineshcx/bq-ask
     /plugin install bq-ask@bq-ask
     ```
   - **Codex:**
     ```sh
     codex plugin marketplace add dineshcx/bq-ask
     codex plugin add bq-ask@bq-ask
     ```
3. Run `/bq-ask setup` (or `$bq-ask setup` in Codex). It asks for one thing, your team's **context link**:
   - a bucket path, `gs://<bucket>/<path>`, or
   - a git repo, `https://github.com/<org>/<repo>` or `git@github.com:<org>/<repo>.git`.

   It saves the link to `~/.config/bq-ask/context-url` and checks that you can read the context and run queries. To switch contexts later, run `/bq-ask setup` again.

**Codex sandbox:** network access is blocked by default, so each `gcloud`, `git` or `bq` call needs approval. To skip the prompts, add these lines to `~/.codex/rules/default.rules`:

```
prefix_rule(pattern=["gcloud", "storage", "rsync"], decision="allow")
prefix_rule(pattern=["git", "-C", "~/.cache/bq-ask/context"], decision="allow")
prefix_rule(pattern=["bq", "query"], decision="allow")
prefix_rule(pattern=["bq", "ls"], decision="allow")
prefix_rule(pattern=["bq", "show"], decision="allow")
```

**Updates:** context updates reach you automatically, because the skill syncs the context at the start of every conversation. Plugin updates are rare: run `/plugin marketplace update bq-ask` (Claude Code) or `codex plugin marketplace upgrade` (Codex).

## What the skill guarantees

These hold whatever the context says:

- **Read-only.** It runs only `SELECT` queries, plus `bq ls` and `bq show`.
- **No surprise cost.** Every query has a `--maximum_bytes_billed` cap, and the skill asks before raising it.
- **Honest answers.** It never invents a business definition. When a question can be read two ways, it shows both numbers. Each answer comes with one line of assumptions (definition, dataset, time range, filters).
- **It keeps working offline.** If the context source can't be reached, it uses the last copy and says how old it is. With no copy at all, it refuses rather than guessing.

---

## Creating a context (for data teams)

A context is a folder of Markdown files. The only required file is `bq-ask.md`. Everything else is up to you, as long as `bq-ask.md` points to it.

### `bq-ask.md`: the entry point

```markdown
---
billing_project: my-gcp-project     # required: queries run and bill here
max_bytes_billed: 5000000000        # optional: per-query cap, default 5 GB
---

# Acme data

Start with [datasets.md](datasets.md) to map what the person names ("EU shop", "billing")
to an app and dataset. Then read `apps/<app>/index.md` for that app.

Example questions:
- How many orders were refunded last week in the EU shop?
- What's the weekly active customer count this quarter?
```

The body is instructions for the agent, so say how to find the right dataset and where the definitions live. The example questions are shown to people after setup.

### Recommended layout

```
bq-ask.md                     entry point (above)
datasets.md                   registry: what people call it → app → `project.dataset`, location, timezone
cross-dataset.md              optional: how to combine datasets (UNION ALL across clients, join keys across apps)
apps/<app>/
  index.md                    which file to read for which kind of question
  entities.md                 the business objects and how they map to tables
  metrics.md                  each metric: formula, time column, caveats
  filters.md                  filters every query needs (soft deletes, test accounts, internal users)
  gotchas.md                  traps: duplicates, timezones, JSON columns, status-history tables
  examples.md                 verified queries to adapt
  tables/<area>.md            per table: what a row is, keys and joins, useful columns, every enum value
```

### What makes a context good

- **Define every metric people ask about.** Give its formula, its time column and its caveats. If "active user" isn't written down, the agent will say it doesn't know rather than guess. That's deliberate, but it means you need to write the definitions.
- **Write down every filter that's always needed** (deleted rows, test data, internal accounts). This is where most wrong numbers come from.
- **List every enum value with its meaning.** Profile the real values with `SELECT status, COUNT(*) ... GROUP BY 1`, not just from the code.
- **Keep files short.** Use tables and bullets. The agent reads only the files a question needs, so split by topic.
- **If one app is deployed once per client,** write its SQL with a `{dataset}` placeholder and keep one registry row per deployment.
- **Leave out personal data and secrets.** The context describes data; it never contains it.
- **Generate the tables, write the meaning by hand.** `tables/*.md` can be regenerated from your code and schemas by an agent. Business definitions, filters and gotchas should be written and reviewed by people.

### Publishing

**Cloud Storage:** keep the context in git, and mirror it to the bucket when it changes:

```sh
gcloud storage rsync ./context gs://<bucket>/<path> --recursive --delete-unmatched-destination-objects
echo "$(git rev-parse --short HEAD) $(date -u +%FT%RZ)" | gcloud storage cp - gs://<bucket>/<path>/VERSION
```

Give users `roles/storage.objectViewer` on the bucket, or on a managed folder for that path. The `VERSION` file is optional; if present, the agent quotes it when the context might be stale.

**git repo:** push to the default branch. Users need read access to the repo through their usual git credentials. The context can live in a subfolder, because the skill finds `bq-ask.md` anywhere in the repo.

Use a bucket when your users have Google accounts but not access to your git host: one `gcloud auth login` then covers both the context and BigQuery.

### BigQuery access

Users need BigQuery Job User (`roles/bigquery.jobUser`) on `billing_project`, and BigQuery Data Viewer (`roles/bigquery.dataViewer`) on the datasets the context points to. Grant them to a Google group. For a hard spending limit, set a *query usage per day per user* quota on the billing project.
