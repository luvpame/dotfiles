---
title: "Triage Intelligence – Linear Docs"
source_url: "https://linear.app/docs/product-intelligence"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation

  + [![Linear Agent](https://webassets.linear.app/images/ornj730p/production/1da47a1cbf8563070d25e5794910b622f03a428d-16x16.svg?q=95&auto=format&dpr=2)Linear Agent](linear-agent.html)
  + [![Loops](https://webassets.linear.app/images/ornj730p/production/0ba9c78fdd4e19b308e1b9bdb530743e3090e397-16x16.svg?q=95&auto=format&dpr=2)Loops](loops.html)
  + [![AI Agents](https://webassets.linear.app/images/ornj730p/production/5914e5199f95b48d50cdd2eb6cb02e0a8d6e7a24-16x16.svg?q=95&auto=format&dpr=2)AI Agents](agents-in-linear.html)
  + [![Triage Intelligence](https://webassets.linear.app/images/ornj730p/production/2308492a72303e9c95f13dad1591c985c13c0c0a-16x16.svg?q=95&auto=format&dpr=2)Triage Intelligence](product-intelligence.html)
  + [![Code Intelligence](https://webassets.linear.app/images/ornj730p/production/6c9a57ffb812e20c93862d04b62ae5ee5893358e-16x16.svg?q=95&auto=format&dpr=2)Code Intelligence](code-intelligence.html)
  + [![MCP server](https://webassets.linear.app/images/ornj730p/production/6b6af6cd841b626b6949c15c3393d726b85d51db-16x16.svg?q=95&auto=format&dpr=2)MCP server](mcp.html)
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Triage Intelligence

Route issues by using LLMs to infer issue properties and relationships.

Available to workspaces on [Business](https://linear.app/pricing.html) and [Enterprise](https://linear.app/pricing.html) plans

![Hero image showing the product intelligence pane underneath issue title](https://webassets.linear.app/images/ornj730p/production/02067ce6f9065399e26861ebb5db223bdc0c897e-1494x584.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/product-intelligence.html#overview)

Triage Intelligence automates the time consuming assessment and routing steps required when triaging issues.

When enabled, issues in your workspace are analyzed by agentic models. Every future issue that enters triage is assessed against the rest of your data. This allows Triage Intelligence to proactively surface suggested issue properties and relationships. Accept, decline, or view more information about why a suggestion was made before making a decision. Issue properties suggested include teams, projects, assignees, and labels, and can be configured to auto-apply when suggested.

## Configure[⁠](https://linear.app/docs/product-intelligence.html#configure)

Enable Triage Intelligence by navigating to Settings > AI and toggling the feature on; this will enable the feature for every team. Taking this action requires admin permissions.

In teams where the functionality won’t be useful, turn it off in that team’s individual triage suggestions settings. Or, if the scope of suggestions should be limited to that team and its sub-teams (don’t suggest related issues in other teams, for example), set that behavior in the “Include suggestions from” menu.

### Issue property suggestions[⁠](https://linear.app/docs/product-intelligence.html#issue-property-suggestions)

![Assignee suggestion detail explaining why the suggestion was made](https://webassets.linear.app/images/ornj730p/production/048e6fa94fdd12e50f05a37a4772354b73c5295d-1596x1034.png?w=1440&q=95&auto=format&dpr=2)

As organizations scale, questions like “who should work on this” or “what labels are usually applied in these scenarios” become harder to answer. Triage Intelligence uses historical trends evaluated against the current issue’s content to proactively surface these suggestions. These suggestions appear alongside suggested duplicates and when issues are in Triage.

### Issue property suggestion behavior[⁠](https://linear.app/docs/product-intelligence.html#issue-property-suggestion-behavior)

![Image displays show, auto-apply, and hide options in team settings for product intelligence](https://webassets.linear.app/images/ornj730p/production/bfdcfad7f20163d175d5f107a0a2b821876c065c-1892x1386.png?w=1440&q=95&auto=format&dpr=2)

![Image displays show, auto-apply, and hide options in team settings for product intelligence](https://webassets.linear.app/images/ornj730p/production/cdc8fa8d09d673288551143cec82d1ef77ad7ccd-1846x1332.png?w=1440&q=95&auto=format&dpr=2)

In each team where Triage Intelligence is on, customize whether issue property suggestions appear, are hidden, or are auto-applied for different property types.

By default, a behavior applies to all values of that property type. Optionally, filter to specific values to narrow the rule’s scope. Any property **not** included in a filter will use the main property behavior.

Sub-team rules are inherited from the parent team by default, but can be overridden in sub-team settings.

### Duplicate and relationship detection[⁠](https://linear.app/docs/product-intelligence.html#duplicate-and-relationship-detection)

![suggested related issue](https://webassets.linear.app/images/ornj730p/production/ec52900779f7dd8bdaceb6eb19c5564333dce947-1618x1146.png?w=1440&q=95&auto=format&dpr=2)

When Triage Intelligence determines there is a strong semantic similarity between an issue in Triage and an existing issue, a suggestion appears to accept the relation. Hover over the suggestion to see why it’s appearing, and optionally accept it, dismiss it, or follow the reference to the secondary issue to analyze further.

### Refine suggestion behavior[⁠](https://linear.app/docs/product-intelligence.html#refine-suggestion-behavior)

In Triage Intelligence settings at any level (sub-team, parent team, or workspace) you can provide additional guidance to refine suggestion behavior. This is best used reactively (for example, if you’re seeing persistent suggestion themes that are incorrect) rather than as part of initial configuration for Triage Intelligence. When additional guidance is set at multiple levels like team and workspace, all are considered but the most local guidance is considered first and weighted most heavily.

### Triggering on issues outside Triage[⁠](https://linear.app/docs/product-intelligence.html#triggering-on-issues-outside-triage)

Triage Intelligence can still be run on issues in other statuses (if you’re looking at a backlog issue for instance, and would like to double-check for duplicates).

To do so, use the `Cmd` / `Ctrl` + `K` menu to search for *Find Suggestions.* This will run in the background and enrich the issue with suggestions when available.

### FAQ[⁠](https://linear.app/docs/product-intelligence.html#faq)

AI Privacy

Linear does not utilize your data to train its own AI models. Any data processed to enable Linear’s AI features is shared with our trusted partners (AI subprocessors, see our DPA) exclusively to deliver those AI functionalities to you without permission to train on provided data.

To provide features powered by AI and large language models (LLMs), Linear utilizes voluntary data provided by the user in terms of labeling feature outputs (thumbs up/down) or in other opt-in ways. If you have any questions or concerns, please let us know at security@linear.app.

For further information, please see AI Security FAQ in our [Trust Center](https://trustcenter.linear.app/).

Can I see reasoning about why suggestions are made?

Yes! Click on the Triage Intelligence window in an issue in Triage while it’s processing, or on the suggestion overflow menu once suggestions have been made.

![Expanded reasoning for Product Intelligence suggestion](https://webassets.linear.app/images/ornj730p/production/1ebe7390a9bb84355abb0e761696b5712df3bcde-1600x1718.png?w=1440&q=95&auto=format&dpr=2)

I'm on another plan and I still see suggestions. How do these work?

Quick suggestions in the issue composer and property menus are available in all plans in Linear. These leverage search, so they’re faster but much less thorough than Triage Intelligence’s suggestions.

How long does it take to generate suggestions?

Processing new issues in Triage is expected to take 1-4 minutes to generate high-quality suggestions. Because most issues aren’t triaged this quickly, we make a tradeoff here with spending more time to yield better results. We do expect speed improvements over time as models improve.

[Previous

AI Agents](https://linear.app/docs/agents-in-linear.html)[Next

Code Intelligence](https://linear.app/docs/code-intelligence.html)

* [Overview](https://linear.app/docs/product-intelligence.html#overview)
* [Configure](https://linear.app/docs/product-intelligence.html#configure)
* [Issue property suggestions](https://linear.app/docs/product-intelligence.html#issue-property-suggestions)
* [Issue property suggestion behavior](https://linear.app/docs/product-intelligence.html#issue-property-suggestion-behavior)
* [Duplicate and relationship detection](https://linear.app/docs/product-intelligence.html#duplicate-and-relationship-detection)
* [Refine suggestion behavior](https://linear.app/docs/product-intelligence.html#refine-suggestion-behavior)
* [Triggering on issues outside Triage](https://linear.app/docs/product-intelligence.html#triggering-on-issues-outside-triage)
* [FAQ](https://linear.app/docs/product-intelligence.html#faq)
