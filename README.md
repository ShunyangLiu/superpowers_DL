# Superpowers DL

`superpowers_DL` is a deep learning research fork of the original Superpowers project.

This repository no longer targets generic software engineering workflows. It is organized around how deep learning research actually happens: form a hypothesis, design the smallest falsifiable experiment, execute it cleanly, debug training failures, analyze results, and only then make claims.

## Repository Direction

- Software-engineering workflow skills have been removed.
- The remaining skills focus on experiment design, execution, debugging, interpretation, and reproducibility.
- Installation examples in this repository point to this fork, not the upstream `obra/superpowers` repository.

## What It Does

The repository provides a set of composable skills that agents can discover and invoke automatically:

- `experiment-design` for turning rough model ideas into falsifiable experiments
- `experiment-planning` for turning an approved experiment into concrete code, run, and artifact steps
- `experiment-execution` for carrying out the plan without losing provenance
- `training-debugging` for NaNs, divergence, OOMs, metric mismatches, and other training failures
- `result-analysis` for comparing baselines, ablations, and reruns
- `experiment-closeout` for deciding whether code changes should be kept or reverted after a run
- `reproducibility-check` for verifying claims before sharing numbers
- `paper-to-implementation` for translating papers into local experiments
- `using-superpowers` for enforcing skill-first behavior at session start

## Basic Workflow

1. Start with `paper-to-implementation` if the idea comes from a paper.
2. Use `experiment-design` to define the hypothesis, baseline, metric, and compute budget.
3. Use `experiment-planning` to map code changes, sanity checks, runs, and artifact capture.
4. Use `experiment-execution` to implement and run the smallest decisive experiment first.
5. Use `training-debugging` when the run misbehaves.
6. Use `result-analysis` to decide what the evidence supports.
7. Use `experiment-closeout` to ask whether to keep or revert the code changes and archive failed runs.
8. Use `reproducibility-check` before claiming improvement.

## Installation

This fork is distributed from GitHub. Use the install docs in this repository rather than the upstream marketplace entries.

### Codex

Tell Codex:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/ShunyangLiu/superpowers_DL/refs/heads/main/.codex/INSTALL.md
```

See [docs/README.codex.md](docs/README.codex.md).

### OpenCode

Tell OpenCode:

```text
Fetch and follow instructions from https://raw.githubusercontent.com/ShunyangLiu/superpowers_DL/refs/heads/main/.opencode/INSTALL.md
```

See [docs/README.opencode.md](docs/README.opencode.md).

### Gemini CLI

```bash
gemini extensions install https://github.com/ShunyangLiu/superpowers_DL
```

### Claude Code / Cursor

The repository still includes `.claude-plugin/` and `.cursor-plugin/` metadata for local packaging, but this fork is not documented here as an official marketplace release. Install it from this repository in your own environment if you need those platforms.

## Philosophy

- Hypothesis before implementation
- Smallest falsifiable experiment first
- Baselines must be fair
- Failed experiments should be archived before their code is discarded
- Evidence beats intuition
- Reproducibility beats storytelling

## Repository Layout

- `skills/` contains the research workflow skills
- `commands/` contains lightweight shortcuts to the main skills
- `hooks/` injects `using-superpowers` at session start on supported platforms
- `agents/` contains reusable reviewer agents
- `tests/` contains skill-triggering and platform smoke tests

## Contributing

Add or edit skills directly in `skills/`. Keep `SKILL.md` concise, move heavy detail into `references/`, and update tests when you add a new trigger path.

## License

MIT License
