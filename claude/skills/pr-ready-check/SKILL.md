---
name: pr-ready-check
description: Check whether a PR is ready for code review (or to leave draft) - CI, open review threads, drift from the main branch, conflicts, local tests/lint/security scan, fresh-eyes reviews, and whether the description matches the code. Use when asked "is this ready for review" or before marking a PR ready.
---

# PR ready check

Read-only. Report each item with its proof (output, exit code).

1. **GitHub state:** `gh pr view <N> --json state,isDraft,headRefOid,reviewDecision`, `gh pr checks <N>`, and unresolved review threads (GraphQL `reviewThreads { isResolved }`). Every check passes on the current head; no unresolved threads.
2. **Branch health:** how far behind the main branch it is (`git rev-list --left-right --count`), and whether a merge conflicts (`git merge-tree --write-tree`; exit 0 = clean).
3. **Local proof on the pushed commit:** clean worktree at the pushed head; the PR's tests, the linter on changed files, the security scanner.
4. **Read the diff:** debug leftovers, TODOs, personal paths, names against style.md, comments with decision history, commits that also live in another open PR.
5. **Fresh-eyes reviews:** confirm a code review and a security review by fresh agents ran on the final diff (the agent's lifecycle step 7); if missing or stale, run them (diff + design link, not conclusions) and verify the findings.
6. **Description matches reality:** testing numbers equal the run from step 3; every claimed test exists; issue linked; template sections present.

Report: ready / not ready, then each fix with who does it. Pushing needs the owner's OK; marking ready is the owner's click.
