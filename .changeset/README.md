# Changesets

Every change users should get needs a changeset: run `npx changeset`, pick the bump (patch for fixes, minor for new skills or behaviour, major for breaking changes), and describe the change in one line, as a user would read it. On merge to `main`, the Release workflow opens a "chore: version skills" PR; merging it publishes the new version.
