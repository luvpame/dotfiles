---
title: "BackupLatte Integration – Linear"
source_url: "https://linear.app/integrations/backuplatte"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. BackupLatte

# Daily backups of your Linear workspace

![backups happen daily](https://webassets.linear.app/images/ornj730p/production/fe9e09a96fc062e7b8b62c98d43ea560a9585cca-1600x1000.png?q=95&auto=format&dpr=2)

![backups happen daily](https://webassets.linear.app/images/ornj730p/production/fe9e09a96fc062e7b8b62c98d43ea560a9585cca-1600x1000.png?q=95&auto=format&dpr=2)

![snapshots from backuplatte](https://webassets.linear.app/images/ornj730p/production/152633d19ea62222588bbc0e5d89aa17cf4e9776-1600x1000.png?q=95&auto=format&dpr=2)

![restoring backups](https://webassets.linear.app/images/ornj730p/production/f93cd238b17966cbc5f24e38f0054a9719ef6728-1600x1000.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/backuplatte.html#overview)

BackupLatte keeps a daily snapshot of your Linear workspace outside Linear, including issues, comments, projects, initiatives, documents, cycles, archived records and uploaded files. When something is deleted or overwritten, you can restore it into a new workspace to compare, or into the original one to bring back only what is missing.

## How it works[⁠](https://linear.app/integrations/backuplatte.html#how-it-works)

BackupLatte connects through Linear’s OAuth and backs up each workspace once a day at the hour you choose, and you can start one more backup yourself every 24 hours. Each run is a full snapshot of 55 sets of Linear data, including issues and their relations, comments, attachments, labels, projects with their updates and milestones, initiatives, cycles, documents, teams and workflow states, templates, shared views, releases and customer requests. With extended coverage, which needs a Linear admin, it also backs up the audit log, workspace settings, invitations, integrations and webhooks, without their credentials or secrets. Files uploaded to Linear that this content links to are copied too, and each file is stored once per workspace.

Every set is saved as gzipped JSON next to a manifest with its state, record count, size and SHA-256 checksum, so you can see that a backup is complete. A set that could not be read in full is marked as a gap with the reason, and BackupLatte emails you, then again when backups are healthy. Snapshots are kept for 1 to 365 days in a private bucket in the EU, and any snapshot can be downloaded as a ZIP that you can read without BackupLatte. One account can connect several workspaces, each with its own schedule.

A restore writes 43 sets back in dependency order, so parents, relations and project links point to the right records. Teams, workflow states and labels that already exist are matched, people are matched by email, files are uploaded again and archived records come back archived. You can restore into a new, empty workspace to compare and copy what you need, or into the source workspace, where only missing records are created and deleted issues and projects are taken out of the trash. A restore that stops can be resumed without creating anything twice.

## Configure[⁠](https://linear.app/integrations/backuplatte.html#configure)

1. Create an account at <https://app.backuplatte.com> and choose a plan under Billing. Backups need a paid plan, priced by the number of active members in your Linear workspaces.

2. In Linear, open the workspace you want to back up, then choose Connect Linear in BackupLatte and approve access. Connect with a Linear account that can see every team you want backed up; private teams that account is not a member of are left out.

3. Optional: to include the audit log, workspace settings, invitations, integrations and webhooks, turn on Extended coverage in the workspace’s Settings in BackupLatte and reconnect as a Linear admin.

4. In the workspace’s Settings, choose the hour of the daily backup and how many days to keep snapshots. The first backup runs within an hour of connecting.

5. To restore, open a backup and choose Restore…, pick the target workspace (a new, empty workspace is recommended) and the sets to restore, then follow the progress under Restores. Full setup instructions are at <https://backuplatte.com/docs/quick-start>

Website
[backuplatte.com](https://backuplatte.com)

Category
[Security & Compliance](https://linear.app/integrations/security-and-compliance.html)

Contact

[Contact BackupLatte](mailto:support@backuplatte.com)

[Open website](https://backuplatte.com/docs/quick-start)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Cloudback icon](https://webassets.linear.app/images/ornj730p/production/a9cf5ef7335894fc81b6ff769b9845ca92498db4-640x640.png?w=256&q=95&auto=format&dpr=2)

  Cloudback

  By MYRTLELABS S.A.S.

  Automated daily backups of your Linear workspace with on-demand restore](cloudback.html)
* [![Vanta  icon](https://webassets.linear.app/images/ornj730p/production/cc51049ac9db240c517f9220841930eeae20abdd-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Vanta

  By Vanta

  Automate compliance. Simplify security. Demonstrate trust.](vanta.html)
* [![Airbyte icon](https://webassets.linear.app/images/ornj730p/production/0f42f3da7d039c3af3b645f0321d8f2a3c02adae-320x320.png?w=256&q=95&auto=format&dpr=2)

  Airbyte

  By Linear

  Connect Linear to Airbyte and consolidate data in data warehouses, lakes, and databases](airbyte.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
