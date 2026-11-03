---
title: "Airbyte – Linear Docs"
source_url: "https://linear.app/docs/airbyte"
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

# Airbyte

Available to workspaces on our [Enterprise](https://linear.app/pricing.html) plan

Connect with Airbyte to consolidate data in data warehouses, lakes, and databases.

![Linear and Airbyte logos](https://webassets.linear.app/images/ornj730p/production/01f331e6f28947dc5304640abb8cf844ea0ff280-2880x1620.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/airbyte.html#overview)

With the Airbyte integration, you can load your Linear data into any data warehouses, lakes, or databases in minutes. Create custom analytics and dashboards for your company and update them on any schedule through Airbyte.

We support Airbyte Open Source environments, and do not support Airbyte Cloud.

## Configure[⁠](https://linear.app/docs/airbyte.html#configure)

Configuration requires workspace owner permissions to navigate to [Settings > Integrations > Airbyte](https://linear.app/settings/integrations/airbyte.html) and click the **Enable** button.

Copy the one time Airbyte API key as you will need this later. With this key the integration receives read access to all data in supported tables. There is no way to *exclude* access to private teams at this time.

### Set up Airbyte locally[⁠](https://linear.app/docs/airbyte.html#set-up-airbyte-locally)

Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and launch it.

Clone the Airbyte repo and run Docker using the following command in Terminal:

```
git clone https://github.com/airbytehq/airbyte.git
cd airbyte
docker-compose up
```

Now you can open Airbyte in your browser at http://localhost:8000.

### Set up Linear Source[⁠](https://linear.app/docs/airbyte.html#set-up-linear-source)

* In the Airbyte dashboard, click “Settings” on the bottom left.
* Click “Sources” on the left sidebar.
* Click the “New connector” button > enter the following:
  **- Connector display name:** `Linear`
  **- Docker repository name:** `gcr.io/linear-public-registry/linear-airbyte-source`
  **- Docker image tag:** `latest`
  **- Connector Documentation URL:** `https://github.com/linear/linear-airbyte-source/blob/main/readme.md`

![Settings page in Airbyte for adding a new connector](https://webassets.linear.app/images/ornj730p/production/411c6aec9ef601e16ae5a157da4dbbf1b133e114-804x719.png?w=1440&q=95&auto=format&dpr=2)

### **Connect your destination**[⁠](https://linear.app/docs/airbyte.html#connect-your-destination)

With the connection complete, you can now choose your destination.

* Click “Connections” in the sidebar and the “New connection” button.
* In the “Source type” box search for “Linear”.
* You can give a custom name to your source or leave it as Linear.
* Paste the API key you generated in the Linear integration page for Airbyte and click “Set up source”.
* On the next page, you can select an existing destination or set up your destination service, their instructions will be provided there if you have not yet created a destination with them before.
* Save the connection.

![Airbyte settings page where you paste your API key](https://webassets.linear.app/images/ornj730p/production/e55fd4eaa74ab6d7ba2f40af3ad9eb490e12721b-901x512.png?w=1440&q=95&auto=format&dpr=2)

### **Choose your sync frequency**[⁠](https://linear.app/docs/airbyte.html#choose-your-sync-frequency)

Next, you need to choose how often you want to sync your Linear data to this destination:

* Click on Connections, then click your chosen connection in the list.
* Click on the “Replication” tab and choose your Replication frequency.
* Select the data you want to sync. You should see a list of table names. You can select all or choose which ones to sync individually.
* Choose what type of sync mode you’d like to use for each source table. [Full Refresh](https://docs.airbyte.com/understanding-airbyte/connections/full-refresh-overwrite) and [Append](https://docs.airbyte.com/understanding-airbyte/connections/full-refresh-append/) are the options you can choose from. Incremental is not supported at this time. Linear data can sync every 12 hours; it cannot sync sooner than this.
* Click “Save changes”.

Everything is now configured to extract, transform, load (ETL) your Linear data into Airbyte and sync it to the selected destination on the schedule you chose.

The following models will be synced:

* Organization
* Teams
* Team Key
* Team Membership
* User
* Milestone
* Project
* Project Updates
* Project Link
* Issues
* Issue History
* Issue Label
* Issue Relation
* Integration Resource
* Attachment
* Audit Entry
* Comment
* Cycle
* Workflow State
* Document
* Document Content

## Remove connection[⁠](https://linear.app/docs/airbyte.html#remove-connection)

You can disable any incremental or full syncs by going to the *Connection* settings page and clicking *Delete this connection.*

## FAQ[⁠](https://linear.app/docs/airbyte.html#faq)

Is there an extra fee for Airbyte?

Airbyte Open Source is free to use, only the cloud version is paid — which we don’t currently support.

Which databases or data warehouses does Airbyte connect to?

Airbyte offers many services you can connect your Linear workspace data to. You can view the full list here: https://docs.airbyte.com/integrations/

[Previous

Integration Directory](https://linear.app/docs/integration-directory.html)[Next

Discord](https://linear.app/docs/discord.html)

* [Overview](https://linear.app/docs/airbyte.html#overview)
* [Configure](https://linear.app/docs/airbyte.html#configure)
* [Set up Airbyte locally](https://linear.app/docs/airbyte.html#set-up-airbyte-locally)
* [Set up Linear Source](https://linear.app/docs/airbyte.html#set-up-linear-source)
* [Connect your destination](https://linear.app/docs/airbyte.html#connect-your-destination)
* [Choose your sync frequency](https://linear.app/docs/airbyte.html#choose-your-sync-frequency)
* [Remove connection](https://linear.app/docs/airbyte.html#remove-connection)
* [FAQ](https://linear.app/docs/airbyte.html#faq)
