#!/usr/bin/env bash
# Dev-only: symlink every skill outside deprecated/ into the local harness skill folders,
# so edits here are live without reinstalling. Don't combine with the installed plugin.
#   ~/.claude/skills   Claude Code
#   ~/.agents/skills   Codex and other Agent Skills harnesses
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

for dest in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  # A destination that is itself a symlink into this repo would write links back into skills/.
  if [ -L "$dest" ]; then
    case "$(readlink -f "$dest")" in "$REPO"|"$REPO"/*)
      echo "error: $dest links into this repo; remove it and re-run." >&2; exit 1 ;;
    esac
  fi
  mkdir -p "$dest"
  find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -print0 |
    while IFS= read -r -d '' md; do
      src="$(dirname "$md")"; target="$dest/$(basename "$src")"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "skip $target: a real folder is there, not a link" >&2; continue
      fi
      ln -sfn "$src" "$target" && echo "linked $(basename "$src") ($dest)"
    done
done
