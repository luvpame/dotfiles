---
title: "Project Slack channels – Changelog"
source_url: "https://linear.app/changelog/2026-05-21-project-slack-channels"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[May 21, 2026](https://linear.app/changelog/2026-05-21-project-slack-channels.html) Share

[## Project Slack channels](https://linear.app/changelog/2026-05-21-project-slack-channels.html)

![Project overview page in Linear titled "Rider onboarding refresh". #p-rider-onboarding-refresh is a Slack channel appearing next to other project properties in the header.](https://webassets.linear.app/images/ornj730p/production/0c4527f4ba7225f8932742103289c47759a4389b-3600x1920.png?q=95&auto=format&dpr=2)

Project teams often use a Slack channel to discuss and share feedback about their project as it takes shape.

Now, Linear can spin up that Slack channel automatically every time a new project is created. All project members are automatically added to the project Slack channel, and project updates post to that channel by default.

When working in a project’s Slack channel, you can use Linear Agent to answer questions or take actions in the project. Try sending messages to the channel like “**@Linear** what’s our target date?” or “**@Linear** file this bug and assign it to me.”

Admins can enable channel creation from [settings](https://linear.app/settings/integrations/slack.html#project-channels). Learn more about project Slack channels in our [documentation](https://linear.app/docs/slack.html#project-slack-channels).

## Linear Asks Agent[⁠](https://linear.app/changelog/2026-05-21-project-slack-channels.html#linear-asks-agent)

[Linear Asks](https://linear.app/features/asks.html) brings internal requests into Linear, where the appropriate team can work on them.

Now, anyone in your Slack workspace can file a request in Linear by mentioning **@Linear Asks**. Linear checks the templates enabled for that channel, picks the best match, and creates an issue using the conversation as context.

When a template uses required fields, Linear follows up to collect any missing details before creating the issue.

![User mentions @Linear Asks in Slack, and Asks replies with a clarifying question -- which laptop model should be sent to Brian? The requester answers and Asks creates the issue.](https://webassets.linear.app/images/ornj730p/production/f63c5535cd554f39a3e1b27be0defe6209ce40fc-3600x2160.png?q=95&auto=format&dpr=2)

Admins can configure Linear Asks agent in [settings](https://linear.app/settings/asks/index.html) for any connected Slack workspace. Asks is available on Business and Enterprise plans. Learn more in our [documentation](https://linear.app/docs/linear-asks-slack.html).

## Issue duplicates[⁠](https://linear.app/changelog/2026-05-21-project-slack-channels.html#issue-duplicates)

Duplicate issues now use a dedicated status type in Linear and move context to the original issue.

When an issue is marked as a duplicate, its customer requests, synced Slack threads, and attachments are moved to the original issue. Whether a teammate, agent or Triage Intelligence marks an issue as a duplicate, the issue context moves to the right place.

Because of theses changes, every issue with a duplicate status must now link to the original issue. On duplicate issues, that original issue is shown clearly in the sidebar.

![Duplicate issue underneath the duplicate status in the issue sidebar](https://webassets.linear.app/images/ornj730p/production/75bbf9242df2b3f659b51785e291ce3a3b217169-3600x2058.png?q=95&auto=format&dpr=2)

When the original issue is completed, every synced Slack thread is notified. Each linked customer ticket in Zendesk or Intercom also reopens, so you can keep your customers in the loop.

## Reorder groups in issue and project views[⁠](https://linear.app/changelog/2026-05-21-project-slack-channels.html#reorder-groups-in-issue-and-project-views)

Issues and projects in views are often organized into groups like status, priority, or label. You can now reorder these groups in any list or board view to put the most important sections first.

Click the reorder groups icon in display options, then drag groups into your preferred order. You can reset the view back to the default order at any time.

![New icon left of  ordering in Display Options on a view that lets you control how swimlanes are ordered.](https://webassets.linear.app/images/ornj730p/production/5f5a0dc9352f10260b070b47e4562408a699fab1-3600x2058.png?q=95&auto=format&dpr=2)

## GitHub Enterprise Cloud integration[⁠](https://linear.app/changelog/2026-05-21-project-slack-channels.html#github-enterprise-cloud-integration)

Linear now supports GitHub Enterprise Cloud.

Once connected, GitHub Enterprise Cloud users have access to all the benefits of our popular GitHub integration. Linked pull requests update issue statuses automatically, GitHub Issues sync can be enabled for select repos, and you can review PRs natively with Linear Diffs.

This integration is available on Linear’s Enterprise plan. Read more in our [documentation](https://linear.app/docs/github.html#github-enterprise-options), and install the [GitHub Enterprise Cloud integration](https://linear.app/settings/integrations/github-enterprise-cloud.html) to get started.

Fixes

* Agent chat

  Fixed highlights on the agent chat buttons
* Agents

  Issues created from templates via the Linear agent (in-app, Slack, Microsoft Teams) now respect required form fields and serialize submitted values into the issue description
* Agents

  Fixed a freeze when pasting long Markdown content that included todo items into agent toolbar input
* Asks

  Fixed Asks Web template submissions that create child issues for authenticated non-members
* Cycles

  Fixed progress ring background blending into the row hover color in quick filter overviews
* Drafts

  Fixed a bug where saving as draft would fail when an issue template included a sub-issue on a sub-team
* Duplicates

  Duplicate issues now appear in the canceled section in focus-grouped issue lists instead of active buckets
* Editor

  Copying part of the text of a list item no longer copies the list structure, only the text itself
* Editor

  When pasting Markdown content that includes code blocks, the cursor now lands correctly at the end of the pasted content
* Filters

  Fixed missing rows on Author, Reviewers, Team owners, Customer owner, and Project milestone filters on first open
* Filters

  Fixed missing rows on Creator filter on search page
* Filters

  Fixed header filter buttons highlighted while their filter menu is open
* Labels

  Restored input focus when switching between New group and New label while creating a label
* Linear Agent

  Fixed resuming Slack threads when the user answers an agent’s follow-up question without `@Linear`, even after a long delay
* Notifications

  Fixed an issue where users could be unexpectedly subscribed to issues they never interacted with
* Performance

  Fixed an issue where switching workspaces could leave the app stuck on the workspace loading screen until a restart
* Projects

  Fixed public project Slack channels incorrectly appearing as private after renames
* Releases

  Fixed order of releases by stage position so canceled releases are sorted after completed ones
* Reviews

  Showed only the relative timestamp for opened pull requests in the review list
* Settings

  Fixed dropdown text overflowing on narrow viewports
* Slack

  Fixed double-notifying on Slack when an issue is deduplicated — the duplicate-relation event is now the only user-facing event
* Sidebar

  Reduced blur and fixed positioning in animated unread count digits on non-retina displays
* Teams

  Fixed issue where team owners can now update the “Restrict team membership” setting without needing workspace admin permissions
* Templates

  Fixed moving a project or document template to the parent team or workspace silently reverting
* Updates

  Switching the project or initiative on an update composer no longer deletes the previously saved draft
* Workflow

  Show the visible workflow-state icon for merged issue status group headers, with a generic fallback when multiple team states are visible

API

* Added parallel `AgentSkill` GraphQL query and mutation types alongside deprecated `AiPrompt` roots for the skill migration
* Added `Team.visibility` and deprecated `Team.private`
* Returns `410 Gone` from `/oauth/migrate_old_token`; old OAuth token migration is no longer supported

Improvements

* Inbox

  Grouped agent-authored inbox replies into a dedicated Agents section in focus inbox grouping
* Issues

  You can now link the same pull request to multiple selected issues from issue actions and `Cmd/CtrlK`
* Reviews

  Unreviewed stacked PRs are now ranked below reviewed PRs in the list
* Triage

  Improved triage actions in the issue header now show labels at wider widths

MCP server

* GitHub pull request URLs in document content saved via MCP are now converted to diff mentions
