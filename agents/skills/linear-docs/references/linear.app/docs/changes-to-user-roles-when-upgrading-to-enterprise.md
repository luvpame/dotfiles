---
title: "Changes to user roles when upgrading to Enterprise – Linear Docs"
source_url: "https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise"
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
* Importers

# Changes to user roles when upgrading to Enterprise

If your existing workspace upgrades from any other plan to the Enterprise plan:

* All current admins are automatically upgraded to workspace owners
* On Enterprise, the existing workspace admin role has more limited permissions than workspace owner.
* Regular members and guest users remain unchanged

Workspace owners can now assign users to the new [admin role](https://linear.app/docs/members-roles.html) as needed.

## **Migrating from admins to owners with SCIM**[⁠](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#migrating-from-admins-to-owners-with-scim)

If your workspace has [SCIM](https://linear.app/docs/scim.html) enabled and is currently managing permissions via `linear-admins`:

* The group will now control workspace owners, not admins
* All users in `linear-admins` will become owners
* The group name itself will not change automatically

If you want to start managing admins as well, you can do one of the following:

If you previously renamed your admins management group after first pushing `linear-admins`, keep using your current renamed group. In the steps below, we refer to `linear-admins` and `linear-owners` as the default group identifiers to make the migration easier to follow, but your existing renamed group will continue to work as the admins group it was originally linked to.

### **Option 1: Rename the admins group**[⁠](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#option-1:-rename-the-admins-group)

Only use this option if your Identity Provider supports syncing group name changes, e.g., via Okta’s *“Rename app groups to match group name in Okta”* setting.

If your IdP does *not* support this—or you’d prefer not to enable this setting—skip ahead to the second option.

1. Rename the `linear-admins` group to `linear-owners` in your IdP
2. Create a new `linear-admins` group and push it to Linear
3. Move users who should be admins from `linear-owners` into the new `linear-admins` group

### **Option 2: Re-link the admins group**[⁠](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#option-2:-re-link-the-admins-group)

Use this option if your IdP does *not* support syncing group name updates

1. Create a new group called `linear-owners`
2. In the Linear [security settings](https://linear.app/settings/authentication.html), unlink the existing `linear-admins` group
3. Move intended owners from the old `linear-admins` group into the new `linear-owners` group
4. Push both `linear-admins` and `linear-owners` groups to Linear

What permission will a user get if they are in both admin and owner groups in SCIM?

If a user is in both the owner and admin groups, they will be assigned the owner role.

* [Migrating from admins to owners with SCIM](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#migrating-from-admins-to-owners-with-scim)
* [Option 1: Rename the admins group](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#option-1:-rename-the-admins-group)
* [Option 2: Re-link the admins group](https://linear.app/docs/changes-to-user-roles-when-upgrading-to-enterprise.html#option-2:-re-link-the-admins-group)
