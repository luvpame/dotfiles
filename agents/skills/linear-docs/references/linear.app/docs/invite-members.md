---
title: "Invite members – Linear Docs"
source_url: "https://linear.app/docs/invite-members"
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
* Administration

  + [![Workspaces](https://webassets.linear.app/images/ornj730p/production/5fbe479163f634cafc305ef4b07cbb6eac5bfa08-16x16.svg?q=95&auto=format&dpr=2)Workspaces](workspaces.html)
  + [![Teams](https://webassets.linear.app/images/ornj730p/production/41309383510a94f0087966d54e90ebc64a177f39-16x16.svg?q=95&auto=format&dpr=2)Teams](teams.html)
  + [![Team pages](https://webassets.linear.app/images/ornj730p/production/2012b5ca81b9d3cde72bae4c743a14d57b500d68-16x16.svg?q=95&auto=format&dpr=2)Team pages](default-views.html)
  + [![Private teams](https://webassets.linear.app/images/ornj730p/production/f95a05604aad31f7e01466ae03897777d1d2a218-16x16.svg?q=95&auto=format&dpr=2)Private teams](private-teams.html)
  + [![Sub-teams](https://webassets.linear.app/images/ornj730p/production/b2e524167129b68e4be926d18dff3d57b050e25c-16x16.svg?q=95&auto=format&dpr=2)Sub-teams](sub-teams.html)
  + [![Login methods](https://webassets.linear.app/images/ornj730p/production/eb030e6addf44b757dcd01b7130fb3020c1e9074-16x16.svg?q=95&auto=format&dpr=2)Login methods](login-methods.html)
  + [![Invite members](https://webassets.linear.app/images/ornj730p/production/4a6d4dcd329012bcb08d42c0e6138e1192c5a4d8-16x16.svg?q=95&auto=format&dpr=2)Invite members](adding-and-managing-members.html)
  + [![Members and roles](https://webassets.linear.app/images/ornj730p/production/ace5af526ef589f638bb9ece43d455b97c2b9e62-16x16.svg?q=95&auto=format&dpr=2)Members and roles](members-roles.html)
  + [![SAML](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)SAML](saml-and-access-control.html)
  + [![SCIM](https://webassets.linear.app/images/ornj730p/production/d762acc0a6dbea9d803c9e5611c0dbfc86df6746-16x16.svg?q=95&auto=format&dpr=2)SCIM](scim.html)
  + [![API and Webhooks](https://webassets.linear.app/images/ornj730p/production/ea822173f6bf2d9383d19105d9ecaa6693492aca-16x16.svg?q=95&auto=format&dpr=2)API and Webhooks](api-and-webhooks.html)
  + [![Third-Party App Approvals](https://webassets.linear.app/images/ornj730p/production/b61fa1aff4d024cf6dcf0134c2c45b8d76cf0b27-16x16.svg?q=95&auto=format&dpr=2)Third-Party App Approvals](third-party-application-approvals.html)
  + [![Security](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)Security](security.html)
  + [![Audit log](https://webassets.linear.app/images/ornj730p/production/9eccb204815aeb102e7cd5fc3626a61c21f8b1b9-16x16.svg?q=95&auto=format&dpr=2)Audit log](audit-log.html)
  + [![Billing and plans](https://webassets.linear.app/images/ornj730p/production/33fa80412b10a65fd8e38cf5771b09a15670593f-16x16.svg?q=95&auto=format&dpr=2)Billing and plans](billing-and-plans.html)
  + [![AI Credits](https://webassets.linear.app/images/ornj730p/production/40f99550f03177fadfe53645dfad2e238091d67e-16x16.svg?q=95&auto=format&dpr=2)AI Credits](ai-credits.html)
  + [![Usage & limits](https://webassets.linear.app/images/ornj730p/production/c4d004a3952b8f8e45ede10f8756e0eeb5153d10-16x16.svg?q=95&auto=format&dpr=2)Usage & limits](usage-and-limits.html)
  + [![Exporting Data](https://webassets.linear.app/images/ornj730p/production/a62608da795d3e55a196c009713363ff08ef20e6-16x16.svg?q=95&auto=format&dpr=2)Exporting Data](exporting-data.html)
* Importers

# Invite members

Invite and manage members of your workspace.

![Linear app settings page showing the Manage members settings](https://webassets.linear.app/images/ornj730p/production/24df0e4ada358c601233c729518f9d91c04b5663-2160x1327.png?w=1440&q=95&auto=format&dpr=2)

## Send an invitation[⁠](https://linear.app/docs/adding-and-managing-members.html#send-an-invitation)

To send an invitation:

1. Go to the [Settings > Administration > Members](https://linear.app/settings/members.html)
2. Click the **Invite** button
3. Enter the invitee(s) email address. To add multiple invitees, separate each email by commas
4. Under **Invite as...**, select the role you want the invitee(s) to have when joining the workspace (*paid plans*)
5. You can select the team(s) you want your invitee(s) to automatically join
6. Click **Send invites**. New members will receive an invite link via email along with steps to join the workspace

In case an email server is filtering out invitation emails, we recommend adding notifications@linear.app and/or pm\_bounces@pm-bounces.linear.app to your allowlist as trusted senders in email settings.

### Email Options by Plan[⁠](https://linear.app/docs/adding-and-managing-members.html#email-options-by-plan)

Free planPaid plansEnterprise (SAML & SCIM)

All members of a workspace on the Free plan are considered an Admin, thus anyone can send invitations to new members.

By default, only Admins can invite members on paid plans. Admins can allow all users to invite members by toggling on **Allow users to send invites** within [Settings > Administration > Security](https://linear.app/settings/security.html).

For [SAML-enabled workspaces](https://linear.app/docs/saml-and-access-control.html), ensure that members are given access in your identity provider (IdP) before inviting them, depending on your login requirements.

Users who have access to Linear through your IdP may login to the workspace without needing an invitation. If no account existed for this user before, one will be created through Just-In-Time (JIT) provisioning. The user will show up as a member in Linear from this point on.

Reach out to [support@linear.app](mailto:support@linear.app) if a new user’s email does not match other emails in your workspace, as it will have to be added to the SAML configuration as an approved domain.

When [SCIM](https://linear.app/docs/scim.html) is enabled for your workspace, Members and Admins are managed through your identity provider. You can still manually invite Guests from the Members page.

Learn how [adding](https://linear.app/docs/billing-and-plans%3Fcollapsible=b6d516b44aa5.html) or [removing](https://linear.app/docs/billing-and-plans%3Fcollapsible=24c14a946d42.html) users affects billing.

## Approved email domains[⁠](https://linear.app/docs/adding-and-managing-members.html#approved-email-domains)

![Approved email domains](https://webassets.linear.app/images/ornj730p/production/68acab16d4f74f4a6c694d2f6f934fe544c41699-1392x296.png?w=1440&q=95&auto=format&dpr=2)

To save time from manually inviting new members, Admins can navigate to  [Settings > Administration > Security](https://linear.app/settings/security.html) and add allowed email domains. Once set up, anyone with the matching email domain can join the workspace without an invitation or approval. This is only designed to streamline the joining process and does not prevent users from creating new workspaces with that domain email.

Users who are creating new accounts will see a prompt to join the workspace during the onboarding flow.

For members with existing accounts, click on your current workspace icon, hover over **Switch workspace**, select **Create or join a workspace**. The workspace with the allowed email domain should show up under available workspaces.

![](https://webassets.linear.app/images/ornj730p/production/95a933639d33ab31c5ac1c56744755344279f769-16x16.svg?q=95&auto=format&dpr=2)

Please review this list regularly to ensure it is up to date.

If you ever cancel your domain or transfer control of a domain to another organization, you’ll need to remove this domain from your approved email domains in Linear to prevent unwanted access to the workspace.

## Invite links[⁠](https://linear.app/docs/adding-and-managing-members.html#invite-links)

Navigate to [Settings > Administration > Security](https://linear.app/settings/security.html) to generate a unique link that allows for anyone with the URL to join your workspace. If enabled, please ensure this link is only shared internally with your organization.

Invite links are persistent and reusable. They can be set to a new unique value with the “*Reset invite link*“ button.

Invite links are unavailable in SAML- and SCIM-enabled workspaces.

## Invite & Assign[⁠](https://linear.app/docs/adding-and-managing-members.html#invite-and-assign)

Invited users can be assigned issues or marked as project leads before they accept their invitation.

* On any issue or project, open the assignee selection menu and choose *“Invite and assign…”.* After inviting them, search for them in assignee/lead menus to continue to allocate work.
* You can also assign issues or set invited users as project leads directly from their user page in workspace settings before they accept.

## FAQ[⁠](https://linear.app/docs/adding-and-managing-members.html#faq)

What happens to API tokens when a user is suspended or converted to a guest?

The API tokens will be revoked and invalidated.

[Previous

Login methods](https://linear.app/docs/login-methods.html)[Next

Members and roles](https://linear.app/docs/members-roles.html)

* [Send an invitation](https://linear.app/docs/adding-and-managing-members.html#send-an-invitation)
* [Email Options by Plan](https://linear.app/docs/adding-and-managing-members.html#email-options-by-plan)
* [Approved email domains](https://linear.app/docs/adding-and-managing-members.html#approved-email-domains)
* [Invite links](https://linear.app/docs/adding-and-managing-members.html#invite-links)
* [Invite & Assign](https://linear.app/docs/adding-and-managing-members.html#invite-and-assign)
* [FAQ](https://linear.app/docs/adding-and-managing-members.html#faq)
