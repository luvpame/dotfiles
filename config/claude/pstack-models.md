# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# `inherit-parent` or `auto` as a value: the role runs on the parent chat model (omit Task `model`). Alias entries in a panel list still count toward its fan-out.
# budget: medium (high)
feature, refactoring: opus high
bug-fix: fable high
perf-issue: fable high
hillclimb: fable high
judgment and prose: opus high
hardest tasks: fable high
how explorer: opus high
how explainer: opus high
why investigators: opus high
why synthesizer: opus high
reflect tooling: opus high
reflect judgment, divergent, synthesizer: opus high
arena runners: opus high, fable high, sonnet high
arena cross-judge pool: opus high, fable high, sonnet high
swarm workers: opus high
architect runners: opus high, fable high, sonnet high
interrogate reviewers: opus high, fable high, sonnet high
