#!/usr/bin/env node
// Copy package.json's version into .claude-plugin/plugin.json (run by `npm run version`).
// With --check, change nothing and exit 1 if they differ.
import { readFileSync, writeFileSync } from "node:fs";

const root = new URL("..", import.meta.url);
const pluginUrl = new URL(".claude-plugin/plugin.json", root);
const { version } = JSON.parse(readFileSync(new URL("package.json", root), "utf8"));
const source = readFileSync(pluginUrl, "utf8");
const current = JSON.parse(source).version;

if (current === version) process.exit(0);
if (process.argv.includes("--check")) {
  console.error(`plugin.json is ${current}, package.json is ${version}. Run: node scripts/sync-plugin-version.mjs`);
  process.exit(1);
}
// Replace only the version value, keeping key order and formatting.
writeFileSync(pluginUrl, source.replace(/("version"\s*:\s*")[^"]*(")/, `$1${version}$2`));
console.log(`plugin.json ${current} -> ${version}`);
