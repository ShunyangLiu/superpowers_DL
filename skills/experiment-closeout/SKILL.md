---
name: experiment-closeout
description: Use when an experiment run has finished and you need to decide whether to keep the code changes, revert them safely, and archive the outcome to avoid repeating the same failed experiment
---

# Experiment Closeout

Every experiment ends with a code-retention decision. Do not let failed or inconclusive changes silently leak into the next run.

## Start-State Requirement

Before the first experiment-specific code change, record:

- start commit
- branch name
- whether the working tree was clean
- expected files or configs the experiment will touch

If the tree was already dirty, isolate the experiment on a branch or record the exact touched-file list. Do not use destructive rollback that could wipe unrelated work.

## Workflow

1. Gather the outcome:
   - result summary
   - artifacts
   - experiment start-state metadata
2. Ask the user explicitly:
   - keep the code changes
   - discard the code changes
   - pause the decision
3. Write or update the experiment note in `docs/experiments/results/YYYY-MM-DD-<topic>.md`.
4. For negative or inconclusive outcomes, make sure the note includes:
   - hypothesis
   - exact intervention
   - baseline used
   - metrics and artifacts
   - why the result is considered failed, flat, or unreliable
   - `do not repeat unless ...`
5. If the user chooses `keep`:
   - if a worktree is active, use `finishing-experiment-branch` with the "keep" or
     "keep + PR" option to merge the experiment branch
   - if no worktree, leave the code in place
   - record that retention decision in the note
   - use `reproducibility-check` before making a performance claim
6. If the user chooses `discard`:
   - write the note first
   - if a worktree is active, use `finishing-experiment-branch` with the "discard"
     option to delete the branch and clean up the worktree
   - if no worktree, revert experiment changes to the recorded start state:
     - if the experiment began from a clean tree, restore or reset to the start commit
     - if the experiment began from a dirty tree, restore only the experiment-touched files
   - verify the post-revert git state before moving on
7. If the user chooses `pause`:
   - write or update the note with status "paused"
   - if a worktree is active, use `finishing-experiment-branch` with the "pause"
     option to preserve the worktree
   - report that the experiment can be resumed later
8. Report three things:
   - whether code was kept or discarded
   - where the experiment note lives
   - what state the workspace is now in

## Guardrails

- Never delete failed-experiment evidence just because code is discarded.
- Never revert before the failed experiment is documented.
- Never assume failed changes should be kept or discarded; ask.
- Never use a destructive rollback if unrelated changes existed before the experiment started.
