---
name: finishing-experiment-branch
description: Use when an experiment is complete and the user has decided whether to keep or discard the code changes - handles branch merge, PR creation, pause, discard, and worktree cleanup
---

# Finishing an Experiment Branch

Execute the keep/discard/pause decision for an experiment branch and clean up the worktree.

**Announce at start:** "I'm using the finishing-experiment-branch skill to handle the experiment branch."

## Prerequisite

`experiment-closeout` must have already:

1. Gathered the experiment outcome.
2. Written the experiment note to `docs/experiments/results/YYYY-MM-DD-<topic>.md`.
3. Obtained the user's explicit keep/discard/pause decision.

This skill handles git mechanics. It does NOT duplicate the documentation or decision-asking from `experiment-closeout`.

## Step 1: Verify Experiment Note Exists

Check that `docs/experiments/results/YYYY-MM-DD-<topic>.md` exists. If not, refuse to proceed and redirect to `experiment-closeout`.

## Step 2: Determine Context

- Read start-state metadata from `.worktrees/<topic>/.experiment-metadata.json` if available.
- Check if currently in a worktree:
  ```bash
  [ "$(git rev-parse --git-common-dir)" != "$(git rev-parse --git-dir)" ]
  ```
- If not in a worktree, fall back to branch-only cleanup (for cases where `experiment-worktree` was not used).

## Step 3: Present Options

If the decision was already made by `experiment-closeout`, execute it directly. If invoked standalone, present exactly these options:

```
Experiment complete. What would you like to do?

1. Merge experiment branch into <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (pause, handle later)
4. Discard this work
```

## Step 4: Execute Choice

### Option 1: Merge Locally

1. Run tests in the worktree (`pytest` or project-specific command).
2. If tests fail, stop and report.
3. Switch to base branch in the main working tree.
4. Merge the experiment branch:
   ```bash
   git merge exp/<YYYY-MM-DD>-<topic>
   ```
5. Run tests on the merged result.
6. If tests pass:
   ```bash
   git worktree remove .worktrees/<topic>
   git branch -d exp/<YYYY-MM-DD>-<topic>
   ```
7. Update experiment note with: "Code merged into `<base-branch>` at commit `<hash>`."

### Option 2: Push and Create PR

1. Run tests in the worktree.
2. If tests fail, stop and report.
3. Push the experiment branch:
   ```bash
   git push -u origin exp/<YYYY-MM-DD>-<topic>
   ```
4. Create a PR linking to the experiment note:
   ```bash
   gh pr create --title "exp: <topic>" --body "$(cat <<'EOF'
   ## Experiment
   See docs/experiments/results/YYYY-MM-DD-<topic>.md

   ## Summary
   <hypothesis and outcome from experiment note>

   ## Test Plan
   - [ ] Verify metrics match experiment note
   - [ ] Reproducibility check passed
   EOF
   )"
   ```
5. Keep worktree alive (reviewer may request changes).
6. Report PR URL.

### Option 3: Pause

1. Report:
   ```
   Branch exp/<YYYY-MM-DD>-<topic> preserved.
   Worktree at .worktrees/<topic>.
   Resume with finishing-experiment-branch when ready.
   ```
2. No cleanup.

### Option 4: Discard

1. Require typed confirmation:
   ```
   This will permanently delete:
   - Branch: exp/<YYYY-MM-DD>-<topic>
   - All commits since <base-commit>
   - Worktree at .worktrees/<topic>

   Type 'discard' to confirm.
   ```
2. Wait for exact confirmation.
3. If confirmed:
   ```bash
   # Return to main working tree
   cd <original-repo-root>
   git worktree remove .worktrees/<topic> --force
   git branch -D exp/<YYYY-MM-DD>-<topic>
   ```
4. Update experiment note with: "Code discarded. Branch deleted."
5. Verify clean state: `git status`, confirm on base branch.

### No Worktree Fallback

If no worktree is active (experiment ran directly on a branch without `experiment-worktree`):

- **Keep**: leave code in place, no worktree cleanup needed.
- **Discard**: revert to the recorded start commit or restore touched files.
- **Pause**: no action needed.
- All other steps (note verification, confirmation, reporting) still apply.

## Step 5: Final Report

Report three things:

1. Whether code was kept, pushed, paused, or discarded.
2. Where the experiment note lives.
3. Current workspace state (branch, commit, clean/dirty).

## Guardrails

- Never delete a branch before the experiment note is written.
- Never merge without running tests on the merged result.
- Never force-delete a branch without typed "discard" confirmation.
- Never clean up a worktree for the Pause option.
- Never proceed if the experiment note does not exist.
- Before removing a worktree, check `.experiment-metadata.json` for `symlinked_data`. Verify that listed paths are symlinks (`[ -L <path> ]`), not real directories. `git worktree remove` deletes symlinks safely (targets are untouched), but never `rm -rf` a worktree directory manually — use `git worktree remove` to avoid accidentally following symlinks into real data.

## Integration

**Called by:** `experiment-closeout` (steps 5 and 6)

**Pairs with:** `experiment-worktree` (cleans up what that skill created)
