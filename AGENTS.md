# Git Workflow (mandatory): Issue -> Commit -> PR -> Review -> Merge

Applies to every change, including docs and one-line fixes.

1. **Issue.** Before editing, run `scripts/start-task.sh <type> <slug> "<title>" <body-file>`.
   The body states the problem and acceptance criteria. It reuses a matching open issue.
2. **Commit.** Work only on the generated branch. One logical change per commit, Conventional Commits.
3. **PR.** Run tests, then `scripts/open-pr.sh <body-file>`. The body states what, why, and how it was verified.
4. **Review.** A separate agent session that did not write the code reads `gh pr diff <n>` and the issue,
   then submits `gh pr review <n> --comment --body-file <file>` (or `--approve` from another account).
   The review lists concrete findings (file and line) and ends with `Verdict: approve` or `Verdict: changes`.
5. **Merge.** Only after all checks pass: `gh pr merge <n> --merge --delete-branch`.

Never: push to the default branch, use `--no-verify` or `--force`, edit hooks, workflows or rulesets
to get past a failing check, or create filler issues, commits or reviews to raise activity counts.
If a step fails, stop and report it.
