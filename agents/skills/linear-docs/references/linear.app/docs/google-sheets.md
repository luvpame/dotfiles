---
title: "Google Sheets – Linear Docs"
source_url: "https://linear.app/docs/google-sheets"
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

  + [![Integration Directory](https://webassets.linear.app/images/ornj730p/production/9b68e0a012db8709a0b436cf9f3e9667e318ae9d-16x16.svg?q=95&auto=format&dpr=2)Integration Directory](integration-directory.html)
  + [![Airbyte](https://webassets.linear.app/images/ornj730p/production/37fa8000e5f87ed22f21256bbbe026370ae93c16-16x16.svg?q=95&auto=format&dpr=2)Airbyte](airbyte.html)
  + [![Discord](https://webassets.linear.app/images/ornj730p/production/c6475146f9bc5a1499c0211e734e36025dc7f974-16x16.svg?q=95&auto=format&dpr=2)Discord](discord.html)
  + [![Figma](https://webassets.linear.app/images/ornj730p/production/39805ebc1087ba353c212f48ca3b2e7810670c7f-16x16.svg?q=95&auto=format&dpr=2)Figma](figma.html)
  + [![Front](https://webassets.linear.app/images/ornj730p/production/3e98d5afaf83119d0934475d6e4168abce295eb4-16x16.svg?q=95&auto=format&dpr=2)Front](front.html)
  + [![GitHub](https://webassets.linear.app/images/ornj730p/production/281c20337377c02a254eed2aaa191c0dfcf0cb8f-16x16.svg?q=95&auto=format&dpr=2)GitHub](github-integration.html)
  + [![GitLab](https://webassets.linear.app/images/ornj730p/production/52b23c9d3b77865a403059dbaea9b187f5edb24a-16x16.svg?q=95&auto=format&dpr=2)GitLab](gitlab.html)
  + [![Google Sheets](https://webassets.linear.app/images/ornj730p/production/9b42494e63e94c3a36ea50357abb89eac48de4b6-16x16.svg?q=95&auto=format&dpr=2)Google Sheets](google-sheets.html)
  + [![Gong](https://webassets.linear.app/images/ornj730p/production/8d8ad9d8e3ff9cb949c365ff2a56e91670b06d7d-16x16.svg?q=95&auto=format&dpr=2)Gong](gong.html)
  + [![Intercom](https://webassets.linear.app/images/ornj730p/production/6043dcf4ee20fb820fa71f17f9d9c99fb38a6244-16x16.svg?q=95&auto=format&dpr=2)Intercom](intercom.html)
  + [![Jira](https://webassets.linear.app/images/ornj730p/production/b4ed29b2721bb179949f9f22d0a90b775eda1d73-16x16.svg?q=95&auto=format&dpr=2)Jira](jira.html)
  + [![Microsoft Teams](https://webassets.linear.app/images/ornj730p/production/9ad8a23671491d788b8da7afceec1ae7278f9d68-16x16.png?q=95&auto=format&dpr=2)Microsoft Teams](microsoft-teams.html)
  + [![Notion](https://webassets.linear.app/images/ornj730p/production/3f74f298541c9330cef4ff4e9e4d881f04a6cac6-16x16.svg?q=95&auto=format&dpr=2)Notion](notion.html)
  + [![Origin](https://webassets.linear.app/images/ornj730p/production/3a9fb15c81c930989690570ed256bebbf4f1ea99-16x16.svg?q=95&auto=format&dpr=2)Origin](origin.html)
  + [![Salesforce](https://webassets.linear.app/images/ornj730p/production/25efb8b0008d88966f8892be5965b1eb1ea5b646-16x16.svg?q=95&auto=format&dpr=2)Salesforce](salesforce.html)
  + [![Sentry](https://webassets.linear.app/images/ornj730p/production/61f628718b18e99cc4b65c9e9197727813646fff-16x16.svg?q=95&auto=format&dpr=2)Sentry](sentry.html)
  + [![Slack](https://webassets.linear.app/images/ornj730p/production/b72b74457ec6124a93ae825b3e10e40ce4dfd314-16x16.svg?q=95&auto=format&dpr=2)Slack](slack.html)
  + [![Zapier](https://webassets.linear.app/images/ornj730p/production/641f65d05b4ad72de980b71a52d92f20c672f7e9-16x16.svg?q=95&auto=format&dpr=2)Zapier](zapier.html)
  + [![Zendesk](https://webassets.linear.app/images/ornj730p/production/bdb234238f4691a632ddf95d34953d3691d1ec23-16x16.svg?q=95&auto=format&dpr=2)Zendesk](zendesk.html)
* Administration
* Importers

# Google Sheets

Use the Google Sheets integration to create custom analytics and dashboards for your company.

![Linear and Google Sheets logos](https://webassets.linear.app/images/ornj730p/production/e72a17743d75cacf18542c1c95122ca4bf4bc5da-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview [⁠](https://linear.app/docs/google-sheets.html#overview)

The Google Sheets integration creates a Google Sheet for your workspace’s issue data, project data, or both, allowing you to build out custom analytics among other uses. The data in these sheets refreshes hourly when changes have been made in your workspace or you can manually refresh.

All issues in public teams in a workspace will be shared to the issues sheet, and all projects belonging to at least one public team will sync to the projects sheet. We do not export data contained only in private teams.

There isn’t a way to select what data is shared to the Google Sheet beyond configuring whether you wish to sync issues, projects, and/or initiatives.

## Configure[⁠](https://linear.app/docs/google-sheets.html#configure)

Go to the [Google Sheets integration settings](https://linear.app/settings/integrations/google-sheets.html) and connect Linear to a Google account. This will automatically create a Google Sheet called *Linear Issues* in your Google Drive. Optionally, also choose to enable new sheets for projects and initiatives.

As this is a workspace setting, you can only connect one account per workspace. To share the data with teammates, update permissions directly on the sheet. If you’re looking for a one-time download, workspace Admins can [export](https://linear.app/settings/import-export.html) a CSV instead.

## Synced data[⁠](https://linear.app/docs/google-sheets.html#synced-data)

### Issues[⁠](https://linear.app/docs/google-sheets.html#issues)

* ID
* Team
* Title
* Description
* Status
* Estimate
* Priority
* Project ID
* Project
* Creator
* Assignee
* Labels
* Cycle Number
* Cycle Name
* Cycle Start
* Cycle End
* Due Date
* Parent issue
* Initiatives
* Project Milestone ID
* Project Milestone
* SLA Status
* Roadmaps
* Created
* Updated
* Started
* Triaged
* Completed
* Canceled
* Archived

### Projects[⁠](https://linear.app/docs/google-sheets.html#projects)

* ID
* Name
* URL
* Summary
* Description
* Status
* Priority
* Milestones
* Creator
* Lead
* Members
* Start Date (Start)
* Start Date (End)
* Target Date (Start)
* Target Date (End)
* Created At
* Started At
* Updated At
* Completed At
* Canceled At
* Archived At
* Teams
* Initiatives
* Health
* Latest Update
* Latest Update Date
* Customer Count
* Customer Revenue

### Initiatives[⁠](https://linear.app/docs/google-sheets.html#initiatives)

* ID
* Parent ID
* Name
* URL
* Description
* Details
* Status
* Creator
* Owner
* Target Date (Start)
* Target Date (End)
* Created At
* Started At
* Updated At
* Completed At
* Archived At
* Teams
* Health
* Latest Update
* Latest Update Date

## Updating data[⁠](https://linear.app/docs/google-sheets.html#updating-data)

The Sheets data refreshes every hour if there is an update to be made, otherwise it won’t refresh.

To run an immediate update, Admins can open the `Cmd`/`Ctrl` + `K` menu and select `Sync to Google Sheets` action. Alternatively, go to the integration’s page and click *Update now*.

You can rename the sheet or move it to shared drives without affecting the data or uploads.

Avoid updating cells in the source sheet as any changes will be overridden. If you want to run analytics, do so in a separate sheet.

## Custom project analytics[⁠](https://linear.app/docs/google-sheets.html#custom-project-analytics)

By using the projects sheet, you have more flexibility to build custom analyses in support of planning decisions. You can see an example of a project prioritization analysis [here](https://docs.google.com/spreadsheets/d/1qi3lV5d22ZGx-9mkHaDS_tT-Y1fT-BEKd7Ik87wkxSw/edit?usp=sharing).

## Custom issue analytics[⁠](https://linear.app/docs/google-sheets.html#custom-issue-analytics)

To build analytics from issue data, import or reference data from the sheet Linear created using IMPORTRANGE, VLOOKUP or similar functions.

Linear users have used the Google integration to build analytics that:

* Track velocity per team member.
* Combine with Linear’s cycle statistics to get a deeper view into individual and team velocity.
* Track the types of work completed and planned. To do this, create custom labels and issue statuses in Linear. A common way to do this is to name labels with a prefix or key:value pair for easier filtering (e.g. *comp: feature\_name* or *type: feature/bug/etc*.)
* Build a Gantt chart for planning or other charts and graphs to show issue progress over time.
* Track bugs more granularly. What percent of open issues are bugs? How many bugs were worked on in a cycle compared to features?
* Track time: Use the timestamp data to measure how long issues remain open or how long it takes an issue to go from start to completion.

For more advanced queries, consider using the API or Zapier.

## Timestamp FAQs[⁠](https://linear.app/docs/google-sheets.html#timestamp-faqs)

* Multiple issue statuses can exist in a single category (e.g. *In Progress* and *In Review* fall under *Started.* The timestamp exported reflects the latest timestamp at which an issue was moved to that status category from another category -- not between statuses of the same category.
* Null fields on timestamps mean the issue or project was never in that status, or the timestamp was cleared (an issue moving from Backlog -> Done -> In Progress will clear the completed timestamp.)
* All times in this integration are displayed in GMT.

[Previous

GitLab](https://linear.app/docs/gitlab.html)[Next

Gong](https://linear.app/docs/gong.html)

* [Overview](https://linear.app/docs/google-sheets.html#overview)
* [Configure](https://linear.app/docs/google-sheets.html#configure)
* [Synced data](https://linear.app/docs/google-sheets.html#synced-data)
* [Issues](https://linear.app/docs/google-sheets.html#issues)
* [Projects](https://linear.app/docs/google-sheets.html#projects)
* [Initiatives](https://linear.app/docs/google-sheets.html#initiatives)
* [Updating data](https://linear.app/docs/google-sheets.html#updating-data)
* [Custom project analytics](https://linear.app/docs/google-sheets.html#custom-project-analytics)
* [Custom issue analytics](https://linear.app/docs/google-sheets.html#custom-issue-analytics)
* [Timestamp FAQs](https://linear.app/docs/google-sheets.html#timestamp-faqs)
