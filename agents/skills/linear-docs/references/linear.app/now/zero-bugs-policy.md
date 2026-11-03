---
title: "Why we committed to a zero-bugs policy - Linear"
source_url: "https://linear.app/now/zero-bugs-policy"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# Why we committed to a zero-bugs policy

![An old-school style rendering of an "asteroids" type game, conveying the idea of a little spaceship shooting bugs.](https://webassets.linear.app/images/ornj730p/production/a247337b8ea328e9dea184f3109b9517de2ca447-3904x1760.png?q=95&auto=format&dpr=2)

![An old-school style rendering of an "asteroids" type game, conveying the idea of a little spaceship shooting bugs.](https://webassets.linear.app/images/ornj730p/production/7bfe3c93531a39fa6b41c8517271f720c0a4b45c-2352x1280.png?q=95&auto=format&dpr=2)

[Tuomas Artman](https://linear.app/now/author/tuomas-artman.html) and [Sabin Roman](https://linear.app/now/author/sabin.html)·September 24, 2025

When we tell people that Linear maintains a zero-bug policy a common response is disbelief. It may sound like a ridiculous approach, but we do it because no other way makes sense.

The zero-bug stance means that we address bugs immediately, with the exact number of days depending on the severity: low-priority bugs need to be addressed within 7 days, high-priority bugs within 2. We formalized this approach two years ago. The impetus was actually a bug in a popular consumer app that I had reported to their team. Finally two years ago—and five years after I first reported the bug—I saw that it got fixed. I thought to myself, “wow, millions of users suffered through this bug for years for no reason.” If the company was going to fix the bug eventually, it would have been so much better to fix it right away.

That’s the big idea behind our zero-bug policy. We want Linear to be a solid, high-quality product, which means we’re going to address any bug that comes in. Fixing a bug takes the same amount of work whether we do it right away or put it off. But it’s not a zero-sum game: fixing it immediately gives us a higher-quality product and spares users unnecessary pain for the same overall effort.

Plus the approach allows us to deliver a kind of magical experience for customers who report bugs and the next day (or sooner) find it’s fixed. For example, this user last October who reported a problem with paragraph breaks in the Linear editor that we [fixed the same day](https://x.com/JohnONolan/status/1847023583307948194):

![Image of Tweet celebrating Linear's bug fixing speed](https://webassets.linear.app/images/ornj730p/production/575a95e1509bdfd5da7f434cc4c7b5153f5b1b64-3904x1978.png?q=95&auto=format&dpr=2)

![Image of Tweet celebrating Linear's bug fixing speed](https://webassets.linear.app/images/ornj730p/production/a4f28876950218079e535472bbfd5f3981a15844-2352x1396.png?q=95&auto=format&dpr=2)

### Zero-bugs starts by clearing the backlog[⁠](https://linear.app/now/zero-bugs-policy.html#zero-bugs-starts-by-clearing-the-backlog)

Once we agreed that a zero-bug policy was the only right way to go, the first step was to clean out the backlog. We had about 175 open bugs at that point and set aside three weeks to fix them all. For that period we paused all other projects. No one did anything but fix bugs. By the end we had given ourselves a clean slate.

Next we had to put in place practices to maintain it.

We already had rotating triage duties. Each week it would be someone’s job to assign incoming bugs to the right team members. Now with our new zero-bug policy we gave everyone a choice: When a bug is assigned to you, you can either mark it as “won’t fix” if it’s too marginal to address, or you can commit to fixing it. Importantly, we eliminated the option of sending bugs to the backlog.

(Related to this, I’ve heard stories of companies whose backlogs grow to thousands of bugs. Eventually, instead of fixing the bugs, they just delete the whole thing and start over. It’s a reflection of how when you put bugs in a backlog, in most cases what you’re really saying is you’re never going to get to them.)

We also set SLAs to focus our work: 48 hours for high-priority bugs and 7 days for the rest. Those were the official guidelines. In practice, it soon became the team norm that the first thing you do in the morning is open your inbox and see if you have been assigned a bug. If you have, you spend a few hours fixing it right away. By taking bugs on immediately, we make sure we stay within our SLAs. We also avoid the drag of context switching all the time. Bugs first, the rest of your work after that.

### The zero-bug dashboard[⁠](https://linear.app/now/zero-bugs-policy.html#the-zero-bug-dashboard)

Each week we review a dashboard of open bugs. If one person has too many, we reassign some so the load is even. Those reviews show us more than just who’s carrying what. Often they highlight patterns in the product and make it obvious when a team doesn’t have enough capacity. It’s one thing to know that in the abstract, but seeing bugs accumulate in particular areas of the product really drives it home and helps us allocate resources.

![Dashboard showing the Linear EU product team's bug statistics](https://webassets.linear.app/images/ornj730p/production/2a8b580d5c06d5a217182d44e813e793d898a5d2-3904x3436.png?q=95&auto=format&dpr=2)

![Dashboard showing the Linear EU product team's bug statistics](https://webassets.linear.app/images/ornj730p/production/b0ac87df68bb3e37d46e2a5c27cf2df7198cb93b-2352x2118.png?q=95&auto=format&dpr=2)

The dashboard the Linear EU product team uses to track bug statistics.

The same idea holds for conversations with individual team members. When an engineer’s bug count creeps above four or five, we notice it when reviewing the dashboard, and provide them with the resources they need to bring it down. The solution might be to reassign a few bugs, or to have the engineer step away from project work for a couple of days and focus on clearing their queue.

### Zero-bugs is not just a practice, it’s a value[⁠](https://linear.app/now/zero-bugs-policy.html#zero-bugs-is-not-just-a-practice-it's-a-value)

The zero-bug policy has a few major effects at Linear. One is obvious: We end up fixing a lot of bugs. Last year we fixed more than 2,000. In the last three months we’ve addressed more than 700.

Another effect is less obvious but just as important: The zero-bugs policy changes our relationship with our customers.

It’s not uncommon for Customer Support to file a bug in the morning—often through our Intercom integration—and have it fixed by lunch. That kind of turnaround allows us to turn a bad experience—an encounter with a bug—into an excellent one that changes their whole perspective on what it’s like to reach out to a company when something is broken.

Over time these experiences have molded the way our user base reacts to imperfections in the product. Instead of coming to us angry or frustrated, we find many users write to us in a spirit of collaboration—working hand in hand with us to make Linear a better product because they trust we’ll respond quickly. It also often turns them into Linear advocates:

![Image of a tweet exchange on Linear's support response.](https://webassets.linear.app/images/ornj730p/production/5309a09bc5e4d42b55fc34d5f1c84ca5f64441e6-3904x2740.png?q=95&auto=format&dpr=2)

![Image of a tweet exchange on Linear's support response.](https://webassets.linear.app/images/ornj730p/production/b742f907db0cf6012b733d7b359f99d151131eef-2352x1940.png?q=95&auto=format&dpr=2)

Then there’s how the zero-bugs policy shapes the culture of our engineering team. One way is that it preempts bugs: because the team understands they’re going to have to fix all these bugs eventually, they work harder to avoid introducing them in the first place.

It’s also a way of establishing our values as an engineering team and sets the tone right away during the hiring process. Engineers who join Linear know we care deeply about quality and that part of their job will always be fixing bugs. It’s a clear signal that helps us attract the right people.

There’s no doubt that the zero-bugs policy requires us to reprioritize our effort. Our team shipped a lot of new features this summer and keeping up with bugs alongside that was a lot of work. But when we recently discussed, purely as a thought experiment, whether anyone would want to discontinue the practice, the answer was unanimous: Nobody could imagine going back, because to do so would mean accepting a lower-quality product.

And for us, that’s simply not an option.

*If building in a zero-bugs environment appeals to you, check out our [open roles](https://linear.app/careers.html#join-us).*

[Tuomas Artman](https://linear.app/now/author/tuomas-artman.html) and [Sabin Roman](https://linear.app/now/author/sabin.html)·September 24, 2025

Copy link
