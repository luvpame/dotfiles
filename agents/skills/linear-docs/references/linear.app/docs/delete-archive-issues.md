---
title: "Delete and archive issues – Linear Docs"
source_url: "https://linear.app/docs/delete-archive-issues"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles

  + [![Issues](https://webassets.linear.app/images/ornj730p/production/edba0d8c37051e1993f867e9ca020865f4605fad-16x16.svg?q=95&auto=format&dpr=2)Issues](creating-issues.html)
  + [![Assign and delegate issues](https://webassets.linear.app/images/ornj730p/production/4f138793712b3f9f7f0dc09ad7ef776c03fe2077-15x15.svg?q=95&auto=format&dpr=2)Assign and delegate issues](assigning-issues.html)
  + [![Issue properties](https://webassets.linear.app/images/ornj730p/production/d234872da34ea6572815705e12566ece16be8a89-16x16.svg?q=95&auto=format&dpr=2)Issue properties](issue-properties.html)
  + [![Select issues](https://webassets.linear.app/images/ornj730p/production/b61fa1aff4d024cf6dcf0134c2c45b8d76cf0b27-16x16.svg?q=95&auto=format&dpr=2)Select issues](select-issues.html)
  + [![Parent and sub-issues](https://webassets.linear.app/images/ornj730p/production/fb9f996198822ba4dd8358f4e37428278e9701dd-16x16.svg?q=95&auto=format&dpr=2)Parent and sub-issues](parent-and-sub-issues.html)
  + [![Issue templates](https://webassets.linear.app/images/ornj730p/production/e4f8aa58d39df0385e4c2bd2838a46dac1e2350b-16x16.svg?q=95&auto=format&dpr=2)Issue templates](issue-templates.html)
  + [![Comments and reactions](https://webassets.linear.app/images/ornj730p/production/22f4ef6d4c3409d3fe7b7bbf4a7690403eb47580-16x16.svg?q=95&auto=format&dpr=2)Comments and reactions](comment-on-issues.html)
  + [![Delete and archive issues](https://webassets.linear.app/images/ornj730p/production/a6e257753e45982c7a7227be82fc81acc33d14d1-16x16.svg?q=95&auto=format&dpr=2)Delete and archive issues](delete-archive-issues.html)
  + [![Cycles](https://webassets.linear.app/images/ornj730p/production/1c19be327a796ea52b2967508141f95a6f74aee7-16x16.svg?q=95&auto=format&dpr=2)Cycles](use-cycles.html)
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Delete and archive issues

Linear archives issues automatically to keep your workspace uncluttered and easy to search.

![Linear settings showing the auto-archive preferences](https://webassets.linear.app/images/ornj730p/production/82132ce2f13a09b1638db646a8dc460416fe89c8-2160x1327.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/delete-archive-issues.html#overview)

Linear offers features that help manage backlog and stale items, keeping your workspace focused on current priorities. We introduce our auto-close and auto-archive feature, and talk about deleted issues and the team archives.

## Delete issues[⁠](https://linear.app/docs/delete-archive-issues.html#delete-issues)

Delete issues with the shortcut `Cmd/Ctrl` `delete`, from an issue’s contextual menu, or use command bar `Cmd/Ctrl` `K` and select **Delete issue**.

If you accidentally delete an issue, the fastest way to restore it is to use `Cmd/Ctrl` `Z`. If undo is no longer available, open your team’s archives, select **Recently deleted issues**, select the issue, then press `#` to restore it. Recently deleted issues are stored in the archives for 30 days, after which they’ll be permanently removed from your workspace. It is not possible to restore deleted issues after they have been permanently removed.

## Auto-close[⁠](https://linear.app/docs/delete-archive-issues.html#auto-close)

![Auto-close automations settings](https://webassets.linear.app/images/ornj730p/production/e3ab2a2dcae1e075aa611591cc07d4281723f239-1342x810.png?w=1440&q=95&auto=format&dpr=2)

Linear offers an option to close issues that have not been updated after a certain time period. This can be configured in *Team settings > Workflows & automations*. When auto-closed, an issue is marked with one of the Closed statuses, we publish a history item to its Activity feed, and notify subscribers. You can re-open an auto-closed issue anytime by changing its status.

Issues will not auto-close while they belong to an active cycle or unfinished project. Auto-close is also delayed when an issue has a future due date, an active SLA, or sub-issues that are not eligible to close.

## Auto-archive[⁠](https://linear.app/docs/delete-archive-issues.html#auto-archive)

Archiving happens automatically with no option to manually archive items.

![Auto-archive closed issues, cycles, and projects](https://webassets.linear.app/images/ornj730p/production/d65e6891b0933632dd09f3ddf3de9ede8f640b3a-1452x466.png?w=1440&q=95&auto=format&dpr=2)

You can adjust the auto-archive time period, after which closed issues are auto-archived in *Team Settings > Workflows & automations*. Changes usually take effect on the next auto-archive run, typically within 24 hours.

### Issues are not archiving[⁠](https://linear.app/docs/delete-archive-issues.html#issues-are-not-archiving)

* The parent issue is not closed
* Sub-issues are not all closed
* Sub-issues in another project are not closed
* The issue’s project is not yet available to archive
* There’s been recent activity on the issue

Closed issues are auto-archived after they have remained completed, canceled, or auto-closed and inactive for the full auto-archive period. Issues in active cycles or unfinished projects are archived only after those cycles or projects have also been completed for that period.

### Projects are not archiving[⁠](https://linear.app/docs/delete-archive-issues.html#projects-are-not-archiving)

Scenarios that prevent a project from archiving:

* The project status is not closed (completed or cancelled category)
* Updates/changes have been made (e.g. renaming a project)
* All issues are not yet available to archive. A project’s issues have to be available to archive in order for the project to archive. This helps to prevent missing data when looking at a project’s graph or other calculations.

## The archives[⁠](https://linear.app/docs/delete-archive-issues.html#the-archives)

![Access archives](https://webassets.linear.app/images/ornj730p/production/444946f80cb7cd76dc5411f7e184feeba77cdeb4-908x366.png?w=1440&q=95&auto=format&dpr=2)

Each team has its own archives page where you will find archived or deleted issues, initiatives, cycles, projects, and documents. Access it with the shortcut `G` then `X` or find it in the sidebar under the three dot menu beside each team name. To keep the app speedy, archived issues are loaded on demand rather than stored in the client, so you may find the issues load a little slower on this page than elsewhere in the app.

### Restore issues[⁠](https://linear.app/docs/delete-archive-issues.html#restore-issues)

Restore archived issues, projects, or cycles from your team’s archives to edit them. You can also recover deleted issues, projects, initiatives, or documents from the corresponding Recently deleted tab for up to 30 days.

[Previous

Comments and reactions](https://linear.app/docs/comment-on-issues.html)[Next

Cycles](https://linear.app/docs/use-cycles.html)

* [Overview](https://linear.app/docs/delete-archive-issues.html#overview)
* [Delete issues](https://linear.app/docs/delete-archive-issues.html#delete-issues)
* [Auto-close](https://linear.app/docs/delete-archive-issues.html#auto-close)
* [Auto-archive](https://linear.app/docs/delete-archive-issues.html#auto-archive)
* [Issues are not archiving](https://linear.app/docs/delete-archive-issues.html#issues-are-not-archiving)
* [Projects are not archiving](https://linear.app/docs/delete-archive-issues.html#projects-are-not-archiving)
* [The archives](https://linear.app/docs/delete-archive-issues.html#the-archives)
* [Restore issues](https://linear.app/docs/delete-archive-issues.html#restore-issues)
