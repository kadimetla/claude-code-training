# Hook Examples

This directory contains advanced hook patterns for Claude Code workflow automation.

## What Are Hooks?

**Hooks** are programmable callbacks that execute in response to Claude Code events. The vocabulary expanded substantially in 2026.

### Event types (current as of May 2026)

- **SessionStart / SessionEnd** — wraps the whole session
- **PreToolUse / PostToolUse** — wraps individual tool calls (PreToolUse can modify tool inputs or block)
- **PostToolUseFailure** — fires when a tool call errored; useful for surfacing diagnostics or auto-recovering
- **UserPromptSubmit** — pre-process the user's prompt before Claude sees it
- **TaskCreated** — fires when Claude creates a task via TaskCreate; useful for syncing to external trackers
- **SubagentStart** — fires when a subagent launches (`Explore`, `Plan`, custom agents); useful for resource budgeting and audit

### Hook types (beyond plain shell commands)

A hook is no longer just a shell command. The supported types are:

- `command` — run a shell command (the original form)
- `http` — POST a JSON payload to a URL endpoint
- `prompt` — ask Claude itself for a yes/no decision against a prompt template
- `mcp_tool` — invoke a specific tool on a configured MCP server
- `agent` — spawn a subagent to verify a condition and report back

`prompt` and `agent` are useful when the decision is too nuanced for a regex or a shell exit code.

## Hook Configuration

Hooks are configured in `~/.claude/settings.json` or `.claude/settings.json`. The current array form supports `if` matchers (permission-rule syntax) and `type` selection:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": "~/.claude/hooks/security-validator.sh",
        "if": "Write(**) | Edit(**)"
      }
    ],
    "PostToolUseFailure": [
      {
        "type": "http",
        "url": "https://hooks.example.com/claude-failures",
        "if": "Bash(**)"
      }
    ],
    "TaskCreated": [
      {
        "type": "command",
        "command": "~/.claude/hooks/task-to-linear.sh"
      }
    ],
    "SubagentStart": [
      {
        "type": "agent",
        "agent": "team-budget-watcher"
      }
    ],
    "SessionEnd": [
      {
        "type": "command",
        "command": "~/.claude/hooks/session-end-summary.sh"
      }
    ]
  }
}
```

## Examples in This Directory

1. **session-end-summary.sh** — Generate session summary and statistics (`SessionEnd`, `command`)
2. **pre-edit-formatter.sh** — Auto-format files before editing (`PreToolUse`, `command`, `if: Edit(**)`)
3. **security-validator.sh** — Validate security before file writes (`PreToolUse`, `command`, `if: Write(**)`)
4. **git-auto-backup.sh** — Create git stash before major operations (`PreToolUse`, `command`)
5. **test-runner-hook.sh** — Run tests before certain operations (`PreToolUse`, `command`)
6. **dependency-checker.sh** — Check for dependency updates (`SessionStart`, `command`)
7. **task-to-linear.sh** *(new)* — Mirror Claude's TaskCreate to a Linear issue (`TaskCreated`, `command`/`http`)
8. **post-failure-reporter.sh** *(new)* — Capture a failed tool call's context for triage (`PostToolUseFailure`, `command`)
9. **subagent-budget-check.sh** *(new)* — Block a subagent from launching if the team token budget is exhausted (`SubagentStart`, `command`)
10. **pixoo/** *(new)* — Drive a Divoom Pixoo64 ambient display from Claude Code lifecycle events: yellow "INPUT?" on permission prompts, green "DONE" flash when Claude finishes a response (`Notification`/`Stop`, `command`). Requires a Pixoo64 on your LAN and the [`pixoo-rest`](https://github.com/4ch1m/pixoo-rest) Docker server. Full setup walkthrough in `pixoo/README.md`.

## Hook Best Practices

1. **Exit codes matter**: Return 0 to allow operation, non-zero to block
2. **Feedback is user input**: Hook output appears as if from the user
3. **Be fast**: Hooks run synchronously; slow hooks delay operations
4. **Error handling**: Provide clear error messages when blocking
5. **Idempotent**: Hooks should be safe to run multiple times

## Using These Examples

Copy hook scripts to your `.claude/hooks/` directory and configure in settings:

```bash
# Copy example hooks
cp session-end-summary.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/session-end-summary.sh

# Configure in ~/.claude/settings.json
{
  "hooks": {
    "sessionEnd": "~/.claude/hooks/session-end-summary.sh"
  }
}
```

## Lab Exercises

Students will:
1. Configure a SessionEnd hook to generate summaries
2. Create a PreToolUse hook for security validation
3. Build a custom hook for their workflow
4. Understand hook feedback and blocking

## Resources

- [Claude Code Hooks Documentation](https://docs.claude.com/en/docs/claude-code/overview)
- Hook examples from changelog (v1.0.85+, v2.0.10+)
