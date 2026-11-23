# Agent worktree setup (per project)

Rules and guard hooks live here in `~/.claude/` (which points at this repo's `claude/` folder). Nothing else in the dotfiles repo is needed.

## 1. Worktree `CLAUDE.local.md` (git-ignore it, e.g. in `.git/info/exclude`)

```markdown
# Coding agent rules (shared; edit them in ~/.claude/agent-rules, not here)

@~/.claude/agent-rules/core.md
@~/.claude/agent-rules/style.md
@~/.claude/agent-rules/tickets/<ticket>.md
```

- The first load from outside the project shows an approval dialog. Until approved, the agent sees only the `@` lines.
- Check it loaded: `cd <worktree> && claude -p "Without tools: quote the first heading of your ticket file, or say NOT LOADED" < /dev/null`

## 2. Worktree `.claude/settings.local.json` (git-ignore it)

```json
{
  "permissions": {
    "deny": [
      "Read(~/.ssh/**)", "Read(~/.aws/**)", "Read(~/.config/gh/**)", "Read(~/.netrc)",
      "Read(**/.env)", "Read(**/.env.*)", "Read(**/config/master.key)", "Read(**/config/credentials/*.key)",
      "Bash(gh gist *)", "Bash(printenv*)",
      "Bash(git push --force*)", "Bash(git push -f*)", "Bash(git commit --no-verify*)",
      "Read(~/Documents/**)", "Read(~/Desktop/**)", "Read(~/Downloads/**)",
      "Read(~/.claude/projects/**)",
      "Edit(~/Documents/**)", "Edit(~/Desktop/**)", "Edit(~/Downloads/**)",
      "Edit(~/.claude/projects/**)",
      "Edit(~/.claude/agent-guard/**)", "Edit(~/.claude/settings.json)", "Edit(~/.claude/CLAUDE.md)", "Edit(/.claude/**)",
      "Edit(~/.claude/agent-rules/**)", "Edit(~/.claude/skills/**)"
    ],
    "ask": ["Bash(git push*)", "Bash(git -C * push*)"]
  },
  "hooks": {
    "PreToolUse": [{"matcher": "Bash", "hooks": [{"type": "command", "command": "~/.claude/agent-guard/guard.sh", "timeout": 10, "onFailure": "block"}]}],
    "PostToolUse": [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/agent-guard/outcome.sh", "timeout": 10}]}],
    "PostToolUseFailure": [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/agent-guard/outcome.sh", "timeout": 10}]}],
    "PermissionRequest": [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/agent-guard/outcome.sh", "timeout": 10}]}],
    "PermissionDenied": [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/agent-guard/outcome.sh", "timeout": 10}]}]
  },
  "env": {"DISABLE_SPRING": "1"},
  "sandbox": {
    "enabled": true,
    "allowUnsandboxedCommands": false,
    "filesystem": {
      "denyRead": ["~/Documents", "~/Desktop", "~/Downloads", "~/.claude/projects"],
      "denyWrite": ["~/.claude/agent-guard", "~/.claude/settings.json", "~/.claude/agent-rules", "~/.claude/skills"],
      "allowWrite": ["<extra cache dirs the linter needs>"]
    },
    "network": {
      "allowUnixSockets": ["<db socket, e.g. /var/run/postgresql/.s.PGSQL.5432>"],
      "allowedDomains": ["github.com"]
    }
  }
}
```

Replace the `<...>` placeholders. Add `DISABLE_SPRING` only for Rails projects.

## 3. Sandbox and hook checks

- Never turn the sandbox off to get past a block. Add the narrowest allowance (one folder, one socket, one env var).
- The agent can't commit or push. That's intended: it stages, and the lead session commits.
- Probe one command at a time. A combined command that touches one denied path is refused by the permission rules before the sandbox is reached.
- Prove the sandbox: `touch ~/sandbox-probe.txt` from the agent should give `Operation not permitted`, with no prompt.
- Prove the hooks: in an agent worktree run `claude -p "Run this exact Bash command once: echo hook-check" --allowedTools "Bash(echo hook-check)" < /dev/null`, then check today's audit file in `~/.claude/agent-guard/audit/` has both a `decision:"allow"` line and a `PostToolUse` line for `echo hook-check`.
- Hooks need `jq` on PATH. Install it with `sudo apt install jq`.
