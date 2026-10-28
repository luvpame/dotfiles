---
title: "Concepts – Linear Docs"
source_url: "https://linear.app/docs/conceptual-model"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started

  + [![Start Guide](https://webassets.linear.app/images/ornj730p/production/cdcefdd220c8e2e8eb7c912375014aa15d614ae3-16x16.svg?q=95&auto=format&dpr=2)Start Guide](tutorials.html)
  + [![Concepts](https://webassets.linear.app/images/ornj730p/production/ee14be7f55be005cf38b6f9c9d8e9fa20a78c561-16x16.svg?q=95&auto=format&dpr=2)Concepts](conceptual-model.html)
  + [![Download Linear](https://webassets.linear.app/images/ornj730p/production/aebd535cb7e6a2ded134f41574d0495431a2299f-16x16.svg?q=95&auto=format&dpr=2)Download Linear](get-the-app.html)
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

# Concepts

Linear is built around a few core concepts that provide rails for your organization’s work, from a simple bug fix to a company-wide initiative.

![Linear interface showing active issues page](https://webassets.linear.app/images/ornj730p/production/a6643535918840dfdc1e41e4515ef1fdde3fb59d-2820x1352.png?w=1440&q=95&auto=format&dpr=2)

## Basic concepts[⁠](https://linear.app/docs/conceptual-model.html#basic-concepts)

### Issues[⁠](https://linear.app/docs/conceptual-model.html#issues)

Issues are the fundamental unit of work in Linear. They represent anything a team needs to track, such as bugs, feature work, follow-up tasks, or internal requests.

An issue belongs to a team and moves through that team’s workflow. It can be assigned to a person, added to a project, planned into a cycle, labeled, prioritized, and discussed in comments.

In practice, most day-to-day work in Linear starts with an issue.

Read more on [creating issues](https://linear.app/docs/creating-issues.html).

#### Workflows[⁠](https://linear.app/docs/conceptual-model.html#workflows)

As you work on and complete issues, they’ll move through workflows; a group of ordered issue statuses defined per-team. These are the statuses that you’ll see group issues on list views and show up as column headers on boards. We create a default workflow for you that you can further customize in Team Settings.

Read more about [issue statuses](https://linear.app/docs/issue-property.html#issue-status).

#### Triage[⁠](https://linear.app/docs/conceptual-model.html#triage)

Triage is the process of reviewing new work and deciding what should happen next. Teams often use it to evaluate incoming issues before they are scheduled, assigned, or prioritized.

Depending on the team’s workflow, triage may involve:

* clarifying the problem
* deciding whether the work should be tracked
* assigning ownership
* setting priority
* moving the issue into the appropriate next status

Triage helps ensure new work is reviewed intentionally instead of getting lost in the backlog.

Read more on [triage](https://linear.app/docs/triage.html).

### Teams[⁠](https://linear.app/docs/conceptual-model.html#teams)

Teams are the primary organizational unit in Linear. Each team owns its own workflow, triage process, and planning cadence.

A team can define:

* its workflow statuses
* its cycles
* its labels and other conventions
* the set of issues it owns

Teams can also be structured into parent teams and sub-teams. Sub-teams can inherit certain settings from a parent team, such as workflow configuration, cycles, or labels, depending on how the team structure is set up. This helps related groups stay aligned while still allowing each team to work independently where needed.

Read more on [teams](https://linear.app/docs/teams.html) and [sub-teams](https://linear.app/docs/sub-teams.html).

### Workspace[⁠](https://linear.app/docs/conceptual-model.html#workspace)

A Linear workspace is the container for all issues, teams and other concepts relating to an individual company. As a user, you can have accounts on one or many workspaces and can switch between these accounts using the dropdown menu in the top left-hand corner of the application. Workspaces each have a unique URL in the style linear.app/example. When you log into Linear, you’re logging into a specific workspace.

Read more on [workspaces](https://linear.app/docs/workspaces.html).

## Organizing work[⁠](https://linear.app/docs/conceptual-model.html#organizing-work)

### Projects[⁠](https://linear.app/docs/conceptual-model.html#projects)

Projects group issues together around a shared outcome. They are useful when work spans multiple issues and needs coordination, visibility, and progress tracking.

A project might represent:

* a feature launch
* a customer migration
* a redesign
* a technical investment
* any other body of work that benefits from shared context and milestones

Projects help teams track progress across related issues and communicate status to stakeholders.

Learn more about [projects](https://linear.app/docs/projects.html).

#### Milestones[⁠](https://linear.app/docs/conceptual-model.html#milestones)

Milestones are a concept used to further organize issues inside an individual project. For each project, define milestones in a way that represent meaningful stages of completion for that project, and assign issues in the project to those milestones.

You can filter by milestones in a project, and easily see how close to completion an individual milestone is at a given time based on the issues belonging to that milestone.

### Initiatives[⁠](https://linear.app/docs/conceptual-model.html#initiatives)

Initiatives sit above projects and represent broader strategic efforts. They help organize work at a higher level, especially when several projects contribute to the same goal.

An initiative can contain multiple projects, making it useful for tracking larger efforts that span teams or phases of work. Initiatives can also have parent and sub-initiative relationships, which allows complex work to be broken into smaller strategic areas while still rolling up into a larger objective.

Use initiatives when the question is not just what the team is shipping, but why the work matters and how multiple efforts connect.

Read more on [initiatives](https://linear.app/docs/initiatives.html) and [sub-initiatives](https://linear.app/docs/sub-initiatives.html).

### Cycles[⁠](https://linear.app/docs/conceptual-model.html#cycles)

Cycles are a team’s repeating planning period for issues. They help teams decide what to work on in the near term and create a predictable rhythm for execution.

A cycle is typically used to:

* plan a set of issues for a fixed period
* focus the team on current work
* measure delivery over time

Cycles belong to teams, and in some team structures they can be inherited by sub-teams.

Cycles are automated and repeating; you’ll set a start date and duration for cycles, which will then repeat every *N* weeks*.*

Read more on [cycles](https://linear.app/docs/use-cycles.html).

### Views[⁠](https://linear.app/docs/conceptual-model.html#views)

Views are different ways of looking at the same underlying work. They do not change the work itself—they help teams organize and focus it.

A view might show:

* all issues assigned to a person
* work in a specific project
* issues in the current cycle
* a team backlog
* filtered work across multiple teams

Views make it easier to move between personal execution, team planning, and broader coordination.

Read more on [custom views](https://linear.app/docs/custom-views.html).

## How these concepts fit together[⁠](https://linear.app/docs/conceptual-model.html#how-these-concepts-fit-together)

The way to think about Linear is:

* issues track individual pieces of work
* teams own the workflows those issues move through
* cycles help teams plan short-term work
* projects organize related issues around a deliverable
* initiatives organize related projects around a broader goal
* views help people navigate all of the above

[Previous

Start Guide](https://linear.app/docs/tutorials.html)[Next

Download Linear](https://linear.app/docs/get-the-app.html)

* [Basic concepts](https://linear.app/docs/conceptual-model.html#basic-concepts)
* [Issues](https://linear.app/docs/conceptual-model.html#issues)
* [Workflows](https://linear.app/docs/conceptual-model.html#workflows)
* [Triage](https://linear.app/docs/conceptual-model.html#triage)
* [Teams](https://linear.app/docs/conceptual-model.html#teams)
* [Workspace](https://linear.app/docs/conceptual-model.html#workspace)
* [Organizing work](https://linear.app/docs/conceptual-model.html#organizing-work)
* [Projects](https://linear.app/docs/conceptual-model.html#projects)
* [Milestones](https://linear.app/docs/conceptual-model.html#milestones)
* [Initiatives](https://linear.app/docs/conceptual-model.html#initiatives)
* [Cycles](https://linear.app/docs/conceptual-model.html#cycles)
* [Views](https://linear.app/docs/conceptual-model.html#views)
* [How these concepts fit together](https://linear.app/docs/conceptual-model.html#how-these-concepts-fit-together)
