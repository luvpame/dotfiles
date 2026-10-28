---
title: "CLI Importer – Linear Docs"
source_url: "https://linear.app/docs/cli-importer"
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

# CLI Importer

Use the CLI Importer when you’re moving from a tool without a dedicated Linear import assistant.

While CLI imports can also be used to customize imports for services with an importer tool, we don’t recommend this as the CLI importer will not import data supported by the import assistant like comments or projects.

## Preparing your CSV file for import[⁠](https://linear.app/docs/cli-importer.html#preparing-your-csv-file-for-import)

Go to Linear [Settings → Administration → Import/Export → Export CSV](https://linear.app/settings/import-export.html) to download a template. Keep its column headers, replace the sample rows with your data, and save the file.

The essential fields are:

* `Title` - Issue title
* `Description` - Issue description
* `Priority` - Issue priority
* `Status` - Issue state
* `Assignee` - Issue assignee (user’s full name)
* `Created` - Issue created date
* `Completed` - Issue completed timestamp. This will not appear in issue activity log, but will be stored on the issue
* `Labels` - Separate each label by commas for multiple labels
* `Estimate` - Please note that these values only appear on the issue after enabling estimates on the imported issue’s team.

## Running the import[⁠](https://linear.app/docs/cli-importer.html#running-the-import)

You’ll need to be a workspace admin and a CSV export from your source tool.

1. Navigate to [Settings > Workspace > Import/Export](https://linear.app/settings/import-export.html)
2. Under “CLI import”, click **Open** to navigate to our [Command Line interface (CLI) tool](https://github.com/linear/linear/tree/master/packages/import).
3. Follow instructions to run the CLI Importer
4. Choose the “Linear” CSV option
5. Follow prompts to select your file and destination team

Re-imports to the same team skip issues that were already imported, so delete a previous import first if you need a clean retry.

[Previous

Linear](https://linear.app/docs/linear-to-linear.html)

* [Preparing your CSV file for import](https://linear.app/docs/cli-importer.html#preparing-your-csv-file-for-import)
* [Running the import](https://linear.app/docs/cli-importer.html#running-the-import)
