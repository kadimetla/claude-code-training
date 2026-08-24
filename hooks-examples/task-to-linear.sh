#!/usr/bin/env bash
#
# Hook: TaskCreated → mirror to Linear
#
# Configure in ~/.claude/settings.json:
#   "TaskCreated": [{ "type": "command", "command": "~/.claude/hooks/task-to-linear.sh" }]
#
# Hook input arrives on stdin as JSON. Output (stdout) is fed back to Claude.
# Exit code 0 = success; non-zero = block the originating event.
#
# Required env: LINEAR_API_KEY, LINEAR_TEAM_ID
#
# NOTE (2.1.233+): current default models don't call TaskCreate unless
# CLAUDE_CODE_ENABLE_TODO_TOOLS=1 is set — without it this hook never fires.

set -euo pipefail

if [[ -z "${LINEAR_API_KEY:-}" || -z "${LINEAR_TEAM_ID:-}" ]]; then
  echo "task-to-linear: LINEAR_API_KEY or LINEAR_TEAM_ID not set; skipping" >&2
  exit 0
fi

# Read the TaskCreated event payload from stdin.
payload=$(cat)
title=$(jq -r '.task.subject // .subject // "Claude task"' <<< "$payload")
body=$(jq -r '.task.description // .description // ""' <<< "$payload")

# Create a Linear issue. Adjust the GraphQL query to match your team's workflow.
response=$(curl -fsS -X POST https://api.linear.app/graphql \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$(jq -n \
    --arg title "$title" \
    --arg body "$body" \
    --arg team "$LINEAR_TEAM_ID" \
    '{query: "mutation($input: IssueCreateInput!) { issueCreate(input: $input) { issue { identifier url } } }",
      variables: {input: {title: $title, description: $body, teamId: $team}}}')") || {
    echo "task-to-linear: Linear API call failed; continuing" >&2
    exit 0
}

identifier=$(jq -r '.data.issueCreate.issue.identifier // empty' <<< "$response")
url=$(jq -r '.data.issueCreate.issue.url // empty' <<< "$response")

if [[ -n "$identifier" ]]; then
  echo "Linked to Linear issue $identifier ($url)"
fi
