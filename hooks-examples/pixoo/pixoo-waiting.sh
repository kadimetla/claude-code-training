#!/bin/bash
# Light Pixoo64 yellow with "INPUT?" when Claude Code waits for the user
# (permission_prompt notifications).
set -u
PIXOO_REST="${PIXOO_REST:-http://localhost:5001}"

# Fill yellow, but don't push yet so the text lands in the same frame.
curl -s -m 3 -X POST "$PIXOO_REST/fill" \
  -d "r=255&g=200&b=0&push_immediately=false" >/dev/null

# Static black "INPUT?" at a roughly-centered location on the 64x64.
curl -s -m 3 -X POST "$PIXOO_REST/text" \
  --data-urlencode "text=INPUT?" \
  -d "x=18&y=28&r=0&g=0&b=0&push_immediately=true" >/dev/null

exit 0
