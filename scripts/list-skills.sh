#!/usr/bin/env bash
# List every SKILL.md in the repo.
set -euo pipefail
cd "$(dirname "$0")/.."
find skills -name SKILL.md -not -path '*/node_modules/*' | sort
