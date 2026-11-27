#!/usr/bin/env bash
# Tests the workflow rules (git hooks and review verdict) in a throwaway repository.
set -uo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failures=0

expect() {
  local want=$1 name=$2 got=pass
  shift 2
  "$@" >/dev/null 2>&1 || got=fail
  if [[ $got == "$want" ]]; then printf 'ok   %s\n' "$name"
  else printf 'FAIL %s\n' "$name"; failures=$((failures + 1)); fi
}

git init -q --bare "$work/remote.git"
git init -q -b main "$work/repo"
cd "$work/repo" || exit 1
git config user.email test@example.com
git config user.name test
git config core.hooksPath "$root/.githooks"
git remote add origin "$work/remote.git"

expect pass "initial commit on main" git commit -q --allow-empty -m "chore: init"
expect pass "initial push of main" git push -q origin main
expect fail "commit on main" git commit -q --allow-empty -m "feat: x"
git switch -q -c random-branch
expect fail "commit on unnamed branch" git commit -q --allow-empty -m "feat: x"
git switch -q -c feat/12-login
expect fail "non-conventional subject" git commit -q --allow-empty -m "update stuff"
expect pass "valid commit" git commit -q --allow-empty -m "feat(auth): add login"
expect pass "issue trailer added" grep -qx "Refs: #12" <(git log -1 --format=%B)
expect pass "push task branch" git push -q origin feat/12-login
expect fail "push to main" git push -q origin feat/12-login:main

verdict() {
  [[ $(jq -r --arg sha abc -f "$root/.github/review-verdict.jq" <<<"$1") == success ]]
}
review() {
  printf '{"commit_id":"%s","author_association":"%s","state":"%s","body":"%s"}' "$@"
}
ok=$(review abc OWNER COMMENTED 'Findings: none\r\nVerdict: approve')
no=$(review abc OWNER COMMENTED 'Verdict: changes')
expect fail "no review" verdict "[]"
expect pass "approving comment review" verdict "[$ok]"
expect pass "formal approval" verdict "[$(review abc COLLABORATOR APPROVED '')]"
expect fail "review of old commit" verdict "[$(review old OWNER APPROVED '')]"
expect fail "untrusted reviewer" verdict "[$(review abc NONE APPROVED '')]"
expect fail "latest verdict wins" verdict "[$ok,$no]"
expect pass "fixed after changes" verdict "[$no,$ok]"
expect fail "comment without verdict" verdict "[$(review abc OWNER COMMENTED 'looks fine')]"

exit $((failures > 0))
