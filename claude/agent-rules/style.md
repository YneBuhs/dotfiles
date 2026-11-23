# Style: code, naming and writing

## Readable code
A teammate follows it on first read: guard clauses over nesting (max ~2 levels), named private methods per branch, no clever one-liners.

## Naming
- Name what a value means, not what it is. Pull a condition into a named boolean or a small predicate.
- A yes/no name reads as a question and ends in `?` as a method.
- Name methods for their happy-path job, not their guards (`link_invitee`, not `link_or_refuse`).
- Long names are a smell, but specific beats short. No abbreviations, even in blocks (`order_item`, not `oi`; `iso8601`, not `iso`).
- Keep a table of settled examples (Instead of | Use | Why) and add to it.

## Grouping
About 3+ methods with one job sit together under `# ---------- Section name ----------`, entry point first, helpers next to their caller.

## Code comments
Say why, not what. One or two plain lines. No decision history, dates or review numbers. A prototype file may open with `PROTOTYPE, NOT PRODUCTION` and its shortcut list.

## Writing anything others read
Plain prose. Problem first. Groups of at most 4 bullets. A diagram where it helps. JSON examples pretty-printed, one key per line.
