#!/usr/bin/env bash
#
# Hook: PostToolUseFailure → capture failure context for triage
#
# Configure in ~/.claude/settings.json:
#   "PostToolUseFailure": [{
#     "type": "command",
#     "command": "~/.claude/hooks/post-failure-reporter.sh",
#     "if": "Bash(**) | Edit(**) | Write(**)"
#   }]
#
# Writes a triage record under .claude/failures/ with the tool name, inputs,
# and error message. Output is surfaced back to Claude as a user message —
# use this to nudge it toward a recovery strategy.

set -euo pipefail

payload=$(cat)
tool=$(jq -r '.tool // "unknown"' <<< "$payload")
input=$(jq -c '.input // {}' <<< "$payload")
error=$(jq -r '.error // "no error message"' <<< "$payload")

# Where to record the failure.
failures_dir="${PWD}/.claude/failures"
mkdir -p "$failures_dir"
timestamp=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
record="$failures_dir/${timestamp}-${tool}.json"

jq -n \
  --arg tool "$tool" \
  --arg ts "$timestamp" \
  --arg error "$error" \
  --argjson input "$input" \
  '{tool: $tool, timestamp: $ts, error: $error, input: $input}' \
  > "$record"

# Output to stdout becomes a user message Claude sees on the next turn.
cat <<EOF
Failure recorded at $record.
Last tool: $tool
Error: $error

Consider: read the failure record, identify the root cause, and propose a recovery plan
before retrying the same call.
EOF
