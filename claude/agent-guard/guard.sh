#!/bin/bash
# PreToolUse guard for the coding agent's sessions (Bash tool).
# Logs every command for the daily security eval, and blocks a short list of
# actions that leak data or skip safety checks. Exit 0 with a deny decision = blocked.
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
sid=$(printf '%s' "$input" | jq -r '.session_id // "unknown"')
cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')
log="$HOME/.claude/agent-guard/audit/$(date +%Y-%m-%d).jsonl"
mkdir -p "$(dirname "$log")"
deny() {
  jq -cn --arg t "$(date -u +%FT%TZ)" --arg s "$sid" --arg d "$cwd" --arg c "$cmd" --arg r "$1" \
    '{at:$t,session:$s,cwd:$d,command:$c,decision:"deny",reason:$r}' >> "$log"
  jq -cn --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:("Blocked by the agent guard: " + $r + " If this is needed, stop and ask the lead session.")}}'
  exit 0
}
[ -z "$cmd" ] && exit 0
c=$(printf '%s' "$cmd" | tr '\n' ' ')
case "$c" in
  *--no-verify*|*core.hooksPath*|*"overcommit --uninstall"*) deny "skipping git hooks is not allowed." ;;
  *"gh gist"*|*pastebin*|*transfer.sh*|*paste.ee*|*hastebin*|*webhook.site*|*requestbin*|*ngrok*) deny "pastebins, gists and request catchers are a data-leak channel." ;;
  *".ssh/"*|*".config/gh"*|*".aws/"*|*".netrc"*|*"master.key"*|*"production.key"*|*"staging.key"*|*"development.key"*) deny "reading credential files is not allowed." ;;
esac
if printf '%s' "$c" | grep -Eq '(^|[;&|[:space:]])(printenv|env)([[:space:]]*($|[;&|]))'; then deny "dumping environment variables is not allowed."; fi
if printf '%s' "$c" | grep -Eq 'git[[:space:]]+push.*(--force|[[:space:]]-f([[:space:]]|$)|\+[A-Za-z])'; then deny "force pushes are not allowed."; fi
if printf '%s' "$c" | grep -Eq 'git[[:space:]]+push.*[[:space:]:](develop|production|staging|main)([[:space:]]|$)'; then deny "pushing to shared branches is not allowed."; fi
# Every other push needs the owner's click in the permission prompt.
if printf '%s' "$c" | grep -Eq '(^|[;&|[:space:](])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$)'; then
  jq -cn --arg t "$(date -u +%FT%TZ)" --arg s "$sid" --arg d "$cwd" --arg c "$cmd" \
    '{at:$t,session:$s,cwd:$d,command:$c,decision:"ask"}' >> "$log"
  jq -cn '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:"Agent guard: every git push needs the owner to approve it here."}}'
  exit 0
fi
jq -cn --arg t "$(date -u +%FT%TZ)" --arg s "$sid" --arg d "$cwd" --arg c "$cmd" \
  '{at:$t,session:$s,cwd:$d,command:$c,decision:"allow"}' >> "$log"
exit 0
