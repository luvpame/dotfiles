---
title: "Asana – Linear Docs"
source_url: "https://linear.app/docs/asana-to-linear"
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

# Asana

Import Asana into Linear

## Prerequisites[⁠](https://linear.app/docs/asana-to-linear.html#prerequisites)

We currently only support in app importing from Asana organizations. Make sure your Asana workspace is an organization before beginning an import, or [convert your Asana workspace to an organization](https://asana.com/guide/help/workspaces/create#gl-convert-workspace) if it is not. If you do not want to convert your Asana workspace to an organization, use the CLI importer.

## Running the import[⁠](https://linear.app/docs/asana-to-linear.html#running-the-import)

1. Navigate to [Settings > Administration > Import/Export](https://linear.app/settings/import-export.html).
2. Click on the button for Asana.
3. Enter your Asana personal access token. You can obtain your personal access token by navigating to your Asana [developer console](https://app.asana.com/0/my-apps).
4. Enter your Asana team name.
5. Select which Linear team to import issues into.
6. Click **Next** to start importing.

## Data included in the import[⁠](https://linear.app/docs/asana-to-linear.html#data-included-in-the-import)

| Asana | Linear |
| --- | --- |
| Priority | Priority |
| Notes | Issue description (converted to Markdown) |
| Attached files | Added to description. All files except images and videos are converted to links. |
| Tags | Labels (Team-level) |
| Assignee | Assignee |
| Projects | Projects |
| Comments | Comments (Markdown respected) |
| Status | Imported status will be "Backlog" or "Done", only. |
| Sub-issue | Sub-issue |
| Blocked/blocking | Blocked/blocking |

[Previous

GitHub Issues](https://linear.app/docs/github-to-linear.html)[Next

Shortcut](https://linear.app/docs/shortcut-to-linear.html)

* [Prerequisites](https://linear.app/docs/asana-to-linear.html#prerequisites)
* [Running the import](https://linear.app/docs/asana-to-linear.html#running-the-import)
* [Data included in the import](https://linear.app/docs/asana-to-linear.html#data-included-in-the-import)
