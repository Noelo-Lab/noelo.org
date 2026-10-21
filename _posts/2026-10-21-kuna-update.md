---
layout: post
title: "Where Has Autonomous Decompiler Development Taken Us?"
date: 2026-10-21
author: mahaloz
description: >-
    How we've improved Kuna through agent-driven development, what has worked, and which hard problems remain.
---

It's been [three months](https://noelo.org/blog/kuna-release/) since [Kuna](https://github.com/noelo-lab/kuna) went open-source, with the goal of building a fast, agent-first decompiler.
Since then, Kuna has topped the [DecBench scoreboard](https://decbench.com/leaderboard/?snapshot=09-10-2026), attracted roughly 2,000 monthly [web GUI](https://kuna.noelo.org/decompile) users, averaged roughly 2.5k [CLI downloads](https://github.com/Noelo-Lab/kuna/releases) a _month_, and been adopted by public and private organizations.
You can also now find Kuna as a _core_ decompiler in [REA](https://github.com/morluto/rea), the most popular reversing platform on the planet by GitHub stars.

I think much of that adoption comes from the success of Kuna's engineering pipelines.
Recently, I've been studying _where_ Kuna is improving, _how_, and _why_.
If you're at [Unprompted Con](https://unpromptedcon.org/), I'll cover some of this in my talk about Kuna.
The central idea, so far, has been that LLMs have independently solved dozens of small decompiler problems (see below, some novel), but have avoided the fundamental ones.

## Development Pipelines

Kuna's original development plan was to [hill-climb](https://en.wikipedia.org/wiki/Hill_climbing) the DecBench dataset across [three fundamental metrics](https://decbench.com/about/?snapshot=09-10-2026).
The dataset is large enough that reaching a consistently high score has taken time.
However, doing well on a benchmark does not guarantee that a decompiler works well on _real applications_.
As people adopted Kuna and opened issues, three development pipelines emerged to address different problems:

1. User- and agent-reported limitations
2. DecBench hill-climbing
3. RE-Needs hill-climbing

I've listed these in descending order of how valuable I think they've been recently.

### User- and Agent-Reported Limitations

The first pipeline is fairly straightforward: someone's agent opens an issue (sometimes with a PR), and my agent reviews and refines the proposed fix before it gets merged.
I also give all external PRs a quick manual review on weekends, because _trust_, man.
These reports often identify issues specific to an architecture or use case.
Take, for instance, [this issue](https://github.com/Noelo-Lab/kuna/issues/510), where Kuna took 30 minutes, with multiple errors, to decompile a 19 MB Windows binary.
This triggered agents to investigate several problems and led to [parallel decompilation support](https://github.com/Noelo-Lab/kuna/pull/532), something most decompilers lack.

This pipeline largely targets _stability_.

The focus of development has also shifted over time.
The graph below shows the volume of code changes across different passes of the decompiler.
As the project matures, more work is concentrated on traditionally _hard_ problems, such as dataflow analysis.

![Heatmap of lines changed across decompiler phases from June to October, highlighting early reliability work and later work on dataflow, calls, and types.](/assets/images/decomp_treng.png)

### DecBench

The second pipeline, DecBench, has mostly focused on deeper quality issues.
Although benchmark gains can give a misleading picture of real-world performance, hill-climbing can still reveal the need for features such as better type recovery.
In one case, agents developed methods inspired by [prior work](https://www.usenix.org/conference/usenixsecurity25/presentation/bosamiya) to [better identify](https://github.com/Noelo-Lab/kuna/pull/1134) array boundaries.
Together with dozens of smaller type improvements, this led to a [twofold improvement](https://github.com/Noelo-Lab/kuna/pull/771) in type recovery accuracy in a week.

In Kuna's early stages, most of these changes came from agents studying prior work: other decompilers or papers.
Now, most come from agents studying Kuna's failures to recover the original source.
Of course, that does not tell us whether a model recalled a well-known concept, from memory, and simply attributed the idea to itself.
The table below shows feature attribution based on if the LLM referenced that decompiler during development.

**Where Kuna Features Originate**

| Kuna (self) | Ghidra | angr | Hex-Rays | Binja | Oxidizer (angr) |
| --- | --- | --- | --- | --- | --- |
|  217 | 44 | 38 | 24 | 2 | 1 |

### RE-Needs

Finally, the `RE-Needs` pipeline was designed to evaluate whether these changes mattered when using Kuna on real, unseen targets.
In this benchmark, Codex (using GPT-5.6-Sol) attempted to solve binaries from [Crackmes.one](https://github.com/crackmesone/crackmes-re-dataset), a set of _mostly_ human-written challenges.
Separate runs used Kuna, IDA Pro, or objdump, and we measured both their success rates and the time, tokens, and cost required.
At any point, an agent could report a limitation in the tool by opening an issue for another agent to pick up.

This approach was inspired by my [Shellphish](https://shellphish.net/) colleague Subwire, who was using the dataset to evaluate our CTF agent.
In an evaluation of 35 crackmes, the results looked like this:

**An Efficiency Evaluation on Crackmes.one**

| Tool | Solved (out of 35) | Wall-clock time | Tokens | Cost |
|---|---|---|---|---|
| **ida** (idalib MCP) | 30 | 8.1 h | 83.3 M | $53.40 |
| **kuna** | 31 | 6.5 h | **42.7 M** | **$31.60** |
| **none** | 29 | 7.2 h | 63.2 M | $43.18 |

The differences in token usage and dollar cost were statistically significant in per-binary comparisons.

These early results encouraged me to keep evaluating Kuna on different subsets of the dataset and optimize its usability for LLMs.
That motivated the decision to _abandon MCP_ and instead represent all Kuna output as `.c`, `.h`, or `.asm` files.
It also led to quirky features, such as agents implementing their own [unpacking algorithms](https://github.com/Noelo-Lab/kuna/pull/488).
I suspect agents will eventually try to recreate _every_ external tool they use for decompilation into Kuna, with both benefits and major drawbacks.

These are useful gains. But where are the promised _foundational_ changes that LLMs will bring to decompilers?

## What Now?

If we keep running these pipelines, I expect we'll eventually exhaust the improvements they readily uncover.
There is still a sizable gap between Kuna's current performance and a decisive lead on DecBench.
Kuna beats Hex-Rays in the [linked DecBench snapshot](https://decbench.com/leaderboard/?snapshot=09-10-2026), but only by two percentage points.
I can confidently say that no single change in Kuna has represented a foundational advance, _yet_.

Within these pipelines, LLMs have focused on improving benchmark scores through small but useful engineering changes.
They have consistently avoided tackling _fundamental_ problems, such as inlining.
Some of the hardest problems they have solved, such as parallel decompilation, were addressed because a human _asked_ them to solve them.
As in mathematics, asking the right question seems to matter a lot right now.

It appears, as it stands, that no fundamental research is being done by these LLMs _without_ telling them to do it.
In Kuna's next phase, we'll aim to push LLMs toward these fundamental problems by designing a dataset and metrics that require addressing them to improve their scores.
Therefore, allowing hill-climbing, what LLMs excel at, while ideally resulting in fundamental changes. 
I'm curious to see how it turns out.

## Acknowledgements

I'd like to acknowledge Bill McKeever, from AFRL, for funding the early work on Kuna and helping me align its goals with what real practitioners care about. I'd also like to acknowledge the numerous external contributors to Kuna, who have built a real community around the decompiler. I am always surprised and inspired by those willing to contribute to a shared, open-source mission. A special acknowledgement to those who have pushed multiple high-quality PRs: [mgostIH](https://github.com/mgostIH), [thotypous](https://github.com/thotypous), [phix33](https://github.com/phix33), and [TsingShui](https://github.com/TsingShui). Your work keeps the project interesting! 
