# Input: array of PR reviews in chronological order. Output: "success" or "failure".
def verdict:
  if .state == "APPROVED" then "success"
  elif .state == "CHANGES_REQUESTED" then "failure"
  elif (.body // "" | test("(^|\n)Verdict: changes[ \t\r]*($|\n)")) then "failure"
  elif (.body // "" | test("(^|\n)Verdict: approve[ \t\r]*($|\n)")) then "success"
  else empty
  end;

[ .[]
  | select(.commit_id == $sha)
  | select(.author_association | IN("OWNER", "MEMBER", "COLLABORATOR"))
  | verdict ]
| last // "failure"
