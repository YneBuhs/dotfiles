#!/bin/bash
# Outcome log for the coding agent's sessions (all tools).
# guard.sh logs what the agent tries to run (Bash only, with its guard decision).
# This logs what happened next: results, failures, sandbox blocks, permission
# prompts and denials, for every tool. One JSON line per event, in the same
# daily file as guard.sh. Never blocks the agent: a logging error goes to
# errors.log and the hook still exits 0.
input=$(cat)
dir="${AGENT_AUDIT_DIR:-$HOME/.claude/agent-guard/audit}"
mkdir -p "$dir"
log="$dir/$(date +%Y-%m-%d).jsonl"
line=$(printf '%s' "$input" | jq -c --arg t "$(date -u +%FT%TZ)" '
  def cut: if type == "string" and length > 400 then .[0:400] + "…" else . end;
  def short: walk(cut);
  {
    at: $t,
    event: .hook_event_name,
    session: (.session_id // "unknown"),
    cwd: (.cwd // ""),
    mode: (.permission_mode // null),
    tool: (.tool_name // null),
    command: (.tool_input.command // null),
    path: (.tool_input.file_path // .tool_input.path // .tool_input.url // null),
    input: (if .tool_name == "Bash" or .tool_name == "Write" or .tool_name == "Edit" then null else (.tool_input | short) end)
  }
  + (if .hook_event_name == "PostToolUse" and .tool_name == "Bash" then
       {stderr: ((.tool_response.stderr // "") | cut),
        interrupted: (.tool_response.interrupted // false),
        sandbox_block: (((.tool_response.stderr // "") + (.tool_response.stdout // "")) | test("Operation not permitted"))}
     else {} end)
  + (if .hook_event_name == "PostToolUseFailure" then {error: ((.error // .tool_response // "") | tostring | cut)} else {} end)
  + (if .hook_event_name == "PermissionDenied" then {reason: ((.reason // .message // .error // "") | tostring | cut)} else {} end)
  | with_entries(select(.value != null))
' 2>>"$dir/errors.log")
if [ -n "$line" ]; then
  printf '%s\n' "$line" >> "$log" 2>>"$dir/errors.log" || printf '%s write failed\n' "$(date -u +%FT%TZ)" >> "$dir/errors.log"
else
  printf '%s jq produced nothing for event input\n' "$(date -u +%FT%TZ)" >> "$dir/errors.log"
fi
exit 0
