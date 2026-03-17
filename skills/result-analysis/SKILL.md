---
name: result-analysis
description: Use when experiment runs finish, baselines and ablations disagree, or you need to decide what the results actually imply
---

# Result Analysis

Interpret results conservatively. The goal is not to defend the new idea; it is to decide what the evidence supports.

## Workflow

1. Gather the comparison set:
   - baseline
   - direct ablations
   - reruns with different seeds if available
2. Normalize the comparison:
   - same metric
   - same selection rule
   - same evaluation split
   - same training budget, or explicitly note differences
3. Explain the result in terms of effect size, variance, and confounders.
4. Decide one outcome:
   - keep and extend
   - rerun for confidence
   - debug before trusting
   - reject and move on
5. Write a result note to `docs/experiments/results/YYYY-MM-DD-<topic>.md`.
6. Hand off to `experiment-closeout` so the user can decide whether the code changes stay or are reverted.

Use `references/result-summary-template.md` when writing the note.

## Guardrails

- Do not compare cherry-picked best runs to average baselines.
- Do not ignore wall-clock, memory, or parameter-count regressions.
- Negative results are useful if the setup is documented well.
- Failed experiments should be archived with enough detail to block accidental repetition.
