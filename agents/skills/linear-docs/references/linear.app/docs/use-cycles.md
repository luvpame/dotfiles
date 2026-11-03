---
title: "Cycles – Linear Docs"
source_url: "https://linear.app/docs/use-cycles"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives
* Issues and cycles

  + [![Issues](https://webassets.linear.app/images/ornj730p/production/edba0d8c37051e1993f867e9ca020865f4605fad-16x16.svg?q=95&auto=format&dpr=2)Issues](creating-issues.html)
  + [![Assign and delegate issues](https://webassets.linear.app/images/ornj730p/production/4f138793712b3f9f7f0dc09ad7ef776c03fe2077-15x15.svg?q=95&auto=format&dpr=2)Assign and delegate issues](assigning-issues.html)
  + [![Issue properties](https://webassets.linear.app/images/ornj730p/production/d234872da34ea6572815705e12566ece16be8a89-16x16.svg?q=95&auto=format&dpr=2)Issue properties](issue-properties.html)
  + [![Select issues](https://webassets.linear.app/images/ornj730p/production/b61fa1aff4d024cf6dcf0134c2c45b8d76cf0b27-16x16.svg?q=95&auto=format&dpr=2)Select issues](select-issues.html)
  + [![Parent and sub-issues](https://webassets.linear.app/images/ornj730p/production/fb9f996198822ba4dd8358f4e37428278e9701dd-16x16.svg?q=95&auto=format&dpr=2)Parent and sub-issues](parent-and-sub-issues.html)
  + [![Issue templates](https://webassets.linear.app/images/ornj730p/production/e4f8aa58d39df0385e4c2bd2838a46dac1e2350b-16x16.svg?q=95&auto=format&dpr=2)Issue templates](issue-templates.html)
  + [![Comments and reactions](https://webassets.linear.app/images/ornj730p/production/22f4ef6d4c3409d3fe7b7bbf4a7690403eb47580-16x16.svg?q=95&auto=format&dpr=2)Comments and reactions](comment-on-issues.html)
  + [![Delete and archive issues](https://webassets.linear.app/images/ornj730p/production/a6e257753e45982c7a7227be82fc81acc33d14d1-16x16.svg?q=95&auto=format&dpr=2)Delete and archive issues](delete-archive-issues.html)
  + [![Cycles](https://webassets.linear.app/images/ornj730p/production/1c19be327a796ea52b2967508141f95a6f74aee7-16x16.svg?q=95&auto=format&dpr=2)Cycles](use-cycles.html)
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Cycles

Cycles are a practice to keep up your team’s momentum, similar to commonly used agile-flavored sprints.

![Image showcasing Cycle Details including percentage success, total effort, number of days ago and a chart showing effort and scope over time.](https://webassets.linear.app/images/ornj730p/production/d9c776ab4f3b38a56b22df4974c8719edc5557fb-1052x584.png?w=1440&q=95&auto=format&dpr=2)

Cycles are time-boxed periods where a team works on completing a pre-defined set of work. When enabled, Linear automatically creates upcoming cycles for your team. Unlike sprints, cycles are not tied to releases.

## Configure[⁠](https://linear.app/docs/use-cycles.html#configure)

Configure cycles under **Team Settings > Cycles.** Turn on the toggle for **Enable cycles**. Required settings will show up in the cycle setting flow with defaults. You can always edit cycle configurations in the future.

## Cycle settings[⁠](https://linear.app/docs/use-cycles.html#cycle-settings)

![Cycle settings](https://webassets.linear.app/images/ornj730p/production/2b6e55ce2413893807c7aef369f2a42a151deddd-1446x958.png?w=1440&q=95&auto=format&dpr=2)

### Cycle duration[⁠](https://linear.app/docs/use-cycles.html#cycle-duration)

In the **Each cycle lasts** field, select the number of weeks you want each cycle to last. Cycles can last anywhere from 1-8 weeks. Cycles follow a repeating schedule rather than being configured one by one. Teams choose a shared duration and start day, and can adjust individual future cycles later if needed. The goal of cycles having repeated intervals is to help you avoid the busywork associated with optimizing cycle timing and instead focus on shipping.

### Cooldowns after each cycle[⁠](https://linear.app/docs/use-cycles.html#cooldowns-after-each-cycle)

Add a cooldown period after each cycle to give your team a break and time to work through technical debt and planning. Issues cannot be assigned to a cooldown.

### Starting day of the week[⁠](https://linear.app/docs/use-cycles.html#starting-day-of-the-week)

Since cycles occur in regular intervals, you’ll choose a specific day of the week for your cycles to start. Cycles begin at 12:01 AM on the chosen day based on the timezone configured in **Team Settings > General**.

### Upcoming cycles[⁠](https://linear.app/docs/use-cycles.html#upcoming-cycles)

Select the number of future cycles to create so your team can assign issues to future cycles. The maximum number of future cycles that can be created is 15.

### Disable cycles[⁠](https://linear.app/docs/use-cycles.html#disable-cycles)

When disabling the Cycles feature, the current cycle will be marked as completed and upcoming cycles will be removed. Any completed cycle data will be preserved for reference. You can choose to reenable cycles at any stage in the future.

## Adjust cycles[⁠](https://linear.app/docs/use-cycles.html#adjust-cycles)

### Move start and end dates[⁠](https://linear.app/docs/use-cycles.html#move-start-and-end-dates)

In cases where a future cycle should deviate from the schedule, its start and end dates may be moved through the overflow menu on that cycle.

![Adjust cycle dates](https://webassets.linear.app/images/ornj730p/production/a2fa4432d04b938961fb56cb83004878a0ecc904-1840x358.png?w=1440&q=95&auto=format&dpr=2)

Past cycle dates cannot be changed, but you can end your current cycle at the end of the current day if needed.

**Note:** You can’t change a cycle’s date into the past, so past cycle dates aren’t editable.

### Adjusting dates without cycle cooldowns[⁠](https://linear.app/docs/use-cycles.html#adjusting-dates-without-cycle-cooldowns)

When shortening the end date for a cycle, the time between the following cycle and the shortened cycle will display a “Cycles paused” period. When extending the end date for a cycle, the extended cycle will cut into the time for the following cycle—thus, shortening the following cycle.

### Adjusting dates with cycle cooldowns[⁠](https://linear.app/docs/use-cycles.html#adjusting-dates-with-cycle-cooldowns)

If cooldown periods are enabled and cycle dates are adjusted, the cooldown label updates to reflect the actual gap. If cooldown periods are not enabled, any gap between cycles is shown as “Cycles paused”.

### Start a cycle today[⁠](https://linear.app/docs/use-cycles.html#start-a-cycle-today)

If you need to kick off the next cycle early, you can start it immediately instead of waiting for its scheduled date. From the Cycles page, click on the overflow menu (…) on the next cycle and choose *Start cycle today*.

This starts the next cycle at 12:00 AM in your team’s timezone. You will see a pop up warning to confirm that you are happy to make this change.

If a cycle is currently in progress, we’ll mark it complete right away and move any open issues into the cycle you just started. If there isn’t an active cycle, this ends the previous cycle’s cooldown.

Please note, once you change the start date of the cycle you cannot revert this change.

### Update cycle name and description[⁠](https://linear.app/docs/use-cycles.html#update-cycle-name-and-description)

From the Cycles view, click the three dots next to a Cycle and select **Edit cycle...** This allows you to update the name and description of the cycle to clarify your team’s focus during that cycle. When updating a cycle name with a number at the end of the name, the following cycle will follow that number and begin a new numbering sequence from there.

## Cycle automations[⁠](https://linear.app/docs/use-cycles.html#cycle-automations)

### Issues rollover[⁠](https://linear.app/docs/use-cycles.html#issues-rollover)

Cycles run on an automated schedule to reduce unnecessary date math and help create routine. This rollover behavior applies to unfinished issues already assigned to the closing cycle. It is separate from the Started and Completed issue automations below, which assign issues without a cycle. Open issues generally roll over automatically, but issues moved to backlog, triage, canceled, or completed during cooldown are not carried into the next cycle. There is no way to keep unfinished issues in a closed cycle. If you forget to update an issue before the cycle ends, completed issues can still be moved over to the previous cycle.

### Auto-add active issues to current cycle[⁠](https://linear.app/docs/use-cycles.html#auto-add-active-issues-to-current-cycle)

![Cycle automations](https://webassets.linear.app/images/ornj730p/production/225303175bf39059797fec985a1a0115553992de-1412x570.png?w=1440&q=95&auto=format&dpr=2)

Auto-adding issues to a cycle helps to ensure all your work is captured by a cycle. You have the option to auto-add any *Started* or *Completed* issues that do not have a cycle assigned into the current cycle. If the team is in a cooldown period, completed issues without a cycle are attributed to the previous cycle. Started issues without a cycle are automatically added to the next cycle when the corresponding automation is enabled.

When toggling on **Active issues** option, an option will appear allowing you to

* Move existing active issues that are not assigned to a cycle to **Move to Backlog** (change its status), or
* **Keep in Active** and put it into the current or next cycle (depending on cooldown settings).

An active status is a status in the “Unstarted” and “Started” category.

## Cycle calendars[⁠](https://linear.app/docs/use-cycles.html#cycle-calendars)

To subscribe to a cycle calendar, open your team’s Cycles page, click a cycle’s overflow menu, and select **Subscribe to cycle calendar**. Choose Google Calendar, copy the feed URL, or download an `.ics` file.

## Cycle capacity[⁠](https://linear.app/docs/use-cycles.html#cycle-capacity)

On the Cycles view, cycles that have not yet started will display a capacity dial that shows an estimate on whether your team will be likely to complete all the issues added to the cycle.

Capacity is calculated from the velocity of the previous three completed cycles, i.e. the number of issues or estimate points completed in these cycles. If the team has not completed any cycles previously, capacity will be roughly estimated from the number of members in the team.

## FAQ[⁠](https://linear.app/docs/use-cycles.html#faq)

How do I start using Cycles now when my team is mid-cycle already?

We recommend creating a cycle starting today, and then setting further cycles to your regular cadence.

To do so, turn on Cycles in Settings > Team > Cycles. Choose today as your start date, which will create your current cycle. Then, edit the date field again to choose when your *next* cycle should start. This way, you’ll create a cycle to reflect your work for the rest of the current cycle, but have your desired cycle cadence reflected moving forwards.

Can I align cycles between multiple teams?

Yes, [sub-teams](https://linear.app/docs/sub-teams.html) inherit the cycle schedule of their parent team. When you designate an existing team as a sub-team, its past cycles remain untouched but future cycles update to match the closest parent cycles.

Why don't the completed cycle graph and issue list always match?

Completed cycle graphs and statistics are preserved as historical snapshots from when the cycle was completed. The issue list on the cycle page can still change afterward because the underlying issues can change. For example, an issue might be reopened, moved to a different cycle, or have its status or estimate updated. When that happens, the issue list can diverge from the historical graph and totals.

[Previous

Delete and archive issues](https://linear.app/docs/delete-archive-issues.html)[Next

Coding sessions](https://linear.app/docs/coding-sessions.html)

* [Configure](https://linear.app/docs/use-cycles.html#configure)
* [Cycle settings](https://linear.app/docs/use-cycles.html#cycle-settings)
* [Cycle duration](https://linear.app/docs/use-cycles.html#cycle-duration)
* [Cooldowns after each cycle](https://linear.app/docs/use-cycles.html#cooldowns-after-each-cycle)
* [Starting day of the week](https://linear.app/docs/use-cycles.html#starting-day-of-the-week)
* [Upcoming cycles](https://linear.app/docs/use-cycles.html#upcoming-cycles)
* [Disable cycles](https://linear.app/docs/use-cycles.html#disable-cycles)
* [Adjust cycles](https://linear.app/docs/use-cycles.html#adjust-cycles)
* [Move start and end dates](https://linear.app/docs/use-cycles.html#move-start-and-end-dates)
* [Adjusting dates without cycle cooldowns](https://linear.app/docs/use-cycles.html#adjusting-dates-without-cycle-cooldowns)
* [Adjusting dates with cycle cooldowns](https://linear.app/docs/use-cycles.html#adjusting-dates-with-cycle-cooldowns)
* [Start a cycle today](https://linear.app/docs/use-cycles.html#start-a-cycle-today)
* [Update cycle name and description](https://linear.app/docs/use-cycles.html#update-cycle-name-and-description)
* [Cycle automations](https://linear.app/docs/use-cycles.html#cycle-automations)
* [Issues rollover](https://linear.app/docs/use-cycles.html#issues-rollover)
* [Auto-add active issues to current cycle](https://linear.app/docs/use-cycles.html#auto-add-active-issues-to-current-cycle)
* [Cycle calendars](https://linear.app/docs/use-cycles.html#cycle-calendars)
* [Cycle capacity](https://linear.app/docs/use-cycles.html#cycle-capacity)
* [FAQ](https://linear.app/docs/use-cycles.html#faq)
