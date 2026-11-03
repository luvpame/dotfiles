---
title: "Loops – Linear Docs"
source_url: "https://linear.app/docs/loops"
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

# Loops

Available on paid plans. Loops that use Linear Agent draw from your workspace’s [AI credits](https://linear.app/docs/ai-credits.html).

![Loops](https://webassets.linear.app/images/ornj730p/production/d50a83fccc38ccc78ad8c0092dbd8796d092e759-3600x2080.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/loops.html#overview)

Loops use Linear Agent to drive your work forward automatically. Loops run on a schedule or in response to supported events on [issues](https://linear.app/docs/creating-issues.html), [projects](https://linear.app/docs/projects.html), [initiatives](https://linear.app/docs/initiatives.html), [cycles](https://linear.app/docs/use-cycles.html), [releases](https://linear.app/docs/releases.html), and [pull requests](https://linear.app/docs/loops.html#pull-request-triggers). They can also run when a new message is posted in a selected public Slack channel.

Use loops to automate routine tasks and free up your attention. You can send weekly digests of your team’s work to Slack, populate project documents with customer feedback from customer requests, or direct Linear to open a coding session when well-scoped bugs hit Triage.

Loops work in your Slack workspace through Linear’s [Slack integration](https://linear.app/docs/loops.html#use-slack-with-loops), and you can extend their capabilities by adding other optional [MCP connectors](https://linear.app/docs/loops.html#mcp-connectors).

## Example loops[⁠](https://linear.app/docs/loops.html#example-loops)

Here are some basic loops that are useful for most workspaces. Create custom loops for your team by prompting Linear, or get started with one of these examples.

### Investigate and delegate bug reports[⁠](https://linear.app/docs/loops.html#investigate-and-delegate-bug-reports)

When new bugs arrive in Triage, check the codebase for a root cause. Delegate the issue to Linear to fix if the cause is found. ([Build this loop ↗](https://linear.app/agent%3Fskill=loop-bug-triage.html))

[](https://webassets.linear.app/files/ornj730p/production/aaafc7577b0e892bef05a313a18d0692bba838af.mp4#t=0.001)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

### Summarize weekly accomplishments[⁠](https://linear.app/docs/loops.html#summarize-weekly-accomplishments)

Every week, summarize the week’s accomplishments for a person or team and share the highlights. ([Build this loop ↗](https://linear.app/agent%3Fskill=loop-weekly-wrap.html))

Send the pre-filled request to start setting up this custom loop.

### Create platform-specific versions of incoming requests[⁠](https://linear.app/docs/loops.html#create-platform-specific-versions-of-incoming-requests)

When a new incoming issue is created, determine if new issues also need to be created for multiple platforms. ([Build this loop ↗](https://linear.app/agent%3Fskill=loop-cross-platform-handoff.html))

[](https://webassets.linear.app/files/ornj730p/production/94fd2b994d955887413cbbbbfe0c2776816cb632.mp4#t=0.001)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

### Create user-facing messaging after issues close[⁠](https://linear.app/docs/loops.html#create-user-facing-messaging-after-issues-close)

After an issue closes, check the PR that closed it and generate user-facing messaging that Support can share with customers. ([Build this loop ↗](https://linear.app/agent%3Fskill=loop-customer-follow-up.html))

[](https://webassets.linear.app/files/ornj730p/production/7eea0fd4bd8d2f019cb4f846cdb4b57ac444e1a4.mp4#t=0.001)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

## How Linear uses loops[⁠](https://linear.app/docs/loops.html#how-linear-uses-loops)

Teams at Linear use loops to automate work. Learn more about some of our own use cases:

* [Slow PostgreSQL queries are surfaced for review](https://linear.app/learn/database-query.html)
* [Technical sales questions get automatically answered in Slack](https://linear.app/learn/customer-questions.html)
* [Customer feedback is routinely collated for Product](https://linear.app/learn/customer-feedback-loop.html)
* [When help documentation falls out of date, a loop suggests changes](https://linear.app/learn/docs-maintenance.html)

## Create loops with Linear Agent[⁠](https://linear.app/docs/loops.html#create-loops-with-linear-agent)

The best approach is to first achieve the outcome you want in a Linear Agent chat, then refine it into a loop. For example, you might be leading a project that has check-in meetings every Thursday morning. You’re about to write the agenda, but realize you could automate this instead.

* Press ⌘/Ctrl + J to open a Linear Agent chat
* Give Linear Agent a prompt such as:

> Review the project’s Slack channel, the open questions in the latest project update, and any relevant issue threads. Add **Open questions**, **Relevant issue threads**, and **Next steps** sections to the Meetings project document. Summarize your findings under each heading and include links to the relevant messages or issues.

* Review the result to make sure it looks right. If it doesn’t, continue prompting Linear until the agenda looks complete, and in the desired format.
* Then, ask Linear to create the loop. You’ll be prompted to add any missing details.

## Create loops manually[⁠](https://linear.app/docs/loops.html#create-loops-manually)

Create a loop from a template, describe what you want Linear to automate, or start from scratch.

1. Open **Loops** in the workspace sidebar, or open a team and select its **Loops** tab
2. Select **New loop**
3. Choose a template, enter a prompt, or select **Start from scratch**
4. Choose where the loop belongs if prompted

To configure a loop from scratch:

1. Choose a trigger and configure its schedule, conditions, repositories, or Slack channels
2. Add instructions describing the outcome you want
3. Add any required [connectors](https://linear.app/docs/loops.html#mcp-connectors)
4. Under **Capabilities & access**, review the loop’s scope, reasoning level, and permissions
5. Select **Create loop**

![Create a new loop page with a prompt box that says "Ask Linear to build the loop for you," a Start from scratch button, and template cards including Autofix bugs, Triage agent, Slack Q&A assistant, and Weekly wrap](https://webassets.linear.app/images/ornj730p/production/8b14d3e80b1cf1c85d76167144c182e8cb1946fb-3416x2294.png?w=1440&q=95&auto=format&dpr=2)

![Create a new loop page with a prompt box that says "Ask Linear to build the loop for you," a Start from scratch button, and template cards including Autofix bugs, Triage agent, Slack Q&A assistant, and Weekly wrap](https://webassets.linear.app/images/ornj730p/production/358b86263ba0584af3d09729d6725577865080cd-3390x2260.png?w=1440&q=95&auto=format&dpr=2)

### Create from a prompt[⁠](https://linear.app/docs/loops.html#create-from-a-prompt)

In the new loop dialog, describe what you want to automate. Linear prepares a draft with instructions and a suggested trigger. Review the draft, adjust its configuration, and select **Create loop** when it is ready.

![Create a new loop page with "Every Monday, summarize the issues my team completed last week" typed in the prompt box](https://webassets.linear.app/images/ornj730p/production/f161ee8b5a3ef96adbffd9013613cc5e692a1ee8-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Create a new loop page with "Every Monday, summarize the issues my team completed last week" typed in the prompt box](https://webassets.linear.app/images/ornj730p/production/51308eb03885418c2c3625f4fb4dd91d27388fa5-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Weekly completed issues loop draft with a weekly schedule trigger on Monday at 09:00, instructions to summarize completed issues, and no connectors added](https://webassets.linear.app/images/ornj730p/production/70fde174a629fb8f22a828e51e9e0225a664f5b2-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Weekly completed issues loop draft with a weekly schedule trigger on Monday at 09:00, instructions to summarize completed issues, and no connectors added](https://webassets.linear.app/images/ornj730p/production/052e431b1c33dc36fdc30ae7a79ae6a4ca4dbd09-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

### Start from a template[⁠](https://linear.app/docs/loops.html#start-from-a-template)

Select a template to start with a predefined workflow. Answer Linear’s setup questions to adapt it to your workspace, and review the instructions, trigger, and permissions as part of setup.

![Project hygiene loop draft with a chat panel asking "Which projects should I review?" and the options Customer Support projects and All public projects](https://webassets.linear.app/images/ornj730p/production/b65889ef77470566313e056feec329bfda7b400a-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Project hygiene loop draft with a chat panel asking "Which projects should I review?" and the options Customer Support projects and All public projects](https://webassets.linear.app/images/ornj730p/production/944039999ab4cf13d28c6341264ce90a9dc69811-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

## Workspace templates[⁠](https://linear.app/docs/loops.html#workspace-templates)

Save a configured loop as a workspace template to reuse its workflow when creating other loops.

1. Open an eligible loop
2. Open the more menu and select **Save as template**
3. Set a name, icon, and optional description
4. Select **Save template**

![Loop actions menu with options including Edit, Duplicate, Save as template, and Move](https://webassets.linear.app/images/ornj730p/production/4c083cdb6ad1876fe6086443a81c0e31e92cf590-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Loop actions menu with options including Edit, Duplicate, Save as template, and Move](https://webassets.linear.app/images/ornj730p/production/bc72906e939af1c6b315fb48830e7c0056ade910-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Save as workspace template dialog with the name Weekly completed issues, an optional description, and Cancel and Save template buttons](https://webassets.linear.app/images/ornj730p/production/a4629d5e5f389b7ca1589ad1112e170e98fb4d4b-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Save as workspace template dialog with the name Weekly completed issues, an optional description, and Cancel and Save template buttons](https://webassets.linear.app/images/ornj730p/production/3bf044a7ddf165fe27859f3791c370f5daaf6066-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

To use a workspace template, open **New loop** and select its card. Linear creates a separate draft and helps adapt it to the destination. Review the configuration and permissions before creating the loop.

![Create a new loop dialog with a Weekly completed issues template card marked Workspace, shown before the built-in templates](https://webassets.linear.app/images/ornj730p/production/8b2d081be8614dc2f9767b3063875bd589ea5d94-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Create a new loop dialog with a Weekly completed issues template card marked Workspace, shown before the built-in templates](https://webassets.linear.app/images/ornj730p/production/e0a0746910e8742ca12a859f3632b6a1e157a119-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

Templates reuse instructions, supported trigger configuration, schedules, and compatible settings. They do not copy the source loop’s owner, enabled state, team access, trusted external sources, or connector authorizations. Review references in the instructions and configure the access and connections required by the new loop.

Only eligible loops can be saved as templates. Slack/chat, pull request, and webhook triggers are not supported. Triage templates require a destination team with triage enabled.

Workspace owners can control who manages workspace templates in [**Settings → Security → Workspace management → Manage workspace templates**](https://linear.app/settings/security.html). Saving a loop as a template also requires permission to edit that loop.

![Workspace management security settings with the Manage workspace templates dropdown open, showing All members, Only owners and admins, and Only owners](https://webassets.linear.app/images/ornj730p/production/9be2dbdfc140a05959421935d3a55c4a2d847734-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Workspace management security settings with the Manage workspace templates dropdown open, showing All members, Only owners and admins, and Only owners](https://webassets.linear.app/images/ornj730p/production/b4bdff886abf5505d08f3170f91a27953eb77ffc-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

To manage a saved template, open the more menu on its card in the new loop chooser. Select **Edit details** to change its name, icon, or description, or **Delete** to remove it. Edit details does not change the saved workflow configuration. To save different instructions or settings, create another template from a configured loop.

![Weekly completed issues template card with a menu showing Edit details and Delete](https://webassets.linear.app/images/ornj730p/production/831cb34699d80b550ba6eacc329a0de90a8040b5-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Weekly completed issues template card with a menu showing Edit details and Delete](https://webassets.linear.app/images/ornj730p/production/7211166cabff0dbefdc5b7f271ac89f1931a11d0-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

## Pull request triggers[⁠](https://linear.app/docs/loops.html#pull-request-triggers)

Pull request triggers run a loop when selected activity occurs in connected GitHub repositories.

Pull request triggers require a connected GitHub repository that your workspace allows loops to access. Enable code-reading access for the loop and select at least one repository. Personal GitHub access alone does not grant a loop access to a repository.

1. In the loop editor, open **Trigger → Pull request** and choose an event
2. Select the repositories to monitor
3. Add filters to narrow the pull requests that can trigger the loop
4. Add instructions and review the loop’s access before creating it

Supported events include pull request creation, ready for review, status changes, reviewers added or removed, GitHub team reviewers added or removed, GitHub labels added or removed, commits pushed, checks passed or failed, reviews submitted, new comments, and resolved comments.

To run a loop after a pull request is merged, choose **Trigger → Pull request → Status → Merged**. The loop runs when a pull request in the selected repositories changes to Merged and matches its filters.

![Loop trigger set to Pull request status is set to Merged in a connected GitHub repository, with instructions to comment on linked issues when a pull request is merged](https://webassets.linear.app/images/ornj730p/production/c57b98b3b1b2364803a7e61b078c1b32b06ca8ba-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Loop trigger set to Pull request status is set to Merged in a connected GitHub repository, with instructions to comment on linked issues when a pull request is merged](https://webassets.linear.app/images/ornj730p/production/fd7387720f34ff152387188ad66383b3b398dd11-3422x2292.png?w=1440&q=95&auto=format&dpr=2)

![Loop trigger set to Pull request status is set to Merged in rideshare/mobile, with instructions to comment on linked issues when a pull request is merged](https://webassets.linear.app/images/ornj730p/production/28e1643eb9cb8ea02f65d02bde62a9fd313ec21c-2880x1929.png?w=1440&q=95&auto=format&dpr=2)

![Loop trigger set to Pull request status is set to Merged in rideshare/mobile, with instructions to comment on linked issues when a pull request is merged](https://webassets.linear.app/images/ornj730p/production/7dfb2f62e2376050b8fe0b89cdf9bf76f003447d-2880x1929.png?w=1440&q=95&auto=format&dpr=2)

Merged is a pull request status transition, not a deployment event. Later updates to an already merged pull request do not retrigger it, and checks passing does not mean every individual successful check produces a run.

For example, run a loop when the GitHub label **QA Test** is added, and have it review the pull request’s changes and draft a QA checklist.

Choose **Trigger → Pull request → Labels → Added**, then select **QA Test**. This matches the label being added. A separate **Labels** filter checks which labels are on the pull request after the change—use it to narrow the workflow further, such as requiring a `mobile` label.

For a removal trigger, select the label under **Labels → Removed**. Don’t also require that same label in a Labels filter, because it is no longer on the pull request.

![Loop configured to draft a QA checklist when the QA Test GitHub label is added to a pull request](https://webassets.linear.app/images/ornj730p/production/6c3685ca51304036a40bd5212d66e187fc7631fa-3422x2358.png?w=1440&q=95&auto=format&dpr=2)

![Loop configured to draft a QA checklist when the QA Test GitHub label is added to a pull request](https://webassets.linear.app/images/ornj730p/production/4c0b1ff02a4b9a16bd229b087492f8a7fcc0570c-3422x2358.png?w=1440&q=95&auto=format&dpr=2)

If the required repository is unavailable, ask a workspace admin to configure the GitHub integration and repository code access. Workspace repository access for loops is controlled in **Settings → Loops → Allow loops to access code**. In the loop editor, review **Capabilities & access → Access code** and allow Read or Read & write as appropriate.

Loops that use a pull request trigger cannot be saved as workspace templates.

## Update loops[⁠](https://linear.app/docs/loops.html#update-loops)

Open the loop and make your changes. Select **Save** in the bar at the bottom of the editor. Only people with permission to edit the loop can save changes.

## Review a loop’s runs[⁠](https://linear.app/docs/loops.html#review-a-loop's-runs)

Each loop has a run history to let you audit its behavior.

Open a loop’s **Run history** to ask Linear Agent follow-up questions or request additional actions using the run’s context.

1. Open **Loops** from the workspace or team that contains the loop
2. Open the loop you want to review
3. Select **Run history**
4. Review recent runs to see when the loop executed and what actions it took

![Run History Menu](https://webassets.linear.app/images/ornj730p/production/cf3bfc297bb27d85829dd05f6e0512ffe4d9a925-1988x882.png?w=1440&q=95&auto=format&dpr=2)

![Run History Menu](https://webassets.linear.app/images/ornj730p/production/831089d29114df09dbc0dd742b4fd6448121d0aa-1988x882.png?w=1440&q=95&auto=format&dpr=2)

![Run History](https://webassets.linear.app/images/ornj730p/production/fd188bde19309e260dd9c92798b3a89b5cf2a1d8-3056x2056.png?w=1440&q=95&auto=format&dpr=2)

![Run History](https://webassets.linear.app/images/ornj730p/production/9abb797a2ce8eb11c7072cbc780468b81144a63f-3088x2088.png?w=1440&q=95&auto=format&dpr=2)

## Restore a previous version[⁠](https://linear.app/docs/loops.html#restore-a-previous-version)

All published versions of a loop are saved and can be restored. Removed connectors must be added and authenticated again.

1. Open the loop for editing
2. Select **Published versions**
3. Choose the version to restore
4. Select **Restore version**

## Slack message triggers[⁠](https://linear.app/docs/loops.html#slack-message-triggers)

Run a loop when a new top-level message is posted in selected public Slack channels.

1. In the loop editor, choose **Trigger → Slack → Message posted**
2. Select the Slack workspace and channels to monitor
3. Add instructions describing when the loop should act and what it should do
4. Review its connectors and **Capabilities & access**, then create the loop

![Loop editor with a Slack Message posted trigger configured for a public channel](https://webassets.linear.app/images/ornj730p/production/8a4a057f29d107f62cff6b0196eda61cec2f43c0-3422x2358.png?w=1440&q=95&auto=format&dpr=2)

![Loop editor with a Slack Message posted trigger configured for a public channel](https://webassets.linear.app/images/ornj730p/production/453cb6e043c974ce1ab05c62ddec522c30c8208f-3422x2358.png?w=1440&q=95&auto=format&dpr=2)

A workspace admin must turn on **Enable Linear Agent** and **Allow Loops access** in **Settings → Integrations → Slack → workspace**. You must also connect your Slack account and be a full member of that Slack workspace.

Slack message triggers do not support externally shared channels, private channels, direct messages, thread replies, or message edits. Messages from guests, posts from Linear or Linear Asks, and messages mentioning Linear’s bots do not trigger runs.

Message-history access must be enabled. If automatic channel joining is disabled, invite Linear to each selected channel before creating the loop.

## Use Slack with loops[⁠](https://linear.app/docs/loops.html#use-slack-with-loops)

Connect a Loop to your workspace’s Slack integration to let it work in Slack as Linear. A Loop can use one connected Slack workspace. You must link your Slack account to Linear and be a full member of the workspace to connect.

To connect Slack to a Loop:

1. A workspace admin must first turn on **Enable Linear Agent** and **Allow Loops access** in [**Settings → Integrations → Slack → workspace**](https://linear.app/settings/integrations/slack.html)
2. In the Loop draft, open the connector menu and select **Slack**
3. Select the appropriate Slack workspace

![Slack Integration Connector](https://webassets.linear.app/images/ornj730p/production/813ad3171dca8c207a14b8700d5bd89bad03e009-990x424.png?w=1440&q=95&auto=format&dpr=2)

![Slack Integration Connector](https://webassets.linear.app/images/ornj730p/production/34f6d699f4080f76d2789955b00efc93158df8ec-989x389.png?w=1440&q=95&auto=format&dpr=2)

The Slack integration uses your workspace’s shared Slack connection, rather than a personal Slack MCP connection. It is intended for shared automation with defined public-channel access. You should use a personal Slack MCP connector when a Loop needs access based on an individual’s Slack authorization or broader Slack tools.

### What loops can do in Slack[⁠](https://linear.app/docs/loops.html#what-loops-can-do-in-slack)

* Loops can find public channels by name, including Slack Connect channels, and read their message history. They can also read messages from Slack links, post new messages, and add or remove emoji reactions. Messages posted to Slack by a loop are identifiable by a direct link to its [run](https://linear.app/docs/loops.html#review-a-loop's-runs).
* Loops can send direct messages to full members in Slack, and those messages are one-way
* In a public-channel thread started by a Loop, anyone with access to the loop run can reply from there to continue the conversation
* Loops can send broadcast mentions such as `@here` and `@channel` in Slack messages

### Slack access and limitations[⁠](https://linear.app/docs/loops.html#slack-access-and-limitations)

* Loops cannot access private channels, direct-message history, or group direct messages
* Loops cannot search messages across the workspace, create channels, edit or delete messages, upload files, or manage Slack canvas documents
* Replies in Slack Connect channels, direct messages, or unrelated threads do not continue the loop conversation
* When automatic channel joining is disabled in Slack, Loops can only use public channels that Linear has already joined. If message history is unavailable, Loops can send messages into those channels but cannot read their history, or continue conversations through replies.

## MCP connectors[⁠](https://linear.app/docs/loops.html#mcp-connectors)

MCP connectors extend what Linear Agent can do during a loop run. When a connected MCP is available to a loop, Linear can use it to gather context or take supported actions in other services. For example:

* Search or retrieve content from connected sources such as GitHub, Notion, or Sentry
* Post comments or updates to external services like Slack
* Fetch documentation, pull request details, or error reports to enrich an issue

An MCP connector can only access data and perform actions that are permitted by the available MCP’s configuration and the loop’s data scope. When a user connects an MCP to a loop, they authorize that loop to act in the other service, so connector access should be granted thoughtfully.

![MCP Connectors available during a loop run](https://webassets.linear.app/images/ornj730p/production/1f5637a8a67dcada4d191a4dd6f05ea00cf00da0-1009x435.png?w=1440&q=95&auto=format&dpr=2)

![MCP Connectors available during a loop run](https://webassets.linear.app/images/ornj730p/production/2978ce6c0e93bc3e51f484ec013f72c0f7acbe47-996x432.png?w=1440&q=95&auto=format&dpr=2)

### Managing available Connectors[⁠](https://linear.app/docs/loops.html#managing-available-connectors)

Owners (Enterprise) or workspace Admins (Business) can elect to let users connect any MCP connector, or only allowlisted servers.

![MCP connector security settings with options to allow all servers or only specific servers](https://webassets.linear.app/images/ornj730p/production/edd247935723320b36a2592447ed0793bf5c8a7a-959x625.png?w=1440&q=95&auto=format&dpr=2)

![MCP connector security settings with options to allow all servers or only specific servers](https://webassets.linear.app/images/ornj730p/production/56dc4e78b28dc26e05409d93c0f7ef8e1ad2a3d7-950x634.png?w=1440&q=95&auto=format&dpr=2)

When access is limited to **Selected connectors**, a workspace admin must add a connector to the allowlist before it can be used in a loop.

Workspace admins and owners can configure the full set of MCP connectors allowed in a workspace in Security settings. Once an MCP server has been added, users can add it when creating or updating a loop. Adding one directly to a loop requires the configuring user to authenticate with the connector, and it will use their personal account’s connection.

### MCP approvals[⁠](https://linear.app/docs/loops.html#mcp-approvals)

To choose which tools a loop can use, edit the loop, open the MCP connector’s ⋯ menu, and select **Manage tools…**. Select the tools you want to make available to the loop.

![Slack Personal MCP connector menu with Manage tools highlighted](https://webassets.linear.app/images/ornj730p/production/2d176fd9a7fee2db51c70cc4811b6e4fd053005f-1402x708.png?w=1440&q=95&auto=format&dpr=2)

Enable **Automatically approve all tool calls** to skip approval requests from that connector. To automatically approve individual tools instead, leave this setting off and enable **Always approved** for each tool you want to approve automatically.

![Manage tools dialog showing tool selection, per-tool Always approved toggles, and Automatically approve all tool calls](https://webassets.linear.app/images/ornj730p/production/f0105f7efeb67f42f886e76d33724937b2ace099-812x794.png?w=1440&q=95&auto=format&dpr=2)

Tool selection controls which tools the loop can use. Automatic approval controls whether tool calls require approval; it does not grant additional access in the connected service. Enable automatic approval only for tools you trust the loop to use without individual review.

## Setup[⁠](https://linear.app/docs/loops.html#setup)

* Workspace owners can manage who can create and manage workspace loops in [**Settings → Security → Workspace management → Manage loops**](https://linear.app/settings/security.html)
* Workspace owners can manage who can save and manage workspace templates in [**Settings → Security → Workspace management → Manage workspace templates**](https://linear.app/settings/security.html)
* Team owners can control who can create and manage loops in **Settings → Teams → [Team name] → Access and permissions → Loop management**
* To change who can edit a specific loop, open it and then select **Who can edit**. Choose between all members, workspace admins or team owners, or only the loop owner.

![Manage Loops Access](https://webassets.linear.app/images/ornj730p/production/f88dbcfb9a980145855dce2c8108fdec226f930c-1924x850.png?w=1440&q=95&auto=format&dpr=2)

![Manage Loops Access](https://webassets.linear.app/images/ornj730p/production/358fe38b142196a3259b9bbb79290df811462fb5-1924x850.png?w=1440&q=95&auto=format&dpr=2)

## Capabilities & access[⁠](https://linear.app/docs/loops.html#capabilities-and-access)

Configure the loop’s scope, reasoning level, and permissions under **Capabilities & access**. Enable only the access it needs, and consider the impact before allowing changes or connecting external services.

![Capabilities & access settings showing Team access, Reasoning level set to Auto, Access code set to Read & write, and controls for changes outside the triggering pull request and externally synced issues and comments](https://webassets.linear.app/images/ornj730p/production/13b8bbf2e2dc5eed47c1b6784ff8298261379873-1726x1360.png?w=1440&q=95&auto=format&dpr=2)

![Capabilities & access settings showing Team access, Reasoning level set to Auto, Access code set to Read & write, and controls for changes outside the triggering pull request and externally synced issues and comments](https://webassets.linear.app/images/ornj730p/production/0f2516b8c9b46c1dc67a3b47ba7acb8f5b1cd70c-1726x1360.png?w=1440&q=95&auto=format&dpr=2)

### Team access[⁠](https://linear.app/docs/loops.html#team-access)

Controls which teams the loop can access. It can read and write data only in those teams. By default, a loop at the workspace level or in a public team will have access to all public teams, while a loop inside a private team will have access only to that team.

Loops that can access all public teams can also access workspace-level objects like Initiatives and Customers.

### Reasoning level[⁠](https://linear.app/docs/loops.html#reasoning-level)

Choose how deeply the loop should analyze information under **Capabilities & access → Reasoning level**.

* **Auto** lets Linear select the reasoning level
* **Low** prioritizes speed and lower cost for simple tasks
* **Medium** balances speed and depth for everyday tasks
* **High** provides more thorough reasoning for complex tasks and costs more

### Web access[⁠](https://linear.app/docs/loops.html#web-access)

If enabled, the loop can query any website. You can use this to set up loops that can take actions like researching competitor announcements, or checking the documentation of services your product integrates with.

Use caution when enabling web access. **Web access can send workspace content to external services.** Do not enable it for loops that may process sensitive data unless you are comfortable with that data leaving Linear.

### Access code[⁠](https://linear.app/docs/loops.html#access-code)

Under **Capabilities & access → Access code**, choose how the loop can use configured repositories:

* **Disabled** prevents code access
* **Read** allows the loop to [inspect code and pull requests](https://linear.app/docs/code-intelligence.html)
* **Read & write** also allows the loop to make changes through [coding sessions](https://linear.app/docs/coding-sessions.html)

A workspace admin must configure repository access in **Settings → Loops → Allow loops to access code**. Coding sessions must also be enabled to use **Read & write**.

### Externally synced issues and comments[⁠](https://linear.app/docs/loops.html#externally-synced-issues-and-comments)

If enabled, the loop will be able to write data on issues or comment threads that are synced with external applications, like issues created from Slack with bi-directionally synced threads.

Enable this with care, as some synced threads may be visible outside your workspace - if you use [GitHub sync](https://linear.app/docs/github.html#configure-github-issues-sync) in a public repo for instance, the loop would be able to post comments to that repo’s GitHub Issues.

### External sources[⁠](https://linear.app/docs/loops.html#external-sources)

Issues can be created from sources outside Linear, such as Slack messages or emails received at a particular address. By default, issue-triggered loops run only on issues created within Linear.

To run an issue-triggered loop on issues created from external sources, enable the relevant sources for that loop. Workspace owners can configure the allowed external sources in [Security settings](https://linear.app/settings/security.html), then enable them for individual loops.

Slack message triggers are configured separately.

### Allow changes outside of triggering entity[⁠](https://linear.app/docs/loops.html#allow-changes-outside-of-triggering-entity)

If enabled, the loop can write data to other entities within its **Team access** scope. If disabled, it can change only the entity that triggered the run. This setting does not apply to scheduled or Slack-triggered loops.

## AI credits[⁠](https://linear.app/docs/loops.html#ai-credits)

Loops use [AI credits](https://linear.app/docs/ai-credits.html), which workspace admins can purchase and manage in [Settings](https://linear.app/settings/billing.html). Purchased credits expire 12 months after the purchase date. If a workspace runs out of credits, Loops pause unless an admin purchases more credits or enables auto top-ups. Workspaces are charged automatically only when auto top-ups are enabled.

**Promotional Loops AI credits**

Some workspaces may receive promotional Loops AI credits with separate expiration terms. Eligible workspaces will be notified by email.

## FAQ[⁠](https://linear.app/docs/loops.html#faq)

What are the best practices for writing instructions?

Clearly describe the intended outcome and any actions Linear Agent should avoid.

For example:

> Investigate the issue using the available context. Add a comment summarizing the likely cause and recommend the next action. Do not change the issue’s assignee or status.

For best results:

* Use Linear Agent chat to help build your instructions. See [Create loops with Linear Agent](https://linear.app/docs/loops.html#create-loops-with-linear-agent) for guidance.
* Describe the outcome, not only an action
* Specify which context or connected tools Linear Agent should use
* State which changes are permitted

What MCP connectors can loops use?

A loop can only use MCP connectors that are connected to your workspace, enabled for Linear Agent, and allowed by your workspace admins. Access also depends on the loop’s scope and permissions.

When should web access be enabled?

Enable web access only when a loop needs information from external websites.

A good fit is research on public information, like competitor announcements, documentation, or API references, where the loop does not need to send sensitive workspace content to external services.

Enable this intentionally, since allowing external web access can increase the risk of exposing workspace data outside Linear.

How do I use Code Intelligence?

A workspace admin must configure repository access in **Settings → Loops → Allow loops to access code**. In the loop editor, select **Capabilities & access → Access code → Read**. **Read & write** also includes code-reading access.

How do I use Coding Sessions?

A workspace admin must enable coding sessions and allow the required repositories in **Settings → Loops → Allow loops to access code**. In the loop editor, select **Capabilities & access → Access code → Read & write**.

How can I review loop costs and AI credit usage?

Open **Settings → Usage & limits** to review AI credit usage. Loop spend includes the loop’s own work and any coding sessions it starts. Learn more about [usage and spend limits](https://linear.app/docs/usage-and-limits.html).

If your workspace runs out of AI credits, loops stop running until more credits are added.

Why did I get a loop run failed notification?

To troubleshoot, open the loop’s **Run history** to check recent runs and any visible failures.

Common causes a loop run might fail include missing permissions, untrusted external sources, or your workspace running out of AI credits.

To get a more detailed description of what went wrong, you can also ask Linear. Press ⌘/Ctrl + J while looking at the run history and ask for a detailed description of why the loop run failed.

Can I run a loop manually?

You can use Run now for enabled loops that use Linear Agent and have a schedule, issue, project, or initiative trigger.

For issue, project, and initiative triggers, choose the entity you want to use for the run. Run now is not available for cycle triggers.

Run now is not available for pull request triggers. These loops run when a matching pull request event occurs.

What schedules can loops use?

Scheduled loops can run hourly, daily, weekly, monthly, or yearly. Choose the timezone and when the loop should first run.

Weekly schedules can run on one or more days of the week. The first run date cannot be in the past.

How do I enable or disable a loop?

Right-click on the loop from either the workspace or team loop view and select **Enable** or **Disable.**

How do triage loops work?

Triage loops are created for a specific team and require triage to be enabled for that team. They run when an issue enters the team’s triage queue and begins matching the configured conditions.

Triage loops do not support schedules or non-issue triggers.

Are there limits on loops?

Teams can create up to 100 loops, and workspaces can create up to 500 workspace-level loops. Each person can keep up to 100 unpublished loop drafts.

Loop names can be up to 64 characters, and descriptions can be up to 255 characters. A loop can include up to eight conditions.

What happens when I delete a loop?

Deleting a loop is permanent and cannot be undone. Consider disabling the loop instead if you may need to restore it in the future.

When does a loop with configured conditions run?

A loop triggered when conditions start matching runs when an item begins matching those conditions. Further updates do not trigger another run while the same conditions remain matched.

Event-triggered loops run whenever the selected event occurs and any configured filters match. For example, adding the **QA Test** label can trigger a run even if other labels on the pull request have not changed.

[Previous

Linear Agent](https://linear.app/docs/linear-agent.html)[Next

AI Agents](https://linear.app/docs/agents-in-linear.html)

* [Overview](https://linear.app/docs/loops.html#overview)
* [Example loops](https://linear.app/docs/loops.html#example-loops)
* [Investigate and delegate bug reports](https://linear.app/docs/loops.html#investigate-and-delegate-bug-reports)
* [Summarize weekly accomplishments](https://linear.app/docs/loops.html#summarize-weekly-accomplishments)
* [Create platform-specific versions of incoming requests](https://linear.app/docs/loops.html#create-platform-specific-versions-of-incoming-requests)
* [Create user-facing messaging after issues close](https://linear.app/docs/loops.html#create-user-facing-messaging-after-issues-close)
* [How Linear uses loops](https://linear.app/docs/loops.html#how-linear-uses-loops)
* [Create loops with Linear Agent](https://linear.app/docs/loops.html#create-loops-with-linear-agent)
* [Create loops manually](https://linear.app/docs/loops.html#create-loops-manually)
* [Create from a prompt](https://linear.app/docs/loops.html#create-from-a-prompt)
* [Start from a template](https://linear.app/docs/loops.html#start-from-a-template)
* [Workspace templates](https://linear.app/docs/loops.html#workspace-templates)
* [Pull request triggers](https://linear.app/docs/loops.html#pull-request-triggers)
* [Update loops](https://linear.app/docs/loops.html#update-loops)
* [Review a loop's runs](https://linear.app/docs/loops.html#review-a-loop's-runs)
* [Restore a previous version](https://linear.app/docs/loops.html#restore-a-previous-version)
* [Slack message triggers](https://linear.app/docs/loops.html#slack-message-triggers)
* [Use Slack with loops](https://linear.app/docs/loops.html#use-slack-with-loops)
* [What loops can do in Slack](https://linear.app/docs/loops.html#what-loops-can-do-in-slack)
* [Slack access and limitations](https://linear.app/docs/loops.html#slack-access-and-limitations)
* [MCP connectors](https://linear.app/docs/loops.html#mcp-connectors)
* [Managing available Connectors](https://linear.app/docs/loops.html#managing-available-connectors)
* [MCP approvals](https://linear.app/docs/loops.html#mcp-approvals)
* [Setup](https://linear.app/docs/loops.html#setup)
* [Capabilities & access](https://linear.app/docs/loops.html#capabilities-and-access)
* [Team access](https://linear.app/docs/loops.html#team-access)
* [Reasoning level](https://linear.app/docs/loops.html#reasoning-level)
* [Web access](https://linear.app/docs/loops.html#web-access)
* [Access code](https://linear.app/docs/loops.html#access-code)
* [Externally synced issues and comments](https://linear.app/docs/loops.html#externally-synced-issues-and-comments)
* [External sources](https://linear.app/docs/loops.html#external-sources)
* [Allow changes outside of triggering entity](https://linear.app/docs/loops.html#allow-changes-outside-of-triggering-entity)
* [AI credits](https://linear.app/docs/loops.html#ai-credits)
* [FAQ](https://linear.app/docs/loops.html#faq)
