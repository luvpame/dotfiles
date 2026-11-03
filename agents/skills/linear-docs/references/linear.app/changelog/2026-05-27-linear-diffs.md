---
title: "Linear Diffs – Changelog"
source_url: "https://linear.app/changelog/2026-05-27-linear-diffs"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



[Changelog](https://linear.app/changelog.html)

[May 28, 2026](https://linear.app/changelog/2026-05-27-linear-diffs.html) Share

[## Linear Diffs](https://linear.app/changelog/2026-05-27-linear-diffs.html)

[![](https://webassets.linear.app/images/ornj730p/production/cef9e17829c3c84af7046ba35d164ea8b60af572-1920x1080.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/2c7351e9b1600c4164586bec035f80f7eba5d49c.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

Agents generate large volumes of code, but individuals are still accountable for the changes that merge. This leads to a lot of review work, and the capability and performance of traditional review tools hasn’t kept up.

Today, we’re releasing Linear Diffs to make reviewing code a fast and fluid experience native to Linear.

You can now review diffs from any issue with a PR, iterate on further changes with agents, and ship code from Linear. All reviews in Linear sync back to GitHub, so the current state of review work is always clear.

![main diffs ui showing code changes and a file list](https://webassets.linear.app/images/ornj730p/production/597fabd8e9471472b51411838daa13ac9b108f4c-3600x2058.png?q=95&auto=format&dpr=2)

### Guided reviews (beta)[⁠](https://linear.app/changelog/2026-05-27-linear-diffs.html#guided-reviews-(beta))

Guided reviews help you efficiently review large PRs. When you view a diff in this format, you’ll see the core of change first, so you don’t have to dig for an entrypoint.

Each section of diffs has an explanation — starting with what the change is, then moving into its consequences. Guided reviews separate out glue code and secondary changes so you can stay focused on what matters. This style of review makes it much easier to move through large changes in a single sitting.

Guided reviews are free during beta and available for Linear customers on Business and Enterprise plans.

![guided review with an explanation and file selection on the left, and the diffs on the right](https://webassets.linear.app/images/ornj730p/production/b5c45bfed8d9d634f390c5a48461980055869637-3600x2200.png?q=95&auto=format&dpr=2)

### Review Inbox[⁠](https://linear.app/changelog/2026-05-27-linear-diffs.html#review-inbox)

Staying on top of reviews is easier when review notifications live alongside the rest of your work. Linear notifies your Inbox for work like review requests, your approved PRs, and comment mentions. You can set up additional real-time desktop, Slack, email, or mobile [notifications](https://linear.app/settings/account/notifications.html).

We’ve also added a dedicated Reviews tab in your sidebar so you can see all your review work at once. The default focus ordering sorts reviews by what’s closest to shipping, so the work that needs your attention most rises to the top.

![Reviews dedicated tab showing what needs your input](https://webassets.linear.app/images/ornj730p/production/3852f8c30d20c29a0831c1d6ca1682542c7b386e-3600x2200.png?q=95&auto=format&dpr=2)

### Reviewing code[⁠](https://linear.app/changelog/2026-05-27-linear-diffs.html#reviewing-code)

When a review calls for changes, keep iterating from the diff surface with a background coding agent. Agent changes update the diff in real-time, so you don’t need to check out the branch locally for every small tweak.

Diffs is responsive when reviewing even very large PRs. You can view unified or split diffs, enable line wrapping and structural highlighting, and choose custom code themes.

![Making changes with agents in a diff](https://webassets.linear.app/images/ornj730p/production/7320fa30208068db3493fe8b9e64bdb46b8a852c-3600x2058.png?q=95&auto=format&dpr=2)

Linear Diffs is available now on all plans. Guided reviews are free during beta and available for Linear customers on Business and Enterprise plans.

Workspace admins can enable Diffs by [upgrading](https://linear.app/settings/integrations/github.html) Linear’s GitHub integration for code access. Then, individual users can choose to [review diffs in Linear](https://linear.app/enable-reviews.html).

To learn more about why we built Diffs, read [Code review should be fast](https://linear.app/now/code-review-should-be-fast.html). For more on Diffs functionality, check our [documentation](https://linear.app/docs/pull-request-reviews.html).

Fixes

* Agents

  Fixed choppy animation when expanding agent thoughts
* Agents

  Fixed agent chat incorrectly minimizing on external link click
* Agents

  Fixed the “Worked for X” label on agent session turns to measure active work time, excluding any idle wait between turns
* Agents

  Fixed agent panel staying focused when expanding or collapsing
* Agents

  Prevented the Ask Linear popup from reopening off-screen after the window height shrinks
* Agents

  Fixed Ask Linear drafts being lost when switching between chats
* Agents

  Fixed agent lists showing too many skills
* Asks

  Linear Asks Agent will now automatically reply to external users when requesting additional information
* Asks

  Fixed Asks Web submission attributions when the submitter logged into Asks Web before accepting their Linear workspace invite
* Desktop

  Fixed an issue where the desktop application could hang when waking up your computer from sleep
* Desktop

  Fixed desktop app flash of white background on new window open
* Diffs

  Fixed deduplication of linked PRs in issue attachment data
* Diffs

  Fixed refreshing the diff when a PR’s target branch changes (e.g., after a stacked parent merges and GitHub retargets the child)
* Diffs

  Stopped attributing GitHub PR comments authored by deleted (“ghost”) users to the wrong user in notifications
* Documents

  Fixed document mention notifications firing on every edit instead of just when a user is newly mentioned
* Documents

  Shortened the placeholder in the “Change document subscribers” action menu so its keyboard shortcut indicator no longer gets clipped
* GitHub

  Comments on a not-yet-linked GitHub PR now backfill the issue→PR link via magic-word matching the same way PR lifecycle and review events do
* Inbox

  Fixed “From is not” filter to correctly exclude issue assignment notifications from integration and OAuth application-driven assignments
* Inbox

  Fixed inbox badge getting stuck when arriving on a review via a legacy `/agent` URL
* Insights

  Fixed a bug where two Duplicate options appeared in the Time in status filter
* Integrations

  Figma links now show a clean `Figma` title instead of the raw marketing page title
* Issues

  Removed Duplicate status from quick issue create and issue template
* Project templates

  Allowed project-template sub-issues to target other private teams again
* Sentry

  Fixed a bug where Sentry-created issues could be assigned to deactivated users in triage
* Settings

  We now correctly truncate long team names in Teams settings list instead of overlapping the next column
* Shortcuts

  Fixed the Copy as Prompt shortcut so it updates issue status when auto-start-on-open is enabled
* Sync

  Fixed “Linear servers are not reachable” error that could appear after laptop unlock
* Triage

  Fixed workspace issue templates not appearing in triage automation filters
* Views

  Fixed list rows shifting horizontally when toggling a group in views with grouped columns

Improvements

* Android

  Improved Android to use server-side filtering for skills
* Agents

  Dashboard pages are now used as context in the Linear agent chat
* Integrations

  Connecting GitHub now defaults to enabling code access
* Project Slack channels

  Used an info-style toast when starting project Slack channel creation
* Reviews

  Activity page file and code comment links, and PR notifications, now open whichever code view (Diffs or Guide) you last visited
* Skills

  Updated empty state for skills to match other settings
* Timeline

  Improved timeline projects aside panel visibility to be remembered per view instead of globally
* Updates

  Removed the UI for hiding project and initiative update details
