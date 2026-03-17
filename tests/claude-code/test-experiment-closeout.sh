#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: experiment-closeout skill ==="

output=$(run_claude "In the experiment-closeout skill, should the agent ask the user whether to keep or discard code changes after a failed experiment? What happens if the user chooses discard? Keep it brief." 60)
assert_contains "$output" "ask the user\|must ask\|询问用户\|保留\|丢弃\|discard" "Mentions user retention decision"
assert_contains "$output" "result note\|archive\|记录\|归档" "Mentions documenting the failed experiment"
assert_contains "$output" "revert\|restore\|start commit\|回退\|恢复\|回滚" "Mentions rollback to the recorded start state"

echo "=== experiment-closeout tests passed ==="
