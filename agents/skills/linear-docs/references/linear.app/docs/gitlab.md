---
title: "GitLab – Linear Docs"
source_url: "https://linear.app/docs/gitlab"
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

# GitLab

Linear supports linking your Linear issues to GitLab and automates your merge request workflows.

![Linear and GitLab logos](https://webassets.linear.app/images/ornj730p/production/d025b73f1b272515da65e8823306b88dff8aa699-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/gitlab.html#overview)

Link Linear issues to GitLab merge requests. Automate your MR workflow so that issues update when MRs are drafted, opened, merged and when reviews are requested. You can link single or multiple issues to a specific MR.

## Configure the GitLab integration[⁠](https://linear.app/docs/gitlab.html#configure-the-gitlab-integration)

We support linking GitLab merge requests for both hosted and self-hosted installations, as long as your installation is *publicly available*.

1. Navigate to [**Linear Settings > Features > Integrations > GitLab**](https://linear.app/settings/integrations/gitlab.html)
2. Click **Enable** to launch the set-up pop-up.

![Pop-up for setting up the GitLab integration](https://webassets.linear.app/images/ornj730p/production/535b00faf5fdbfad01399eb8bdaffb7ca1efa780-1002x948.png?w=1440&q=95&auto=format&dpr=2)

1. Navigate to [**GitLab > User Settings > Personal Access Token**](https://gitlab.com/-/user_settings/personal_access_tokens) or **GitLab > Project Settings > Access Token** to create a legacy API access token.

   An access token is used to query the GitLab API for further information and also used to post issue linkbacks. Because GitLab doesn’t support bot accounts, linkbacks are created under the name of the token owner. It’s recommended that you create a new user for Linear to act as the bot account.
2. When creating the legacy token, set the `api` *or* `read_api` scope.

   If the `read_api` scope is selected, Linear will not post linkbacks to the issue on GitLab merge requests. If using a project access token, the token needs `Reporter` role or higher.
3. **(Optional)** Enable and set a custom URL for your self-hosted GitLab installation without any path (e.g. `https://gitlab.yourcompany.com`). This URL needs to be accessible to public Internet and is only required for self-hosted installations. The earliest supported version of GitLab is 15.6.

   If you need to grant access to Linear’s IPs, they are documented on our [Security page](https://linear.app/docs/security.html#collapsible-fb465e337d77).
4. Click **Connect**.
5. Linear will generate the Webhook URL after it validates the access token. Copy and paste this URL to GitLab in either:
   1. A Group’s Webhook Settings (For a company on GitLab’s Premium or Ultimate tiers) to integrate all projects under it.
   2. A Project’s Webhook Settings, to individually connect a specific project.
6. Enable the following Triggers:
   1. `Push events`
   2. `Comments`
   3. `Merge request events`
   4. `Pipeline events`
7. Under SSL verification, ensure **Enable SSL verification** is checked
8. Click **Save changes**.

## Link Merge Requests[⁠](https://linear.app/docs/gitlab.html#link-merge-requests)

### Create a new branch[⁠](https://linear.app/docs/gitlab.html#create-a-new-branch)

Set the branch format in Linear **Settings > Workspace > Integrations GitLab > Branch format**. When viewing or selecting a Linear issue, use the *Copy git branch name* action or shortcut `Cmd/Ctrl` + `Shift`  `.` It will give you a branch name with the issue ID which you can use to create a new branch in GitLab.

We recommend using common branch naming patterns throughout all of your teams.

### Add the issue ID in the MR title[⁠](https://linear.app/docs/gitlab.html#add-the-issue-id-in-the-mr-title)

Include the Linear issue ID (e.g. ID-123) in the MR title when creating merge requests.

### Use a magic word[⁠](https://linear.app/docs/gitlab.html#use-a-magic-word)

Add a magic word + `issue ID` in the MR description (e.g. `Fixes ENG-123`). The integration cannot link MRs via comments or commit messages. The available magic words to link issues are: `close, closes, closed, closing, fix, fixes, fixed, fixing, resolve, resolves, resolved, resolving, complete, completes, completed, completing, implement, implements, implemented, implementing.`

To link MRs to issues **without** them automating your issue status on MR merge, use the one of the contributing magic words: `ref, references, part of, contributes to, towards, updates`. When using a non-closing magic word like this, the linked MR or commit will still move the issue through other statuses per Workflow settings, but will not automate the issue’s status when the MR or commit merges. Instead, it will only transition the issue through to what’s configured prior to the *On MR or commit merge* event.

Use `related to` or `relates to` to create a reference-only link. These links do not change the issue’s status or participate in Ready for merge automation.

#### Link multiple Linear issues to an MR[⁠](https://linear.app/docs/gitlab.html#link-multiple-linear-issues-to-an-mr)

To link multiple Linear issues to a single Merge Request, or to link a Merge Request after creating it, use the magic word linking method by including multiple closing statements in the MR description (e.g. `Fixes ENG-123, DES-5 and ENG-256`). Linking will happen after you save your changes. The Linear issue will not close until all Merge Requests have been closed/merged.

## Merge Request automation[⁠](https://linear.app/docs/gitlab.html#merge-request-automation)

The merge request automation allows you to select specific statuses for your Linear issues based on MR changes—saving you the hassle of updating Linear issues manually.

Customize the MR automation in **Settings > Team > Workflow**. Since this is a team setting, it must be configured for each team in your workspace.

![MR status automation set for the following categories: on draft mr open, on mr open, on mr review request, on mr ready for merge, on mr merge](https://webassets.linear.app/images/ornj730p/production/b26feeac53ba12d391fef53daa87a38366e4a6f2-1346x676.png?w=1440&q=95&auto=format&dpr=2)

### Ready for merge automation[⁠](https://linear.app/docs/gitlab.html#ready-for-merge-automation)

If you’d like to use the Merge Request automation to capture passing CI checks, please verify in GitLab that:

1. You have enabled Pipeline events under the Webhook settings for any repo part of the GitLab integration.
2. All pipelines that Linear should consider when determining if an MR is mergeable need to be merge request pipelines. GitLab documentation is available [here](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html).
3. Under ‘Merge requests’ in project settings, ‘Pipelines must succeed’ is checked.

If you want to capture MR approvals, please verify in **Project Settings > Merge requests** that Merge request approvals are required.

### Custom merge queues[⁠](https://linear.app/docs/gitlab.html#custom-merge-queues)

If you use a custom merge queue that merges changes and then closes the merge request, be sure to add the `externally-merged` label **before** closing it. This tells Linear to treat the merge request as successfully merged even though it was closed.

### Branch-specific rules[⁠](https://linear.app/docs/gitlab.html#branch-specific-rules)

You can set custom workflow automations based on particular target branches. For example, you can now configure that when a MR is merged to:

* `staging`, the issue status should change to “In QA”
* `main`, the issue status should change to “Deployed”

You can also override a default rule in a particular branch with “no action” if desired, so that issues linked to a change in that branch will not change status. Branch rules can be specified using regex, e.g: `^fea/.*` can set automations for all feature branches.

## Issue linkbacks[⁠](https://linear.app/docs/gitlab.html#issue-linkbacks)

When an issue is linked with a merge request, Linear posts a linkback message as a comment with the issue title and description. All the merge requests are also listed in the issue details in Linear. When your MR is being reviewed in GitLab, see the avatars of up to three most recent reviewers and their review states without leaving Linear. This cross-referencing makes it faster to retain context without jumping between apps. Linkbacks are managed by the scope selected.

## Auto-assign and update status[⁠](https://linear.app/docs/gitlab.html#auto-assign-and-update-status)

Save yourself a few steps by toggling on our automations in **Settings > My Account > Preferences > Behavior**.

* Auto-assigns the issue to you, and/or
* Move the issue to the first Started status (which you can customize in **Settings > Team > Workflow)** when you copy the git branch name.

## Auto-linking[⁠](https://linear.app/docs/gitlab.html#auto-linking)

GitLab supports rendering URLs pointing to Linear when you mention issue IDs in GitLab. To configure this functionality, please reference GitLab’s [documentation](https://docs.gitlab.com/user/project/integrations/linear/).

## FAQ[⁠](https://linear.app/docs/gitlab.html#faq)

Can I import or sync GitLab issues?

Our issue migration assistant does not support GitLab issues. We suggest customizing the CLI importer to import issues. One option is to customize the importer to support GitLab imports. Another option is to export GitLab issues to a CSV and then modify the headers and format so that it matches one of the issue trackers supported by the CLI.

How do I connect a MR that is already open?

Modify the MR title or description to link an issue. See the section on this page titled *Linking MRs to issues*.

How do I remove a MR from an issue?

Open the issue in Linear and right click on the merge request attachment to bring up an option to remove it. You can also do this through the command menu in Linear by viewing or selecting an issue, then searching for `git.`

I get a notification in Linear every time a MR is open. How can I change this?

Go to integration settings and remove linkbacks. This should reduce the notifications.

My issue title is not showing up in GitLab comments, just the issue ID. Why?

If your team is private, we won’t disclose the issue title. The link will go to your Linear issue and be accessible only by users who are part of that private team.

What permissions do the integrations require?

On GitLab, we have both read and write access with their API (they don’t have separate permissions for comments).

Why does Linear need an access token?

During integration setup, Linear requires an access token. The below is an exhaustive list of how that token is used:

* To get supplemental information about merge requests that isn’t included in the webhooks we receive
* For posting linkbacks on linked merge requests
* To retrieve merge request information when linking an MR to an issue (for rich attachment)
* To retrieve merge request mergeability status when a pipeline completes

Why are my Linear issues not progressing to my "On MR ready for merge" status?

We currently only allow issues to transition to the status you’ve chosen for “On MR ready for merge” if you also have a status selected for “On MR review request or activity”. Make sure that you have a status selected for this event.

![GitLab MR workflow status events](https://webassets.linear.app/images/ornj730p/production/69971e7151c829466d84567e82fbf516db5c6390-1586x742.png?w=1440&q=95&auto=format&dpr=2)

GitLab MR workflow status events

My GitLab integration stopped working

In GitLab’s webhook settings, check that the webhook used for Linear is active. If it isn’t, please send take a screenshot of its recent events and send it into [support@linear.app](mailto:support@linear.app) for further support.

In the meantime, please click the “Test” button for the relevant webhook and confirm if you continue to see issues with the integration.

Can I add multiple GitLab instances?

It is not currently possible to connect multiple GitLab instances to your Linear workspace, you will need to select one GitLab instance to connect within your GitLab settings.

[Previous

GitHub](https://linear.app/docs/github-integration.html)[Next

Google Sheets](https://linear.app/docs/google-sheets.html)

* [Overview](https://linear.app/docs/gitlab.html#overview)
* [Configure the GitLab integration](https://linear.app/docs/gitlab.html#configure-the-gitlab-integration)
* [Link Merge Requests](https://linear.app/docs/gitlab.html#link-merge-requests)
* [Create a new branch](https://linear.app/docs/gitlab.html#create-a-new-branch)
* [Add the issue ID in the MR title](https://linear.app/docs/gitlab.html#add-the-issue-id-in-the-mr-title)
* [Use a magic word](https://linear.app/docs/gitlab.html#use-a-magic-word)
* [Link multiple Linear issues to an MR](https://linear.app/docs/gitlab.html#link-multiple-linear-issues-to-an-mr)
* [Merge Request automation](https://linear.app/docs/gitlab.html#merge-request-automation)
* [Ready for merge automation](https://linear.app/docs/gitlab.html#ready-for-merge-automation)
* [Custom merge queues](https://linear.app/docs/gitlab.html#custom-merge-queues)
* [Branch-specific rules](https://linear.app/docs/gitlab.html#branch-specific-rules)
* [Issue linkbacks](https://linear.app/docs/gitlab.html#issue-linkbacks)
* [Auto-assign and update status](https://linear.app/docs/gitlab.html#auto-assign-and-update-status)
* [Auto-linking](https://linear.app/docs/gitlab.html#auto-linking)
* [FAQ](https://linear.app/docs/gitlab.html#faq)
