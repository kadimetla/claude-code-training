#!/bin/bash
# Flash Pixoo64 green with "DONE" when Claude finishes a response,
# then revert to channel 0 (Faces / weather) after 3 seconds.
set -u
PIXOO_REST="${PIXOO_REST:-http://localhost:5001}"

curl -s -m 3 -X POST "$PIXOO_REST/fill" \
  -d "r=0&g=180&b=0&push_immediately=false" >/dev/null

curl -s -m 3 -X POST "$PIXOO_REST/text" \
  --data-urlencode "text=DONE" \
  -d "x=22&y=28&r=255&g=255&b=255&push_immediately=true" >/dev/null

# Detached revert — survives the hook's process group exit.
nohup bash -c "sleep 3 && curl -s -m 3 -X PUT '$PIXOO_REST/channel/0' >/dev/null" >/dev/null 2>&1 &
disown 2>/dev/null || true

exit 0
