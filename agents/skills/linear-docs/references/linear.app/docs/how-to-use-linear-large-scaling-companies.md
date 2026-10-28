---
title: "How to use Linear: Large & scaling companies – Linear Docs"
source_url: "https://linear.app/docs/how-to-use-linear-large-scaling-companies"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# How to use Linear: Large & scaling companies

Linear is designed to support the core elements of the software development lifecycle. For large or rapidly scaling companies, Linear helps increase shipping velocity while keeping work visible.

**This guide is designed for use by admins and owners at large companies on Linear’s Enterprise plan, and covers setting up your workspace and making the most of Linear’s features.**

Not yet using Linear, or have questions? [Contact us](https://linear.app/contact.html).

## Setting up your workspace[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#setting-up-your-workspace)

Establishing effective governance and structure in your Linear workspace is essential for smooth operations. This section outlines key best practices for configuring your workspace to meet enterprise requirements around security, access controls, team organization, and integration management.

### Workspace access management[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-access-management)

#### SAML & SCIM integration[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#saml-and-scim-integration)

For secure, streamlined user management at enterprise scale:

* Connect your Identity Provider using [SAML](https://linear.app/docs/saml-and-access-control.html) for Single Sign-On, enhancing security while simplifying the login experience
* Enable [SCIM](https://linear.app/docs/scim.html) for automated user provisioning/de-provisioning, ensuring access controls remain in sync with your HR systems
* Consider implementing group attribute statements through your Identity Provider for automatic team membership where available

#### User roles and permissions[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#user-roles-and-permissions)

Linear offers permission levels to balance access with security:

| Role | Function |
| --- | --- |
| Workspace Owners | Full control over workspace settings, team configurations, integrations, and billing |
| Workspace Admins | More limited permissions than Owners—ideal for routine workspace management |
| Team Owners | An additional designation available to members. Team owners can take basic administrative actions in the teams they own. The extent of team owner permissions is governed in each team’s settings. Workspace admins and owners are automatically team owners of all teams they belong to. |
| Members | Access to all public content with ability to create and modify issues, but limited from workspace settings |
| Guests | Access restricted to only the specific teams they're invited to join; ideal for contractors or external collaborators |

↳ Doc: [Learn more about roles](https://linear.app/docs/members-roles.html#roles)

## Workspace structure[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-structure)

### Teams[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#teams)

A [Team](https://linear.app/docs/teams.html) in Linear shares issues and projects and follows the same workflows, cycles, and triage processes. Users typically do most of their work out of a few primary teams.

Teams can be structured into a hierarchy using parent and [sub-teams](https://linear.app/docs/sub-teams.html). This relationship enables you to create a hierarchy of teams within Linear, so that it’s easier to understand and manage work across different levels.

![Sub-teams](https://webassets.linear.app/images/ornj730p/production/533d9155ce1ddbfc57cd0bc273537c5445675781-1148x467.png?w=1440&q=95&auto=format&dpr=2)

### Team structure recommendation at scale[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#team-structure-recommendation-at-scale)

Linear’s team hierarchy works best when it mirrors how people actually collaborate and route work. For a 300-person organization, we recommend a small number of top-level teams, each with its own distinct workflows, ownership, and access needs. Use sub-teams only where a group has distinct work, a real privacy boundary, or its own membership to manage.

We generally recommend these top-level teams:

* EPD
  + Sub-team 1: Security
  + Additional sub-teams should represent durable groups with distinct ownership, not initiatives or temporary programs. If it has a clear owner, its own workflow, and ongoing work, it earns a sub-team. Temporary collaboration is handled in Linear projects
* Business Operations
  + Likely no sub-teams needed. Only create sub-teams when groups have distinct ownership and ongoing work
* HR / People
  + Sub-team 1: Recruiting
  + Sub-team 2: HR Help or People Operations
* Legal
  + Sub-team 1: Contracts
  + Sub-team 2: eDiscovery or Legal Requests

*Note: HR and Legal are also strong candidates for private parent teams. Their sub-teams can then be:*

* *Restricted: visible to members of the private parent, who may choose to join.*
* *Private: visible only to people explicitly added to that sub-team.*

*See [Sub-teams](https://linear.app/docs/sub-teams.html) and [Private teams](https://linear.app/docs/private-teams.html).*

The team structure above preserves the valuable part of hierarchy: shared cycles, inherited resources, parent-level views, membership structure, and delegated ownership within each organization. It avoids implying that HR, Legal, and EPD should share the same workflows, cycles, permissions, or parent administration simply because they belong to the same company.

### When to create a new team[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#when-to-create-a-new-team)

Create a team or sub-team when work has one or more of these traits:

* A durable group of people who regularly work together.
* Issues that need clear ownership.
* A distinct workflow, triage process, or cycle cadence.
* A real privacy boundary.
* Dedicated team owners or membership administration.
* A meaningful parent-level reporting or roll-up need.

Use a project, initiative, workspace label, workspace view when something is primarily:

* A program, initiative, or activity spanning multiple teams.
* A temporary body of work.
* A reporting category.

The proposed hierarchy is not inherently too deep everywhere. The issue is that it currently combines unrelated organizations under generic roots and turns some activities into teams. The better model is multiple shallow, intentional hierarchies, each aligned to how that organization works and governs access.

### Team-level permissions[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#team-level-permissions)

These permissions determine who can administer an individual team.

| Permission | What it controls | Parent → sub-team behavior |
| --- | --- | --- |
| Settings management | Team settings, workflows, statuses, and cycles | Configured independently |
| Label management | Creating, updating, and deleting team labels | Configured independently |
| Template management | Team templates and recurring issues | Configured independently |
| Agent skills management | Shared Linear Agent skills | Configured independently |
| Member management | Adding and removing members, excluding guests | Parent establishes a minimum restriction |

For most permissions, teams can choose between All team members and Team owners.

Except for Member management, restricting a permission on the parent only restricts administration of that parent team. For example, setting the parent’s Label management permission to Team owners does not prevent a sub-team from allowing all of its members to manage that sub-team’s labels.

### Where sub-teams retain autonomy[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#where-sub-teams-retain-autonomy)

Sub-teams can opt out of or independently configure several areas: statuses, labels, settings, triage, automations, and integrations.

Sub-teams cannot opt out of:

* A parent-defined cycle schedule.
* The parent’s minimum Member management restriction.
* Required ancestor membership.
* The access boundary of a private parent.
* Parent-owner authority in non-private descendants.

## Workspace-level enforcement[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-level-enforcement)

Workspace security settings provide the global enforcement layer. Depending on the workspace plan, administrators can control:

| Workspace control | Effect |
| --- | --- |
| Team creation | Restricts who can create top-level teams |
| Invitations | Restricts who can invite workspace members |
| Label management | Establishes a workspace-wide minimum role |
| Template management | Establishes a workspace-wide minimum role |
| Automation management | Restricts automation administration |
| Integration creation | Controls who can install integrations |
| API administration | Controls API settings and personal API key creation |
| Imports | Controls who can run imports |
| Agent guidance | Controls who can manage workspace-level agent guidance |

Workspace administrators with team-management authority act as owners across non-private teams. Private teams remain explicit access boundaries, including for administrators who do not have access.

Authentication and security policies—including SSO, SCIM provisioning, permitted authentication methods, domain controls, and IP restrictions—apply across the workspace without team-level overrides.

## Migrating to Linear[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#migrating-to-linear)

Once you’ve got your teams set up in Linear, it’s time to start bringing over work from your other tools. Whether you’ve chosen to adopt Linear as your primary issue tracking and project management tool, or you’re integrating it alongside existing tools, you’ll want to consider your organization’s needs before making the switch.

Learn more about migrating to Linear [here](https://linear.app/switch/migration-guide.html).

### Core integrations[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#core-integrations)

Most organizations install at least one integration from these categories:

* [GitHub](https://linear.app/integrations/github.html) or [GitLab](https://linear.app/integrations/gitlab.html): connect PRs/MRs to Linear. GitHub also unlocks access to [coding sessions](https://linear.app/docs/coding-sessions.html), [code intelligence](https://linear.app/docs/code-intelligence.html), and [reviewing code](https://linear.app/docs/pull-request-reviews.html) in Linear.
* In addition to using Linear Agent in [coding sessions](https://linear.app/docs/coding-sessions.html), consider adding third party background agents like Cursor or Codex.
* [Slack](https://linear.app/docs/slack.html) or [Microsoft Teams](https://linear.app/integrations/microsoft-teams.html): access Linear from your chat tool by mentioning @Linear. Create issues, ask questions about your codebase, or kick off a coding session.
* [Zendesk](https://linear.app/docs/zendesk.html), [Intercom](https://linear.app/docs/intercom.html), or [Front](https://linear.app/docs/front.html): create issues from support tickets
* [incident.io](https://linear.app/integrations/incident-io.html), Pagerduty, or an API-synced schedule: set [Triage responsibility](https://linear.app/docs/triage.html#triage-responsibility) on individual teams

↳ [See all integrations](https://linear.app/integrations.html)

Not seeing what you need in our published integrations? [The Linear API](https://developers.linear.app/docs) and [MCP server](https://linear.app/docs/mcp.html) allow you to connect your existing tools and workflows with Linear. If you have your own custom agent you’d like to use in Linear, check out our [documentation](https://linear.app/developers/agents.html).

### Set up Issue Triage[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#set-up-issue-triage)

[Triage](https://linear.app/docs/triage.html) is a shared inbox that captures incoming new issues such as bug reports, feature requests, and other unplanned work. Triage is enabled at the team level and acts as a first checkpoint to ensure that every issue is properly assigned and prioritized before it is added to the team’s workflow.

This centralized intake mechanism allows everyone in your organization to quickly create new issues without needing to worry about where they belong in your Linear workspace — particularly helpful for customer-facing teams such as Support or Sales who frequently report bugs or feature requests from users.

Integrations with tools such as Slack, Intercom, or Zendesk (where unplanned work typically first surfaces) can be configured to automatically route new issues directly to the most relevant triage queue.

Larger teams can enhance Triage with additional workflows:

* [Triage automations](https://linear.app/docs/triage.html#triage-automations) — kick off a [coding session](https://linear.app/docs/coding-sessions.html) to draft a PR when a bug-labeled issue is reported by an internal user, for instance.
* Configure [triage responsibility](https://linear.app/docs/triage.html#triage-responsibility) rotations by linking your on-call schedule to automatically assign a triage owner, who is responsible for reviewing issues that are added to the triage queue
* Leverage [Triage Intelligence](https://linear.app/docs/product-intelligence.html) to automate the time consuming assessment and routing steps required when triaging issues
* [Use SLAs](https://linear.app/docs/sla.html) — service level agreements — to set guidance for when time-sensitive issues should be completed
* Enable [Linear Asks](https://linear.app/docs/linear-asks.html) to streamline workplace requests from Slack

Looking for inspiration? [Here’s a rundown of how we use Triage at Linear](https://linear.app/blog/planning-for-unplanned-work.html)

### Set up Linear Asks[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#set-up-linear-asks)

[Asks](https://linear.app/docs/linear-asks.html) lets everyone in your Slack workspace turn requests such as bug reports, questions, and IT needs into actionable issues in Linear. Teams can submit requests directly from Slack and automatically send them to the relevant team in Linear. Useful for tracking bugs, logging customer feedback, or simply making a request to another team at your company — such as a request for data, or design mock ups for a marketing campaign.

↳ [Configure Linear Asks](https://linear.app/docs/linear-asks.html)

**Important:** Beyond these core integrations, your team can [request additional third-party apps](https://linear.app/docs/third-party-application-approvals.html). As an admin, you get to control which applications can access your Linear workspace, and set up a review process for integration requests to evaluate security and data access implications.

## Planning[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#planning)

Linear brings planning and building together into one tool, eliminating the disconnect between strategy and execution. By keeping plans and progress in sync, teams maintain clear visibility while spending less time updating status reports and more time delivering value.

Linear offers several objects to track higher-level strategic goals (Initiatives), deliverables that roll up to them (Projects), and important progress stages (Milestones).

### Using Initiatives, Projects, and Milestones[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#using-initiatives-projects-and-milestones)

![Initiatives](https://webassets.linear.app/images/ornj730p/production/2680d360daf1b22b15ed8b1eab84342eb35b9b61-3256x1394.tif?w=1440&q=95&auto=format&dpr=2)

InitiativesProjectsMilestones

[**Initiatives**](https://linear.app/docs/initiatives.html): Designed to plan and manage strategic streams of work that span multiple Projects and longer timelines, such as major launches, product goals, or company-wide objectives. Typically set top-down, leaders use Initiatives to translate company strategy into visible progress by providing a single place for observing relevant Project timelines and updates.

*Examples:*

* *ENG / Launch Enterprise Offering*
* *ENG / Mobile App v2*
* *GTM / Grow Linear’s customer base*

**[Projects](https://linear.app/docs/projects.html):** Enable leads and managers to coordinate work that underpins a company Initiative. They have a clear outcome or completion date, often encompass work from multiple people or teams, and last for several weeks to months.

*Examples:*

* *ENG / New Feature Launch*
* *ENG / Mobile App MVP*
* *Marketing / Customer Story Launch*

**[Project Milestones](https://linear.app/docs/project-milestones.html):** Represent functional goals and deadlines within Projects that the team aims to achieve throughout its lifespan. Issues will be grouped by Milestone within a Project.

*Example*

* *Phases of each project; ex. Brainstorm, Design, Build, QA, Released.*

### Assign a lead[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#assign-a-lead)

Each project and initiative should have a lead, responsible for maintaining momentum, ensuring accountability, and preventing work from falling through the cracks. A lead doesn’t need to be the head of their team — just the person responsible for the delivery of the work.

### Draft the specification[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#draft-the-specification)

Initiative and [Project Overview](https://linear.app/docs/projects.html) pages act as container for all the related information - documents, customer discovery notes, and designs.

![Project overview](https://webassets.linear.app/images/ornj730p/production/d9970576bed3615e3124981bbb85a0a80e2aa1b7-1832x1784.png?w=1440&q=95&auto=format&dpr=2)

You can create [Documents](https://linear.app/docs/project-documents.html) on most objects in Linear like teams, projects, and initiatives. They can be used for tracking meeting notes, drafting PRDs, or storing user research for a particular project.

## Building[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#building)

### Using Issues[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#using-issues)

Issues are the atomic unit in Linear. They represent a specific piece of work, such as a task or bug, that has a clear output and might take anywhere from a few minutes to an hour or a day.

Issues take seconds to create, and has [configurable properties](https://linear.app/docs/issue-properties.html):

* Categorized using labels
* Linked by relationships, such as *blocking*, *related*, or *duplicate*
* Assigned a due date and priority score
* Estimated in magnitude

You can create [recurring issues](https://linear.app/docs/creating-issues.html#create-recurring-issues) to automate your repeated tasks on a cadence of your choosing.

**Top tip:** You can create [sub-issues](https://linear.app/docs/parent-and-sub-issues.html) when a set of work is too large to be a single issue but too small to be a project. Sub-issues also ideal for splitting up work shared across teammates. When you add a sub-issue to another issue, the other issue becomes its “parent.”

↳ Doc: [Learn more about Issues](https://linear.app/docs/creating-issues.html)

## Understanding progress[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#understanding-progress)

### Updates[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#updates)

Both projects and initiatives use [Updates](https://linear.app/docs/project-updates.html) . Leads will receive reminders from Linear to provide updates at regular intervals. These updates, along with progress tracking (On track, At risk, Off track), can be configured to post in Slack with bi-directional comment syncing — enabling you to keep the broader organization informed.

![Updates schedule](https://webassets.linear.app/images/ornj730p/production/e29e93134992c6ab6ef12509ad49c95b20cea06c-3312x1732.tif?w=1440&q=95&auto=format&dpr=2)

As Projects progress, they move through [statuses](https://linear.app/docs/project-status.html) that you can configure at the workspace level.

![Project statuses](https://webassets.linear.app/images/ornj730p/production/42b6cd5957a5374626fbbd7106bf0833e28280f6-3312x1820.tif?w=1440&q=95&auto=format&dpr=2)

Built-in [Project Graphs](https://linear.app/docs/project-graph.html) help you understand the progress your team is making towards completion, and offers estimates for when you’ll finish.

![Project graph](https://webassets.linear.app/images/ornj730p/production/1583151e675c8ebcd8b2fd926362a15f4f407ea7-2880x1928.tif?w=1440&q=95&auto=format&dpr=2)

### Go deeper with custom views and dashboards[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#go-deeper-with-custom-views-and-dashboards)

[Custom views](https://linear.app/docs/custom-views.html) enable you to create filtered views of issues or projects that you can save and share with others in your workspace. They can be private, available to everyone, or visible per team. They are particularly useful to see issues across multiple teams, projects, or a single label, like `label:bug`.

Views at the project level enable you to visualize projects based on their start and target dates.

![Project timeline](https://webassets.linear.app/images/ornj730p/production/6a5478c3bc2de4eae7b848954548c9ddb2b0f53c-4460x2868.png?w=1440&q=95&auto=format&dpr=2)

### Insights and dashboards[⁠](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#insights-and-dashboards)

Open [Insights](https://linear.app/docs/insights.html) on any view in Linear to see visual reports that highlight trends, bottlenecks, and opportunities across your workspace.

Use them to:

* Track resource allocation across projects
* Measure bug resolution speed and trends
* Evaluate estimation accuracy
* Retro cycle times to improve predictability
* Identify bottlenecks and blocking dependencies

Save any insights you’d like to reference regularly to a durable Dashboard. See a demo of dashboards [here](https://www.youtube.com/watch?v=9CcONYjfSms&list=PLP9v0Y4zla9vG7k8e279bSz5hUl0oXlMH&index=7) for more detail.

* [Setting up your workspace](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#setting-up-your-workspace)
* [Workspace access management](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-access-management)
* [SAML & SCIM integration](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#saml-and-scim-integration)
* [User roles and permissions](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#user-roles-and-permissions)
* [Workspace structure](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-structure)
* [Teams](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#teams)
* [Team structure recommendation at scale](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#team-structure-recommendation-at-scale)
* [When to create a new team](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#when-to-create-a-new-team)
* [Team-level permissions](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#team-level-permissions)
* [Where sub-teams retain autonomy](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#where-sub-teams-retain-autonomy)
* [Workspace-level enforcement](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#workspace-level-enforcement)
* [Migrating to Linear](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#migrating-to-linear)
* [Core integrations](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#core-integrations)
* [Set up Issue Triage](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#set-up-issue-triage)
* [Set up Linear Asks](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#set-up-linear-asks)
* [Planning](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#planning)
* [Using Initiatives, Projects, and Milestones](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#using-initiatives-projects-and-milestones)
* [Assign a lead](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#assign-a-lead)
* [Draft the specification](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#draft-the-specification)
* [Building](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#building)
* [Using Issues](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#using-issues)
* [Understanding progress](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#understanding-progress)
* [Updates](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#updates)
* [Go deeper with custom views and dashboards](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#go-deeper-with-custom-views-and-dashboards)
* [Insights and dashboards](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html#insights-and-dashboards)
