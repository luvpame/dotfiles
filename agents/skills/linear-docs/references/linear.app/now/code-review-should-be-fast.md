---
title: "Code review should be fast - Linear"
source_url: "https://linear.app/now/code-review-should-be-fast"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [Product launches](https://linear.app/now/product-launches.html)

# Code review should be fast

![Abstract illustration of code review UI](https://webassets.linear.app/images/ornj730p/production/4056dd91c1a0faec71044da4dffa11a3cd4a18fe-3904x1760.png?q=95&auto=format&dpr=2)

![Abstract illustration of code review UI](https://webassets.linear.app/images/ornj730p/production/1cba4e48e8de50cf994580b34d9cc481aa026b5e-2352x1280.png?q=95&auto=format&dpr=2)

[Tuomas Artman](https://linear.app/now/author/tuomas-artman.html)·May 28, 2026

*Today we’re launching Diffs, a new way to review pull requests inside Linear.*

## Why we built Diffs[⁠](https://linear.app/now/code-review-should-be-fast.html#why-we-built-diffs)

When we started Linear, [we set out to improve the experience of building software](https://medium.com/linear-app/announcing-linear-e64e79581d01), which had been full of friction for too long. We obsessed over making the core workflow feel fast, fluid, and enjoyable to use.

Code review has stayed painfully slow while everything else sped up. Growing PR volumes from coding agents are putting further strain on an already creaking process. So much so that the speed gained from using agents gets swallowed in review.

Diffs is designed to keep code review fast without sacrificing the rigour of the work.

We approached Diffs with a short list of beliefs about what review should be:

* **Fast.** Reviews should open near-instantly
* **Focused.** Reviews should show what matters and strip out the noise
* **In context.** Code should sit next to the issue, project, and customer signal behind the change

To begin with, we’ve focused where the friction was loudest.

### **Knowing what to review first**[⁠](https://linear.app/now/code-review-should-be-fast.html#knowing-what-to-review-first)

Review requests get buried in your email inbox and the queue offers no guidance on what is urgent, because every PR in the list looks roughly the same. The requester shouldn’t have to spam your Slack DMs to get your attention.

Reviews sit inside Linear next to the rest of your work, where priority is visible because everything else competing for your attention is right there too. Each Diff is attached to the issue and project that produced it, so you can see when one is blocking something critical and weigh it against what else is on your plate.

![UI showing the Reviews tab in Linear](https://webassets.linear.app/images/ornj730p/production/cf0ac9c07ba8d337976b5d53868148d30ffe6e51-3904x2462.png?q=95&auto=format&dpr=2)

![UI showing the Reviews tab in Linear](https://webassets.linear.app/images/ornj730p/production/2460bc996f9d7f9c1716896d2d70698ead311113-2352x1480.png?q=95&auto=format&dpr=2)

### Getting through a huge diff[⁠](https://linear.app/now/code-review-should-be-fast.html#getting-through-a-huge-diff)

Large pull requests are usually reviewed in whatever order the filesystem produced the files, with formatting churn and refactoring noise mixed into the substantive edits. Reviewer attention runs out before the diff does, and the rest gets either skimmed or rubber-stamped. Stacked diffs emerged as a workaround, but it’s a lot of overhead to compensate for tools that can’t handle a large diff.

Guided reviews in Linear break the diff into chapters that follow the order the work was reasoned through. It shows you the core of the change first, then walks you through the consequences, with auxiliary changes and glue code kept separate. A 2,000-line PR becomes legible in a single sitting.

![UI showing Guided Reviews in Linear](https://webassets.linear.app/images/ornj730p/production/f70c5f8d3beb948940f83f59e81701fc62a294d9-3904x2400.png?q=95&auto=format&dpr=2)

![UI showing Guided Reviews in Linear](https://webassets.linear.app/images/ornj730p/production/21c5a05ee9eb4f07ebb70dd3e381e9c3c1e992be-2352x1444.png?q=95&auto=format&dpr=2)

Structural diff highlighting strips the formatting changes that have nothing to do with what the program does, so what is left on the page is the actual change rather than the noise around it.

![UI showing structural diff highlighting in Linear](https://webassets.linear.app/images/ornj730p/production/48d21d4a3cc69bf02ee04fcbe666b184bf323dfa-3904x1560.png?q=95&auto=format&dpr=2)

![UI showing structural diff highlighting in Linear](https://webassets.linear.app/images/ornj730p/production/6ecca38e4c2ccfd68b681d1a15232c3a81742dca-2352x1444.png?q=95&auto=format&dpr=2)

### **Piecing together why it matters**[⁠](https://linear.app/now/code-review-should-be-fast.html#piecing-together-why-it-matters)

A reviewer’s main job is to figure out why the change should exist at all, rather than just checking if the code is correct. This is a slower process when context is spread across multiple tools and tabs.

Because reviews live inside Linear, the issue, project, and customer signal that inspired the change are right there alongside them. There’s no chase across tools, because Linear has already assembled the picture and structured it for you.

![Linear UI showing a diff in product context](https://webassets.linear.app/images/ornj730p/production/a8da8322a7f70e0db8e3ff44fdf8d17658b1761f-3904x2100.png?q=95&auto=format&dpr=2)

## **The new shape of review**[⁠](https://linear.app/now/code-review-should-be-fast.html#the-new-shape-of-review)

Agents have absorbed most of the line-by-line correctness work that used to take up a lot of time. What’s increasingly left is the layer above the code itself, which is whether the change fits the architectural system the team has and solves the problem the customer actually reported. Diffs removes the friction around reviews, giving the reviewer the time and attention to do that judgement work.

[Linear Diffs](https://linear.app/docs/pull-request-reviews.html) is the latest step in a workspace Linear has been building for years, where every stage of shipping a product happens in the same place. There’s more of the workflow to come.

Available on all Linear plans starting today, [see the Changelog](https://linear.app/changelog/2026-05-27-linear-diffs.html) for setup steps.

[Tuomas Artman](https://linear.app/now/author/tuomas-artman.html)·May 28, 2026

Copy link
