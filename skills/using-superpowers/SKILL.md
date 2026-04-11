---
name: using-superpowers
description: Use when starting any conversation - establishes skill-first discipline for deep learning research tasks such as experiment design, execution, debugging, result analysis, and reproducibility checks
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute one narrow task, skip this skill.
</SUBAGENT-STOP>

## Rule

If there is even a small chance a research skill applies, load it before responding or acting.

User instructions still win. Skills define how to work, not what the human wants.

## Platform Adaptation

Skills use Claude Code tool names. On other platforms, read:

- `references/codex-tools.md`
- `references/gemini-tools.md`

## Research Skill Order

Use process skills before doing work:

1. `paper-to-implementation` for a paper idea or reproduction request
2. `experiment-design` before proposing changes to model, loss, data, augmentation, training, or evaluation
3. `experiment-planning` once the hypothesis and design are approved
4. `experiment-worktree` to create an isolated workspace before making experiment changes
5. `experiment-execution` when carrying out the plan (calls `experiment-worktree` automatically)
6. `training-debugging` for NaNs, divergence, OOMs, metric mismatches, or other failures
7. `result-analysis` when runs finish and you need to compare evidence
8. `experiment-closeout` when a run has ended and you must decide whether to keep or revert the code changes (calls `finishing-experiment-branch` for git cleanup)
9. `finishing-experiment-branch` to merge, push, pause, or discard an experiment branch
10. `reproducibility-check` before claiming an improvement or handing results to others

## Red Flags

Stop and load the relevant skill if you catch yourself thinking:

- "I can just change the model and try it."
- "The metrics look better enough."
- "I'll explain the result without checking seeds/configs."
- "This failure is probably just learning rate."
- "I already know how to reproduce a paper."

## What Good Looks Like

- Hypothesis before code
- Baseline and success metric before conclusions
- Smallest falsifiable experiment first
- Explicit keep-or-revert decision after each experiment
- Evidence attached to every claim
- Negative results recorded, not hidden
