---
title: "Cloudback Integration – Linear"
source_url: "https://linear.app/integrations/cloudback"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Cloudback

# Automated daily backups of your Linear workspace with on-demand restore

![Connect Linear alongside GitHub, GitLab, and Azure DevOps](https://webassets.linear.app/images/ornj730p/production/e51322560ecca191637c8c74b7bc7b76b0b92b5c-1500x960.png?q=95&auto=format&dpr=2)

![Connect Linear alongside GitHub, GitLab, and Azure DevOps](https://webassets.linear.app/images/ornj730p/production/e51322560ecca191637c8c74b7bc7b76b0b92b5c-1500x960.png?q=95&auto=format&dpr=2)

![Full backup history with download and one-click restore](https://webassets.linear.app/images/ornj730p/production/7930d8d6d159acb5f0a912c128bf151af3dd2707-1500x960.png?q=95&auto=format&dpr=2)

![Manage backup settings, view backup and data deduplication statistics](https://webassets.linear.app/images/ornj730p/production/a98d882bbbad53a0d5b44b3ef09a994d92e49086-1500x960.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/cloudback.html#overview)

Cloudback automatically backs up your Linear workspace on a configurable schedule, capturing issues, projects, documents, cycles, comments, labels, templates, initiatives, embedded files, and more. Backups are stored as encrypted, password-protected archives in your own cloud storage or built-in Cloudback storage.

When you need to recover data, Cloudback can restore your workspace to a different Linear workspace, making it useful for disaster recovery and workspace migration.

## How it works[⁠](https://linear.app/integrations/cloudback.html#how-it-works)

Cloudback connects to your Linear workspace via OAuth and runs scheduled backups automatically, with the option to customize the schedule. Each backup captures a snapshot of your workspace data: issues and sub-issues, comments, projects, project updates, project milestones, cycles, documents, labels (issue and project), teams, workflow states, attachments, initiatives, initiative updates, custom views, templates (issue, project, and document), issue relations, external users, project statuses, and initiative-to-project links. Files and images hosted on Linear are downloaded with authentication and stored directly in the archive. The resulting backup is a structured set of JSON files organized by entity type.

You choose where backups are stored: your own AWS S3, Google Cloud Storage, Azure Blob Storage, Alibaba Cloud, Wasabi, OneDrive (Business or Personal), OpenStack Swift containers, or built-in Cloudback regional storages. Backup schedules are fully configurable with presets and support for custom cron expressions, and you can trigger a manual backup at any time. Retention policies control how long backups are kept, and deduplication reduces storage costs when workspace data has not changed between runs. Archives can be password-protected and encrypted. Cloudback also provides an audit log for tracking all backup and restore activity, a Terraform provider for infrastructure-as-code workflows, and an official Vanta integration for compliance reporting.

Restoring from a backup recreates all entities in a target Linear workspace that must be empty. Cloudback handles the complexity of rebuilding your workspace — issues, projects, documents, and all other data types are restored with their relationships and links intact. Embedded files are re-uploaded to the destination workspace. Backup status notifications can be delivered via Slack, Microsoft Teams, or Discord. Cloudback also has official integrations with GitHub, Azure DevOps, and GitLab, so teams can manage backups for all their development platforms in one place.

## Configure[⁠](https://linear.app/integrations/cloudback.html#configure)

1. Sign in or create an account at https://app.cloudback.it. An active Cloudback subscription is required (a free trial is available).
2. In the dashboard sidebar, click `Add Account` and select `Linear` as the platform.
3. You will be redirected to Linear for OAuth authorization. You must have admin or owner access to the workspace you want to back up.
4. After authorization, your workspace appears in the dashboard. Open the workspace details page to configure your storage destination, backup schedule, and retention policy.
5. Backups run automatically on your configured schedule. You can also trigger a backup manually at any time from the workspace details page.
6. To restore data, click `Restore` on any backup. A separate OAuth authorization with write permissions is required, and the target workspace must be empty.

Website
[cloudback.it](https://cloudback.it/)

Category
[Security & Compliance](https://linear.app/integrations/security-and-compliance.html)

Contact

[Email Cloudback](mailto: support@cloudback.it)

[Open website](https://docs.cloudback.it/linear)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![Vanta  icon](https://webassets.linear.app/images/ornj730p/production/cc51049ac9db240c517f9220841930eeae20abdd-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Vanta

  By Vanta

  Automate compliance. Simplify security. Demonstrate trust.](vanta.html)
* [![Aikido Security icon](https://webassets.linear.app/images/ornj730p/production/2247569c11ceede6b8ab993deb4dca2374e61207-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Aikido Security

  By Aikido Security

  Put your application security on autopilot](aikido.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
