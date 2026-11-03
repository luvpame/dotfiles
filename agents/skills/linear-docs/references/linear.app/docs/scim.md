---
title: "SCIM – Linear Docs"
source_url: "https://linear.app/docs/scim"
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

# SCIM

SCIM, or *System for Cross-domain Identity Management* allows for the automation of user provisioning for your Linear workspace.

Available to workspaces on our [Enterprise](https://linear.app/pricing.html) plan

![Security Settings page for SCIM in the Linear app](https://webassets.linear.app/images/ornj730p/production/de09045809402f74f116b880078a1b7b4b774bb4-2160x1326.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/scim.html#overview)

With SCIM enabled, user accounts can be automatically created, updated, and suspended based on your IDP settings—eliminating the need for manual account management in Linear. This integration helps ensure that your team’s access stays in sync with your organization’s directory.

SCIM is available for workspaces on plans that include SAML/SCIM. If a workspace later moves to a plan that does not include SAML/SCIM, new user provisioning through SCIM will no longer be allowed. Existing users provisioned through SCIM can still sign in.

## Configure[⁠](https://linear.app/docs/scim.html#configure)

### Enable and test[⁠](https://linear.app/docs/scim.html#enable-and-test)

1. Navigate to [Settings > Administration > Security](https://linear.app/settings/security.html)*.*
2. Under the “Authentication” section, click **Configure** next to “SAML & SCIM”.
3. Toggle the option to enable SCIM
4. Click *“View configuration”* to get your **SCIM base connector URL** and **Bearer Auth token.** Keep these values at hand as you will need them to configure SCIM in your Identity provider.

Once enabled, Admins will **not** be able to manage users from within Linear as they will be kept up to date through your identity provider.
If necessary, you can temporarily enable a manual override to allow user suspension. This may be useful if you need to remove members or Guests that were added to Linear before you enabled SCIM.

### IdP-specific configuration notes[⁠](https://linear.app/docs/scim.html#idp-specific-configuration-notes)

OktaMicrosoft Entra IDOneLogin

* In the Okta admin pages, open the Linear application you have for SAML 2.0
* In the *General* tab, click *Edit* and choose *SCIM* in the Provisioning section and *Save*
* In the *Provisioning* tab, enter the SCIM Base connector URL you generated from Linear
* For the *Unique identifier* field for users section enter **email**
* For *Supported provisioning actions* you can enable “Import New Users and Profile Updates”, “Push New Users” and “Push Profile Updates”. Also select “Push Groups” if you are planning to sync selected Okta groups with Linear teams. “Import Groups” is optional, but can be selected to import existing Linear teams to be later linked to Okta groups.
* For *Authentication mode* field, choose HTTP Header and enter your Bearer token generated from Linear. You can now test the configuration and save
* Lastly, return to the Provisioning tab in Okta and edit your settings under “To App” to enable the SCIM functionality needed for your Linear application (Create, Update and Deactivate users)

![Okta settings with provisioning options checked for Linear app](https://webassets.linear.app/images/ornj730p/production/d5c19b976eca09f26ecea5eea1d19c63c0b67a82-1076x902.png?w=1440&q=95&auto=format&dpr=2)

1. In Entra, go to *Enterprise applications*, select your existing Linear app, and open *Provisioning*.
2. Select **New configuration**. Enter the SCIM base URL from Linear as the **Tenant URL** and the bearer token as the **Secret Token**.
3. Select *Test Connection*, then **Create**.
4. Under *Users and groups*, assign the users or groups you want provisioned.
5. Under *Attribute mapping*, review the user mappings. Make sure `userName` maps to the email address used for the user’s Linear account.
6. Test an assigned user with *Provision on-demand*, then go to *Overview* and select **Start provisioning**.

To provision users only, disable the groups mapping under *Attribute mapping*. Re-enable it when you want to sync groups with Linear teams or roles. Entra can’t import Linear teams, so link existing teams using [name matching](https://linear.app/docs/scim.html#link-by-name-matching).

* In OneLogin’s Admin panel > Applications, click *Add App*
* Search for the “SCIM Provisioner with SAML (SCIM v2 Enterprise, full SAML)” app and add
* Click on the *Configuration* tab and add your SCIM base URL and Bearer token
* Click on the *Provisioning* tab and Enable Provisioning
* Save your App

## Group push[⁠](https://linear.app/docs/scim.html#group-push)

Linear’s SCIM integration also supports group push. From your side all you have to do is start pushing groups from your Identity provider to Linear. These will then map 1:1 with teams in Linear.

### Link by importing teams[⁠](https://linear.app/docs/scim.html#link-by-importing-teams)

To link an existing team to a Group, you first need to import teams from Linear. These teams will be recognized as groups by your Identity provider. Once imported, you can then select the appropriate team when configuring group push.

### Link by name matching[⁠](https://linear.app/docs/scim.html#link-by-name-matching)

If your identity provider does not support importing Linear teams before configuring group push, you can instead map a pushed group to an existing team by name. In Linear, go to **Settings > Teams > [team] > General** and set the **SCIM group mapping** to the group display name used by your identity provider. When that group is pushed, Linear links it to the existing team instead of creating a new team.

Once a team is linked to a Group, this team’s membership is solely managed through your identity provider and not in Linear directly.

If you choose to disconnect the Push group from Linear in the future, you may see different options offered by your IDP:

* Opting to delete the group on Linear’s side will remove all members from the Linear team and convert the team to private. Issues will remain unchanged.
* Disconnecting the group without sending a delete request will leave the team unchanged and not sync any changes to the team on Linear’s side. From the team’s **Settings > Danger Zone** you can then unlink SCIM manually to resume managing the team as normal.

![Unlink from SCIM option in Linear team settings](https://webassets.linear.app/images/ornj730p/production/3c82a6bf3de2d2fdf814e9f9c721cb6c0f229d28-915x274.png?w=1440&q=95&auto=format&dpr=2)

## Provisioning Roles[⁠](https://linear.app/docs/scim.html#provisioning-roles)

By default, all accounts created via SCIM via individual assignment or group push are provisioned as Members. You can also choose to provision specific users into Owner (if on an Enterprise plan), Admin and Guest roles directly from your IDP.

To do this, you need to create `linear-owners` (only if on an Enterprise plan), `linear-admins` and `linear-guests` as push groups on the IDP side and sync their members with Linear.

Once these have been connected to Linear, any users added to the group will be given the corresponding role in Linear.

* These particular groups do not create Teams in Linear or sync membership with existing teams.
* You can rename these groups from your IDP after you’ve pushed them at first as `linear-owners` (if applicable), `linear-admins` and `linear-guests`
* You will not be able to assign or edit admin or guest roles manually when this link is in place.

If your workspace already uses SCIM and is now migrating to an Enterprise plan for the first time, follow [this migration guide](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html) to make sure both Owner and Admin roles get provisioned correctly going forward.

![](https://webassets.linear.app/images/ornj730p/production/18d51ecafdddceacba1197df01bb1334ef8dfd91-16x16.svg?q=95&auto=format&dpr=2)

You may prefer to invite external Guests to your workspace manually, without adding them through your IDP.

The Invite menu in *Settings > Members* will allow you to invite Guests only, even with SCIM enabled.

For Guests added before this was an option, you can use the ... menu on the Members page to unlink their account from your identity provider and manage them in Linear.

## SCIM Sync[⁠](https://linear.app/docs/scim.html#scim-sync)

Linear keeps the following user and team properties in Linear up to date in near real time when we receive SCIM updates from your IDP.

**Users**

* **Email (`userName`):** primary identifier; must be a valid email. SCIM updates are accepted when the email domains are claimed by your workspace.
* **Full Name:** resolved in order from `name.givenName` + `name.familyName`, then `name.formatted`, then `displayName`.
* **Username/Nickname:** updated from `displayName`. Linear ensures uniqueness by appending a number when needed.
* **Active:** `active: false` suspends the user; `active: true` unsuspends.
* **Avatar:** updated from `avatarUrl` or `photos[].value`

**Teams**

* **Name (`displayName`):** updates the team name; uniqueness enforced with a suffix if needed (e.g., “Engineering (2)”).
* **Members (`members`):** add/replace/remove members to SCIM-managed teams via user references (`value` = user ID).

## Disabling SCIM[⁠](https://linear.app/docs/scim.html#disabling-scim)

Once SCIM is disabled on Linear side:

* SCIM requests coming from your Identity provider will be rejected on Linear side.
* Any team that was linked to a Group will be unlinked.
* All SCIM restrictions will stop being enforced.

This does mean that if SCIM is re-enabled on Linear side, any changes or member removals that happened on your Identity provider will have to be pushed again to Linear. Refer to your Identity provider documentation for more information on accomplishing this.

If you need to remove some Linear accounts that are not part of your IDP, we recommend enabling the temporary override from your Linear SCIM settings, rather than disabling SCIM.

You’ll find the option for this at the bottom of your SCIM settings page and it will allow the Admin or Owner who toggles the setting to manually suspend users temporarily.

![SCIM Manual overrides button with "Enable override" option](https://webassets.linear.app/images/ornj730p/production/e48d8a73d4a1ede5965682104bc1f5581966a1b4-2058x562.png?w=1440&q=95&auto=format&dpr=2)

## FAQ[⁠](https://linear.app/docs/scim.html#faq)

Can I update my existing users and their teams using SCIM?

Yes. Existing users can be updated through SCIM. Existing teams can also be linked to SCIM group push by setting the team’s **SCIM group mapping** to exactly match the identity provider group name before pushing the group. If no existing team is mapped, pushing a new group will create a new team in Linear.

Can you set default public teams for users created through SCIM?

Yes. SCIM-provisioned users can be automatically added to public teams that are set as default teams in *Settings > Security > SAML & SCIM*. This is separate from assigning users to teams through SCIM group push.

What identity providers do you support?

SCIM should work with most identity providers though we have only tested with Okta and OneLogin.

What version of SCIM do you use?

We support SCIM 2.0 (not SCIM 1.1.)

When do SCIM created users become billable seats?

As of August 14th 2025, SCIM-created users are billable only after they’ve logged on for the first time, not at time of creation.

What plan is SCIM available on?

SCIM provisioning is available on the Enterprise plan.

[Previous

SAML](https://linear.app/docs/saml-and-access-control.html)[Next

API and Webhooks](https://linear.app/docs/api-and-webhooks.html)

* [Overview](https://linear.app/docs/scim.html#overview)
* [Configure](https://linear.app/docs/scim.html#configure)
* [Enable and test](https://linear.app/docs/scim.html#enable-and-test)
* [IdP-specific configuration notes](https://linear.app/docs/scim.html#idp-specific-configuration-notes)
* [Group push](https://linear.app/docs/scim.html#group-push)
* [Link by importing teams](https://linear.app/docs/scim.html#link-by-importing-teams)
* [Link by name matching](https://linear.app/docs/scim.html#link-by-name-matching)
* [Provisioning Roles](https://linear.app/docs/scim.html#provisioning-roles)
* [SCIM Sync](https://linear.app/docs/scim.html#scim-sync)
* [Disabling SCIM](https://linear.app/docs/scim.html#disabling-scim)
* [FAQ](https://linear.app/docs/scim.html#faq)
