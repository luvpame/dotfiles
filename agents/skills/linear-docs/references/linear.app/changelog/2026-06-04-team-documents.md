---
title: "Team documents – Changelog"
source_url: "https://linear.app/changelog/2026-06-04-team-documents"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[June 4, 2026](https://linear.app/changelog/2026-06-04-team-documents.html) Share

[## Team documents](https://linear.app/changelog/2026-06-04-team-documents.html)

![Shows a team page with pinned docs and links](https://webassets.linear.app/images/ornj730p/production/6263cddeb0816ce7f9ce24e49dc6870d55b37c65-3600x2080.png?q=95&auto=format&dpr=2)

Important team context doesn’t always belong in a specific issue, project, or initiative. Teams also need a dedicated place for the notes, docs, and shared references that support their work over time. Now, every team has a page to keep its context organized and easy to access.

Teams can create documents directly from their home page, add existing documents from projects and issues, and group resources into sections.

Open a team’s page by clicking on its name in your sidebar, or search by pressing `o`, then `t`. Learn more in our [documentation](https://linear.app/docs/teams.html#team-documents).

## Shared skills for Linear Agent[⁠](https://linear.app/changelog/2026-06-04-team-documents.html#shared-skills-for-linear-agent)

[Skills](https://linear.app/docs/linear-agent.html#skills) let you save reusable instructions for Linear Agent.

We now support sharing skills with your team so great personal workflows can become shared team process. Sharing a skill helps your team standardize recurring workflows like writing specs, running weekly planning, or drafting updates.

Use skills in any agent conversation by clicking on *Skills* or using a slash command. You can share an existing skill from [settings](https://linear.app/settings/account/agents.html), or by asking Linear Agent. Learn more in our [documentation](https://linear.app/docs/linear-agent.html#shared-skills).

## Issue description comments[⁠](https://linear.app/changelog/2026-06-04-team-documents.html#issue-description-comments)

You can now comment directly on text or images in issue descriptions.

Select any part of a description to leave a comment anchored to that exact spot. Use description comments to share feedback on a specific part of the description, rather than commenting on the issue as a whole.

Fixes

* Asks

  The Creator in activity log copy for Slack Asks issues now always matches the `creator` filter.
* Attachments

  Linear now preserves the original filename (and extension) when downloading attachments whose name contains characters like middle dot (`·`) or non-breaking space.
* Comments

  Fixed synced Slack thread replies that could fail or disappear after switching threads.
* Comments

  Fixed mentioning app users in comments created through triage automations.
* Comments

  We now correctly strip leading whitespace from comment paragraphs on submit.
* Diffs

  Files marked as viewed in the Guide tab now stay collapsed when returning to the Diff tab.
* Diffs

  Fixed links in Guide jumping or over-scrolling past the target when navigating to a file or symbol.
* Diffs

  Fixed the diff horizontal scrollbar not being draggable when a collapsed unchanged-lines row was present.
* Diffs

  Fixed Guide showing large blocks of unchanged code when an LLM-supplied hide directive sat adjacent to a long unchanged stretch.
* Documents

  Capped the document table of contents markers height, showing only top-level headings when there are too many to fit.
* Documents

  Fixed a previously open document staying selected after creating a new document in side-by-side view.
* Display options

  Toggling a display option back to its default now correctly clears the modified indicator on the Display button.
* Editor

  Fixed portrait videos being clamped when going fullscreen.
* Figma

  Fixed Figma links in comments triggering repeated comment update errors and slow issue loads.
* GitHub

  GitHub backlink comments are now posted for issues that reference a GitHub URL even when the target repo isn’t synced to a Linear team, as long as the GitHub install can access it.
* GitHub

  We now correctly handle null GitHub ghost users across webhook, issue sync, and pull request intake paths.
* GitHub

  Fixed GitHub issue sync failing with a 401 “A JSON web token could not be decoded” error in some GitHub Enterprise Cloud workspaces.
* Google Sheets

  Fixed a Google Sheets export failure caused by large issue batches overflowing the call stack.
* Inbox

  Returning to Inbox no longer scrolls to a previously-viewed notification without selecting it.
* Insights

  Fixed incorrect Insights results when using “Time in status” after an issue status was renamed.
* Integrations

  Fixed Linear Agent creating a Slack channel for new projects when “Automatically create channel for new projects” was disabled.
* Keyboard

  Pressing `Esc` on a page opened directly in a new tab no longer wipes that page from browser history, so the browser back button can still return to it.
* Linear Agent

  Stopped the Linear agent from chiming in on later Slack thread chatter after it creates an issue/Ask.
* Login

  Login now shows a clear error instead of a false “email sent” confirmation when emails can’t be delivered to a suppressed address.
* Onboarding

  Fixed the onboarding invite step hanging on desktop after sending invites.
* Performance

  Loading icon animations are more performant and use less CPU.
* Projects

  Fixed missing icons on project milestone context menu actions.
* Projects

  Fixed missing padding around the milestones help text shown when a project has no milestones.
* Projects

  Fixed project activity showing the wrong priority change after consecutive priority updates.
* Pulse

  Fixed Pulse summaries rendering document links with a stray `@` prefix instead of a proper document mention.
* Releases

  Fixed a bug that caused only partial release names to be saved.
* Diffs

  Clicking “Request review” on a draft pull request that already has requested reviewers now marks it ready for review directly.
* Diffs

  Outdated review comments are now reflected separately from resolved comments in the code review comment summary.
* Search

  Fixed exact issue identifier searches with different casing not ranking the matching issue first.
* Sidebar

  Fixed alt-clicking a team in the sidebar downloading an HTML file instead of collapsing/expanding all teams.
* Sidebar

  Fixed the “Exploring” sidebar section dropping a team when navigating to its documents tab.
* Sidebar

  Sidebar nav item hover state changes are now instant.
* Slack project channels

  Linear no longer overwrites a connected Slack channel’s topic when a project’s description changes.
* Templates

  Fixed an error that could occur when saving templates that contained legacy invalid content.
* Templates

  Fixed issue templates intermittently losing their default project and milestone.
* Triage

  Fixed the triage automation actor name showing “Triage Behaviour” instead of “Triage Behavior”.
* Triage

  Fixed the triage responsibility settings separators appearing darker than the triage rules card.
* Version history

  Fixed the “Highlight changes” toggle disappearing when turned off in version history.
* Views

  Fixed a freeze that could occur when opening some saved issue views.

Improvements

* Agents

  Added an *Error* option to the agent session issue filter and insights grouping.
* Diffs

  You can now paste a GitHub pull request link into command menu to open it in Linear.
* Diffs

  Customers on legacy plans can now use Diffs.
* Diffs

  We now show indentation changes in diffs for more whitespace-sensitive languages (CoffeeScript, Elm, F#, HAML, Haskell, LiveScript, MoonScript, Nim, Stylus, Makefile).
* Editor

  We now support right-clicking an issue mention in a doc or editor to change its properties.
* Editor

  We now treat ) and ( as emoji autocomplete aliases for standard smile and sad results.
