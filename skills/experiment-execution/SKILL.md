---
name: experiment-execution
description: Use when carrying out a written deep learning experiment plan, implementing experiment scaffolding, or running batches of research experiments
---

# Experiment Execution

Run a research plan with tight control over changes, artifacts, and claims.

## Workflow

1. Read the plan once and extract the task list.
2. Before making experiment-specific changes, use `experiment-worktree` to create an
   isolated workspace. The worktree skill records start-state metadata (base commit,
   branch, clean-tree status) and sets up the DL environment automatically.
   If the user declines worktree isolation, record the start state manually:
   - start commit
   - branch name
   - whether the working tree is clean
   - expected files/configs to touch
3. Implement the smallest required code or config change.
4. Run cheap verification before expensive runs:
   - import/build checks
   - unit or shape checks
   - one batch forward/backward
   - short sanity training
5. Launch the smallest experiment that can falsify the hypothesis.
6. Record for every run:
   - command
   - config path or diff
   - seed
   - commit
   - dataset version or split
   - output directory
7. Escalate ambiguous or completed outcomes to `result-analysis`.
8. After the experiment outcome is understood, use `experiment-closeout` to decide
   whether code stays or is reverted. If a worktree is active, `experiment-closeout`
   will invoke `finishing-experiment-branch` to handle the git mechanics.
9. Before claiming success, use `reproducibility-check`.

## Execution Rules

- Never mix unrelated improvements into an experiment branch.
- If a sanity run fails, do not launch the full job.
- If the first run is noisy or suspicious, rerun before interpreting.
- If compute is limited, prioritize experiments that remove uncertainty fastest.
- Do not start an experiment without enough start-state metadata to undo it safely later.
- Prefer worktree isolation over in-place changes. Working directly on the main branch
  is acceptable only when the user explicitly opts out.
