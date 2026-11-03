---
title: "Migration guide – Linear"
source_url: "https://linear.app/switch/migration-guide"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



4

Migration guide

1. 1

   [Switch to Linear](https://linear.app/switch.html)
2. 2

   [Pitching Linear](https://linear.app/switch/pitch-guide.html)
3. 3

   [Running a pilot](https://linear.app/switch/pilot-guide.html)
4. 4

   [Migration guide](https://linear.app/switch/migration-guide.html)

   1. [Getting started](https://linear.app/switch/migration-guide.html#considerations-before-you-start)
   2. [Issue migration](https://linear.app/switch/migration-guide.html#decide-whether-to-migrate-your-issues)
   3. [Configuration](https://linear.app/switch/migration-guide.html#choose-your-configuration-approach)
   4. [Migration](https://linear.app/switch/migration-guide.html#create-a-migration-plan)
   5. [Announcement](https://linear.app/switch/migration-guide.html#announce-the-change-to-your-team)
   6. [Roll out](https://linear.app/switch/migration-guide.html#prepare-your-linear-workspace)
   7. [Not ready?](https://linear.app/switch/migration-guide.html#let-us-help-you)

[Sign up](https://linear.app/signup.html)[Talk to sales](https://linear.app/contact/sales.html)

# Migration guide

Your pilot proved Linear’s value and you’re ready to roll it out. Here’s how to seamlessly move your data from your current tool to Linear.

Getting started

## Considerations before you start

You’ll need to make several key decisions that will shape your approach:

* Will you import existing issues or start fresh?
* Should teams follow standardized workflows or maintain autonomy?
* What’s your timeline and communication plan?

This guide walks through each decision, outlining the trade-offs and best practices we’ve learned from hundreds of successful migrations.

Issue migration

## Decide whether to migrate your issues

Many teams use the migration to Linear as an opportunity to start fresh and leave their old issues behind. Other teams import their existing issues from other tools for reference or to finish a sprint.

### Import your issues

Use the [Importer](https://linear.app/docs/import-issues.html) to pull in-flight issues into Linear and map them to appropriate teams. Linear offers native importers for GitHub Issues, Jira, Asana, Shortcut, and Trello. Alternatively, you can import a CSV with issue data.

If you’re using Jira or GitHub Issues and not yet ready to fully import your data, you can enable two-way sync while trialing or transitioning to Linear. The [Jira integration](https://linear.app/docs/jira.html) and [GitHub Issues integration](https://linear.app/integrations/github.html) keep Linear in sync with your current tool, so that new issues created live in both places.

#### Start fresh

Migration is your chance to move forward with intention, not historical baggage. The switch to Linear can be an opportunity for a clean slate. Several teams, like [Opendoor](https://linear.app/customers/opendoor.html) and [Oscar Health](https://linear.app/customers/oscar.html), opted to leave behind years of accumulated workflow complexity, and dozens of custom fields.

Configuration

## Choose your configuration approach

There are two approaches when it comes to setting up Linear:

#### Standardized workflows

In a prescriptive approach, functions such as technical program management, engineering ops, or IT standardize the Linear workspace and team settings to create a shared way of working. Organizations that follow this path frequently map their backlog and in-progress work to the new way of working in Linear.

##### The benefits of standardization

Reporting is easier when every team uses the same labels, estimations, templates, statuses, and SLAs. If you know you’re going to need specific reports, for example, it’s worth being intentional about how you structure workflows in Linear.

Standardizing how teams work can also facilitate alignment by establishing a company-wide cadence. Linear cycles get everyone moving at the same speed and shipping on the same timelines.

#### Autonomous teams

Alternative to a standardized approach, some organizations prefer to give each team autonomy over how they work. Organizations that follow this path typically enable their teams to configure Linear independently.

##### The benefits of autonomy for teams

Each team can customize their Linear workspace to stay focused and productive. We find that teams that have more freedom in their setup are more likely to fully adopt Linear, though producing reports is not as straightforward when working styles aren’t standardized.

Migration

## Create a migration plan

Building an internal transition guide will help you think through each part of the migration and keep everyone on track.

#### Approach

Spell out how you are approaching your migration (standardized vs. autonomous; import vs. starting fresh) and your reasons for doing so.

Since this internal guide will be distributed to teams that did not participate in the pilot, include [high-level findings from the trial](https://linear.app/switch/pilot-guide.html#compile-your-data-and-present-your-case) and state the main goal(s) of switching to Linear. Include a few data points or quotes from real team members to bolster your message.

#### Timeline

Work with your organization’s leaders to set a go-live date based on your approach to migration and configuration, keeping in mind any renewal dates for the tools Linear is replacing. If the autonomous approach is preferred, we recommend giving teams up to 6 weeks to configure their workspace and team settings.

#### Training

Run a Linear demo for your organization and share self-serve onboarding resources to teams in advance of the rollout, such as links to [Linear docs](https://linear.app/docs.html) and [best practices](https://linear.app/method.html). If you plan to use [Asks](https://linear.app/docs/linear-asks.html) to intake issues from non-Linear users, organize an onboarding session to educate them on how to use Asks in Slack to submit a request.

#### Communication

Create a Slack channel for Linear-related questions to support your teammates throughout the migration. The Slack channel creates a centralized home for the resources you’re creating, and gives new users a place to ask questions or request support.

Announcement

## Announce the change to your team

Apprehension comes with change. Put your team members at ease by letting them know when Linear is coming and how the migration will work. Keep your announcement short and actionable to increase engagement with the migration.

Use this template as a baseline:

Copy

All,
We are moving from prior tool to Linear for project and issue tracking this month.
The goal of switching to Linear is to enhance our core issue tracking workflows with an intuitive interface, real-time project updates and seamless integrations with our key tools like list integrations. We are committed to company-wide transparency and believe Linear will offer improved visibility into our projects and tasks.
We are aiming for minimal disruption but expect a transition period as we migrate. If your team is in the middle of a release or needs to delay moving to Linear, please connect with [person or team] so that we can find an approach that works for your team.
In the coming weeks, we will be working closely with team leads to get you set up on Linear and plan to host training sessions on insert dates to get you up to speed. In the meantime:
- Read our internal migration guide.
- Join our #linear-company name Slack channel.
We appreciate your support during this transition. Please don't hesitate to reach out if you have any questions.

Roll out

## Prepare your Linear workspace

Configure teams and provision users ahead of time, so that when they land in Linear they’re good to go.

#### Provision users

If you are coming from a prior tool and bringing data over, provision your Linear users. Linear’s native importers will match existing Linear users to the users you are importing. Ideally, users already exist in both services with the same email address and have linked their accounts in [Settings > Integrations](https://linear.app/settings/integrations.html) so that creators, assignees, mentions, and comments are imported properly.

#### Create your teams

Issues in Linear are organized by [team](https://linear.app/docs/teams.html). Linear will automatically create a default team with the same name as your workspace, but you can create more teams to group employees who work together frequently or who work on a specific area or feature. We recommend starting with fewer teams and then adding more (and moving necessary issues) over time.

#### Import data (if applicable)

*Note: You must be a Linear Admin to run an import.*

1. Navigate to [Settings > Workspace > Import/Export](https://linear.app/settings/import-export.html) and select your current issue tracker.
2. Select the issues you want to import and the Linear team to import them to.
3. Review fetched data.
4. Map the users the Importer found in your current issue tracker.
5. Confirm your selections. Click Finish.

#### Migrate your integrations

Most issue trackers are connected to upstream or downstream tools. Work with your Linear admins and those responsible for other internal tools to get each integration up and running. Below are a few examples of common integrations with Linear:

* [Slack](https://linear.app/integrations/slack.html)

  To create issues and receive notifications
* [Zendesk](https://linear.app/integrations/zendesk.html), [Front](https://linear.app/integrations/front.html), [Intercom](https://linear.app/integrations/intercom.html)

  To intake bugs and feature requests from the frontlines
* [GitHub](https://linear.app/integrations/github.html)

  GitHub Linear’s native workflow automations and issue syncing for OSS.
* [Triage Responsibility](https://linear.app/docs/triage.html#triage-responsibility)

  Create ownership over triage; supporting PagerDuty, incident.io and Opsgenie rotations
* [Google Calendar](https://linear.app/integrations/google-calendar.html)

  Let teammates know if you are away or OOO

#### Sunset your previous tool

Notify your previous service provider that you are no longer using their services once you’ve made the decision to move over to Linear. Work with your internal tools team to shut off access to the tool or put it in read only mode.

Once migrated, send a message to the team Slack channel letting teammates know that your previous issue tracker is no longer available.

#### Enable users

Follow your training plan and schedule additional enablement sessions as needed. If you’re taking an autonomous approach to configuration, some teams may want extra guidance when configuring workspace and team settings.

Share the [Linear Method](https://linear.app/method.html) and [Getting Started Documentation](https://linear.app/docs/tutorials.html) in your internal operations documentation for easy reference.

Not ready?

## Let us help you

Learn how to hone your [Linear pitch](https://linear.app/switch/pitch-guide.html) or [run a pilot](https://linear.app/switch/pilot-guide.html) to strengthen your case for Linear.

## Resources

[Talk to our teamRequest a demo, or get help with your migration

→](https://linear.app/contact/sales.html)[PricingFind the right plan for your team

→](https://linear.app/pricing.html)[SecurityBest-in-class security practices

→](https://linear.app/security.html)

[Pitch guideConvince the rest of your team

→](https://linear.app/switch/pitch-guide.html)[Pilot guideEverything you need for a successful pilot

→](https://linear.app/switch/pilot-guide.html)[Migration guideInstructions for a seamless transition

→](https://linear.app/switch/migration-guide.html)

[Jira SyncKeep work in sync with Jira

→](https://linear.app/docs/jira.html)[GitHub Issues SyncKeep work in sync with GitHub Issues

→](https://linear.app/docs/github.html#github-issues-sync)

## FAQ

What is Linear’s pricing structure

Linear offers three pricing tiers (Basic, Business, Enterprise) tailored to the needs of your team. For detailed information about each plan, visit [our Pricing page](https://linear.app/pricing.html) or [get in touch with our Sales team](https://linear.app/contact/sales.html).

Does Linear have dedicated support for enterprise customers?

Yes, we offer white glove onboarding and migration assistance for enterprise customers as well as ongoing priority support and account management. [Get in touch with our Sales team](https://linear.app/contact/sales.html) to learn more.

What if I want to make the switch, but l’m under contract with my current tool?

If you’re stuck in an annual contract, [please reach out to our team](https://linear.app/contact/sales.html) with a copy of your current contract.

Does Linear meet my organization's security standards?

Linear is built with enterprise-grade security practices to keep your work safe and secure at every layer. This includes state-of-the-art encryption, safe and reliable infrastructure partners, and independently verified security controls. Linear is SOC2 and HIPAA compliant and committed to compliance with Europe’s General Data Protection Regulation (GDPR). You can learn more about Linear’s security features [here](https://linear.app/security.html).

How does Linear integrate with our existing tools?

Linear is natively integrated with all major tools that teams use in their day-to-day workflows, ranging from engineering ([GitHub](https://linear.app/integrations/github.html), [GitLab](https://linear.app/integrations/gitlab.html), [Sentry](https://linear.app/integrations/sentry.html)) and design tools ([Figma](https://linear.app/figma.html)) to customer support systems ([Intercom](https://linear.app/integrations/intercom.html), [Front](https://linear.app/integrations/front.html), [Zendesk](https://linear.app/integrations/zendesk.html)) and communication platforms ([Slack](https://linear.app/integrations/slack.html), [Discord](https://linear.app/integrations/discord.html)).

Additionally, there are hundreds of [third-party integrations](https://linear.app/integrations.html). You can also build your own apps and integrations with the [Linear API](https://linear.app/developers.html).

Migration guide – Linear
