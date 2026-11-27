#!/usr/bin/env bash
TYPES='feat|fix|docs|refactor|test|chore|ci'
BRANCH_RE="^($TYPES)/([0-9]+)-[a-z0-9-]+$"

current_branch() { git symbolic-ref --quiet --short HEAD; }

fail() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }
