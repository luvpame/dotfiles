---
title: "Import Guide – Linear Docs"
source_url: "https://linear.app/docs/import-issues"
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

# Import Guide

Learn best practices for importing to Linear. Imports can only be started by workspace admins.

![Image of migration assistants](https://webassets.linear.app/images/ornj730p/production/d2f61b4eeb982988a066a5416eaa81bb547178b3-2880x1769.png?w=1440&q=95&auto=format&dpr=2)

## Linear Concepts[⁠](https://linear.app/docs/import-issues.html#linear-concepts)

A Linear [workspace](https://linear.app/docs/workspaces.html) is our top level concept, which contains one or many [teams](https://linear.app/docs/teams.html). We recommend that each company using Linear uses only one workspace.

[Issues](https://linear.app/docs/creating-issues.html) and [projects](https://linear.app/docs/projects.html) are the core entities used to manage work in Linear. Each issue belongs to a single team, while projects can belong to one or many teams. Other concepts in Linear can be scoped to a team or a workspace like [Views](https://linear.app/docs/custom-views.html) (filter based groups of issues or projects), [Initiatives](https://linear.app/docs/initiatives.html) (hand-picked groups of projects) and more.

When you import from another service to Linear, we’ll attempt to match data from the source tool with the closest concept in Linear. If a concept from the source tool does not translate well to Linear, it may not be imported; please see details on your individual service for further details.

## Pre-import best practices[⁠](https://linear.app/docs/import-issues.html#pre-import-best-practices)

Consider the below before starting your first import for a smoother experience.

### Which data is worth importing?[⁠](https://linear.app/docs/import-issues.html#which-data-is-worth-importing)

If there is data that is no longer relevant to your organization’s day to day work, consider whether it needs to be in Linear at all (perhaps a CSV of exported data from long-resolved issues is sufficient). Some organizations choose to use Linear as a “clean break” from their legacy tool and import only where absolutely necessary so they can start fresh with minimal clutter. Others prefer to maintain as full a historical record as possible in one place.

If you’re importing when evaluating Linear instead of transitioning all at once, you may wish to run a pilot by importing just a few teams. We also have a resource for switching tools in our [switch instruction manual.](https://linear.app/switch.html)

### Choose an import method[⁠](https://linear.app/docs/import-issues.html#choose-an-import-method)

We offer two main methods of importing to Linear; our dedicated import assistants in-product and a CLI import tool. We recommend using a dedicated importer whenever possible as they retain much more data from the original source, are easier to use, and provide the option to delete an import in bulk if desired.

Jump to our importers:

* [Jira](https://linear.app/docs/jira-to-linear.html)
* [GitHub Issues](https://linear.app/docs/github-to-linear.html)
* [Asana](https://linear.app/docs/asana-to-linear.html)
* [Shortcut](https://linear.app/docs/shortcut-to-linear.html)
* [Linear](https://linear.app/docs/linear-to-linear.html)
* [CLI](https://linear.app/docs/cli-importer.html)

### Understand the import process[⁠](https://linear.app/docs/import-issues.html#understand-the-import-process)

You’ll first need to have an Admin role in Linear in order to access our import tools. You may also need high permissions in the tool you’re importing from in order to access the data. In general, the import assistants follow this path:

| Step | Detail |
| --- | --- |
| Setup | Provide an access token, or sign in to your source tool from Linear. Choose an existing team to import to, or create a new team. You can import issues into a top-level team or a sub-team with its own workflow statuses. Imports aren't available for sub-teams that inherit workflow statuses from their parent team. |
| Review | We'll display the issues, projects, labels, users and other data fetched from the information provided. |
| Choose what to import | Choose which issues to import, including active-only or broader sets such as stale, completed, or all issues depending on the source. The archive can be accessed through the overflow menu on each team in your sidebar. |
| Map users | For each user fetched, choose not to import them, to create a new user from an email address, or to map them to an existing user in your Linear workspace. |
| Confirm | At this point, all data available to import will be summarized. If it looks as you expect, hit Finish to start the import. |

Some importer behavior varies by source. For details not covered in this article, check the guide for your source tool in the section below, especially for Jira and GitHub.

### Troubleshooting[⁠](https://linear.app/docs/import-issues.html#troubleshooting)

If something did not import as you expected, please check the section for your specific service to confirm whether we support importing that property. If the property is supported but didn’t import as documented, please let us know at [support@linear.app](mailto:support@linear.app).

If you need to delete an import in order to re-import once more, you can do so through Import/Export settings, on the overflow menu on a specific import. Imports can only be deleted for a limited time after creation, so if the delete option is no longer available, the import may be outside that window.

Reimporting from the same external source to the same Linear team without deleting the initial import first will skip any already-imported issues.

[Previous

Exporting Data](https://linear.app/docs/exporting-data.html)[Next

Jira](https://linear.app/docs/jira-to-linear.html)

* [Linear Concepts](https://linear.app/docs/import-issues.html#linear-concepts)
* [Pre-import best practices](https://linear.app/docs/import-issues.html#pre-import-best-practices)
* [Which data is worth importing?](https://linear.app/docs/import-issues.html#which-data-is-worth-importing)
* [Choose an import method](https://linear.app/docs/import-issues.html#choose-an-import-method)
* [Understand the import process](https://linear.app/docs/import-issues.html#understand-the-import-process)
* [Troubleshooting](https://linear.app/docs/import-issues.html#troubleshooting)
