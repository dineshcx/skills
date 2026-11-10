# Context format

A bq-ask **context** is a folder of Markdown files that tells the agent what a team's data means: which dataset to use, how each metric is defined, which rows to exclude. It lives in a Cloud Storage bucket or a git repo; `/setup-bq-ask` connects a user to it, and `bq-ask` syncs it at the start of every conversation.

The only required file is `bq-ask.md`. Everything else is up to you, as long as `bq-ask.md` points to it.

## `bq-ask.md`: the entry point

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

## Recommended layout

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

## What makes a context good

- **Define every metric people ask about.** Give its formula, its time column and its caveats. If "active user" isn't written down, the agent will say it doesn't know rather than guess. That's deliberate, but it means you need to write the definitions.
- **Write down every filter that's always needed** (deleted rows, test data, internal accounts). This is where most wrong numbers come from.
- **List every enum value with its meaning.** Profile the real values with `SELECT status, COUNT(*) ... GROUP BY 1`, not just from the code.
- **Keep files short.** Use tables and bullets. The agent reads only the files a question needs, so split by topic.
- **If one app is deployed once per client,** write its SQL with a `{dataset}` placeholder and keep one registry row per deployment.
- **Leave out personal data and secrets.** The context describes data; it never contains it.
- **Generate the tables, write the meaning by hand.** `tables/*.md` can be regenerated from your code and schemas by an agent. Business definitions, filters and gotchas should be written and reviewed by people.

## Publishing

**Cloud Storage:** keep the context in git, and mirror it to the bucket when it changes:

```sh
gcloud storage rsync ./context gs://<bucket>/<path> --recursive --delete-unmatched-destination-objects
echo "$(git rev-parse --short HEAD) $(date -u +%FT%RZ)" | gcloud storage cp - gs://<bucket>/<path>/VERSION
```

Give users `roles/storage.objectViewer` on the bucket, or on a managed folder for that path. The `VERSION` file is optional; if present, the agent quotes it when the context might be stale.

**git repo:** push to the default branch. Users need read access to the repo through their usual git credentials. The context can live in a subfolder, because the skill finds `bq-ask.md` anywhere in the repo.

Use a bucket when your users have Google accounts but not access to your git host: one `gcloud auth login` then covers both the context and BigQuery.

## BigQuery access

Users need BigQuery Job User (`roles/bigquery.jobUser`) on `billing_project`, and BigQuery Data Viewer (`roles/bigquery.dataViewer`) on the datasets the context points to. Grant them to a Google group. For a hard spending limit, set a *query usage per day per user* quota on the billing project.
