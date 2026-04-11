---
name: experiment-worktree
description: Use when an experiment plan is about to be executed and code changes need git isolation - creates an isolated git worktree with DL environment verification so failed experiments can be cleanly discarded
---

# Experiment Worktree

Create an isolated git worktree before making experiment-specific code changes. This ensures failed or inconclusive experiments can be discarded without touching the main branch.

**Announce at start:** "I'm using the experiment-worktree skill to set up an isolated workspace."

## When To Use

- Called by `experiment-execution` step 2, before any code changes.
- Called directly when the user wants to isolate DL work on a separate branch.
- Skip if the user explicitly opts out of worktree isolation.

## Directory Setup

### 1. Check for `.worktrees/`

```bash
ls -d .worktrees 2>/dev/null
```

If found, use it. If not found, create it.

### 2. Verify Gitignored

```bash
git check-ignore -q .worktrees
```

If NOT ignored: add `.worktrees/` to `.gitignore`, commit the change, then proceed.

## Branch Naming

Default pattern: `exp/<YYYY-MM-DD>-<topic>`

- `<topic>` comes from the experiment plan filename or the hypothesis summary.
- Must match the experiment note naming convention used by `experiment-design` and `experiment-closeout` (i.e., `YYYY-MM-DD-<topic>`).
- Example: `exp/2026-04-11-rotary-embeddings`

If the user provides a branch name, use it as-is.

## Creation Steps

1. Determine the branch name from the experiment plan or ask the user.
2. Record pre-worktree state:
   - current branch (`git branch --show-current`)
   - current commit (`git rev-parse HEAD`)
   - working tree clean status (`git status --porcelain`)
3. Create the worktree:
   ```bash
   git worktree add .worktrees/<topic> -b exp/<YYYY-MM-DD>-<topic>
   ```
4. Change into the worktree directory.
5. Run DL environment setup (see below).
6. Run sanity verification (see below).
7. Write start-state metadata to `.worktrees/<topic>/.experiment-metadata.json`.
8. Report readiness.

## DL Environment Setup

Auto-detect and run the appropriate setup in priority order:

1. `pyproject.toml` with `[tool.poetry]` -> `poetry install`
2. `pyproject.toml` without poetry -> `pip install -e .`
3. `setup.py` or `setup.cfg` -> `pip install -e .`
4. `requirements.txt` -> `pip install -r requirements.txt`
5. `environment.yml` -> `conda env update`

After dependency setup:

- Check CUDA availability: `python -c "import torch; print(torch.cuda.is_available())"` (skip if torch is not installed).
- Verify data directory symlinks are accessible from the worktree. Common patterns: `data/`, `datasets/`, paths in `.env` or config files.
- If symlinks or data paths are broken, report and ask whether to proceed.

## Sanity Verification

- Run `pytest` or the project-specific test command if a test suite exists.
- If tests fail, report failures and ask whether to proceed.
- If no tests exist, report that baseline verification was skipped.

## Start-State Metadata

Write `.worktrees/<topic>/.experiment-metadata.json` so that a future session can detect and resume:

```json
{
  "worktree_path": ".worktrees/<topic>",
  "branch_name": "exp/<YYYY-MM-DD>-<topic>",
  "base_branch": "main",
  "base_commit": "<hash>",
  "tree_was_clean": true,
  "environment_tool": "pip",
  "created_at": "<ISO-8601>"
}
```

## Report

```
Worktree ready at .worktrees/<topic>
Branch: exp/<YYYY-MM-DD>-<topic>
Base commit: <hash>
Environment: <pip/poetry/conda>
CUDA: <available/not available/not checked>
Tests: <N passing / skipped>
```

## Guardrails

- Never create a worktree without verifying `.worktrees/` is gitignored.
- Never skip environment setup — a worktree with mismatched dependencies produces false failures.
- Never proceed with failing CUDA checks if the experiment requires GPU.
- Never mix unrelated code changes into the experiment branch.

## Integration

**Called by:** `experiment-execution` (step 2)

**Pairs with:** `finishing-experiment-branch` (cleanup after experiment)
