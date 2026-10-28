---
title: "Project templates – Changelog"
source_url: "https://linear.app/changelog/2023-09-21-project-templates"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[September 21, 2023](https://linear.app/changelog/2023-09-21-project-templates.html) Share

[## Project templates](https://linear.app/changelog/2023-09-21-project-templates.html)

![A project template for Marquee feature with milestones Alpha, Beta, etc.](https://webassets.linear.app/images/ornj730p/production/588fdaa6553c15667f81457fab70807bbbb8458c-3312x1734.png?q=95&auto=format&dpr=2)

## Project Templates[⁠](https://linear.app/changelog/2023-09-21-project-templates.html#project-templates)

You can now create standard templates for projects. You’ll be able to define basic details such as the project name, description, lead, project members, project status, and associated roadmaps. You can create pre-defined milestones, for instance, so that every project includes Alpha, Beta, and GA milestones (e.g. this makes it easy to filter for all projects actively in beta), and also create standard issues for the project. Issues created in a project template can be assigned to different teams and milestones as well. This feature is particularly useful for workflows that require a standard set of tasks.

To create or edit a project template, go to the Templates section in your team or workspace settings. When you initiate a new project, you’ll have the option to apply one of these templates from the project creation modal, in the same way you do for issue templates.

## Series B [⁠](https://linear.app/changelog/2023-09-21-project-templates.html#series-b)

Last week we announced our Series B fundraise, led by Accel, with participation from Sequoia Capital, 01Advisors, and some of the world’s best product builders and operators including the founders of Slack, Vercel, and Supercell. We didn’t have to raise a new round, but it gives us the capital and confidence to build and grow for many years to come. Thank you for building with Linear. We’re committed to our focus on building intuitive, high-quality, and magical software and helping you do the same. Read the full [post](https://linear.app/blog/series-b) on our blog.

Improvements & Fixes

* Fix display of overflows (e.g. +2) in avatar groups.
* Fixed layout issues in API settings page on mobile devices
* Aligned the link timestamp displayed in the issue history and the link widget
* Fixed a styling bug in the milestone selector
* Fixed a rare issue where trying to set the status of an issue to the same status, would result in the issue getting one of the default statuses for the team.
* Fixed an issue where sometimes double breadcrumbs would appear in triage/inbox if you moved up/down with arrows multiple times and quickly pressed enter.
* Fixed an issue where using up/down arrows after searching didn’t move focus to the search results.
* We now always expand the “Exploring” or “Your teams” section in the sidebar when you navigate to a team through the command menu
* Fixed team level notifications for when an issue was added to the team’s triage queue not being sent
* Fixed an issue where document search repeated items in the list.
* [API] Added mutations to add or remove a single label to/from an issue.
* You can now filter user actions (such as assigning an issue to someone) by both the user’s full name and display name, regardless of your Linear setting for preferring full names.
* We fixed a bug where we let you create circular parent-child issue dependencies when linking an issue as a sub-issue from the client
* Removed unnecessary spacing in timeline footer
* Fixed problems with sub-issues when creating issues using a template link
* Added “Apply template” action to the issue page overflow menu
* Remove small horizontal gap between triage list items
* Fixed image downloads in desktop app
* Fixed random crash that happened when navigating to an issue
* Get rid of unsaved changes prompt when dismissing an unchanged template
* Fixed a bug where pasting images copied from Microsoft Teams would lead to an error.
* Notifications will now properly respect the “show full names” setting
* We fixed a bug where editing a GitHub PR description after it was merged would move the PR back to the merge workflow state, even if the PR was previously linked to the issue and had since been moved
* [API] Add mutations to subscribe/unsubscribe single user.
* We fixed a bug where support tickets created from Linear would send responses to your old email address rather than your current email address if you had previously changed your Linear user’s email
* [API] `addedLabels` and `removedLabels` were added as fields on issue history
* Floating help menu with compact workspace status token and changelog updates in sidebar
* Comments created from the “Reply” action on Slack will now be properly synced between Linear and Slack if they are part of a synced thread
* We now display the roadmap icons when selecting a project roadmap
* Improved keyboard navigation for label and template settings pages
* Use muted color for the bell icon when receiving an issue reminder notification
* No longer animates in similar issues if they are available immediately on navigating to an issue.
* Fixed a bug where closing the Figma embed using the X icon would prevent any clicks in the app
* Added breadcrumb to user pages
* Removed extraneous padding for similar issues container.
* Removed misleading checkbox for label group in the command menu
* Fixed an issue where opening some notifications on phones would not present arrows to navigate up/down to the previous/next notification.
* Fixed an issue with a missing page header on some project views.
* Fixes command menu not appearing on some Android phones
* Adds a permalink to the specific Slack threaded comment that was synced
* Add rich metadata attachments when linking GitHub pull requests or GitLab merge requests to an issue.
* [API] Added the ability to query associated subscription through notification resolver
* Fixed the reset button on the inline search input in Firefox
* Fixed a bug where pressing space in the command menu for multi-select options would not select the first option
* We brought back the ability to toggle checkboxes in another team members comment
* Fix transparency issues for browsers without backdrop filter support
* Fixed a bug preventing the focus return to not work properly when closing a contextual menu
* Prevent opening a new tab switching all other tabs to the same workspace
* Fixes incorrect items getting selected when navigating lists using keyboard.
* Fixed favorite folder contextual menu alignment and keyboard navigation
* Emails no longer cuts off long comments, etc., but allows you to scroll the content instead.
* Fixed a bug in the Slack integration where issues created using the global “Create new issue...” shortcut showed the issue’s creator as “Slack” instead of the Linear user who created the issue
* Fixed placement of a tooltip explaining why applying a template with sub-issues isn’t possible
* Improved a11y and keyboard navigation in sidebar of a project/roadmap/custom view pages
* Fixed a bug where the action menu would not close when text was selected and the Enter key was pressed
* Improved keyboard support for inline date pickers
* Improved loading experience when entering settings
* Fixed arrow to navigate to an issue property in the sidebar not being visible when focused with the keyboard
* Fix a rendering issue with long milestone names on the timeline view
* Fixes an issue where applying template over another template would append to, instead of replacing the issue description.
* Fixed a bug where some issue statuses would not be synced with Jira Link correctly after they are moved to a different team
* Fixed a bug causing pre-filled create issue URLs to not copy over the issue’s description after being pasted
* Add display option to sort inbox by issue priority.
* Fix non-threaded comments animation
* Fixed a bug that displayed an empty tooltip for teams that had no members
* The Github importer now supports using the project’s columns to determine the issue’s status
* We fixed a bug where some issues were not associated to a project in Github imports
* Add support for archived project items in Github imports
* Fixed action buttons in Inbox randomly showing and hiding labels
* Temporarily removed the ability to drag & drop items on boards on touch devices, since it has too many bugs.
* Fixed a bug where the favorite button was not accessible with keyboard navigation
* For lists of similar issues, you can now peek at the similar issue contents when hovering it and pressing spacebar.
* Fixed a bug where creating a duplicate issue would always open the newly created issue.
* We fixed a bug that would cause search results to be incorrect when ordering by created or updated property.
* Status group headers will now always reflect the most common team in the issue list, when grouping by team.
* [API] Added ability to send a project update reminder using `createProjectUpdateReminder` GraphQL mutation
* Various quality improvements to the milestones editor in project creation modal
* Improved the keyboard navigation in icons and emojis picker
* Fixed a bug where opening a team menu in the sidebar would leave the team highlighted
* Fixed a bug where the custom color input for roadmap icon was not selectable
* Fixed a bug where you’d see a flash of no content in the desktop app.
* We now won’t add issue history entries for newly created issues.
* Add “Parent issue: “ prefix to parent issue tooltip shown in lists
* Add member count in workspace members and team members pages.
* Fixes a bug where linking a PR to an issue using magic words after the PR was merged would not move the issue to the merge workflow state
* Label page now has a details sidebar with quick filters, just like the cycle view.
* Fixed a bug in Triage settings where triage setting could be disabled when clicking on the page
* Fixed a problem with My Activity page being empty on the first render with the board layout selected.
* Icon colors now adapt to the current theme.
* Some usability improvements for workspace audit logs.
* Fixed a rare issue where in the case of multiple notifications for the same issue it wasn’t clear which one to show in the Inbox and it would be semi-random which one we showed. Now it’s consistent/stable.
* All issues, active issues and backlog view now have a details sidebar with quick filters, just like the cycle view.
* [API] Added projectUpdate.diffMarkdown resolver that returns a project update diff formatted in a markdown
* Command menu actions to go to your workspace and account settings
* Improved the highlight behavior of favorite buttons
* Fixed accepting spell check suggestions that didn’t work for some users
* Fixed an issue where the “Move to project” action wouldn’t show up correctly in the Cmd+K menu
* Added ability to select items in lists and board using shift + J/K.
* Added undo button to toast when deleting multiple notifications.
* Fixed a bug causing the OAuth application creation form to reset when toggling on webhooks
* Fixed a bug where we showed excessive amount on whitespace when creating issues with a lot of sub-issues.
* Fixed a bug in the command menu where selecting text and overflowing would close it
* Add a contextual menu to the project teams selector to quickly add or remove teams
* Tweaked the look of sub-issue panels in issue template editing.
* Fixed a small misalignment in the header on some notifications.
* [API] We added support for filtering project updates
* Fix some select menus not scrolling properly
