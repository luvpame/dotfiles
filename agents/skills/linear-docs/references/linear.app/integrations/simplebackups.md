---
title: "SimpleBackups Integration – Linear"
source_url: "https://linear.app/integrations/simplebackups"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. SimpleBackups

# Never lose an issue, project, or cycle

![SimpleBackups dashboard showing a completed Linear workspace backup with per-entity counts](https://webassets.linear.app/images/ornj730p/production/af64e7c5fc305a7d87ed27e361338768d332a441-1500x960.png?q=95&auto=format&dpr=2)

![SimpleBackups dashboard showing a completed Linear workspace backup with per-entity counts](https://webassets.linear.app/images/ornj730p/production/af64e7c5fc305a7d87ed27e361338768d332a441-1500x960.png?q=95&auto=format&dpr=2)

![See what's backupped in simplebackups](https://webassets.linear.app/images/ornj730p/production/3d0fbb38cdea88380f659d9d7eba9c0498ef27cf-1500x960.png?q=95&auto=format&dpr=2)

![restoring issues in simplebackups](https://webassets.linear.app/images/ornj730p/production/9a53b11469c2ef945d2ebb32f06c01a0ebcfb6c7-1500x960.png?q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/integrations/simplebackups.html#overview)

SimpleBackups keeps a scheduled, verifiable copy of your entire Linear workspace in cloud storage you own, so issues, projects, documents, comments, and cycles survive an accidental bulk delete, a bad automation, or a lost workspace. Every run reports exactly what it captured, and you can restore any past backup into a separate Linear workspace while the original is only ever read.

## How it works[⁠](https://linear.app/integrations/simplebackups.html#how-it-works)

Connect a Linear workspace with a read-only authorization, then choose a schedule and a storage destination: Amazon S3 and S3-compatible providers, Azure Blob Storage, Backblaze B2, Dropbox, and more, or storage provided by SimpleBackups. Each run captures: issues and sub-issues, issue relations, comments, projects, project updates, project milestones, project labels, project statuses, cycles, documents, initiatives, initiative updates, initiative-to-project links, teams, team memberships, workflow states, issue labels, users, external users, attachments, custom views, and templates. Everything is written as JSON Lines with one file per record type, so the archive stays readable without SimpleBackups, and encryption with your own key and downloading the files hosted in Linear are both optional.

Every run writes per-type counts into the archive and shows them on the backup’s dashboard, so you can confirm what was captured rather than assume. If core content cannot be retrieved, meaning issues, comments, projects, cycles, teams, users, labels, or workflow states, the run is marked failed instead of being stored as a usable restore point, and you choose whether it stops at the first failure or keeps going and collects everything it can before failing. Failures affecting optional content do not fail the run; they are listed alongside partial counts for review.

To recover, pick any previous backup and authorize a destination workspace with a separate write-scoped connection. SimpleBackups recreates teams, workflow states, labels, projects, milestones, cycles, issues and sub-issues, comments, documents, and initiatives, rebuilds the relationships between restored records, rewrites cross-references between restored issues, and carries over original author names and creation dates on issues and comments where Linear’s API allows. The source workspace is only ever read, per-type progress is reported live while the restore runs, and a restore that is interrupted resumes from its last checkpoint instead of starting over.

## Configure[⁠](https://linear.app/integrations/simplebackups.html#configure)

In SimpleBackups, create a new backup, select Linear, and click Connect Linear workspace, then approve the read-only authorization. The integration connects as a Linear app, which reaches your workspace’s public teams by default; to include a private team, grant it to the app from the app’s details page in your Linear settings. Once connected, select the connection, choose a schedule and a storage destination, and optionally turn on encryption with your own key or include the images and files hosted in Linear. You can also choose whether a run stops as soon as core content fails or keeps going and captures everything it can before reporting the failure.

To restore, open the backup run you want and select Restore, then authorize a destination workspace. This is a separate write-enabled authorization, and because the restore creates teams in the destination, Linear may require that you have the Admin role there. Use a new, empty workspace: if the destination already contains teams, issues, projects, or initiatives, the restore stops and asks you to confirm explicitly before it will run. Restores read from S3-compatible storage, Azure Blob Storage, Backblaze B2, and Dropbox, and an encrypted archive also needs its matching private key, which is used for that restore and never stored. Full setup instructions are at <https://simplebackups.com/docs/saas-app-backup/apps/linear>

Website
[simplebackups.com](https://simplebackups.com)

Category
[Security & Compliance](https://linear.app/integrations/security-and-compliance.html)

Contact

[Contact SimpleBackups](mailto:hello@simplebackups.com)

[Open website](https://simplebackups.com/docs/saas-app-backup/apps/linear)

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
* [![Aikido Security icon](https://webassets.linear.app/images/ornj730p/production/2247569c11ceede6b8ab993deb4dca2374e61207-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Aikido Security

  By Aikido Security

  Put your application security on autopilot](aikido.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
