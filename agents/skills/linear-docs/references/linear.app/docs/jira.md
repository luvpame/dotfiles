---
title: "Jira – Linear Docs"
source_url: "https://linear.app/docs/jira"
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

# Jira

Enable Jira Sync while trialing or transitioning to Linear to keep Jira spaces up to date.

![Linear and Jira logos](https://webassets.linear.app/images/ornj730p/production/adbef6f35402b94c3522a0f38ac578573dcb6f57-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/jira.html#overview)

The Jira integration connects your Jira spaces to Linear teams, allowing organizations to run a pilot or work through a gradual transition. Once configured, issues and projects will be created in Linear when issues and epics are created in a Jira space.

Issues belonging to that synced space prior to the sync was configured will not create issues in Linear. However, when those older issues and epics receive updates in Jira, the updates will prompt those issues to be created and synced in Linear.

### Limitations[⁠](https://linear.app/docs/jira.html#limitations)

There are features in Jira that Linear has chosen not to pursue as a matter of product philosophy. These discrepancies are worth noting, as they will affect sync. Among these are Issue Type, Constraints, Components, and Required fields. Read more about how these differences are handled by sync below.

Required fields

If a Jira project’s workflow demands required fields, we will not create the synced issue or project in Linear. In the case where an issue has been created in Linear before required fields are enforced in Jira, we’ll send an error to the Linear issue as a comment to surface the problem.

Issue type

Issue type is a native required field in Jira. Bug, Story, Epic and Task are common issue types. When you create a new issue in Linear and we create a synced issue in Jira, it will be type *Task* if we find that type in Jira.

If this type has been deleted, we’ll fallback to the first type on the list. If issues created in Linear are created in Jira as *Story* for instance, you may wish to create a type *Task* so that future issues created in Linear will display appropriately.

Constraints

You may have constraints in Jira that prevent certain updates to a Jira issue until various conditions are met.

If you update a synced Linear issue in a way that violates Jira constraint, the Linear issue will update but the Jira issue will not.

Components

In a synced Linear issue or project, components appear as labels - “Component: Engineering” for instance. These labels cannot be grouped or deleted. Removing a component label from an issue in Linear will remove the component in the synced Jira issue.

Hierarchy Limitations

Linear and Jira have different restrictions for issue and project hierarchy that can lead to discrepancies. If you remove a parent relationship (Project > Issue > Sub-issue) in Linear that would violate Jira’s hierarchy constraints (Epic > Story/Bug/Task > Sub-issue), the sync may fail or show discrepancies.

## Permissions required[⁠](https://linear.app/docs/jira.html#permissions-required)

The Jira integration can be configured using a Jira user account, Jira service account, or manual webhooks.

### Jira user account[⁠](https://linear.app/docs/jira.html#jira-user-account)

The user creating the API token must have the global ADMINISTER [permission](https://support.atlassian.com/jira-cloud-administration/docs/manage-global-permissions/) in Jira. This is necessary for Linear to install the required webhooks. It is possible to remove the ADMINISTER permission after the setup is complete without impacting the integration.

The default token expiry is one week, please choose to enable for **one year** instead.

**Jira Cloud** - Create an API key for this user by following instructions [here](https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/).

**Jira Server** - API keys might not be available. Instead, you need to create a personal access token (or PAT). Instructions can be found [here](https://confluence.atlassian.com/enterprise/using-personal-access-tokens-1026032365.html).

### Jira service account[⁠](https://linear.app/docs/jira.html#jira-service-account)

The service account requires admin permissions with the follow required scopes:

* `read:jira-user`
* `read:jira-work`
* `write:jira-work`

### Manual webhooks[⁠](https://linear.app/docs/jira.html#manual-webhooks)

The actor who configures the webhook must still have ADMINISTER, but this can be done between two people synchronously—A Jira ADMINISTER holder without a Linear seat, and a Linear admin with BROWSE PROJECTS permissions.

## Configure[⁠](https://linear.app/docs/jira.html#configure)

![Configure Jira integration](https://webassets.linear.app/images/ornj730p/production/e068ac6ff949f29922a6890cbddb97f598645a1c-500x711.png?w=1440&q=95&auto=format&dpr=2)

1. Navigate to your Linear [Settings > Integrations > Jira](https://linear.app/settings/integrations/jira.html)
2. Click **Enable**
3. Enter the API Access Token of the Jira user account or Jira service account
4. Enter the Email address of the Jira user account or Jira service account, or the username if using a Jira Server/DC
5. Enter the installation or cloud hostname. Be sure to remove the `http://` and anything after `.net`.
6. [Optional] Select **Manual webhook** if configuring manually
7. [Optional] Select **Service account** if using a Jira service account for configuration. This will auto-enable the **Manual webhook** option and cannot be disabled because service accounts in Jira cannot create webhooks
8. Click **Connect**.

Support for multiple Jira sites are available for the Enterprise plan, only.

### Manual webhook[⁠](https://linear.app/docs/jira.html#manual-webhook)

If **Manual webhook** configuration was selected, another pop-up will show upon clicking **Connect**. Share the provided webhook URL with the Jira ADMINISTER holder to setup the webhook in the Jira directly:

![jira webhook form in Linear](https://webassets.linear.app/images/ornj730p/production/b2c81982922bb2ccefd750b2fcf17adda6acc7c3-485x584.png?w=1440&q=95&auto=format&dpr=2)

After the webhook is setup, the Jira ADMINISTER can securely share the webhook secret to the Linear admin (e.g. through 1Password), who can input it where prompted and click **Save**. Any Linear admin can then manage the integration from within Linear.

### Linking spaces and teams[⁠](https://linear.app/docs/jira.html#linking-spaces-and-teams)

To link a Jira Space and a Linear team:

1. Click the **+** next to “Jira links”
2. If you have multiple Jira sites, select the site that contains the Jira space
3. Select the Jira space and Linear team
4. Click **Continue**
5. Select whether you want to sync issues

Each Jira space can only link to a single team in Linear, so the same space cannot create issues in multiple Linear teams. Multiple Jira spaces can be linked to the same Linear team though and issues will be created in Linear from any connected Jira space.

**Sync direction**

When configuring the mapping between a Jira space and a Linear team, choose either uni-directional or bi-directional sync.

With uni-directional sync, issues created in Jira are created in Linear. Updates to existing synced issues flow both ways, but creating a new issue in Linear does not create an issue in Jira.

With bi-directional sync, creating an issue in either service creates a synced copy in the other service, and updates to existing synced issues flow both ways.

Existing legacy uni-directional mappings may exist in your workspace as Jira → Linear only. For these mappings prior to March 2026, changes to issue properties made in Linear do not sync back to Jira.

Switching an existing legacy mapping to either current sync mode is irreversible; Linear changes will then sync to Jira and the legacy option will no longer be available.

![Jira synced issue banner](https://webassets.linear.app/images/ornj730p/production/08bd834bb5c1c5ae41ac68192a284a82363690f7-2874x150.png?w=1440&q=95&auto=format&dpr=2)

Once an issue or project is synced between Jira and Linear, a banner will appear at the top of the issue to make this clear. The banners will display information to show current sync status or will surface any errors with syncing.

If your team uses GitHub alongside Jira Sync, we recommend using different identifiers in Linear and Jira. For example, if your Jira project key is `ENG`, consider setting your Linear team identifier to something like `LIN` or `LENG`.

Linear and Jira do not always assign the same number to the same issue. When both systems share an identifier prefix, a branch named `ENG-654` in GitHub may link to a different issue in Linear than it does in Jira — causing the wrong ticket to be updated or closed when a PR is merged.

Using distinct identifiers in each system keeps GitHub PR linking predictable. Engineers can include both identifiers in a PR title so the PR links correctly in both tools.

To update your Linear team identifier, navigate to your *Team settings > General > Identifier*.

### Filtering issues for import[⁠](https://linear.app/docs/jira.html#filtering-issues-for-import)

By default, Jira Sync will create and sync every issue that’s created in the mapped Jira space. If you wish to filter out some issues, you have the ability to do so by editing the webhook in Jira.

Please note that any JQL filters you applied to limit the scope of *import* do not apply for Jira Sync purposes. In order to change what is provided to Linear for Jira Sync, follow the instructions below:

Go to `Settings` → `System` → `Advanced` → `Webhooks`. Select the Linear webhook and click `Edit`.

The `Issue related events` box allows you to provide a custom JQL query to filter out some issues that you do not want to sync with Linear. This works both when the conditions are met at the time of the Jira issue’s creation, as well as if the Jira issue is updated to meet the parameters of your filter later.

Here is an example to only sync issues with the label `Bug`:

![image of editing a webhook in Jira to restrict returned results](https://webassets.linear.app/images/ornj730p/production/82c1152a9b627e4b7ebf326122e3dc08a9deea5c-2096x316.png?w=1440&q=95&auto=format&dpr=2)

### Syncing user accounts[⁠](https://linear.app/docs/jira.html#syncing-user-accounts)

Users should link their individual Jira accounts in [Settings > Connect accounts](https://linear.app/settings/account/connections.html). This allows better handling of fields in Jira like Assignee and Creator.

#### Posting in a synced thread[⁠](https://linear.app/docs/jira.html#posting-in-a-synced-thread)

In order to send a reply to a synced thread, you’ll need to link your Atlassian account.

| Permission | What we use it for |
| --- | --- |
| User → View → me | We use this to capture the Jira Account ID of each user. This allows us to properly map users between Linear and Jira |
| User → View → me | This allows us to create issues and comments on behalf of the user. This does not grant access to read issues or comments not created by this user. |

Jira Server users will be presented with a simple form to input their own personal access token.

## Synced properties[⁠](https://linear.app/docs/jira.html#synced-properties)

Once the integration is enabled, any new issue created in a linked Jira space or Linear team will create a synced version of that issue in the other service.

Jira epics automatically sync as Linear projects, maintaining parent-child relationships between issues and their projects/epics.

### Issues[⁠](https://linear.app/docs/jira.html#issues)

| Name in Linear | Name in Jira |
| --- | --- |
| Title | Title |
| Description | Description |
| Assignee\* | Assignee\* |
| Creator\* | Creator/Reporter\* |
| Priority | Priority |
| Status\*\* | Status\*\* |
| Labels\*\*\* | Labels\*\*\* |
| Due date | Due date |

### Epics/Projects[⁠](https://linear.app/docs/jira.html#epicsprojects)

| Name in Linear | Name in Jira |
| --- | --- |
| Project title | Epic title |
| Project status | Epic status |
| Project labels\*\*\* | Epic labels\*\*\* |
| Project priority | Epic priority |
| Project description | Epic description |
| Project lead\* | Epic assignee\* |

\* For these fields to sync successfully, the relevant user must connect their Jira account to Linear in **Settings > Integrations > Jira > Connect personal account**. If no connection exists, the Assignee field will be unassigned, and/or the creator field will be the user who configured Jira.

\*\* Deleting a synced issue in either Jira or Linear will not delete the issue in the other direction, or otherwise affect status in the synced issue.

If a synced issue in Jira moves to a status not in Linear, The Linear issue’s status will not update. The status will update in Linear if the synced issue is moved in Jira to a status that can be mapped properly, or if the status is changed in Linear directly.

\*\*\* For labels to sync from Jira to Linear, the label must have already been created in Linear (either through a previous import, or by creating the label manually or through our GraphQL API. When labels sync from Linear to Jira, we’ll create a new label in Jira when appropriate.

## Jira integration vs Jira import[⁠](https://linear.app/docs/jira.html#jira-integration-vs-jira-import)

If you’d prefer not to work out of both Jira and Linear in parallel, you can [import your existing Jira issues and projects](https://linear.app/docs/jira-to-linear.html).

For a holistic approach that involves importing historical data *and* syncing new issues:

1. Enable the Jira integration so historical Jira issues can be synced once they are imported. Running an import alone does not sync the imported issues.
2. [Import your data from Jira](https://linear.app/docs/jira-to-linear.html) to bring over historical data.
3. The Jira integration will create copies and sync issues going forward.

## FAQ[⁠](https://linear.app/docs/jira.html#faq)

Does Linear become aware of updates to synced Jira space metadata?

If you change metadata in synced Jira spaces (delete, add, make them unrequired) this may cause the Jira issue and Linear issue to become out of sync.

Clicking the refresh button on the list of synced Jira spaces in Linear settings will update the list of available spaces, but also update the metadata to Linear’s context. This is a fix forward; issues already out of sync because of missing metadata will not update after pressing this.

![Showing the refresh button in the Jira integration to account for new Jira metadata](https://webassets.linear.app/images/ornj730p/production/028551dbcc69612f31c12505703eedd684a6c3d9-819x469.png?w=1440&q=95&auto=format&dpr=2)

Can I send Linear tickets created by Jira to Triage?

You may wish to triage Linear issues created by Jira instead of syncing their status automatically (for example, you may want the opportunity to decline the issue before admitting it to your backlog).

While this integration is broadly intended to keep Jira and Linear issues in sync, you can workaround this by renaming your first status under type *Started* something besides To do, to-do or similar variants. When the integration can’t determine the right status at issue creation, it falls back to Triage. In other words, if your first started status is called “Started” in Linear and “To do” in Jira, new issues created by Jira in Linear will go to Triage.

Will moving a Jira issue from an unsynced space to a synced space create a Linear issue?

Yes, a Linear issue will be created when a Jira issue is moved into a synced space.

Will moving a Linear issue from an unsynced team to a bidirectionally synced team create a Linear issue?

No, a Jira issue will not be created when a Linear issue is moved from one team to another. This will only work when an issue is created directly in the Linear Team.

My issues are showing a sync or permissions error

Viewing the sync error will tell you more specific information about the root cause of the sync error. This can typically occur in cases where an issue is missing on Jira or your permissions are not configured correctly.

For permissions errors, using Jira’s permissions helper can shed light on where the error lies.

![Jira permission helper](https://webassets.linear.app/images/ornj730p/production/1b0faa06c89c3759263aa68f59d4e584de22eba8-633x344.png?w=1440&q=95&auto=format&dpr=2)

Fill the values to:

* ​**User**​: This should be set to the user who created the Jira Sync integration (you can check this in Linear in Settings > Integrations > Jira > Enabled by)
* ​**Issue**​: Even though we are looking to check permissions to create new issues, the form requires us to pick an issue to check against. Choose any issue.
* **Permission:**​ Choose `Create issues`. Then click submit and look for a status in the blue box, it should tell if that user has access to this permission on this project. If not, the details below should contain some clues about what’s missing.

Do Linear Sub-teams work with Jira Sync?

[Sub-teams](https://linear.app/docs/sub-teams.html) are not considered when mapping Jira spaces and Linear teams.

If a parent team is linked to Jira bidirectionally, issues created in that parent team will be created in Jira. Issues created in its sub-teams will not be created in the linked Jira team.

The sub-teams themselves may be linked individually to Jira spaces however, and this will work independent of the parent team’s sync settings.

Do epics that were previously imported or synced as issues automatically sync as projects?

No. Epics that were previously imported as projects or synced as issues will not retroactively sync as projects. Only newly created epics (after bi-directional sync is enabled) will sync as Linear projects going forward.

[Previous

Intercom](https://linear.app/docs/intercom.html)[Next

Microsoft Teams](https://linear.app/docs/microsoft-teams.html)

* [Overview](https://linear.app/docs/jira.html#overview)
* [Limitations](https://linear.app/docs/jira.html#limitations)
* [Permissions required](https://linear.app/docs/jira.html#permissions-required)
* [Jira user account](https://linear.app/docs/jira.html#jira-user-account)
* [Jira service account](https://linear.app/docs/jira.html#jira-service-account)
* [Manual webhooks](https://linear.app/docs/jira.html#manual-webhooks)
* [Configure](https://linear.app/docs/jira.html#configure)
* [Manual webhook](https://linear.app/docs/jira.html#manual-webhook)
* [Linking spaces and teams](https://linear.app/docs/jira.html#linking-spaces-and-teams)
* [Filtering issues for import](https://linear.app/docs/jira.html#filtering-issues-for-import)
* [Syncing user accounts](https://linear.app/docs/jira.html#syncing-user-accounts)
* [Posting in a synced thread](https://linear.app/docs/jira.html#posting-in-a-synced-thread)
* [Synced properties](https://linear.app/docs/jira.html#synced-properties)
* [Issues](https://linear.app/docs/jira.html#issues)
* [Epics/Projects](https://linear.app/docs/jira.html#epicsprojects)
* [Jira integration vs Jira import](https://linear.app/docs/jira.html#jira-integration-vs-jira-import)
* [FAQ](https://linear.app/docs/jira.html#faq)
