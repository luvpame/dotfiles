---
title: "Fencer Integration – Linear"
source_url: "https://linear.app/integrations/fencer"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



1. [Integrations](https://linear.app/integrations.html)
2. Fencer

# Create and link issues directly from Fencer

![Turn security findings into issues in Linear](https://webassets.linear.app/images/ornj730p/production/4a8e84380b066805ff3d0552983a4e1f00f8ccd9-1500x960.png?q=95&auto=format&dpr=2)

Turn security findings into issues directly from Fencer

![Turn security findings into issues in Linear](https://webassets.linear.app/images/ornj730p/production/4a8e84380b066805ff3d0552983a4e1f00f8ccd9-1500x960.png?q=95&auto=format&dpr=2)

Turn security findings into issues directly from Fencer

![linking to an existing linear issue from fencer](https://webassets.linear.app/images/ornj730p/production/1ec7be6d5fb55b84e961f592c7fb8c8a4a616616-1500x960.png?q=95&auto=format&dpr=2)

Link security findings to existing issues

## Overview[⁠](https://linear.app/integrations/fencer.html#overview)

Fencer’s Linear integration enables security teams to create and track Linear issues directly from security findings, including vulnerabilities, detections, and exposed secrets. When issues are resolved or canceled in Linear, linked findings are automatically updated in Fencer, keeping security workflows in sync without manual status tracking.

## How it works[⁠](https://linear.app/integrations/fencer.html#how-it-works)

Fencer integrates with Linear to streamline security remediation workflows. Security engineers can create Linear issues directly from vulnerabilities discovered in code scans, cloud infrastructure assessments, and SIEM detections. When creating an issue, Fencer automatically populates the description with relevant context including severity, affected assets, remediation guidance, and links to industry standards like CWE, OWASP, and CVE references. Teams can also link existing Linear issues to findings or perform bulk operations to create multiple issues at once.

The integration maintains bidirectional synchronization through webhooks. When a linked Linear issue transitions to a “Done” state, Fencer automatically marks the associated vulnerability as ready for verification or the detection as a resolved true positive. Similarly, when an issue is canceled, the finding is marked as ignored or a false positive. This ensures security status stays current without requiring manual updates in both systems.

Issue creation supports full customization including team assignment, labels, projects, workflow states, and priority levels. Fencer automatically maps security severity (Critical, High, Medium, Low) to Linear’s priority system. Each created issue includes an attachment linking back to the original finding in Fencer, making it easy for developers to access full vulnerability details and remediation steps.

## Configure[⁠](https://linear.app/integrations/fencer.html#configure)

To connect Fencer to Linear, navigate to your Fencer’s integration settings and select Linear. You must be an organization admin in Fencer and have permission to install OAuth applications in your Linear workspace.

Click “Connect to Linear” to begin the OAuth authorization flow. You will be redirected to Linear where you can review the requested permissions (read and write access to create issues, manage labels, and assign team members) and select which workspace to connect. After authorizing, you will be returned to Fencer where the connection is automatically configured.

Once connected, you can create Linear issues from any vulnerability, detection, or secret detail page, or use bulk actions to create issues for multiple findings at once. To disconnect, return to the integration settings page and click “Disconnect.”

Website
[fencer.dev](https://fencer.dev)

Category
[Security & Compliance](https://linear.app/integrations/security-and-compliance.html)

Contact

[Email Fencer](mailto:support@fencer.dev)

[Open website](https://fencer.dev/integrations)

#### You might be interested in

[Browse all integrations](https://linear.app/integrations.html)

* [![SecureSlate icon](https://webassets.linear.app/images/ornj730p/production/e7d37e91802f84c4004482806ef309a70c44d89c-320x320.png?w=256&q=95&auto=format&dpr=2)

  SecureSlate

  By SecureSlate

  Create and link SecureSlate security tickets to Linear](secureslate.html)
* [![Vanta  icon](https://webassets.linear.app/images/ornj730p/production/cc51049ac9db240c517f9220841930eeae20abdd-320x320.svg?w=256&q=95&auto=format&dpr=2)

  Vanta

  By Vanta

  Automate compliance. Simplify security. Demonstrate trust.](vanta.html)
* [![Marker.io icon](https://webassets.linear.app/images/ornj730p/production/77a26790fb115b9655809053aa62685799573c4f-640x640.png?w=256&q=95&auto=format&dpr=2)

  Marker.io

  By Marker.io

  Collect website feedback and bug reports directly into your Linear projects](marker-io.html)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.

[Start building](https://linear.app/docs/integration-directory.html#build-your-own)

## Build your own integration

Create your own integration with Linear’s API and submit it to the directory.
