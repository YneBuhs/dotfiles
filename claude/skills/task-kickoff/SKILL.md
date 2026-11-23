---
name: task-kickoff
description: Front-load the information gathering for a coding task before writing any code - state it as before/after, trace the code path, surface product decisions and side effects, grill the open points, then write a plan with a files-touched list for the owner to approve. Use at the start of any new task, feature, bug fix or improvement, or when asked to "kick off", "plan" or "scope" a change.
---

# Task kickoff

Find the surprises (product decisions, side effects, quality traps) before coding, not halfway through. No code until the plan is approved. Write the plan to `tmp/kickoff/<task-slug>.md` in the worktree (git-ignored) and keep it updated.

1. **Name the task.** Type: implement, fix or improve. Before → after, concretely, in two or three lines; if you can't, ask. Link the issue and design section.
2. **Trace the code path** end to end with `file:line`: entry point, models and services, every writer and reader of the data. Note side effects (callbacks, jobs, broadcasts, mail), existing behavior that differs from the design, the blast radius (who else uses this code), and what users see (look at any page, form or email it touches; a UX problem is a product decision for step 3).
3. **Product decisions:** a table of Decision | Options | Suggested answer and why | Who decides. Product and security go to the owner; design to the lead session.
4. **Grill** the open decisions and the plan's weakest points (ask the questions directly). Record each answer and who gave it.
5. **Plan:** ordered steps (one commit each, with tests); a files-touched table (Add/Change | File | Why); the tests for each decision; what's out of scope.
6. **Get the OK:** send the path and a short summary. Build only after approval; update the file first if the plan changes.

After the build, when staging: compare the files-touched list with `git diff --cached --stat` and explain every file that's new, missing or much bigger than planned.
