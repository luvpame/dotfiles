---
title: "Exporting Data – Linear Docs"
source_url: "https://linear.app/docs/exporting-data"
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

# Exporting Data

Export your workspace data using built-in tools, integrations, or the API

![Export issues as CSV option displayed after clicking on the overflow menu on a custom view](https://webassets.linear.app/images/ornj730p/production/8467997bef5508113d3245730f68905602daebc2-1186x687.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/exporting-data.html#overview)

Export data from your workspace to build custom reports, keep records, or input into LLMs.

### Workspace CSV exports[⁠](https://linear.app/docs/exporting-data.html#workspace-csv-exports)

Workspace admins can export this data. On Enterprise plans, only owners can do this. Export workspace issue data in CSV format from [Settings > Administration > Import Export](https://linear.app/settings/import-export.html) and click **Export data** at the bottom. There is a toggle option to include private teams, if any. This export action is recorded in the audit log.

Once the export is ready, we’ll email you a download link. The link expires after 12 hours.

This export contains the following fields for each issue: *ID, Team, Title, Description, Status, Estimate, Priority, Project ID, Project, Creator, Assignee, Labels, Cycle Number, Cycle Name, Cycle Start, Cycle End, Created, Updated, Started, Triaged, Completed, Canceled, Archived, Due Date, Parent issue, Initiatives, Project Milestone ID, Project Milestone, SLA Status*

## Member list CSV exports[⁠](https://linear.app/docs/exporting-data.html#member-list-csv-exports)

Workspace admins can export this data. On Enterprise plans, only owners can do this. Export the list of members in CSV format from your [Settings > Administration > Members](https://linear.app/settings/members.html) and click **Export CSV** button.

## Issue view CSV exports[⁠](https://linear.app/docs/exporting-data.html#issue-view-csv-exports)

Export a CSV of issues from any issue view, project or issue list using the `Ctrl`/`CMD` + `K` menu. In projects and custom views, this action is also accessible through the dropdown menu pictured.

Members can export up to 250 issues at a time while Admins (Owners, on Enterprise plans) can export views with up to 2,000 issues.

Guest users cannot export issues from a Linear workspace.

Command menuMouse

![Export issues as CSV on the command menu](https://webassets.linear.app/images/ornj730p/production/8464b391e1fac11411e5269b47710611af695c60-1476x786.png?w=1440&q=95&auto=format&dpr=2)

* When in projects or custom views, click the project or view name and choose “Export issues as CSV…” from the dropdown.

![Export issues as a CSV option selected on overflow menu of a project](https://webassets.linear.app/images/ornj730p/production/24537d04edd782a6d2ccc69516ee9c1dc522a815-1106x1586.png?w=1440&q=95&auto=format&dpr=2)

This export contains the following fields for each issue: *ID, Team, Title, Description, Status, Estimate, Priority, Project ID, Project, Creator, Assignee, Labels, Cycle Number, Cycle Name, Cycle Start, Cycle End, Created, Updated, Started, Triaged, Completed, Canceled, Archived, Due Date, Parent issue, Initiatives, Project Milestone ID, Project Milestone, SLA Status*

CSV exports don’t include attachment files. Links to attachments may appear in exported issue descriptions.

## Copy issues as markdown for LLMs[⁠](https://linear.app/docs/exporting-data.html#copy-issues-as-markdown-for-llms)

Copy issues and documents as Markdown with `Cmd Opt C`, or from the command menu. When copying an issue, this command captures its full context — including title, description, comments, and customer requests — in a structured format for use in AI chat tools.

Copy multiple issues at once by selecting them on a list or a board and using the same command.

## Export individual issues as PDFs[⁠](https://linear.app/docs/exporting-data.html#export-individual-issues-as-pdfs)

If you need to save an individual issue as a PDF, open the Print dialog (`Cmd`/`Ctrl` + `P`) while viewing the issue and save it as a PDF. On doing this, we’ll automatically change the timestamps on each issue event from relative to absolute, which can be helpful if your auditors require seeing precise timestamps for each event on an issue.

## Project and Initiative list CSV exports[⁠](https://linear.app/docs/exporting-data.html#project-and-initiative-list-csv-exports)

Export a project or an initiative view as a CSV. This export type is available to members and admins. Please note if you attempt to export from the issues page of a project you will be exporting issues, not the project itself.

Members can export up to 200 projects or initiatives at a time.

Command menuMouse

To export only one project or initiative, select just that single project before opening the `Cmd` + `K` menu.

![Export projects as CSV through the command menu](https://webassets.linear.app/images/ornj730p/production/2fb7d05534506c42b04b097f7ccd2923fbf9dcfa-1158x556.png?w=1440&q=95&auto=format&dpr=2)

![dropdown menu on a project view showing export projects as csv](https://webassets.linear.app/images/ornj730p/production/bace1f1cbbfd97b043e57d17ccf95074468e3ed9-884x562.png?w=1440&q=95&auto=format&dpr=2)

For projects, CSV exports contain: *Name, Summary, Status, Milestones, Creator, Lead, Members, Created At, Started At, Target Date, Completed At, Canceled At, Teams, Initiatives*

For initiatives, CSV exports contain: *Name, Description, Details, Status, Creator, Owner, Target Date, Created At, Started At, Completed At, Projects, Teams, Health, Latest Update, Latest Update Date*

## Customer request CSV exports[⁠](https://linear.app/docs/exporting-data.html#customer-request-csv-exports)

Export customer requests associated with an issue, project, or customer by opening the command menu and selecting **Export customer requests as CSV…**. This option is available when customer requests exist.

## Integrations[⁠](https://linear.app/docs/exporting-data.html#integrations)

Use [Airbyte](https://linear.app/docs/airbyte.html) or [Google Sheets](https://linear.app/docs/google-sheets.html) to sync Linear data for reporting. Google Sheets supports issues, projects, and initiatives from public teams. If you’re interested in exporting data for analysis, consider using [Insights](https://linear.app/docs/insights.html) as well for in-product reporting.

## API[⁠](https://linear.app/docs/exporting-data.html#api)

You can also export data from issues, projects and more using our [API](https://studio.apollographql.com/public/Linear-API/variant/current/schema/reference), or work with Linear data using [webhooks](https://developers.linear.app/docs/graphql/webhooks).

## FAQ[⁠](https://linear.app/docs/exporting-data.html#faq)

Can I export teams?

No, there isn’t a CSV export for teams. If you need to move teams between workspaces, you can [import](https://linear.app/docs/import-issues.html#linear) them from one Linear workspace to another.

[Previous

Usage & limits](https://linear.app/docs/usage-and-limits.html)[Next

Import Guide](https://linear.app/docs/import-issues.html)

* [Overview](https://linear.app/docs/exporting-data.html#overview)
* [Workspace CSV exports](https://linear.app/docs/exporting-data.html#workspace-csv-exports)
* [Member list CSV exports](https://linear.app/docs/exporting-data.html#member-list-csv-exports)
* [Issue view CSV exports](https://linear.app/docs/exporting-data.html#issue-view-csv-exports)
* [Copy issues as markdown for LLMs](https://linear.app/docs/exporting-data.html#copy-issues-as-markdown-for-llms)
* [Export individual issues as PDFs](https://linear.app/docs/exporting-data.html#export-individual-issues-as-pdfs)
* [Project and Initiative list CSV exports](https://linear.app/docs/exporting-data.html#project-and-initiative-list-csv-exports)
* [Customer request CSV exports](https://linear.app/docs/exporting-data.html#customer-request-csv-exports)
* [Integrations](https://linear.app/docs/exporting-data.html#integrations)
* [API](https://linear.app/docs/exporting-data.html#api)
* [FAQ](https://linear.app/docs/exporting-data.html#faq)
