#!/bin/bash
# Weekly look at what the coding agent asked to do.
# Usage: summary.sh [days]   (default 7)
days=${1:-7}
dir="${AGENT_AUDIT_DIR:-$HOME/.claude/agent-guard/audit}"
files=$(for i in $(seq 0 $((days - 1))); do f="$dir/$(date -d "-${i} days" +%Y-%m-%d).jsonl"; [ -f "$f" ] && echo "$f"; done)
if [ -z "$files" ]; then echo "No agent logs in the last $days days."; exit 0; fi
cat $files | jq -rs '
  def n: length | tostring;
  "Agent activity, last '"$days"' days\n",
  "Commands tried: " + ([.[] | select(.decision != null)] | n),
  "  blocked by the guard: " + ([.[] | select(.decision == "deny")] | n),
  "  sent to you for approval (push): " + ([.[] | select(.decision == "ask")] | n),
  "Blocked by the OS sandbox: " + ([.[] | select(.sandbox_block == true)] | n),
  "Permission prompts shown: " + ([.[] | select(.event == "PermissionRequest")] | n),
  "Denied (rules or safety check): " + ([.[] | select(.event == "PermissionDenied")] | n),
  "Tool failures: " + ([.[] | select(.event == "PostToolUseFailure")] | n),
  "\nTools used:",
  ([.[] | select(.event == "PostToolUse") | .tool] | group_by(.) | map("  \(.[0]): \(length)") | .[]),
  "\nBlocked or denied (newest first):",
  ([.[] | select(.decision == "deny" or .sandbox_block == true or .event == "PermissionDenied")]
     | sort_by(.at) | reverse | .[0:20][]
     | "  \(.at)  \(.event // "guard")  \(.command // .path // .tool)  \(.reason // .stderr // "")"),
  "\nPermission prompts (newest first):",
  ([.[] | select(.event == "PermissionRequest")] | sort_by(.at) | reverse | .[0:20][]
     | "  \(.at)  \(.tool)  \(.command // .path // "")")
'
if [ -s "$dir/errors.log" ]; then echo; echo "Logger errors: $(wc -l < "$dir/errors.log") (see $dir/errors.log)"; fi
