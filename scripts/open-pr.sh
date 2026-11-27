#!/usr/bin/env bash
# Usage: open-pr.sh <body-file>
# Pushes the task branch and opens a PR that closes its issue. Exits 1 on invalid state or gh/git failure.
set -euo pipefail
source "$(dirname "$0")/../.githooks/lib.sh"

[[ $# -eq 1 && -s $1 ]] || fail "usage: open-pr.sh <non-empty body-file>"
branch=$(current_branch) || fail "detached HEAD"
[[ $branch =~ $BRANCH_RE ]] || fail "not a task branch: $branch"
issue=${BASH_REMATCH[2]}

git push --set-upstream origin "$branch"

existing=$(gh pr list --head "$branch" --state open --json url --jq '.[0].url // empty')
if [[ -n $existing ]]; then
  printf 'PR already open: %s\n' "$existing"
  exit 0
fi

title=$(gh issue view "$issue" --json title --jq .title)
{ printf 'Closes #%s\n\n' "$issue"; cat "$1"; } |
  gh pr create --head "$branch" --title "$title" --body-file -
