---
title: "Members and roles – Linear Docs"
source_url: "https://linear.app/docs/members-roles"
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

  + [![Workspaces](https://webassets.linear.app/images/ornj730p/production/5fbe479163f634cafc305ef4b07cbb6eac5bfa08-16x16.svg?q=95&auto=format&dpr=2)Workspaces](workspaces.html)
  + [![Teams](https://webassets.linear.app/images/ornj730p/production/41309383510a94f0087966d54e90ebc64a177f39-16x16.svg?q=95&auto=format&dpr=2)Teams](teams.html)
  + [![Team pages](https://webassets.linear.app/images/ornj730p/production/2012b5ca81b9d3cde72bae4c743a14d57b500d68-16x16.svg?q=95&auto=format&dpr=2)Team pages](default-views.html)
  + [![Private teams](https://webassets.linear.app/images/ornj730p/production/f95a05604aad31f7e01466ae03897777d1d2a218-16x16.svg?q=95&auto=format&dpr=2)Private teams](private-teams.html)
  + [![Sub-teams](https://webassets.linear.app/images/ornj730p/production/b2e524167129b68e4be926d18dff3d57b050e25c-16x16.svg?q=95&auto=format&dpr=2)Sub-teams](sub-teams.html)
  + [![Login methods](https://webassets.linear.app/images/ornj730p/production/eb030e6addf44b757dcd01b7130fb3020c1e9074-16x16.svg?q=95&auto=format&dpr=2)Login methods](login-methods.html)
  + [![Invite members](https://webassets.linear.app/images/ornj730p/production/4a6d4dcd329012bcb08d42c0e6138e1192c5a4d8-16x16.svg?q=95&auto=format&dpr=2)Invite members](adding-and-managing-members.html)
  + [![Members and roles](https://webassets.linear.app/images/ornj730p/production/ace5af526ef589f638bb9ece43d455b97c2b9e62-16x16.svg?q=95&auto=format&dpr=2)Members and roles](members-roles.html)
  + [![SAML](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)SAML](saml-and-access-control.html)
  + [![SCIM](https://webassets.linear.app/images/ornj730p/production/d762acc0a6dbea9d803c9e5611c0dbfc86df6746-16x16.svg?q=95&auto=format&dpr=2)SCIM](scim.html)
  + [![API and Webhooks](https://webassets.linear.app/images/ornj730p/production/ea822173f6bf2d9383d19105d9ecaa6693492aca-16x16.svg?q=95&auto=format&dpr=2)API and Webhooks](api-and-webhooks.html)
  + [![Third-Party App Approvals](https://webassets.linear.app/images/ornj730p/production/b61fa1aff4d024cf6dcf0134c2c45b8d76cf0b27-16x16.svg?q=95&auto=format&dpr=2)Third-Party App Approvals](third-party-application-approvals.html)
  + [![Security](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)Security](security.html)
  + [![Audit log](https://webassets.linear.app/images/ornj730p/production/9eccb204815aeb102e7cd5fc3626a61c21f8b1b9-16x16.svg?q=95&auto=format&dpr=2)Audit log](audit-log.html)
  + [![Billing and plans](https://webassets.linear.app/images/ornj730p/production/33fa80412b10a65fd8e38cf5771b09a15670593f-16x16.svg?q=95&auto=format&dpr=2)Billing and plans](billing-and-plans.html)
  + [![AI Credits](https://webassets.linear.app/images/ornj730p/production/40f99550f03177fadfe53645dfad2e238091d67e-16x16.svg?q=95&auto=format&dpr=2)AI Credits](ai-credits.html)
  + [![Usage & limits](https://webassets.linear.app/images/ornj730p/production/c4d004a3952b8f8e45ede10f8756e0eeb5153d10-16x16.svg?q=95&auto=format&dpr=2)Usage & limits](usage-and-limits.html)
  + [![Exporting Data](https://webassets.linear.app/images/ornj730p/production/a62608da795d3e55a196c009713363ff08ef20e6-16x16.svg?q=95&auto=format&dpr=2)Exporting Data](exporting-data.html)
* Importers

# Members and roles

Linear provides several role types to help you control access and permissions across your workspace. Each role gives team members the right level of access—from full administrative control to limited guest visibility.

Please note that on Free plans, all users are Admins.

## Overview[⁠](https://linear.app/docs/members-roles.html#overview)

Users with administrative roles can manage workspace members and their roles from [Settings > Administration > Members](https://linear.app/settings/members.html). This page lists all active and suspended members and allows filtering by role or status (Pending invites, Suspended, or users who have left the workspace).

On Enterprise plans with [SCIM](https://linear.app/docs/scim.html) enabled, some or all member management will be accomplished through your IdP instead of the Members settings page.

## Managing user roles[⁠](https://linear.app/docs/members-roles.html#managing-user-roles)

### Changing a member’s role[⁠](https://linear.app/docs/members-roles.html#changing-a-member's-role)

To update a user’s role:

1. Go to *Settings > Administration > Members* page
2. Hover over a member’s row
3. Click the **overflow menu (⋯)**
4. Select the **Change role...**

### Suspend a member[⁠](https://linear.app/docs/members-roles.html#suspend-a-member)

Administrative roles can suspend a member from the workspace:

1. Go to [Settings > Administration > Members](https://linear.app/settings/members.html)
2. Hover over a member’s row
3. Click on the **overflow menu (⋯)**
4. Select **Suspend user...**

Suspended users lose all access immediately and are removed from your next billing cycle. They remain visible in the members list for historical purposes—for example, when viewing issues they created or were assigned to.

To view issue activity for a suspended user, visit their profile page at:
`linear.app/<workspace-name>/profiles/<username>`

Admins can access this link from the user’s avatar or by filtering the Members page for **Suspended** users.

### Viewing workspace admins[⁠](https://linear.app/docs/members-roles.html#viewing-workspace-admins)

Any member who needs to quickly identify workspace administrators can:

* Open Command menu `Cmd/Ctrl` `K` and select **View workspace admins**
* Navigate directly to [linear.app/settings/view-admins](https://linear.app/settings/view-admins.html)

## Role types[⁠](https://linear.app/docs/members-roles.html#role-types)

### Workspace owner[⁠](https://linear.app/docs/members-roles.html#workspace-owner)

The workspace owner role is only available on Enterprise plans

Workspace owners have full administrative control, including access to sensitive settings like billing, security, audit logs, workspace exports, and OAuth application approvals and team access management. Admins have more limited permissions for day-to-day workspace management.

For more flexibility, workspace owners can configure which roles can perform certain workspace-level actions in [*Settings > Administration > Security*](https://linear.app/settings/security.html), under Workspace restrictions.

**SCIM-managed workspaces**

Enterprise workspaces with brand new SCIM setups should create a `linear-owners` group to manage workspace owners, in addition to any other role groups described [here](https://linear.app/docs/scim.html#provisioning-roles).

If you are upgrading an existing workspace that uses SCIM to the Enterprise plan, please look at [this article](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html) to understand what actions you need to take.

### Admin[⁠](https://linear.app/docs/members-roles.html#admin)

Admins have elevated permissions to manage routine workspace operations. This role is well-suited for managers, team leads, and operations-focused members.

**Free plan behavior**
All workspace members become admins automatically

**Basic and Business plan behavior**
The user who upgrades the workspace is granted the admin role

**Enterprise plan behavior**Admins will have limited permissions

### Team owner[⁠](https://linear.app/docs/members-roles.html#team-owner)

Available on Business and Enterprise plans

Delegated control over how individual teams are run, without routing every change through workspace owners or admins.

**Configure team owners**

Workspace admins/owners or team owners may:

1. Go to *Team settings > Access and permissions* and adjust settings to be restrictive to team owners only
2. Navigate to *Team settings > Members* to promote members to team owners

There is no limit to the number of team owners a team can have, and teams are not required to have a team owner.

**Who are team owners?**

* *Workspace admins and owners* are automatically team owners for all teams they can access. For any newly created team, the creator becomes a team owner by default
* Any team member can be promoted to team owner by an existing team owner or a workspace admin/owner
* Team owners in the parent team are team owners in the sub-teams
* Guests cannot be team owners

**Team owner only operations**

Certain critical actions are restricted to team owners only:

* Deleting a team
* Making a team private
* Changing a team’s parent

**Configurable permissions**

![Team permissions](https://webassets.linear.app/images/ornj730p/production/2dfa78eee5af719095be345826537353c6d8f27b-1414x748.png?w=1440&q=95&auto=format&dpr=2)

From *Team settings > Access and permissions*, team owners can choose whether to allow all members or only team owners to manage the following:

* **Issue Label Management** - Control who can create and edit team issue labels.
* **Template Management** - Control who can create and edit team templates.
* **Team Settings Management** - Control who can manage workflow statuses, cycles, triage rules, agent guidance, and other team settings.
* **Member Management** - Control who can add new users to the team. Note: Only team owners can add guest users, regardless of this setting.

Permission settings are not inherited from parent team to sub-team.

**Team access**

From *Team settings > Access and permissions*, team owners can also choose to restrict how members can join your team. By default, any member of your workspace can join a non-private team. Team owners now have the option to restrict access to only members they add or invite.

![Team access](https://webassets.linear.app/images/ornj730p/production/10c484efbd8dc5bfd8906dbf176ee9bf046a75e9-1368x496.png?w=1440&q=95&auto=format&dpr=2)

### Member[⁠](https://linear.app/docs/members-roles.html#member)

Members can collaborate across teams they have access to and use all standard workspace features. They **cannot access** workspace-level administration pages.

### Guest[⁠](https://linear.app/docs/members-roles.html#guest)

Guest accounts are only available on Business and Enterprise plans, and are billed as regular members.

Guest accounts grant restricted access to specified teams—ideal for contractors, clients, or cross-company collaborators.

**Guests can**

* Access issues, projects, and documents for the teams they are explicitly added to
* Take the same actions as Members within those teams

**Guests cannot**

* View workspace-wide features such as workspace views, customer requests, or initiatives
* Access settings beyond their own **Account** tab
* Use [Code Intelligence](https://linear.app/docs/code-intelligence.html)

**Sharing projects with guests**

If a project spans multiple teams:

* Guests will only see issues belonging to the teams they’re part of
* They will still see the project shell, but only with their allowed team’s issues visible

**Integration security**

Integrations enabled for the workspace will be accessible to guest users, which could potentially allow them to access Linear data from teams outside those they’re invited to join. To prevent data leakage:

* For Linear-built integrations (GitHub, GitLab, Figma, Sentry, Intercom, Zapier, Airbyte): Ensure guest users don’t have access to your accounts on those services
* For integrations requiring email authentication (Slack, Discord, Front, Zendesk): These should automatically limit access to only issues and data in invited teams — though Slack link previews (unfurls) follow the channel’s visibility and the workspace Unfurls setting, not the viewer’s role.
* For third-party integrations: review access individually or contact the integration provider in the [Integrations directory](https://linear.app/integrations.html).

## FAQ[⁠](https://linear.app/docs/members-roles.html#faq)

What permission will a user get if they are in both admin and owner groups in SCIM?

If a user is in two groups, they will get the permission of the most recent group that was pushed.

[Previous

Invite members](https://linear.app/docs/adding-and-managing-members.html)[Next

SAML](https://linear.app/docs/saml-and-access-control.html)

* [Overview](https://linear.app/docs/members-roles.html#overview)
* [Managing user roles](https://linear.app/docs/members-roles.html#managing-user-roles)
* [Changing a member's role](https://linear.app/docs/members-roles.html#changing-a-member's-role)
* [Suspend a member](https://linear.app/docs/members-roles.html#suspend-a-member)
* [Viewing workspace admins](https://linear.app/docs/members-roles.html#viewing-workspace-admins)
* [Role types](https://linear.app/docs/members-roles.html#role-types)
* [Workspace owner](https://linear.app/docs/members-roles.html#workspace-owner)
* [Admin](https://linear.app/docs/members-roles.html#admin)
* [Team owner](https://linear.app/docs/members-roles.html#team-owner)
* [Member](https://linear.app/docs/members-roles.html#member)
* [Guest](https://linear.app/docs/members-roles.html#guest)
* [FAQ](https://linear.app/docs/members-roles.html#faq)
