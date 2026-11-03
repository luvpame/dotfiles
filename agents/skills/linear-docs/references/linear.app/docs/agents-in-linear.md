---
title: "AI Agents – Linear Docs"
source_url: "https://linear.app/docs/agents-in-linear"
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

# AI Agents

![list of agents in assignee menu, Charlie and ChatPRD are visible](https://webassets.linear.app/images/ornj730p/production/68c955d01e0e45b23747e8cd7362b018b06a6655-2880x1768.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/agents-in-linear.html#overview)

While [Linear Agent](https://linear.app/docs/linear-agent.html) works by default in every workspace, Linear also maintains an open platform for third party agents (including those you build yourself.)

Agents are designed to work seamlessly alongside human teammates, and can open PRs against issues, help write documents, and take most actions that human users can, depending on their granted scopes.

To interact with an agent in Linear:

* **Delegate issues** by assigning the issue to the agent. This triggers the agent to take action based on its programmed behavior.
* **@mention them** in comments or descriptions to trigger their functions.

If you’re not sure how to interact or what they’re able to help with, you can try @mentioning the agent to ask for help.

## Adding Agents[⁠](https://linear.app/docs/agents-in-linear.html#adding-agents)

Workspace admins can install agents by following the setup instructions provided by the agent developer. Find available agents in the [Integrations Directory](https://linear.app/integrations/agents.html).

During installation, you’ll be prompted to choose which teams the agent has access to.

Once installed, any user with access to the selected teams can interact with the agent. Admins can also review agent access from the [AI & Agents](https://linear.app/settings/ai.html) settings in the *Installed Agents* section.

Depending on the permissions granted during installation, agents can be mentioned, delegated issues through assignment, create and reply to comments, and collaborate on projects and documents. App users are installed and managed by workspace admins.

## Guiding Agents[⁠](https://linear.app/docs/agents-in-linear.html#guiding-agents)

Agent guidance lets you provide instructions that agents will automatically receive when they work on issues in your workspace.

![Screenshot of the Additional guidance panel showing repository instructions for agents](https://webassets.linear.app/images/ornj730p/production/d9cb1836286c78822dddee0e6e9ec3c67a1c10a9-1570x788.png?w=1440&q=95&auto=format&dpr=2)

Agent guidance provides instructions that help agents work within your team’s conventions. Guidance can specify which repository to use for certain code changes, how to reference issues in commits or pull requests, and what review process to follow, so agents align with your existing workflows.

**Note:** All guidance is passed to the agent, but how it is interpreted or applied depends on the specific agent integration. If an agent doesn’t appear to follow the guidance, please share feedback with the team responsible for that agent directly.

Workspace guidance applies across the entire organization, while team-specific guidance can be used to include additional instructions unique to that team. When both exist, team guidance takes priority.

Guidance is authored in a markdown editor with full history, so instructions can be formatted clearly and reviewed or updated over time.

To edit your workspace-level agent guidance, navigate to [*Settings* > *Agents* > *Additional guidance*](https://linear.app/settings/agents.html). For team-level guidance, navigate into your parent or sub-team’s settings > *Agents* > *Additional guidance*. Both workspace and team level guidance may not exist in all agent contexts.

## Viewing Agent Activity[⁠](https://linear.app/docs/agents-in-linear.html#viewing-agent-activity)

You can track what an agent has done in the same ways you track other teammates:

* **Agent** [**user pages**](https://linear.app/docs/custom-views.html#user-views) show issue activity and contributions.
* In the **My issues** view, issues that you’ve delegated to agents will still appear—so you maintain visibility and control over the work in progress.
* **Custom views** filtered by **Delegate** to monitor agent involvement on specific types of issues or workflows.
* Use **Insights** sliced or segmented by **Delegate** to measure how much work is being directed to and handled by agents.

## Building Your Own Agent[⁠](https://linear.app/docs/agents-in-linear.html#building-your-own-agent)

Developers can build custom agents using Linear’s developer platform. Documentation on agent APIs, authentication, and behavior can be found in our [Developer Docs](https://linear.app/developers/agents.html).

## FAQs[⁠](https://linear.app/docs/agents-in-linear.html#faqs)

Are agents billable seats?

Agents are not counted as billable seats in Linear. The services that provide the agent may have their own pricing structure, and you should refer to their documentation before installing.

How does Linear use data from agents?

Linear does not train on customer’s data. We use models from common model providers, a complete list is available in our [DPA](https://linear.app/dpa.html).

Agents themselves would be 3rd party integrations approved by your workspace, in which case we can’t speak to how the agent provider operates and you’d have to refer to the agent service provider.

What are the limitations in agents interacting with Linear?

Agents cannot sign in to the app, access admin functionality or manage users.

What happens if I install an agent but the name is already taken?

In the event that you have a member on your workspace with the same name as an Agent, the Agent’s username will simply append a number at the end to keep it unique.

For example, Charlie would become Charlie1.

[Previous

Loops](https://linear.app/docs/loops.html)[Next

Triage Intelligence](https://linear.app/docs/product-intelligence.html)

* [Overview](https://linear.app/docs/agents-in-linear.html#overview)
* [Adding Agents](https://linear.app/docs/agents-in-linear.html#adding-agents)
* [Guiding Agents](https://linear.app/docs/agents-in-linear.html#guiding-agents)
* [Viewing Agent Activity](https://linear.app/docs/agents-in-linear.html#viewing-agent-activity)
* [Building Your Own Agent](https://linear.app/docs/agents-in-linear.html#building-your-own-agent)
* [FAQs](https://linear.app/docs/agents-in-linear.html#faqs)
