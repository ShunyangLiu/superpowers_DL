#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: training-debugging skill ==="

output=$(run_claude "In the training-debugging skill, what should happen before changing multiple training knobs?" 60)
assert_contains "$output" "training-debugging\|Training Debugging" "Skill is recognized"
assert_contains "$output" "reproduce\|smallest reproducible config\|复现\|最小可复现\|isolate\|隔离\|根本原因\|root cause" "Mentions evidence-first debugging"
assert_contains "$output" "one variable at a time\|one variable\|一次只改一个变量\|单变量\|改一个变量\|每次只改一个" "Mentions controlled changes"
assert_contains "$output" "root cause\|classify\|根因\|分类" "Mentions root-cause style debugging"

echo "=== training-debugging tests passed ==="
