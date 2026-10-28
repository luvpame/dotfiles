---
title: "How to use Linear: Startups & mid-size companies – Linear Docs"
source_url: "https://linear.app/docs/how-to-use-linear-startups-mid-size-companies"
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

# How to use Linear: Startups & mid-size companies

Linear is best paired with our philosophy on how teams should work, [The Linear Method](https://linear.app/method.html). We are building Linear to support the core elements of the software development lifecycle: Planning and Building exceptional products.

**This guide**

* **Is tailored for:** admins and leaders at medium sized companies, like early-stage startups and growth companies
* **And covers:** how to set up your Linear workspace, and make the most of Linear’s features.

## Setting up your workspace[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#setting-up-your-workspace)

### **Plan recommendation**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#plan-recommendation)

Our Business Plan provides unlimited teams and members, unlimited Issues and uploads, and advanced features.

You should consider the Enterprise Plan if:

* You need to connect your [SAML](https://linear.app/docs/saml-and-access-control.html) and [SCIM](https://linear.app/docs/scim.html) provider to manage logins and user provisioning
* You have advanced security needs, like HIPAA Compliance and want to control which third-party applications can plug into your Linear workspace
* You want to consolidate your data warehouses, lakes, and databases via Airbyte

**For Admins**: If you are setting up Linear on our Enterprise Plan please refer to this guide: [How to use Linear: Large & scaling companies](https://linear.app/docs/how-to-use-linear-large-scaling-companies.html)

### Key integrations to setup:[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#key-integrations-to-setup:)

* [GitHub](https://linear.app/integrations/github.html) & [GitLab](https://linear.app/integrations/gitlab.html): to automate status updates and review PRs in Linear
* [Slack](https://linear.app/docs/slack.html): create issues from Slack and share project updates
* [Figma](https://linear.app/integrations/figma.html)**:** link issues directly from Figma, and embed your designs
* [Zendesk](https://linear.app/docs/zendesk.html), [Intercom](https://linear.app/docs/intercom.html), or [Front](https://linear.app/docs/front.html)**:** create issues from support tickets

↳ [See all integrations](https://linear.app/integrations.html)

### Enable Issue Triage[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#enable-issue-triage)

[Triage](https://linear.app/docs/triage.html) is a shared inbox that captures incoming new issues such as bug reports, feature requests, and other unplanned work. Triage is enabled at the team level and acts as a first checkpoint to ensure that every issue is properly assigned and prioritized before it is added to the team’s workflow.

This centralized intake mechanism allows everyone in your organization to quickly create new issues without needing to worry about where they belong in your Linear workspace — particularly helpful for customer-facing teams such as Support or Sales who frequently report bugs or feature requests from users.

Integrations with tools such as Slack, Intercom, or Zendesk (where unplanned work typically first surfaces) can be configured to automatically route new issues directly to the most relevant triage queue.

Larger teams can enhance Triage with additional workflows:

* Configure [triage responsibility](https://linear.app/docs/triage.html#triage-responsibility) rotations by linking your on-call schedule to automatically assign a triage owner, who is responsible for reviewing issues that are added to the triage queue
* [Triage intelligence](https://linear.app/docs/product-intelligence.html) can apply the necessary properties to issues, or deduplicate them against existing issues.
* Set deterministic [Triage rules](https://linear.app/docs/triage.html#triage-rules) for automations you’d like to occur every time an issue meeting certain criteria hits triage.
* [Use SLAs](https://linear.app/docs/sla.html) — service level agreements — to set guidance for when time-sensitive issues should be completed
* Enable [Linear Asks](https://linear.app/docs/linear-asks.html) to streamline workplace requests from Slack

Looking for inspiration? [Here’s a rundown of how we use Triage at Linear](https://linear.app/blog/planning-for-unplanned-work.html)

### **Set up Linear Asks**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#set-up-linear-asks)

[Asks](https://linear.app/docs/linear-asks.html) lets everyone in your Slack workspace turn requests such as bug reports, questions, and IT needs into actionable issues in Linear. Teams can submit requests directly from Slack and automatically send them to the relevant team in Linear. Useful for tracking bugs, logging customer feedback, or simply making a request to another team at your company — such as a request for data, or design mock ups for a marketing campaign.

↳ [Configure Linear Asks](https://linear.app/docs/linear-asks.html)

### **Organizing Teams**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#organizing-teams)

Mimic your org chart and establish teams by function — such as Engineering, Design, and Marketing — and use [Sub-teams](https://linear.app/docs/sub-teams.html) to reflect specialized teams under those, like backend or frontend development, or a team working on a specific feature.

![Sub-teams](https://webassets.linear.app/images/ornj730p/production/533d9155ce1ddbfc57cd0bc273537c5445675781-1148x467.png?w=1440&q=95&auto=format&dpr=2)

Invite your team to the workspace via a unique link, email, or bulk CSV upload.

↳ Doc: [Learn more about Teams](https://linear.app/docs/teams.html)

**Top tip**: [Share this with your team once added to help them spin up on Linear](https://linear.app/docs/joining-your-team-on-linear.html)

### **Configure workflows**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#configure-workflows)

While standardized workflows in Linear enhance scalability and consistency across your organization, we understand that each team needs a certain level of autonomy to succeed.

| **At the workspace level, admins can control:** | **While members can customize their team settings:** |
| --- | --- |
| * [Statuses](https://linear.app/docs/project-status.html) to show the progress of each project * [Updates](https://linear.app/docs/project-updates.html) for Initiatives and Projects * Workspace templates for [Issues](https://linear.app/docs/issue-templates.html), [Projects](https://linear.app/docs/project-templates.html) and [Documents](https://linear.app/docs/project-documents.html#create-document-templates) | * [Statuses](https://linear.app/docs/issue-property.html#configure-statuses) that your Issues will move through * Team templates for [Issues](https://linear.app/docs/issue-templates.html), [Projects](https://linear.app/docs/project-templates.html) and [Documents](https://linear.app/docs/project-documents.html#create-document-templates) for more specific requirements * Custom [labels](https://linear.app/docs/labels.html) to categorize specific Issues. Labels can also be created at the workspace level for common Issues, like bugs * [Estimates](https://linear.app/docs/estimates.html) to describe the complexity or size of an Issue * Schedules for sprint-like structures called [Cycles](https://linear.app/docs/use-cycles.html) * Configure [status updates](https://linear.app/docs/github.html#issue-status-updates) to linked issues when updates are made to PRs |
| These help with visibility across the organization by ensuring that all inputs feeding up to leadership use the same framework. | This flexibility allowed teams to work in ways that suited their unique needs while still fitting into the broader company structure. |

## Migrating to Linear[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#migrating-to-linear)

Once you’ve got your teams set up in Linear, it’s time to start bringing over work from your other tools. Whether you’ve chosen to adopt Linear as your primary issue tracking and project management tool, or you’re integrating it alongside existing tools, data imports and synchronization are essential.

**Importing**

* Use the [Importer](https://linear.app/docs/import-issues.html) to pull in-flight issues into Linear and map them to appropriate teams. Linear offers native importers for GitHub Issues, Jira, Asana, Shortcut, and Trello.
* Alternatively, you can import a CSV with issue data

**Syncing**

* Sync issues with [Jira](https://linear.app/docs/jira.html) and [GitHub](https://linear.app/docs/github.html#github-issues-sync) while trialing or transitioning to Linear to keep projects up to date across tools

Follow our detailed [migration guide](https://linear.app/switch.html) for step-by-step instructions.

## Planning[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#planning)

Linear brings planning and building together into one tool, eliminating the disconnect between strategy and execution. By keeping plans and progress in sync, teams maintain clear visibility while spending less time updating status reports and more time delivering value.

Linear offers several objects to track higher-level strategic goals (Initiatives), deliverables that roll up to them (Projects), and important progress stages (Milestones).

### **Using Initiatives, Projects, and Milestones**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#using-initiatives-projects-and-milestones)

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

### Assign a lead[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#assign-a-lead)

Each Project and Initiative should have a lead, responsible for maintaining momentum, ensuring accountability, and preventing work from falling through the cracks. Project Leads don’t have to be team leads — they can be anyone best suited for the project.

### Draft the specification[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#draft-the-specification)

Initiative and [Project Overview](https://linear.app/docs/projects.html) pages act as container for all the related information - documents, customer discovery notes, and designs.

![Project overview](https://webassets.linear.app/images/ornj730p/production/d9970576bed3615e3124981bbb85a0a80e2aa1b7-1832x1784.png?w=1440&q=95&auto=format&dpr=2)

You can create [Documents](https://linear.app/docs/project-documents.html) at the Initiative and Project level. They can be used for tracking meeting notes, drafting PRDs, or expanding on certain aspects of the project.

## **Building**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#building)

### **Using Issues**[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#using-issues)

Issues are the atomic unit in Linear. They represent a specific piece of work, such as a task or bug, that has a clear output and might take anywhere from a few minutes to an hour or a day.

We’ve designed them to be zero-friction. Issues take seconds to create, which counterintuitively means your team will log additional bug reports and share ideas more frequently while spending *less* time in the tool.

Each issue has [configurable properties](https://linear.app/docs/issue-properties.html):

* Categorized using labels
* Linked by relationships, such as *blocking*, *related*, or *duplicate*
* Assigned a due date and priority score
* Estimated in magnitude

You can create [recurring issues](https://linear.app/docs/creating-issues.html#create-recurring-issues) to automate your repeated tasks on a cadence of your choosing.

**Top tip**: You can create [sub-issues](https://linear.app/docs/parent-and-sub-issues.html) when a set of work is too large to be a single issue but too small to be a project. Sub-issues also ideal for splitting up work shared across teammates. When you add a sub-issue to another issue, the other issue becomes its “parent.”

↳ Doc: [Learn more about Issues](https://linear.app/docs/creating-issues.html)

### Working in Cycles[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#working-in-cycles)

If you’re accustomed to working in sprints, [Cycles](https://linear.app/docs/use-cycles.html) offer a similar time-boxed structure but with automation at their core. They repeat automatically, roll unfinished work forward, and help you to build a clear picture of your [team’s true capacity](https://linear.app/docs/use-cycles.html#cycle-capacity) without introducing planning overhead.

## Understanding progress[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#understanding-progress)

### Updates[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#updates)

Both Projects and Initiatives include an [Updates](https://linear.app/docs/project-updates.html) feature. Leads will receive reminders from Linear to provide updates at regular intervals. These updates, along with progress tracking (On track, At risk, Off track), can be configured to post in Slack with bi-directional comment syncing — enabling you to keep the broader organization informed.

![Updates schedule](https://webassets.linear.app/images/ornj730p/production/e29e93134992c6ab6ef12509ad49c95b20cea06c-3312x1732.tif?w=1440&q=95&auto=format&dpr=2)

As Projects progress, they move through [statuses](https://linear.app/docs/project-status.html) that you can configure at the workspace level.

![Project status](https://webassets.linear.app/images/ornj730p/production/42b6cd5957a5374626fbbd7106bf0833e28280f6-3312x1820.tif?w=1440&q=95&auto=format&dpr=2)

Built-in [Project Graphs](https://linear.app/docs/project-graph.html) help you understand the progress your team is making towards completion, and offers estimates for when you’ll finish.

![Project graph](https://webassets.linear.app/images/ornj730p/production/1583151e675c8ebcd8b2fd926362a15f4f407ea7-2880x1928.tif?w=1440&q=95&auto=format&dpr=2)

### Go deeper with custom views and Insights[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#go-deeper-with-custom-views-and-insights)

[Custom views](https://linear.app/docs/custom-views.html) enable you to create filtered views of issues or projects that you can save and share with others in your workspace. They can be private, available to everyone, or visible per team. They are particularly useful to see issues across multiple teams, projects, or a single label, like `label:bug`.

Views at the project level enable you to visualize progress in timelines, by progress, or status (n Track, At Risk, Off Track).

![Project timeline](https://webassets.linear.app/images/ornj730p/production/6a5478c3bc2de4eae7b848954548c9ddb2b0f53c-4460x2868.png?w=1440&q=95&auto=format&dpr=2)

### Insights[⁠](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#insights)

[Insights](https://linear.app/docs/insights.html) come attached to every view in Linear, turning the data into visual reports that highlight trends, bottlenecks, and opportunities across your workspace.

Use them to:

* Track resource allocation across Projects
* Measure bug resolution speed and trends
* Evaluate estimation accuracy
* Retro cycle times to improve predictability
* Identify bottlenecks and blocking dependencies

#

* [Setting up your workspace](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#setting-up-your-workspace)
* [Plan recommendation](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#plan-recommendation)
* [Key integrations to setup:](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#key-integrations-to-setup:)
* [Enable Issue Triage](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#enable-issue-triage)
* [Set up Linear Asks](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#set-up-linear-asks)
* [Organizing Teams](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#organizing-teams)
* [Configure workflows](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#configure-workflows)
* [Migrating to Linear](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#migrating-to-linear)
* [Planning](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#planning)
* [Using Initiatives, Projects, and Milestones](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#using-initiatives-projects-and-milestones)
* [Assign a lead](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#assign-a-lead)
* [Draft the specification](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#draft-the-specification)
* [Building](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#building)
* [Using Issues](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#using-issues)
* [Working in Cycles](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#working-in-cycles)
* [Understanding progress](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#understanding-progress)
* [Updates](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#updates)
* [Go deeper with custom views and Insights](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#go-deeper-with-custom-views-and-insights)
* [Insights](https://linear.app/docs/how-to-use-linear-startups-mid-size-companies.html#insights)
