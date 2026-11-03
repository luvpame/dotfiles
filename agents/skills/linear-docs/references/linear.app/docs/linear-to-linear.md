---
title: "Linear – Linear Docs"
source_url: "https://linear.app/docs/linear-to-linear"
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

  + [![Import Guide](https://webassets.linear.app/images/ornj730p/production/36166a21e4c78686fb3db165e616b850e5f08ff1-16x16.svg?q=95&auto=format&dpr=2)Import Guide](import-issues.html)
  + [![Jira](https://webassets.linear.app/images/ornj730p/production/83cee60ad9eb8c7252735846a75ef6eb6905ab2f-16x16.svg?q=95&auto=format&dpr=2)Jira](jira-to-linear.html)
  + [![GitHub Issues](https://webassets.linear.app/images/ornj730p/production/30f905940fc56cfbacf3fcb5d5f96bc84b555380-16x16.svg?q=95&auto=format&dpr=2)GitHub Issues](github-to-linear.html)
  + [![Asana](https://webassets.linear.app/images/ornj730p/production/6e24347eefee7bc40d8c567752a62729fab0e3a3-16x16.svg?q=95&auto=format&dpr=2)Asana](asana-to-linear.html)
  + [![Shortcut](https://webassets.linear.app/images/ornj730p/production/fe1c3b670fafcda0926b5e0d5e3a93a4ad47bcec-16x16.svg?q=95&auto=format&dpr=2)Shortcut](shortcut-to-linear.html)
  + [![Linear](https://webassets.linear.app/images/ornj730p/production/f2c0128d9d54c7cb5972f09d7853c364ddb4ce52-16x16.svg?q=95&auto=format&dpr=2)Linear](linear-to-linear.html)
  + [![CLI Importer](https://webassets.linear.app/images/ornj730p/production/2bdad8886bc8ec8ee3602ac68d5262b99032ef49-16x16.svg?q=95&auto=format&dpr=2)CLI Importer](cli-importer.html)

# Linear

## Prerequisites[⁠](https://linear.app/docs/linear-to-linear.html#prerequisites)

To import data from one Linear workspace to another, first ensure that you have an admin account in both workspaces using the same email login credential.

If there isn’t already an admin using the same email credential in both source and destination workspaces, invite an admin from the destination workspace to the source workspace (or vice versa) and have them run the import. For best results, avoid creating multiple accounts on the same workspace under different emails.

## Running the import[⁠](https://linear.app/docs/linear-to-linear.html#running-the-import)

1. Navigate to [Settings > Administration > Import/Export](https://linear.app/settings/import-export.html). You must be an admin in Linear to access this page.
2. Click on the “Linear to Linear import” button.
3. Select the workspace you would like to import. We will only show workspaces under the same email address where you are an admin member.
4. Select the teams you would like to import from this workspace.
5. Choose how to map members from the workspace you are importing from to your current workspace.
6. Review a summary of the import.
7. Click “Start import”.

## Data included in the import[⁠](https://linear.app/docs/linear-to-linear.html#data-included-in-the-import)

| Linear (old) | Linear (new) |
| --- | --- |
| Title | Title |
| Description | Description |
| Estimate | Estimate |
| Labels | Labels |
| Due date | Due date |
| Comments | Comments |
| Workflow state | Workflow state |
| Sub-issues | Sub-issues |
| Relationships | Relationships |
| Projects | Projects |
| Initiatives | Initiatives |
| Team templates | Team templates |
| Dashboards | Dashboards |
| Documents | Documents |

## Data excluded in the import[⁠](https://linear.app/docs/linear-to-linear.html#data-excluded-in-the-import)

This import will not carry over all data associated with your source workspace. The data below will not transfer the following:

* Saved display preferences for custom, project, and initiative views
* Favorites / reminders / drafts / inbox notifications
* Integrations\* / webhooks / OAuth clients / API keys
* Billing/plans\*\*
* Workspace URL (you can update this manually after import in your [Settings > Workspace](https://linear.app/settings/workspace.html))
* Personal and Workspace settings
* Roles\*\*\*

\* Integrations will need to be installed on the new workspace and will not resume notifications or automations for imported issues in most cases.

\*\* Contact support@linear.app for assistance with billing transfers.

\*\*\* Current admins will be imported as members. The person who initiated the import will initially be the only admin. Guests will carry over with the same permissions.

[Previous

Shortcut](https://linear.app/docs/shortcut-to-linear.html)[Next

CLI Importer](https://linear.app/docs/cli-importer.html)

* [Prerequisites](https://linear.app/docs/linear-to-linear.html#prerequisites)
* [Running the import](https://linear.app/docs/linear-to-linear.html#running-the-import)
* [Data included in the import](https://linear.app/docs/linear-to-linear.html#data-included-in-the-import)
* [Data excluded in the import](https://linear.app/docs/linear-to-linear.html#data-excluded-in-the-import)
