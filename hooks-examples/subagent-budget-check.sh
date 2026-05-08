#!/usr/bin/env bash
#
# Hook: SubagentStart → enforce a token budget across an Agent Team
#
# Configure in ~/.claude/settings.json:
#   "SubagentStart": [{
#     "type": "command",
#     "command": "~/.claude/hooks/subagent-budget-check.sh"
#   }]
#
# The hook checks a running counter (a file with the cumulative spend so far)
# against a configurable ceiling. If launching a new subagent would push the
# team over its token budget, the hook exits non-zero — which BLOCKS the
# subagent launch.
#
# Required env (with sane defaults):
#   CLAUDE_TEAM_BUDGET_TOKENS — ceiling (default: 250000)
#   CLAUDE_TEAM_SPEND_FILE    — counter path (default: ~/.claude/team-spend)

set -euo pipefail

budget="${CLAUDE_TEAM_BUDGET_TOKENS:-250000}"
spend_file="${CLAUDE_TEAM_SPEND_FILE:-$HOME/.claude/team-spend}"

current=0
[[ -f "$spend_file" ]] && current=$(cat "$spend_file")

# Estimate this subagent's worst-case spend. Refine for your workload.
estimated_max=20000
projected=$((current + estimated_max))

if (( projected > budget )); then
  cat <<EOF >&2
subagent-budget-check: BLOCKED — projected spend $projected tokens would exceed
budget $budget. Current cumulative spend: $current. Increase CLAUDE_TEAM_BUDGET_TOKENS
or reset $spend_file to allow more work.
EOF
  exit 1
fi

# Allow launch. Reserve the estimate so concurrent launches don't double-spend.
echo "$projected" > "$spend_file"
echo "subagent-budget-check: OK — projected $projected of $budget tokens"
