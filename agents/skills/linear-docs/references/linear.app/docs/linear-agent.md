---
title: "Linear Agent – Linear Docs"
source_url: "https://linear.app/docs/linear-agent"
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

# Linear Agent

![Linear Agent](https://webassets.linear.app/images/ornj730p/production/7c4f95deb251038467a652d0f0195e6d1c92db8a-1998x1650.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/linear-agent.html#overview)

Linear’s native agent can answer questions about your workspace and codebase, take action on your behalf, and connect with other tools in your stack.

You can ask Linear to:

* Find information across issues, projects, documents, and code
* Run repeatable workflows through skills and Loops
* Fix well-scoped issues by starting a [coding session](https://linear.app/docs/coding-sessions.html) when enabled
* Create and update work like issues, projects, milestones and initiatives
* Summarize and analyze ongoing work, threads, and customer requests

Open an agent chat with ⌘/Ctrl + J, or mention `@Linear` in a comment within your workspace. Linear Agent is also available in Slack and Microsoft Teams. Connect MCP servers to extend its abilities to services like Granola, Notion, and Figma.

## Setup[⁠](https://linear.app/docs/linear-agent.html#setup)

Linear Agent is available by default in your workspace.

![Linear Agent, configured by default in your Linear workspace](https://webassets.linear.app/images/ornj730p/production/ecb5dfe6fd6c62baea7f94d0c2fdfb0a4f1cab54-1362x400.png?w=1440&q=95&auto=format&dpr=2)

If you’d prefer to disable Linear Agent for your workspace, a workspace admin or owner can navigate into [*Settings* **→** *AI & Agents* **→** *Linear Agent*](https://linear.app/settings/ai.html) and toggle-off *Enable Linear Agent*.

## Linear Agent[⁠](https://linear.app/docs/linear-agent.html#linear-agent)

Linear Agent works with your existing workspace data, including teams and sub-teams, initiatives and projects (with milestones and cycles), issues and their relationships, comments, activity history, and documents.

![Linear Agent works directly with the same workspace data that powers the rest of Linear.](https://webassets.linear.app/images/ornj730p/production/8a9d915712780eb14176714138976ef7f4ff329d-2150x566.png?w=1440&q=95&auto=format&dpr=2)

It uses this context to understand how work is organized and to answer questions, summarize activity, and make updates in the right places.

Linear Agent operates within your existing permissions — it can only reference or change content that you already have access to.

### Linear Agent chat[⁠](https://linear.app/docs/linear-agent.html#linear-agent-chat)

The dedicated [Linear chat](https://linear.app/agent.html) is the main place to converse with Linear. It can keep context over time, show its progress as it works, and help you iterate from questions to drafts to concrete next steps.

![New Linear agent chat.](https://webassets.linear.app/images/ornj730p/production/19a983865b607be8ebf6733f3ccfb6b69dc5aa1c-1438x1098.png?w=1440&q=95&auto=format&dpr=2)

Start a new chat whenever you want a clean slate: when you’re switching to a different topic, a different issue or project scope, or you want to avoid the agent reusing earlier context from a prior thread.

If you prefer to multi-task, Linear supports working in multiple open chats at once. In the toolbar, each open chat appears as a tab so you can switch between topics without losing context. Each tab shows a short label and indicates when there are unread updates or when the agent is currently working in that thread.

![Linear supports multiple open chats at once. In the toolbar, each open chat appears as a tab so you can switch between topics without losing context.](https://webassets.linear.app/images/ornj730p/production/c9b3effa5d181396c310c11916f95953890d110a-1417x1351.png?w=1440&q=95&auto=format&dpr=2)

Try prompting Linear to:

> Summarize the current status of this project with progress, risks, and next steps.

> Summarize the progress of our team’s current cycle; what issues are at risk of rolling over?

> Draft a new document on this project that comprehensively outlines the feature.

> Publish a stakeholder update that is concise and focused on outcomes and risks.

You can start a new chat or return to recent conversations by typing `⌘J`.

#### Chat history[⁠](https://linear.app/docs/linear-agent.html#chat-history)

Linear keeps a history of your past chats so you can return to them later instead of starting over. Open **Chat history** in the agent toolbar to browse previous conversations.

Chats are typically grouped by recency (for example, *Today*, *Last week*, *4 weeks ago*, or *Older*) and may also surface chats that are related to what you’re currently looking at, so it’s easier to jump back into a relevant thread.

![Linear keeps a record of your past chat history for later access.](https://webassets.linear.app/images/ornj730p/production/dd64b34a76bb6659ca9cd716a5d5ec228477d64e-807x477.png?w=1440&q=95&auto=format&dpr=2)

### Linear Agent in comments[⁠](https://linear.app/docs/linear-agent.html#linear-agent-in-comments)

Outside of the dedicated chat experience, `@Linear` is also available directly in comments across issues, documents, and updates, as well as inline in project and initiative descriptions.

This is meant for moments when you’re already doing work and you want the agent to help in-place, using that context.

![When you’re writing a comment, you can prompt Linear to help you produce something that’s ready to post.](https://webassets.linear.app/images/ornj730p/production/fcd0817572b6f59d69f7ad6d71fd58cb0e6b8e35-958x680.png?w=1440&q=95&auto=format&dpr=2)

When you’re writing a comment, you can prompt Linear to help you produce something that’s ready to post — like a status update, a concise summary of progress, a list of action items, or a decision recap. This is useful when you want the output to live directly on the issue for team visibility.

Try asking:

> Summarize the current state of this issue and call out blockers.

> Rewrite this section to be more concise and action-oriented.

> Turn these notes into a weekly update with progress, risks, and next steps.

> Draft a summary of the overview for the next person picking this up.

![Ask Linear in any comment field to provide a status update, a concise summary of progress, a list of action items, or a decision recap.](https://webassets.linear.app/images/ornj730p/production/45b1c0fbd746010cc668dc5229057d26f6a5d638-1384x513.png?w=1440&q=95&auto=format&dpr=2)

### Linear Agent for Slack[⁠](https://linear.app/docs/linear-agent.html#linear-agent-for-slack)

Linear Agent is available in both Linear and Slack, so you can collaborate on work in whichever tool your team is using.

In Slack, mention `@Linear` to take actions based on the context of your conversations.

[Learn how to use Linear Agent for Slack](https://linear.app/docs/slack.html#linear-agent-for-slack)

### Skills[⁠](https://linear.app/docs/linear-agent.html#skills)

When a conversation with Linear agent yields a great result, save that workflow as a reusable skill.

Skills help you save time, get more consistent results when collaborating with Linear, and avoid rewriting the same instructions for repeated prompts or workflows.

![When a conversation with Linear agent yields a great result, save that workflow as a private skill so you can personally reuse it.](https://webassets.linear.app/images/ornj730p/production/b5831a56a99dc4a2900cac94b3e8c96b676069b9-1174x1014.png?w=1440&q=95&auto=format&dpr=2)

You can create a skill by asking Linear directly to save a conversation as a skill for you, either as a personal resource or shared to your team.

Once saved, skills can be invoked directly with a slash command in the agent input, and Linear Agent may also use them automatically when the context matches the skill’s intent.

#### Personal skills[⁠](https://linear.app/docs/linear-agent.html#personal-skills)

Personal skills can be created and managed in [*Settings → Personal → Agent personalization → Skills*](https://linear.app/settings/account/agents.html).

Consider creating skills for personal workflows you use frequently. Click any of the links below to save a skill in Linear.

* [My weekly focus areas](https://linear.app/agent%3Fprompt=Review%20all%20issues%20assigned%20to%20me,%20the%20projects%20I’m%20involved%20in,%20and%20any%20upcoming%20deadlines%20or%20milestones%20in%20the%20next%20two%20weeks.%20%250A%250ARecommend%20what%20I%20should%20focus%20on%20this%20week%20based%20on:%20what’s%20blocking%20other%20people’s.html)
* [New project update](https://linear.app/agent%3Fprompt=Draft%20a%20concise%20weekly%20update%20for%20this%20project.%250A%250ACall%20out%20any%20meaningful%20changes%20in%20scope%20or%20timeline.%20Note%20work%20that%20appears%20off%20plan%20or%20is%20drifting%20from%20the%20original%20goals.%20Base%20the%20update%20on%20evidence%20from%20project%20iss.html)
* [Prep for my 1:1s](https://linear.app/agent%3Fprompt=Review%20my%20recent%20work%20across%20issues,%20projects,%20and%20comments%20from%20the%20last%20two%20weeks.%250A%250AHighlight%20the%20most%20important%20updates,%20decisions,%20risks,%20and%20open%20questions%20I%20should%20bring%20to%20my%20next%201:1.%250A%250AAlso%20flag%20anything%20tha.html)

![A draft Linear agent skill to draft a new project update.](https://webassets.linear.app/images/ornj730p/production/63b3ff36df33ee731bad0b8dc7bc183d1cec0652-1426x942.png?w=1440&q=95&auto=format&dpr=2)

#### Shared skills[⁠](https://linear.app/docs/linear-agent.html#shared-skills)

Skills can be shared at the team level under *AI & Agents → Agent skills* in your team settings. Team-shared skills are visible for use across all members of that specific team.

Permissions to create, update, or delete team-shared skills are controlled by *Team permissions → Agent skills management*. By default, any team member can manage team skills.

Consider creating team-shared skills for repeatable workflows that team members benefit from running the same way. Use these examples as starting points when creating a shared skill for your team.

* [Project creation from PRD](https://linear.app/agent%3Fprompt=Turn%20the%20attached%20PRD%20into%20a%20new%20Linear%20project.%250A%250ADraft%20the%20project%20overview%20based%20on%20the%20PRD,%20create%20the%20issues%20needed%20to%20deliver%20it,%20and%20organize%20them%20into%20milestones%20in%20a%20way%20that%20reflects%20the%20plan%20in%20the%20doc.%250A%250AK.html)
* [Triage issues for the team](https://linear.app/agent%3Fprompt=Review%20new%20and%20untriaged%20issues%20for%20our%20team.%250A%250AFor%20each%20issue,%20recommend%20the%20next%20step,%20such%20as%20clarifying%20scope,%20assigning%20an%20owner,%20setting%20priority,%20linking%20related%20work,%20or%20closing%20it%20if%20it%20is%20no%20longer%20needed.%250A.html)
* [Summarize new customer feedback for the team](https://linear.app/agent%3Fprompt=Review%20recent%20customer%20feedback,%20customer%20requests,%20and%20related%20issues%20for%20our%20team.%250A%250ASummarize%20the%20main%20themes,%20repeated%20pain%20points,%20and%20notable%20new%20signals.%250A%250ACall%20out%20which%20requests%20seem%20to%20be%20gaining%20momentum,%20w.html)

#### Best practices[⁠](https://linear.app/docs/linear-agent.html#best-practices)

**Start in chat**

Start by working with the Linear agent in a chat to solve a real problem.

Beyond achieving your immediate goal, this helps you figure out what instructions work, what context is needed, and what kind of result you want.

**Save a skill once the result is good**

Once an interaction works well and is likely to be reused, save it as a personal skill. Personal skills are a good fit when the workflow is still evolving, reflects an individual way of working, or is only useful to one person.

**Share a skill to the team**

Create a team-shared skill when the workflow is repeatable, stable, and useful for multiple people on the team. Team-shared skills should have clear instructions, predictable output, and a purpose that others can understand and use without extra explanation.

**Optimize the skill**

After saving a skill, you can also keep improving it. You might ask Linear how to make it faster by excluding steps that aren’t needed every time.

### Loops[⁠](https://linear.app/docs/linear-agent.html#loops)

Loops run Linear Agent workflows in the background on a schedule or in response to supported Linear, Slack, and GitHub events. For example, triage feedback posted in a public Slack channel or draft a QA checklist when a GitHub label is added to a pull request.

For setup details, triggers, permissions, and troubleshooting, see the [Loops](https://linear.app/docs/loops.html) help documentation.

![Create a new loop page with a prompt box, Start from scratch button, and workflow templates](https://webassets.linear.app/images/ornj730p/production/f5f5a226acc749bfc91392701cfed8b25c72b60d-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

![Create a new loop page with a prompt box, Start from scratch button, and workflow templates](https://webassets.linear.app/images/ornj730p/production/b184bd0df4d04626ad7daa0056a0d7a5d08736f1-3452x2358.png?w=1440&q=95&auto=format&dpr=2)

### Coding sessions[⁠](https://linear.app/docs/linear-agent.html#coding-sessions)

Linear Agent can also be delegated the actual implementation work on an issue. See [Coding sessions](https://linear.app/docs/coding-sessions.html) to learn how this workflow operates.

### Connect MCP Servers[⁠](https://linear.app/docs/linear-agent.html#connect-mcp-servers)

Linear Agent can connect to MCP servers to access tools and data outside of Linear.

This lets the agent bring external context into your workflows to investigate issues, plan projects, write specs, and draft updates grounded in your full context. MCP works across Linear Agent chat, comments, and Loops, and is configured at the workspace level by Admins.

For more information to configure MCP servers within your workspace, check out our documentation [here](https://linear.app/docs/connect-mcp-servers-to-linear-agent.html).

### Guidance[⁠](https://linear.app/docs/linear-agent.html#guidance)

Guidance is a set of instructions for how Linear operates within your workspace and across teams. Use guidance to make outputs consistent with conventions in your workspace. You might specify how you want issues titled, what fields should be included in bug reports, or how updates should be structured.

![Personal guidance that instructs the Linear agent with things like: stay concise, write responses in paragraph-style, and bias on actionable responses.](https://webassets.linear.app/images/ornj730p/production/aaeba8918442d7c532bbbfbb677fbf1314fa830b-1406x766.png?w=1440&q=95&auto=format&dpr=2)

You can configure guidance for Linear at different scopes: workspace-wide, specific to a team or personal to you.

**Workspace guidance** applies to everyone in the workspace by default. Restrictions for who can edit workspace-level guidance is configurable by navigating into [*Settings* → *AI*](https://linear.app/settings/ai.html).

![Workspace-level guidance restrictions](https://webassets.linear.app/images/ornj730p/production/bb98af39b35922ef41c86bcb52ba14336c29ede4-1516x346.png?w=1440&q=95&auto=format&dpr=2)

**Personal guidance** lets an individual tailor how Linear responds for them. Update your personal Linear agent guidance by navigating in [*Settings → Agent personalization*](https://linear.app/settings/account/agents.html).

If you’d like guidance to apply to a specific team only, you can reference that team and its unique instructions in your workspace-level guidance.

*Note that workspace-level guidance for the Linear agent within Linear is separate from the guidance used for the [Linear agent for Slack](https://linear.app/docs/slack.html#linear-agent-for-slack). The Slack integration has its own guidance specifically for how Linear Agent should turn Slack messages into issues, and it’s configured in `Slack integration settings` rather than the general `Linear Agent guidance settings`.*

*Personal agent guidance applies to both the agent within Linear and Slack.*

### Preferences[⁠](https://linear.app/docs/linear-agent.html#preferences)

When opening a new Linear tab, we launch a new chat with Linear agent.

![Update your Default home view preference from Linear Agent.](https://webassets.linear.app/images/ornj730p/production/e08a3e6fca539425b72dccb93648db425cb1a435-1730x850.png?w=1440&q=95&auto=format&dpr=2)

If you’d prefer to change this behavior, navigate [Preferences](https://linear.app/settings/account/preferences.html) and update *Default home view* from *Linear Agent* to your desired location.

[Previous

Coding settings](https://linear.app/docs/code-and-reviews.html)[Next

Loops](https://linear.app/docs/loops.html)

* [Overview](https://linear.app/docs/linear-agent.html#overview)
* [Setup](https://linear.app/docs/linear-agent.html#setup)
* [Linear Agent](https://linear.app/docs/linear-agent.html#linear-agent)
* [Linear Agent chat](https://linear.app/docs/linear-agent.html#linear-agent-chat)
* [Chat history](https://linear.app/docs/linear-agent.html#chat-history)
* [Linear Agent in comments](https://linear.app/docs/linear-agent.html#linear-agent-in-comments)
* [Linear Agent for Slack](https://linear.app/docs/linear-agent.html#linear-agent-for-slack)
* [Skills](https://linear.app/docs/linear-agent.html#skills)
* [Personal skills](https://linear.app/docs/linear-agent.html#personal-skills)
* [Shared skills](https://linear.app/docs/linear-agent.html#shared-skills)
* [Best practices](https://linear.app/docs/linear-agent.html#best-practices)
* [Loops](https://linear.app/docs/linear-agent.html#loops)
* [Coding sessions](https://linear.app/docs/linear-agent.html#coding-sessions)
* [Connect MCP Servers](https://linear.app/docs/linear-agent.html#connect-mcp-servers)
* [Guidance](https://linear.app/docs/linear-agent.html#guidance)
* [Preferences](https://linear.app/docs/linear-agent.html#preferences)
