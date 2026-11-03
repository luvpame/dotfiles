---
title: "Descript's internal guide for using Linear"
source_url: "https://linear.app/now/descript-internal-guide-for-using-linear"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the community](https://linear.app/now/community.html)

# Descript’s internal guide for using Linear as your work operating system

![Descript logo on dark gray background with tile cards representing the company's tips for using Linear. ](https://webassets.linear.app/images/ornj730p/production/655567b1044177d9e9da88eeeae666d16796018c-4112x1888.png?q=95&auto=format&dpr=2)

![Descript logo on dark gray background with tile cards representing the company's tips for using Linear. ](https://webassets.linear.app/images/ornj730p/production/4a62063c5cf6d4252c0db260e1963780d99464f8-4112x1888.png?q=95&auto=format&dpr=2)

[Karri Saarinen](https://linear.app/now/author/karri-saarinen.html)·January 31, 2024

*Linear is a critical internal tool for Descript’s EPD and business teams. Below is an excerpt of the best practices guide Descript CEO Andrew Mason wrote to help the teams at Descript set up Linear as their work operating system. The guide includes a breakdown of tips for mastering keyboard shortcuts, integrating Slack messages with Linear, using Raycast for quick issue capture, and customizing Linear for focused task management.*

Today, your tooling is the place most of your team’s collaboration and work happens. What tools you choose–and how well your team truly embraces the functionality and potential of them–determines how well your organization operates.

Thankfully, leaders like [Andrew Mason](https://www.linkedin.com/in/andrewmason/), CEO at Descript, are out there creating comprehensive resources for their teams, including a great breakdown of how to use Linear as your work operating system.

For the unfamiliar, Descript is an all-in-one video editing platform that’s been [building on Linear since December 2020](https://linear.app/customers/descript.html). Over the years, we’ve helped them uplevel their engineering workflows, and drive deeper collaboration between different functional teams.

As Andrew expands on in the re-printed guide below, the superpower of a great collaboration tool isn’t really about the tool at all. Rather, it’s about the ways you can free up your time to focus on more satisfying work (in turn making your team more successful and happier to work together).

Thanks again to Andrew for creating such a great resource for the teams at Descript, and for letting us republish it here for the wider Linear community.

## Descript’s Linear best practices[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#descript's-linear-best-practices)

At Descript, Linear is core to the way we work internally, and if you use it effectively, should be your central work operating system.

But, like all tooling changes, getting up to speed with it and helping our engineering, product, design, and business teams learn how to best leverage it has taken some time and standardization. This is less a comment on Linear and more just the reality of folks learning a new way to do project and task management.

It’s worth putting in the time to learn though, because, as a company, these are the benefits we get from using Linear effectively as a collaboration tool:

* **Less time looking for things** (Did someone file a ticket for X already? Where is that bug?)
* **Less fielding questions** **from a zillion people** like ”What’s the status of X?” - just look it up in Linear
* **Less interruptive use of Slack** for things that should really be handled as tickets (distinction touched on below)
* **A framework for you to prioritize your work** and decide what you can/can’t commit to, so you don’t get overwhelmed. And you automatically communicate those prioritization decisions to everyone and automatically set expectations

Below are the Linear best practices encouraged across all the teams at Descript.

## How to get more efficient with Linear[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#how-to-get-more-efficient-with-linear)

Linear has a range of features that help you work faster and smarter across all your workflows, including keyboard shortcuts, quick screen capture with Raycast, and their [Slack integration](https://linear.app/integrations/slack.html).

If you spend a few minutes at the beginning of your Linear journey understanding how to navigate these shortcuts, it’ll save you a ton of time down the road.

### Learn the keyboard shortcuts[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#learn-the-keyboard-shortcuts)

You’re going to spend a lot of time in Linear, but you’ll spend a lot less if you invest in learning the built-in keyboard shortcuts. Linear is probably the most tricked-out with keyboard shortcuts app I’ve ever used. Here are some of my favorites:

* `command k` to open a list of commands specific to the item you’re on (e.g. moving an issue to another project, changing the assignee or followers, changing status, etc.).
* **`g` and then `various keys`** to quickly navigate to My Issues, Projects, etc.
* **`o` and then `p`** to search projects, or **t** to switch teams, or **d** to open project documents
* **`j` and `k`** to navigate up and down list items

There are also a bunch of single-key keyboard shortcuts (`c` to create issue, `a` to assign to user, `l` to add label, `p` to assign priority, and `f` to filter are particularly helpful). You can access them for whatever the active item is you have selected. If it takes some time to remember them all it’s ok (I’m still getting them into my muscle memory).

### Send saved Slack messages to Linear[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#send-saved-slack-messages-to-linear)

Managing two inboxes is hard. Here are two ways to use Zapier to stop flipping between multiple inboxes and merge your Slack and Linear to-dos into your Linear inbox.

#### The quick improvement[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#the-quick-improvement)

The end result of this flow is to have your saved messages in Slack automatically added to your Linear inbox with the original message context. This way, you can easily follow up on tasks and messages at a future date.

![The flow for automatically creating issues in Linear based on your saved Slack messages.](https://webassets.linear.app/images/ornj730p/production/73553d12dd7e074d262387381f0c4b326acc39e4-1176x720.png?q=95&auto=format&dpr=2)

![The flow for automatically creating issues in Linear based on your saved Slack messages.](https://webassets.linear.app/images/ornj730p/production/6cf43c5e841800f0dcbf90c40068b0df77533a63-1176x720.png?q=95&auto=format&dpr=2)

The flow for automatically creating issues in Linear based on your saved Slack messages.

Here are the steps:

* Go to your Zapier account and create a new Zap
* For trigger event, select Slack and set the event to “save message” (make sure you’ve connected your work Slack account)
* For the action, find Linear and set the event to create an issue (sign into your Linear account before continuing)
* Tell Zapier what team to create the issue in and what info you want to populate the issue title and description with
  + For title, I use username:(the description text)
  + For description, I repeat the message text and include a markdown link to the original message for reference later

You can also turn messages into issues with the [Linear Slack integration](https://linear.app/docs/slack.html) and manually edit issue details such as title, description, assignee et al. (without the Zapier workflow).

#### The powered-up version[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#the-powered-up-version)

![The flow for having messages marked as scheduled in Slack automatically create issues in Linear for you with AI-summarized descriptions.](https://webassets.linear.app/images/ornj730p/production/91fa2e8733a574af1536d428af4982ff846727b6-1176x1008.png?q=95&auto=format&dpr=2)

![The flow for having messages marked as scheduled in Slack automatically create issues in Linear for you with AI-summarized descriptions.](https://webassets.linear.app/images/ornj730p/production/37666add300ad92939dadbaccc2202781a3b0bbf-1176x1008.png?q=95&auto=format&dpr=2)

The flow for having messages marked as scheduled in Slack automatically create issues in Linear for you with AI-summarized descriptions.

If you want to take it to the next level, you can also have chatGPT summarize the description of the message. This is the workflow I use every day:

* Building on the zap above, add chatGPT to the flow before the Linear issue creation step
* For the action, have chatGPT summarize the Slack message into 12 words or less
* Now, in the Linear action step, populate your issue description with the summarized version. Include the markdown link back to Slack (I use the same title formatting as before).
* Set the issue status as triaged to yourself

### Use Raycast for quick capture[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#use-raycast-for-quick-capture)

![Screenshot of the Raycast search modal featuring the "create issue for myself" command](https://webassets.linear.app/images/ornj730p/production/af83ac2a62321176a976820fb8cc35016823f530-1522x970.png?q=95&auto=format&dpr=2)

![Screenshot of the Raycast search modal featuring the "create issue for myself" command](https://webassets.linear.app/images/ornj730p/production/af83ac2a62321176a976820fb8cc35016823f530-1522x970.png?q=95&auto=format&dpr=2)

Customize Raycast shortcuts to create issues in Linear from anywhere

Another key requirement of any task management system is a way to quickly capture an emergent issue. That way, you’re never left trying to store this stuff in your brain.

Unlike many native task management apps, Linear doesn’t have a quick-entry global system hotkey type of thing. Instead, [you can use Raycast](https://linear.app/integrations/raycast.html), a free system-wide command bar “Spotlight on Steroids”.

Install the Linear extension, and then bind the create issue for myself action to the hotkey `command`  `space`  `shift`.

## How to customize Linear to your work and focus areas[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#how-to-customize-linear-to-your-work-and-focus-areas)

Linear doesn’t just offer features to help you customize your shortcuts. It also gives you ways to customize your inbox and views to stay focused on your highest-priority work.

### Configure My Issues to only contain what’s actionable[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#configure-my-issues-to-only-contain-what's-actionable)

A task management system should give you a view of all your issues. It should reduce the chaos to something orderly and actionable. **My Issues** (`g` and then `m`) is how Linear does this.

To make **My Issues** more manageable, I recommend adding a few filters (which Linear remembers until you change them):

* Don’t show **Project Status** = **Done** or **Backlog**
* Don’t show issues that are blocked.
* Try to keep **In progress** issues to only 1-2 issues at a time\*

*\*I’m sure this will vary depending on your role, but the point is, it should only be the stuff that you’re actively working on, and everything else should be in Todo.*

![Screenshot of Linear UI featuring Andrew's My Issues view with done, backlog and blocked issues filtered out.](https://webassets.linear.app/images/ornj730p/production/0ba0f8215065339d8b4be29de9900e254ede5508-1176x434.png?q=95&auto=format&dpr=2)

![Screenshot of Linear UI featuring Andrew's My Issues view with done, backlog and blocked issues filtered out.](https://webassets.linear.app/images/ornj730p/production/1609398390411d017baa008d67ad7b018e269490-1176x434.png?q=95&auto=format&dpr=2)

Keep your My Issues view orderly and actionable by using filters to remove the noise.

**My Issues** in a more focused state w/ **Status** and blocking filters.

### Use a saved View to promote tasks from Backlog to Todo[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#use-a-saved-view-to-promote-tasks-from-backlog-to-todo)

![Screenshot of the Linear UI featuring Andrew's view My Backlog with sections for in progress, to do, backlog, and triage statuses. ](https://webassets.linear.app/images/ornj730p/production/50998b35abf94c7cdc415e050641afd1b627f282-1176x696.png?q=95&auto=format&dpr=2)

![Screenshot of the Linear UI featuring Andrew's view My Backlog with sections for in progress, to do, backlog, and triage statuses. ](https://webassets.linear.app/images/ornj730p/production/6f73cd010c40c1fb52faa35a19b100dae9926789-1176x696.png?q=95&auto=format&dpr=2)

Separate out backlog issues from your My Issues view to make it easy to promote them to todo as needed.

The **My Issues** view is intended to be the spot where you’ll spend most of your time (think of it as your home view). Since you should have backlog issues filtered out of your **My Issues** view (and you want to avoid changing view filters back and forth), I recommend saving/favoriting a separate view for this to see all open issues sitting in your backlog so you can promote them to **Todo** as needed.

You can use the view I use, which is called Open by Project. This view groups issues by the project.

![Screenshot of the Linear UI featuring Andrew's Open by Project view which groups backlog tasks by project area. ](https://webassets.linear.app/images/ornj730p/production/ca6ecadc05788b5c4b740f59e4c6bff9f22030cf-1176x696.png?q=95&auto=format&dpr=2)

![Screenshot of the Linear UI featuring Andrew's Open by Project view which groups backlog tasks by project area. ](https://webassets.linear.app/images/ornj730p/production/fe35433b6165d7ad0643d22979690e25e1e82f5d-1176x696.png?q=95&auto=format&dpr=2)

Group backlog issues by project to help you review and promote priority tasks each week.

At the beginning of the week, I’ll open this view and do a pass-through on every issue, deleting stuff that’s no longer relevant or needed.

## How to handle issues effectively[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#how-to-handle-issues-effectively)

As we do more and more work in Linear, the number of issues we create and interact with can become unwieldy. To avoid creating a bunch of noise for yourself and your teammates, there are a few hygiene best practices to keep on top of.

### Use the Todo/Backlog statuses to organize active work[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#use-the-todobacklog-statuses-to-organize-active-work)

This best practice is for people who aren’t doing EPD-style sprint/cycle planning - those who are have their own process for this.

Marking an issue status as **Todo** means you plan to start it in the next week or so. Everything else should be in the **Backlog**.

The first thing you do each week should be to go through all the issues assigned to you in your backlog and promote a manageable number to **Todo**.

This will help you prioritize. It will also set expectations with your collaborators on when you plan to actively work on an issue. For example, the **Backlog** status communicates it’s not coming soon. Meanwhile, **Todo** shows it’s imminent.

### Use Issue Blocking and Reminders to focus My Issues[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#use-issue-blocking-and-reminders-to-focus-my-issues)

Sometimes you’ll have a task that’s **In Progress** or you otherwise want to keep it in **My Issues**, but you can’t actually act on it. This is just creating cognitive noise. To narrow my focus, there are two things I do:

1. If I’m blocked by another issue, I **mark the issue as Is blocked by** (`command K` → **Blocked**) and filter blocked issues from the list.
2. If I’m not yet ready to work on it, I **move the issue to my Backlog with a reminder to follow up** at a future time (`H` shortcut).

### Set a Priority instead of a Due Date to rank issues[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#set-a-priority-instead-of-a-due-date-to-rank-issues)

Sometimes due dates are real (like when there’s an external dependency), but often we’re just using them to stack rank work. If this is the case, try using priorities instead.

When you’re going through your backlog, promote the highest-priority items — it’s that simple. This will save you from the common and demotivating state of having a zillion overdue tasks. Try to only use due dates when they’re real.

## How to collaborate in Linear[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#how-to-collaborate-in-linear)

The main goal of using Linear as our work operating system is to break down silos across teams and make it easier to do great work together. Here are a few of the best practices to follow to make it easier (and joyful) to build with your teammates.

### When you assign issues, put them in Triage[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#when-you-assign-issues-put-them-in-triage)

When you assign new issues to someone, putting them directly into **Todo** is tantamount to declaring that they’ll be working on it this week. So use your judgment, but generally it’s better to mark issues as **Triage**, which is a status that tells the assignee that they need to process/assign a status.

### Use “Verify” when done with issues[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#use-"verify"-when-done-with-issues)

Oftentimes, we need to have someone review and sign off on work before it’s truly done. To reflect this review stage, we created a custom workflow status in Linear called verify before the **Done** status. Rather than marking a task as done, use verify to flag that it’s ready to review and then assign it to your teammate.

### Stay on top of your Inbox[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#stay-on-top-of-your-inbox)

For this all to work, it’s paramount others can rely on you to read new comments and see new issues as they come in. Treat your Linear **Inbox** the way you treat Slack (and the way, once upon a time, we all treated email): Keep it open and process it at the same rate you would process things with those tools.

When people feel the need to ping you on Slack to get feedback on a comment left in Linear, it’s a pretty good signal that you’ve got work to do here!

To tame your Linear Inbox, use general [Inbox Zero processing principles](https://www.wired.com/story/everything-you-thought-you-knew-about-inbox-zero-is-wrong/) (i.e. clear out your notifications as you’re reading them.) Use the **`E`** keyboard shortcut to quickly archive an Inbox notification, `Shift H` to snooze an issue, and use **`J`** and `K` to navigate up and down the list.

### Be intentional about when you start a Slack thread vs assign an issue in Linear[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#be-intentional-about-when-you-start-a-slack-thread-vs-assign-an-issue-in-linear)

As we streamline how we work and communicate as a team, we need to be more intentional about what kinds of communication goes in which channel.

* Use Linear if it’s a task that someone needs to complete (distinct outcome)
* Use Slack if it’s a discussion without a “completion” state (fuzzy outcome) or if it involves a lot of context sharing between teams.

If you’re having a long conversation with multiple stakeholders in Slack about a new, distinct issue or task, you can [create an issue based on the thread](https://linear.app/docs/slack.html#create-issues). Linear will keep the Slack thread and Linear issue comments in sync via our Slack Integration.

## Take what works and leave the rest[⁠](https://linear.app/now/descript-internal-guide-for-using-linear.html#take-what-works-and-leave-the-rest)

The principles throughout are good hygiene for any team using Linear that wants to improve their day-to-day workflows.

Learning a new way of working always takes some intentional effort, but Linear helps us spend less time answering tons of questions and searching our systems for information, and more time working on our actual product.

[Karri Saarinen](https://linear.app/now/author/karri-saarinen.html)·January 31, 2024

Copy link
