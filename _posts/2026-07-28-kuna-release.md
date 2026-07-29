---
layout: post
title: "Kuna: Decompiler Development in the Age of Coding Agents"
date: 2026-07-28
author: mahaloz
description: >-
    Background, motivation, and thoughts around the release of Kuna, a new agent-first decompiler designed for autonomous refinement.
---

Today, I'm releasing [Kuna](https://kuna.noelo.org), an experimental decompiler I've been developing over the summer while working as a visiting faculty researcher at the [Air Force Research Lab (AFRL)](https://www.afrl.af.mil/) and a research fellow at [Metalware](https://www.metalware.com/).
However, when I say that _I have been developing_, I should clarify that an LLM has written nearly every line of code in this project.

Yet, as it stands now, this decompiler rivals the industry standard, IDA Pro (9.2), in [control flow structuring](https://decompilation.wiki/fundamentals/structuring/overview/) on C programs: in [recent benchmark results](https://decbench.com), Kuna achieves perfect structuring on 44.4% of functions, compared with IDA's 45.7%.
This was largely achieved through autonomous refinement: the LLM studies examples where it performs worse than IDA Pro on fundamental metrics, which have only [emerged over the last few years](https://decompilation.wiki/fundamentals/evaluation/).
Using this strategy, it can effectively _learn_ how another decompiler solves a hard problem through trial and error.

IDA Pro was also not the only decompiler studied in this improvement process.
This large refinement experiment also involved Ghidra and the angr decompiler; I spent [my entire PhD as a core developer of the latter](https://mahaloz.re/dec-history-pt2#sailr-compiler-aware-structuring).
This method of learning allowed an LLM to reimplement, in Kuna, more than [20 fundamental features](https://github.com/Noelo-Lab/kuna/tree/main/docs/features) from angr, which took us years to design through [scientific advancements](https://www.usenix.org/system/files/usenixsecurity24-basque.pdf) in decompilation.
I emphasize all of this to clarify that this project is more than just _slop_: it is a truly experimental approach to developing a scientifically interesting tool that gets better automatically.

#### A snippet from Kuna and Hex-Rays showing a popular angr switch feature

![A comparison of decompiled code from Kuna and Hex-Rays](/assets/images/kuna_vs_ida.png)

With all of that said, I also want to acknowledge limitations in this approach and how this work might affect the research community.

First, Kuna is only possible through the [decades-long efforts](https://mahaloz.re/dec-history-pt1) of scientists and engineers advancing decompiler research.
Kuna is, in fact, a Rust port of the [NSA's Ghidra](https://github.com/nationalsecurityagency/ghidra), reworked to more closely match angr's pipeline.
That is also why I don't plan on leaving the angr decompiler any time soon.
The angr decompiler is still the first place I go to for developing frontier algorithms in decompilation, simply because it was designed for that.

Kuna, on the other hand, is an _experiment_ in seeing what can be done with high-level scientific feedback alone.
At this point, it would be significantly harder to write anything by hand in Kuna.
Kuna needs angr (and other open-source research), and my hope is that, after more time, angr will need Kuna (if the experiment is a success).

Second, Kuna requires scientific insight to even begin "automatic" refinement, which likely explains why no other decompiler has done this yet (that I know of).
Getting to this point required discovering new [fundamental metrics](https://www.usenix.org/system/files/usenixsecurity24-basque.pdf), studying what aligns with [human reversing values](https://www.ndss-symposium.org/wp-content/uploads/2026-f380-paper.pdf), and gathering insights over years to understand what data a [meaningful benchmark requires](https://decbench.com/about/#the-dataset).
The gist: this is also not _automatic research_; it requires research led by humans.

Third, and finally, there is still significantly more progress to be made in this decompiler.
We are doing well on structuring, but decompilation is more than just structuring!
We need to improve types, optimizations, recompilability, variable identification... you get the idea.
This is, after all, an experiment to see if it is even possible to achieve all those things within the framework we're using to develop Kuna.
And I (we) could really use your help.

---

If you are interested in the internals of Kuna, the goals of the project, or how automatic improvement works, go check out the [code](https://github.com/noelo-Lab/kuna) or wait for a more technical follow-up post.
As always, I'd like to acknowledge those who have helped me refine my ideas and push forward the research.
My PhD advisors, [Fish](https://ruoyuwang.me/) and [Yan](https://yancomm.net/), are the biggest sources of inspiration for my research.
I am also grateful for the insights from Metalware, AFRL, and the Department of Defense, which help make my research impactful.

See you all at the next checkpoint of the experiment!
