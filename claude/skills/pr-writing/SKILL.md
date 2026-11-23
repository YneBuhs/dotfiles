---
name: pr-writing
description: Write or update a PR title, description or reviewer line comments in plain, human prose. Use whenever drafting or editing a PR body.
---

# PR writing

- **Title:** Conventional Commits, `type(scope): Description`, under ~72 characters.
- **Body:** keep the repo's template sections. Start with a one-paragraph summary (what was wrong, for whom), then a diagram if the change has a flow, a short **Terms** list for domain words, and implementation detail in a collapsible `<details>` block. Link the design doc.
- **Testing:** the exact command and its numbers from a run on the pushed commit, what the tests cover, and what's not tested, said plainly.
- At most 4 bullets per group; JSON pretty-printed; no Co-Authored-By lines.
- **Line comments as a guided tour** for reviewers new to the area: where a gem needs config, security checks and their order, side effects, migrations. Bold lead phrase, then 1–3 plain sentences.
- Every PR links an issue (`Closes #N` or `Refs #N`).
