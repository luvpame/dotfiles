---
title: "How our Customer Experience team works in Linear - Linear"
source_url: "https://linear.app/now/cx-in-linear"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Now](https://linear.app/now.html)
2. [From the team](https://linear.app/now/team.html)

# How our Customer Experience team works in Linear

![An illustration showing different arrows that point to a single Linear Triage icon](https://webassets.linear.app/images/ornj730p/production/c06423dfdeb9b79a19542a9b4d0019e8ff9ad452-3904x1760.png?q=95&auto=format&dpr=2)

![An illustration showing different arrows that point to a single Linear Triage icon](https://webassets.linear.app/images/ornj730p/production/4200895d8cd48241c1597df0bf51948ab1680aa8-2352x1280.png?q=95&auto=format&dpr=2)

[Alexandra Lapinsky Wilson](https://linear.app/now/author/alexandra-lapinsky-wilson.html)·November 06, 2025

One of our main goals in Customer Experience (CX) at Linear is to make the support process feel like an extension of the product itself.

That starts with meeting customers where they are—places like Intercom, Slack, Slack Community, X, or Reddit—and turning those conversations into part of our product development process. This creates a tight feedback loop between customers and our EPD teams, leading to a better product and moments of delight when users see their feedback realized in the app.

At a high level, this is our process:

**Stage 1**: CX routes customer feedback through designated waypoints (namely Intercom and Slack) into triage queues in Linear monitored by our engineering and product teams.

**Stage 2**: When an issue lands in triage, it triggers a notification to a Linear team member whose priority that week is to take on the work themselves or assign it to the right engineer (in the case of bugs) or attach it to the right candidate projects (in the case of feature requests).

**Stage 3**: The assigned engineer builds the solution and merges the PR.

**Stage 4**: Once the PR is merged, Linear’s GitHub integration marks the issue as Done in the Linear issue, which prompts CX to close the loop with the customer.

The key is building systems that collect and funnel information in a consistent way, and wiring them together so that handoffs between stages happen efficiently. Here’s more detail on how it all works.

### Stage 1: Intake[⁠](https://linear.app/now/cx-in-linear.html#stage-1:-intake)

We initiate the CX process in two main places: Intercom and Slack. There we begin the process of translating a customer’s words into a Linear issue.

#### Intercom[⁠](https://linear.app/now/cx-in-linear.html#intercom)

We use Intercom to collect all support tickets that come in via email or from within the Linear app. We use the Linear-Intercom integration to create Linear issues directly from inside Intercom.

*(Linear also supports integrations with Zendesk, Salesforce Service Cloud, and Front. Plain and HelpScout have built their own Linear integrations.)*

![A flowchart of the Intercom-Linear integration: When the bug template is used, the issue is added to Proudct. When the Feature Request template is used, the issue gets added to Engineering.](https://webassets.linear.app/images/ornj730p/production/88faa60fb388b2d4814e9909001d21bd6c603e4f-3904x2138.png?q=95&auto=format&dpr=2)

![A flowchart of the Intercom-Linear integration: When the bug template is used, the issue is added to Proudct. When the Feature Request template is used, the issue gets added to Engineering.](https://webassets.linear.app/images/ornj730p/production/304ae4afc119a85e01a64e12a09a74fc4d19b2d0-2352x1280.png?q=95&auto=format&dpr=2)

We have two templates in Intercom for turning customer feedback into Linear issues—one for bugs, another for feature requests. The templates automatically apply the right issue type and take a first pass at duplicate detection. They also route issues to the right team: bugs go into the engineering triage queue, feature requests go into the product triage queue.

#### Slack[⁠](https://linear.app/now/cx-in-linear.html#slack)

Each week, as part of our CX on-call rotation, one team member is responsible for keeping an eye on feedback from external channels like social media, community spaces, and app store reviews.

Notifications from those sources flow into dedicated Slack channels such as #notifs-twitter and #notifs-reddit, which make it easier to catch relevant comments. The CX on-call person also keeps an eye on channels in our own Slack community, like #help and #product-feedback.

When they spot a comment that needs engineering or product attention, they use Linear Asks templates to turn the message directly into an issue.

Just as in Intercom, we maintain two Asks templates—one for bugs, one for feature requests. We keep the required fields to a minimum so CX can file issues quickly while still including enough detail for engineering and product teams to act on. These issues automatically include the customer’s exact words and a link back to the original conversation, which makes it easy to close the loop once the issue is resolved.

![A screenshot of a Feature Request template in Linear Asks](https://webassets.linear.app/images/ornj730p/production/d14a877ab5037f08a4ac58e814be0876919d12dc-1952x1669.png?q=95&auto=format&dpr=2)

![A screenshot of a Feature Request template in Linear Asks](https://webassets.linear.app/images/ornj730p/production/44e7a5623a274d495ad75e8123db9d197ef2b379-2352x3338.png?q=95&auto=format&dpr=2)

### Stage 2: Triage[⁠](https://linear.app/now/cx-in-linear.html#stage-2:-triage)

Triage—the dedicated “inboxes” monitored by our engineering and product teams—is where we decide who should take the work and how it should be categorized. [Triage Intelligence](https://linear.app/docs/product-intelligence.html) helps a lot here. Above and beyond the automation built into our intake templates, it:

* Detects duplicates (particularly useful for aggregating feature requests)
* Applies labels (such as the area of the product the issue is about)
* Suggests the right team or assignee

![A screenshot of the Triage Intelligence UI element in Linear with suggestions for assignee, labels, and potential duplicates.](https://webassets.linear.app/images/ornj730p/production/33505ac482eb62752c75ac76dd20ff2931641a8b-3904x1178.png?q=95&auto=format&dpr=2)

![A screenshot of the Triage Intelligence UI element in Linear with suggestions for assignee, labels, and potential duplicates.](https://webassets.linear.app/images/ornj730p/production/165894ff4b4552dff96e5072e4e8eaa84a630356-2352x1178.png?q=95&auto=format&dpr=2)

After that automated pass, the person overseeing triage makes the final decision about where each issue should go (internally we refer to this person as the “goalie”). Engineers and product team members rotate through the role each week, as configured in our [triage responsibility](https://linear.app/changelog/2023-10-12-triage-responsibility.html) settings.

For bugs, the goalie either takes the issue themselves or assigns it to the right expert on the team. We address bugs according to clear SLAs consistent with our [zero-bugs policy](https://linear.app/now/zero-bugs-policy.html).

Feature requests follow a different flow. By utilizing [Customer Requests](https://linear.app/customer-requests.html), the user’s direct feedback, company information, and a record of the original discussion are all linked to a Linear issue or project. The product team goalie for the week reviews this feedback and adds notes or context that CX can share back with customers. (For more about how we aggregate feature requests into projects, see our blog “[Continuous planning in Linear](https://linear.app/now/continuous-planning-in-linear.html).”)

You can automate much of the process of sorting incoming work with triage rules which let you define actions that run the moment after Triage Intelligence completes its work. For example, you might route all urgent enterprise bugs directly to a specific team or assignee and automatically apply the right SLA.

![A screenshot of an example Triage Rule in Linear: When the customer tier is Enterprise, the issue automatically gets marked as Urgent](https://webassets.linear.app/images/ornj730p/production/8eec7357bedbd5499ef2556053918be6d20cdbf0-3904x1034.png?q=95&auto=format&dpr=2)

![A screenshot of an example Triage Rule in Linear: When the customer tier is Enterprise, the issue automatically gets marked as Urgent](https://webassets.linear.app/images/ornj730p/production/438375792b4437de1850a9b4f2ae08ead09b8001-2352x1034.png?q=95&auto=format&dpr=2)

### Stage 3: Engineering[⁠](https://linear.app/now/cx-in-linear.html#stage-3:-engineering)

When an engineer takes on an issue, it becomes part of their active work. They make the changes, test the solution, and merge the pull request. At that point, our GitHub integration marks the associated Linear issue as “Done.”

### Stage 4: Closing the loop[⁠](https://linear.app/now/cx-in-linear.html#stage-4:-closing-the-loop)

Once an issue is marked Done, it triggers an update back to wherever it originated. In Intercom, the linked conversation reopens with a note letting the CX team know the issue was resolved.

![A screenshot of a customer conversation in Intercom that automatically gets reopened once a linked Linear issue gets marked as done](https://webassets.linear.app/images/ornj730p/production/1a958da630ad00d771f5bf38d4220379b2ca26ca-3904x2992.png?q=95&auto=format&dpr=2)

![A screenshot of a customer conversation in Intercom that automatically gets reopened once a linked Linear issue gets marked as done](https://webassets.linear.app/images/ornj730p/production/3ae7ea7e07e3eb14ecf80748de5ce4cab29544bc-2352x2992.png?q=95&auto=format&dpr=2)

In Slack, the linked message is updated with the current status. From that point, we reach out to the customer directly to share the update and confirm the fix.

### CX as UX[⁠](https://linear.app/now/cx-in-linear.html#cx-as-ux)

Treating customer experience as part of the Linear product experience means two things. First, at a tangible level, it means CX is connected directly to product and engineering. Second, it means we want the experience customers have when they reach out for help to feel as seamless as the experience they have using Linear itself.

To build a similar workflow in your own workspace:

* Integrate Linear with your support tools such as [Intercom](https://linear.app/integrations/intercom.html), [Zendesk](https://linear.app/integrations/zendesk.html), [Salesforce Service Cloud](https://linear.app/integrations/salesforce.html), and [Front](https://linear.app/integrations/front.html).
* Install the [Slack](https://linear.app/integrations/slack.html) and [GitHub](https://linear.app/integrations/github.html) integrations to connect CX with product, design, and engineering workflows.
* Turn on [Triage](https://linear.app/docs/triage.html) to organize new issues and route them automatically.
* Enable [Triage Intelligence](https://linear.app/ai.html) to automate labeling, deduplication, and assignment.
* Set up [Triage Rules](https://linear.app/changelog/2025-06-05-asks-fields-and-triage-routing.html#triage-routing) (Enterprise) to handle recurring actions automatically.

Or, if the Linear way of product building appeals to you, consider [joining our team](https://linear.app/careers.html).

[Alexandra Lapinsky Wilson](https://linear.app/now/author/alexandra-lapinsky-wilson.html)·November 06, 2025

Copy link
