---
title: "Subtext Integration – Linear"
source_url: "https://linear.app/integrations/subtext"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Subtext

# Triage issues with evidence from real user sessions

![Linear agent automation configured with Subtext session review tools for automatic issue triage](https://webassets.linear.app/images/ornj730p/production/9d8ebb5aaf8a37549b9c24a39d38a51e25578a71-1600x1000.png?q=95&auto=format&dpr=2)

![Linear agent automation configured with Subtext session review tools for automatic issue triage](https://webassets.linear.app/images/ornj730p/production/9d8ebb5aaf8a37549b9c24a39d38a51e25578a71-1600x1000.png?q=95&auto=format&dpr=2)

![Linear Loop run history showing Subtext session triage with root cause analysis and evidence](https://webassets.linear.app/images/ornj730p/production/29542c9f398b7fc7fe1eef2c4ef4357761143475-1600x1000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/subtext.html#overview)

Subtext is session replay built for agents. When an issue includes a Subtext session link, agents in Linear can efficiently review the real production session—including screenshots, component trees, console and network activity—and post a diagnosis with evidence before a coding agent or engineer picks the issue up.

## How it works[⁠](https://linear.app/integrations/subtext.html#how-it-works)

Subtext captures production web sessions through a lightweight snippet, reconstructed on demand so an agent can inspect any moment without a human scrubbing the session replay. Session links flow into Linear issues from the places bugs already originate — error trackers, support tools, analytics events, or a pasted URL in the issue description.

When an agent picks up an issue during triage, it checks the description and comments for a Subtext session URL. If one is present, a triage Loop opens the session with Subtext’s MCP tools: it steps through the moments around the problem, zooms into the relevant network requests and console errors at the resolution it needs, and compares what the user actually saw against what the UI intended. It then posts a structured triage comment grounded in the session: root cause, steps to reproduce, and visual evidence attached.

From there, Linear routes the work. A delegated coding agent or a Loop inherits the issue with full context: the screenshot of the failure, the component state behind it, and a verified reproduction path. The same MCP tools work with whatever agent harness your team runs, so the diagnosis travels with the issue rather than living in a separate tool.

## Configure[⁠](https://linear.app/integrations/subtext.html#configure)

To get started, your workspace must be on a Linear Business or Enterprise plan, since Loops are available on those plans and draw from your workspace’s AI credits. The team you’re configuring must have Triage enabled. Additionally, a workspace admin will need to allow the Subtext MCP server before it can be used. Then. you can follow the [Install and configuration guide](https://subtext.fullstory.com/docs/recipes/linear)

Website
[subtext.fullstory.com](https://subtext.fullstory.com)

Category
[Bug Reporting](https://linear.app/integrations/bug-reporting.html)

Contact

[Contact Subtext](mailto:subtext@fullstory.com)

[Open website](https://subtext.fullstory.com/docs/recipes/linear)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Sentry icon](https://webassets.linear.app/images/ornj730p/production/064fe767b3259577c743a29fdd10c5d89b882986-640x640.png?w=256&q=95&auto=format&dpr=2)

  Sentry

  By Linear

  Create and link issues with Sentry and automate issue creation](sentry.html)
* [![Bird Eats Bug icon](https://webassets.linear.app/images/ornj730p/production/65cf0a9026350b5d3c8f1324d8ef3b742e44166c-640x640.png?w=256&q=95&auto=format&dpr=2)

  Bird Eats Bug

  By Bird Eats Bug

  Speed up your bug reporting workflow with Bird Eats Bug](bird-eats-bug.html)
* [![Jam icon](https://webassets.linear.app/images/ornj730p/production/404cd197c83e602d8cc911cb4300198c8cac03f3-361x361.png?w=256&q=95&auto=format&dpr=2)

  Jam

  By Jam.dev

  Create Linear issues with all the details developers need to resolve bugs faster](jam.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
