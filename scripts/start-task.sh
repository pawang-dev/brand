#!/usr/bin/env bash
# Usage: start-task.sh <type> <slug> <title> <body-file>
# Creates (or reuses) an issue and checks out its branch. Exits 1 on invalid input or gh/git failure.
set -euo pipefail
source "$(dirname "$0")/../.githooks/lib.sh"

[[ $# -eq 4 ]] || fail "usage: start-task.sh <type> <slug> <title> <body-file>"
type=$1 slug=$2 title="$1: $3" body_file=$4

[[ $type =~ ^($TYPES)$ ]] || fail "type must be one of: $TYPES"
[[ $slug =~ ^[a-z0-9-]+$ ]] || fail "slug may only contain a-z, 0-9 and '-'"
[[ -s $body_file ]] || fail "issue body file is missing or empty"
[[ -z $(git status --porcelain --untracked-files=no) ]] || fail "working tree has uncommitted changes"

issue=$(TITLE="$title" gh issue list --state open --limit 200 --json number,title \
  --jq 'map(select(.title == env.TITLE)) | .[0].number // empty')
if [[ -z $issue ]]; then
  url=$(gh issue create --title "$title" --body-file "$body_file")
  issue=${url##*/}
fi
[[ $issue =~ ^[0-9]+$ ]] || fail "could not resolve the issue number"

base=$(gh repo view --json defaultBranchRef --jq .defaultBranchRef.name)
branch="$type/$issue-$slug"
git fetch origin "$base"
if git show-ref --verify --quiet "refs/heads/$branch"; then
  git switch "$branch"
else
  git switch --no-track -c "$branch" "origin/$base"
fi
printf 'Issue #%s ready on branch %s\n' "$issue" "$branch"
