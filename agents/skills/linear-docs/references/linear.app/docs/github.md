---
title: "GitHub – Linear Docs"
source_url: "https://linear.app/docs/github"
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

# GitHub

Linear supports linking your GitHub pull requests, automating workflow statuses, and syncing issues between GitHub and Linear.

![Linear logo and GitHub logo](https://webassets.linear.app/images/ornj730p/production/d41fdca27f9f36238e86e4c01d3cd9d91b078d6b-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/github.html#overview)

The GitHub integration offers two core functionalities:

| Link GitHub PRs | Sync GitHub issues |
| --- | --- |
| Automate your issue status by linking to a GitHub pull request or commit to follow their progress. | Sync Linear teams to GitHub repos of your choice, to automatically create and sync issues between Linear and GitHub. This will create a synced thread in the Linear issue so comments will sync both ways  This will only sync issues *going forward*. To import and sync historical GitHub Issues, refer to our [GitHub Issues Importer](https://linear.app/docs/github-to-linear.html). |

### Permissions[⁠](https://linear.app/docs/github.html#permissions)

Permissions depend on whether code access is enabled.

* **Read access to** checks, commit statuses, deployments, members, merge queues, and metadata
* **Read and write access to** actions, code, issues, pull requests, and workflows

To grant Linear organization-level access in GitHub, the integration must be installed by a GitHub organization owner. If you only need repository-level access, a repository administrator can install the integration instead.

The GitHub integration can link pull requests and sync issues without access to repository code. To view pull request diffs and file contents in Linear, enable code access for the selected repositories. On [GitHub](https://github.com), this uses the Linear Code GitHub App.

Pull requests can appear in Reviews without repository code access. If you can’t check or change the installation’s repository access, ask your GitHub organization owner to confirm the setup. See [Reviews setup](https://linear.app/docs/pull-request-reviews.html#setup) for organization and personal account requirements.

## Configure[⁠](https://linear.app/docs/github.html#configure)

### Enable the GitHub integration[⁠](https://linear.app/docs/github.html#enable-the-github-integration)

1. Go to [Setting > Features > Integrations > GitHub](https://linear.app/settings/integrations/github.html)
2. Click **Enable**
3. Select the GitHub organization you want to connect
4. Select **All repositories** or **Only select repositories** and choose the repositories you want to connect
5. Click **Install**
6. Authenticate into your personal GitHub account

#### GitHub Enterprise options [⁠](https://linear.app/docs/github.html#github-enterprise-options)

Available to workspaces on our [Enterprise](https://linear.app/pricing.html) plan.

If it’s relevant to your organization, GitHub Enterprise Cloud and GitHub Enterprise Server require additional setup compared to GitHub.com. See the following section for details of each.

GitHub Enterprise CloudGitHub Enterprise Server (self-hosted)

GitHub Enterprise Cloud has a dedicated Linear integration for organizations on `*.ghe.com`.

To get started, go to [Settings > Integrations > GitHub Enterprise Cloud](https://linear.app/settings/integrations/github-enterprise-cloud.html). Select *Enable* and enter your .ghe domain name. Follow the steps through to set it up. One GitHub organization is selected during install. To connect additional organizations, repeat the flow. Once all organizations are added, people should add their personal connection.

If your GitHub organization has an IP Allow List enabled—this applies to GitHub.com organizations as well as GitHub Enterprise Cloud—you’ll also need to turn on *Enable IP allow list configuration for installed GitHub Apps* setting to enable Linear’s GitHub integration. [Read more here](https://docs.github.com/en/organizations/keeping-your-organization-secure/managing-allowed-ip-addresses-for-your-organization#allowing-access-by-github-apps).

Alternatively you can grant access to Linear’s IP addresses:

`35.231.147.226`

`35.243.134.228`

`35.196.141.51`

`34.140.253.14`

`34.38.87.206`

`34.62.119.29`

`34.134.222.122`

`35.222.25.142`

`34.60.255.158`

If you use *Coding sessions*, also allow the following static outbound IP addresses, which are managed by our sandbox provider and assigned exclusively to Linear:

`52.213.165.62`

`34.253.145.97`

`54.205.34.6`

`100.60.25.137`

`100.29.161.36`

We’ve expanded Linear’s pull request automation to self-hosted GitHub Enterprise Server. You can now install the [new integration](https://linear.app/integrations/github-enterprise-server.html) to link Linear issues with a GitHub instance that’s hosted in a custom URL. This integration doesn’t require new firewall rules.

GitHub Enterprise Server supports the core webhook-based linking and sync flows, but it does not offer full feature parity with the standard GitHub integration.

Some functionality depends on API-based access that isn’t available in the same way on GitHub Enterprise Server.

The table below provides a comparison of available features across GitHub.com, GitHub Enterprise Cloud, and GitHub Enterprise Server.

| Feature | GitHub.com | GitHub Enterprise Cloud (\*.ghe.com) | GitHub Enterprise Server |
| --- | --- | --- | --- |
| Installation Method | Linear GitHub App | Linear GitHub App | Separate GHES App |
| IP Requirements | None | IP Allow List config required if enabled | No additional network setup required |
| Multiple GitHub Orgs | Yes | Yes | No |
| PR Linking | Yes | Yes | Yes |
| Branch Name Formatting | Yes | Yes | Yes |
| Status Automation from PRs | Yes | Yes | Yes |
| Magic Words for Linking | Yes | Yes | PR description only |
| Commit Linking | Yes | Yes | No |
| GitHub Issues Sync | Yes | Yes | No |
| Issues Sync → Multiple Repositories to Single Team | Yes | Yes | No |

#### Add multiple GitHub organizations[⁠](https://linear.app/docs/github.html#add-multiple-github-organizations)

Click the **+** icon under *Connected organizations* to add another GitHub organization. This will take you through the same flow as when you connected the first organization. Currently, we support multiple organizations for the PR automation only. You will only be able to use commit linking with a single GitHub organization.

It is not possible to connect multiple Linear workspaces to a single GitHub organization. This is a limitation on GitHub’s side. GitHub Apps can only be installed once for a GitHub organization so this means only one Linear workspace can be connected.

#### Branch format[⁠](https://linear.app/docs/github.html#branch-format)

Select the branch format you want to use when copying the branch name using `Cmd` + `Shift` + `.` from a Linear issue and pasting it into your branch name.

![Branch format setting](https://webassets.linear.app/images/ornj730p/production/9a16304705f1e90c4056d4270221b3f09ac7c71b-1362x366.png?w=1440&q=95&auto=format&dpr=2)

### Personal account connection[⁠](https://linear.app/docs/github.html#personal-account-connection)

In addition to the organization-level setup, each member should connect their personal GitHub account. This ensures that the activity feed, synced comments, and assignees are mapped directly to the connected user in Linear, rather than appearing as generic GitHub activity.

Connect your personal GitHub account to reply to GitHub-synced issue threads from Linear. If your account isn’t connected, you’ll be prompted to connect it before replying. For GitHub Enterprise Server, connect an account on the same instance used by the integration.

To connect your account, navigate to [Settings > Connected accounts](https://linear.app/settings/connected-accounts.html). Once connected, any synced activity from GitHub will be correctly attributed to you in Linear.

![Section in your GitHub integration settings that indicates your personal account is not yet connected.](https://webassets.linear.app/images/ornj730p/production/48fb82ecd332e000afc047dc8a8fb5459079cdd2-1362x200.png?w=1440&q=95&auto=format&dpr=2)

![Connect your personal GitHub account to link issues with commits, PRs, and branches.](https://webassets.linear.app/images/ornj730p/production/ec39f09171f32564bb2e8314bebaa85513b0b4ed-1422x466.png?w=1440&q=95&auto=format&dpr=2)

### Enable commit linking[⁠](https://linear.app/docs/github.html#enable-commit-linking)

1. Turn on the toggle for **Link commits to issues with magic words** at the bottom of the GitHub settings page.
2. Go to **Settings → Webhooks** in your GitHub organization or repository.
3. Click **Add webhook** button
4. Input the Payload URL and Secret provided in Linear, and select `application/json` content type. Leave “Push events” selected.
5. Click **Add webhook**.
6. Go back to Linear and click **Done**.

![Setting to enable commit linking](https://webassets.linear.app/images/ornj730p/production/1aae774b895db809359e7fd2b080341a6b797de1-1372x250.png?w=1440&q=95&auto=format&dpr=2)

### Configure GitHub Issues Sync[⁠](https://linear.app/docs/github.html#configure-github-issues-sync)

Watch this video to see how GitHub Issues sync works:

[![](https://webassets.linear.app/images/ornj730p/production/5f3c96a44e55a647f91140906ac41beff871f735-1280x720.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/27bbcb51c07b84bfc28a2fc30eb708612d1e8852.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

From the *GitHub Issues* section of the [GitHub integration settings](https://linear.app/settings/integrations/github.html), click the **+** icon, then select the GitHub repo and Linear team to link.

You can choose to sync:

* **One-way**: issues created in GitHub will create a synced copy in Linear, or
* **Two-way**: issues created in either the GitHub repo or Linear team will create a synced copy in the other software

![GitHub Issue Sync configured for two repositories, mapped to their correlated Linear teams.](https://webassets.linear.app/images/ornj730p/production/88707d9d9208d520011ef1abc28e28d63093c236-1370x620.png?w=1440&q=95&auto=format&dpr=2)

![Setup for GitHub Issues Sync.](https://webassets.linear.app/images/ornj730p/production/f5210265017419b639ab32ccbe952133c74316ef-1042x980.png?w=1440&q=95&auto=format&dpr=2)

Multiple repositories can be connected to create issues to a single Linear team through one-way sync when issues are created in GitHub. However, only one repo can be configured for two-way sync at a time.

You can enable two-way sync when connecting a repo to Linear, or change this to another repo by pressing **... > Edit Link** on an existing repo connection.

GitHub Issues Sync will only sync newly created issues. To sync existing GitHub Issues, you will have to import them. Refer to the [Importer](https://linear.app/docs/import-issues.html#github-issues) page.

Properties that are synced between Linear and GitHub issues include:

| title |
| --- |
| description |
| status | Please note that any custom statuses set at the GitHub Project level do not sync to Linear. |
| assignee | Linear users can connect their GitHub account to be synced as the issue assignee. |
| labels |
| sub-issues | Multi-level & cross-repository/team hierarchies are supported. If parent issue is not a synced issue (e.g. it's in a different GH repo/Linear team), the sub-issue can still get synced, but will have no parent issue set on the other end. |
| comments | Comments made not in the synced thread of the Linear issue will not get synced to the GitHub issue. This allows for private discussions. |
| priority |

Moving GitHub synced Linear issues between Linear teams will maintain the synced relationship. You can also transfer GitHub issues between two synced repos; this will appropriately update the team of the associated issue in Linear.

To manually stop syncing, remove the attachment from the Linear issue through its overflow menu.

#### **Issue sync banners**[⁠](https://linear.app/docs/github.html#issue-sync-banners)

Once an issue is synced between GitHub and Linear, a banner will appear at the top of the issue to make this clear. The banners will display information to show current sync status or will surface any errors with syncing.

![Synced issue banners showing connected and a sync error](https://webassets.linear.app/images/ornj730p/production/d0d25688334fad6ebef18e9411daad033b77432f-2990x400.png?w=1440&q=95&auto=format&dpr=2)

GitHub sync banners in Linear, showing issue #37 is connected and #34 had a sync error.

## Linking Linear issues to GitHub PRs[⁠](https://linear.app/docs/github.html#linking-linear-issues-to-github-prs)

You can link a Linear issue using pull requests or commits.

Watch this video for a quick demo on the available linking methods:

[![](https://webassets.linear.app/images/ornj730p/production/47503a43bfa9564e7eb4872755ceabbeb22bfc8f-1280x720.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/d97ba48f0c5840572625fd4038594b09bf35184a.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

### Link through pull requests[⁠](https://linear.app/docs/github.html#link-through-pull-requests)

#### Branch name[⁠](https://linear.app/docs/github.html#branch-name)

Include issue ID in the branch name. Use the *Copy git branch name* action or shortcut `Cmd/Ctrl` + `Shift` + `.` when viewing or highlighting an issue and paste it into the new branch name in GitHub.

#### Issue ID in Pull Request title[⁠](https://linear.app/docs/github.html#issue-id-in-pull-request-title)

Include the Linear issue ID (e.g. ID-123) in the title when creating pull requests.

Use a magic word + issue ID in the PR description or title (for example, `Fixes ENG-123` or `Fixes https://linear.app/workspace/issue/ENG-123/title`) to link the PR to the issue. If the issue is unassigned when linking takes place, you will be added as the assignee of the issue.

#### Magic words[⁠](https://linear.app/docs/github.html#magic-words)

Linear offers *closing* and *non-closing* magic words so you can customize your workflow. When you use a *closing* magic word, the issue will move through your mapped automation workflow when the branch is pushed and to the status configured for *On PR or commit merge* when the PR or commit is merged.

When you use a *non-closing* magic word, the linked PR or commit will still move the issue through other statuses per your workflow settings, but it will not apply the *On PR or commit merge* status when the PR or commit merges.

When you use a *relation* magic word, Linear simply marks the PR as related to the issue, with no status changes.

The **closing magic words** are: `close, closes, closed, closing, fix, fixes, fixed, fixing, resolve, resolves, resolved, resolving, complete, completes, completed, completing, implement, implements, implemented, implementing, linear issue`*.*

The **non-closing magic words** are: `ref, refs, references, part of, contributes to, toward, towards`*.*

The **relation magic words** are `relates to`, `related to`.

To prevent a specific issue from being linked automatically, use `skip` or `ignore` with that issue ID. For example: `Ignore ENG-123`.

**Create an issue with a magic word**

Add `{TEAM}-NEW` to a pull request description to create and link an issue in that team. Replace `{TEAM}` with the team’s key, for example `ENG-NEW`. This new issue is created in Started status and assigned to the pull request author when possible.

On [Business](https://linear.app/pricing.html) and [Enterprise](https://linear.app/pricing.html) plans, Linear uses AI to write the title and description and automatically sets labels, projects, and milestones based on the pull request content and the author’s recently completed issues. On other plans, Linear creates the issue in the specified team using the pull request title, without AI enhancements.

Use a team you belong to. If a pull request already has a linked issue or includes an existing issue reference, Linear does not create another issue.

### Link using commits[⁠](https://linear.app/docs/github.html#link-using-commits)

Use a magic word before the issue ID in commit message to link issues. We’ll move the issue to `In Progress` when the commit is pushed and `Done` when the commit reaches the default branch.

## Link multiple issues[⁠](https://linear.app/docs/github.html#link-multiple-issues)

**Link multiple issues to one PR**

Include multiple issue IDs after a magic word in the PR title or description (for example, `Fixes ENG-123, DES-5, and ENG-256`). Linking happens after you save your changes. Magic words in PR comments won’t create links.

**Link multiple PRs to one Linear issue**

You can link multiple PRs to a single Linear issue using any linking technique. The Linear issue status will be updated when the final linked PR moves to the required state from your workflow.

For example if you have 2 PRs linked to 1 issue, you’ll need merge both PRs before the Linear issue status will change.

## Viewing a linked Linear issue[⁠](https://linear.app/docs/github.html#viewing-a-linked-linear-issue)

### Remove a PR from an issue[⁠](https://linear.app/docs/github.html#remove-a-pr-from-an-issue)

To remove a PR from a Linear issue, open the issue, click on the three dots on the PR attachment, and select **Remove**. You can also do this through the command menu in Linear by viewing or selecting an issue, then searching for `git.`

To link a PR that is already open, modify the PR title or description to link an issue.

### PR review state[⁠](https://linear.app/docs/github.html#pr-review-state)

When individual reviewers comment, request changes, or approve your PR, we’ll display their avatars and their actions on the GitHub attachment visible on the linked Linear issue. You can use this feature to quickly parse the review state of your PR without needing to return to GitHub.

![PR comments and approved state displayed in Linear attachment.](https://webassets.linear.app/images/ornj730p/production/71c7f822215a7dbd92212e4e4cf15fe06412bec0-1642x190.png?w=1440&q=95&auto=format&dpr=2)

If you request a team review instead of a review from specific individuals, we display “review requested” or “in review” on the GitHub attachment in place of user avatars.

### Pull request preview links[⁠](https://linear.app/docs/github.html#pull-request-preview-links)

If your PR contains one or multiple preview links, this will add a preview link shortcut to the Linear issue.

Preview links are automatically detected for popular platforms like Vercel, Netlify, Cloudflare and AWS Amplify if you have connected Linear with your GitHub repository. For custom preview links, add a Markdown link whose visible label ends with “Preview” (case-insensitive). The destination can be any valid HTTPS URL. Put “Preview” inside the link label—not only in surrounding text. Linear parses links in the pull request description and in eligible comments from the pull request author or a GitHub bot.

```
<!-- Detected -->
[Prod Preview](https://linear.app/docs/<preview-url>)
[Staging Preview](https://linear.app/docs/<preview-url>)

<!-- Not detected -->
[Prod](https://linear.app/docs/<preview-url>)
Preview: [Staging](https://linear.app/docs/<preview-url>)
```

Multiple previews for a single PR are available in a dropdown menu, with customizable names and icons for easy identification (e.g. mobile and desktop previews). Icons are automatically chosen to reflect best their name, such as a mobile icon for mobile release links. Preview links are automatically removed after 30 days of inactivity on the PR.

![Preview links on a Linear issue](https://webassets.linear.app/images/ornj730p/production/3a621c036a7905eba1232e10ab9d0198b462ad4d-2140x1105.png?w=1440&q=95&auto=format&dpr=2)

**Pull request preview link accepted formats**

PR description textVercel Preview commentsNetlify Preview comments

Links that end with “preview” in your PR descriptions and comments will get added to the Linear issue as a preview link.
For example:

![PR containing preview links](https://webassets.linear.app/images/ornj730p/production/2560ff47911cab9d2cd2b0a4df57810572801a98-901x649.png?w=1440&q=95&auto=format&dpr=2)

Vercel comments with the following format will be added as a preview link in your Linear issue.

![Vercel preview comment in GitHub](https://webassets.linear.app/images/ornj730p/production/56ded746ad9cab1212c73a7619cfcaf528d2cd8f-1278x531.png?w=1440&q=95&auto=format&dpr=2)

Netlify comments with the following format will be added as a preview link in your Linear issue.

![Netlify PR comment with preview](https://webassets.linear.app/images/ornj730p/production/99d538e6966157ac67473bb4a2e70db205f1aa3a-1277x575.png?w=1440&q=95&auto=format&dpr=2)

## Workflow automation[⁠](https://linear.app/docs/github.html#workflow-automation)

### Issue status updates[⁠](https://linear.app/docs/github.html#issue-status-updates)

Updates to PRs can automatically update the status of their linked Linear issues.

Watch this video to explore more about how issue status automation works:

[![](https://webassets.linear.app/images/ornj730p/production/4ca41a90c116a9cf7c73742ef9dfdf19bb957c97-1280x720.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/8a2505bb37058e85139d4715a8568d9318016c5a.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

You can customize the automation in *Settings > Team > Workflows & automations > Pull request and commit automations.* Since this is a team setting, it must be configured for each team in your workspace.

You can configure status updates when PRs are drafted, opened, have a review requested, are ready for merge, and merged. By default, we will move linked issues to “In Progress” when PRs are open and “Done” when PRs merge.

![Pull request and commit automation](https://webassets.linear.app/images/ornj730p/production/84e19df283f1da9252108a9fed0a4761697bb999-1430x896.png?w=1440&q=95&auto=format&dpr=2)

The “Ready for merge” automation relies on GitHub reporting a stable/mergeable PR status. If any check (including non-required checks) fails, GitHub reports the PR as unstable and the automation to move issues to the ready-for-merge destination will not trigger.

### Automatic PR Cancellation[⁠](https://linear.app/docs/github.html#automatic-pr-cancellation)

When you directly cancel an issue, Linear closes open GitHub pull requests linked with the **Closes** or **Contributes** relationship. Marking an issue as duplicate has the same effect. A pull request remains open when it is also linked to another open Linear issue or is linked only as a reference. Completing an issue and automated cancellations do not close pull requests.

### Custom merge queues[⁠](https://linear.app/docs/github.html#custom-merge-queues)

If you use a custom merge queue that merges changes and then closes the pull request, be sure to add the `externally-merged` label **before** closing it. This tells Linear to treat the pull request as successfully merged even though it was closed.

### Branch protection rules[⁠](https://linear.app/docs/github.html#branch-protection-rules)

Once a review is requested, if you do not have [branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule) rules set up in GitHub, the issue will skip the “review request or activity” state and move to “ready to merge”. Without branch protection rules, a PR is considered always mergeable. Please note that “ready to merge” automations will not fire if a “review request or activity” automation is not also configured.

### Branch-specific rules[⁠](https://linear.app/docs/github.html#branch-specific-rules)

You can also set custom workflow automations based on particular target branches.

For example, you can now configure that when a PR is merged to:

* `staging`, the issue status should change to “In QA”
* `main`, the issue status should change to “Deployed”

Branch rules apply only to target branches—the branch a PR is being merged *into*. Automations are not supported for source branches, the branch the PR is created *from*.

Watch this video to visualize how branch-specific rules work:

[![](https://webassets.linear.app/images/ornj730p/production/9772ce2f3d562af2911ac9a6611b7e2201c2aaf2-1280x720.jpg?q=95&auto=format&dpr=2)](https://webassets.linear.app/files/ornj730p/production/21ec41c5cace62492df29c5cf5ec36138f0600d8.mp4)

Elapsed00:00Remaining time unknown−--:--

0.25×0.5×0.75×1×1.25×1.5×1.75×2×

You can also override a default rule in a particular branch with “no action” if desired, so that issues linked to a change in that branch will not change status. Branch rules can be specified using regex, e.g: `^fea/.*` can set automations for all feature branches.

![Image shows a set of default rules, rules specific to a "staging" branch.](https://webassets.linear.app/images/ornj730p/production/61ff343a87898b3f64535a1af1fc09b1da76d711-1414x862.png?w=1440&q=95&auto=format&dpr=2)

### Auto-assign and move issue to start[⁠](https://linear.app/docs/github.html#auto-assign-and-move-issue-to-start)

Save yourself a few steps by toggling on our automations that moves a Linear issue into a started status when you copy the git branch name. To set up this automation, refer to your [Code & reviews settings](https://linear.app/settings/account/code-and-reviews.html).

You can also configure an automation to always assign issues you create to yourself, and extend this by automatically assigning issues you move to a started status. These settings are configured in your [Preferences](https://linear.app/docs/account-preferences.html#auto-assign-to-self).

### Pull request triggers for loops[⁠](https://linear.app/docs/github.html#pull-request-triggers-for-loops)

Run a loop when selected activity occurs on a pull request, including when a GitHub label is added or removed. For example, draft a QA checklist when the **QA Test** label is added.

Pull request triggers use Linear’s GitHub integration, not a GitHub MCP connection. A workspace admin must allow the repository in **Settings → Loops → Allow loops to access code**.

See [Pull request triggers](https://linear.app/docs/loops.html#pull-request-triggers) for setup instructions, supported events, and filters.

## Other settings[⁠](https://linear.app/docs/github.html#other-settings)

### Linkbacks[⁠](https://linear.app/docs/github.html#linkbacks)

When an issue is linked with a pull request, commit or GitHub Issue, Linear posts a linkback message as a comment with the issue title and description—including any images or attachments that exist within the description. All the pull requests are also listed in the issue details in Linear. This cross-referencing makes it faster to retain context without jumping between apps.

If enabled for private teams, the issue titles will not be included in the comment. The link will go to your Linear issue and be accessible only by users who are part of that private team.

![Setting for enabling or disabling linkbacks.](https://webassets.linear.app/images/ornj730p/production/524d938918c0a733d722d9a39f8c3589265dba8a-1376x490.png?w=1440&q=95&auto=format&dpr=2)

### Enable Autolink[⁠](https://linear.app/docs/github.html#enable-autolink)

If you want to automatically resolve your Linear issue IDs (e.g. *ENG-123*) in PR descriptions or comment to links, you can enable this using GitHub’s *Autolink references* feature. See instructions on [GitHub](https://help.github.com/en/github/administering-a-repository/configuring-autolinks-to-reference-external-resources).

Use the following URL format: `https://linear.app/<workspace>/issue/ID-<num>` where `workspace` corresponds to your workspace’s URL and `ID` is the issue identifier key for your team. You need to add each team separately as they all have a different ID pattern.

If you change your Linear team name/ID, you may need to reconfigure the Autolink settings.

## FAQ[⁠](https://linear.app/docs/github.html#faq)

My integration is not working.

If you get an error when setting up your GitHub integration, or it doesn’t work:

1. Disconnect the integration from GitHub’s side.
2. Open Linear in the browser and reset your local database by going to [https://linear.app/reset](https://linear.app/reset.html).
3. Reconnect the integration in Linear settings.

These are the most common causes of errors:

* The integration got out of sync. In this case, reconnecting and resetting should fix it.
* You can only connect your GitHub account to a single Linear workspace. The workaround is to ask someone else from your org to set up the integration.

I get a notification in Linear every time a PR is open. How can I change this?

Go to integration settings and remove linkbacks. This should reduce the notifications.

GitHub Enterprise Server integration isn't linking pull requests

Make sure you completed the following steps during integration installation:

1. Copied the provided *webhook secret* and saved it when creating the Linear GitHub App for your GHES instance. Without the secret, Linear is unable to verify requests
2. Installed the newly created app to organizations and their repos you wish to link

If you missed the step 1 during installation, you’ll need to Disconnect the integration inside Linear, and remove the installation inside your GitHub’s developer settings, and re-install.

If you haven’t completed the step 2, but successfully created the app, you can link new organizations and repositories under “Install App” in the application’s developer settings.

If you have added new organizations, or repositories, they will also need to be linked to the application under developer settings under the “Install App” menu.

Why is my "Ready for merge" workflow not triggering?

For the “Ready for merge” workflow to trigger, either review or checks are required within GitHub for this PR. Without either of these, the “Ready for merge” workflow will not trigger.

![GitHub workflow settings](https://webassets.linear.app/images/ornj730p/production/6f22958c2c097f287fc3304dddc183a08d803a0f-1332x608.png?w=1440&q=95&auto=format&dpr=2)

GitHub workflow settings

Does the GitHub integration support squash merging?

If you have already merged multiple PRs into a single branch and you want to merge that branch into a new branch, we will not auto-detect any Linear issues that were linked in the previous PRs. You will need to link each issue anew. You can do this by mentioning the Linear issue IDs in the new PR title or by mentioning them alongside magic words in the PR description.

How can I unlink a PR from a Linear issue when the branch name includes the issue ID?

If your branch name includes a Linear issue ID, Linear will automatically link the pull request to that issue. Even if you manually unlink it, the connection can return when you push new commits or when the PR is merged.

To prevent this from happening, include the magic word `skip` or `ignore` followed by the relevant Linear issue ID in the PR description:

* `skip ENG-123`
* `ignore ENG-123`

This will fully unlink the PR and prevent status automation, even if the branch name still includes the issue ID.

* [Overview](https://linear.app/docs/github.html#overview)
* [Permissions](https://linear.app/docs/github.html#permissions)
* [Configure](https://linear.app/docs/github.html#configure)
* [Enable the GitHub integration](https://linear.app/docs/github.html#enable-the-github-integration)
* [GitHub Enterprise options](https://linear.app/docs/github.html#github-enterprise-options)
* [Add multiple GitHub organizations](https://linear.app/docs/github.html#add-multiple-github-organizations)
* [Branch format](https://linear.app/docs/github.html#branch-format)
* [Personal account connection](https://linear.app/docs/github.html#personal-account-connection)
* [Enable commit linking](https://linear.app/docs/github.html#enable-commit-linking)
* [Configure GitHub Issues Sync](https://linear.app/docs/github.html#configure-github-issues-sync)
* [Issue sync banners](https://linear.app/docs/github.html#issue-sync-banners)
* [Linking Linear issues to GitHub PRs](https://linear.app/docs/github.html#linking-linear-issues-to-github-prs)
* [Link through pull requests](https://linear.app/docs/github.html#link-through-pull-requests)
* [Branch name](https://linear.app/docs/github.html#branch-name)
* [Issue ID in Pull Request title](https://linear.app/docs/github.html#issue-id-in-pull-request-title)
* [Magic words](https://linear.app/docs/github.html#magic-words)
* [Link using commits](https://linear.app/docs/github.html#link-using-commits)
* [Link multiple issues](https://linear.app/docs/github.html#link-multiple-issues)
* [Viewing a linked Linear issue](https://linear.app/docs/github.html#viewing-a-linked-linear-issue)
* [Remove a PR from an issue](https://linear.app/docs/github.html#remove-a-pr-from-an-issue)
* [PR review state](https://linear.app/docs/github.html#pr-review-state)
* [Pull request preview links](https://linear.app/docs/github.html#pull-request-preview-links)
* [Workflow automation](https://linear.app/docs/github.html#workflow-automation)
* [Issue status updates](https://linear.app/docs/github.html#issue-status-updates)
* [Automatic PR Cancellation](https://linear.app/docs/github.html#automatic-pr-cancellation)
* [Custom merge queues](https://linear.app/docs/github.html#custom-merge-queues)
* [Branch protection rules](https://linear.app/docs/github.html#branch-protection-rules)
* [Branch-specific rules](https://linear.app/docs/github.html#branch-specific-rules)
* [Auto-assign and move issue to start](https://linear.app/docs/github.html#auto-assign-and-move-issue-to-start)
* [Pull request triggers for loops](https://linear.app/docs/github.html#pull-request-triggers-for-loops)
* [Other settings](https://linear.app/docs/github.html#other-settings)
* [Linkbacks](https://linear.app/docs/github.html#linkbacks)
* [Enable Autolink](https://linear.app/docs/github.html#enable-autolink)
* [FAQ](https://linear.app/docs/github.html#faq)
