---
title: "Open issues with custom scripts – Linear Docs"
source_url: "https://linear.app/docs/open-issues-with-custom-scripts"
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

# Open issues with custom scripts

## Overview[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#overview)

While many coding tools are supported in your [Code & reviews settings](https://linear.app/settings/account/code-and-reviews.html), you can also choose to open issues using local scripts. This is particularly useful if you want to connect Linear to tools not supported in preferences.

Custom script lets you define precisely how an issue should be opened. You might choose to open issues through a CLI tool, internal script, or custom development workflow. Linear passes issue context into your command at runtime.

## How it works[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#how-it-works)

1. Enable **Custom script** in [Settings > Code & reviews > Configure coding tools](https://linear.app/settings/account/code-and-reviews/coding-tools.html).
2. Define a command in `~/.linear/coding-tools.json`.
3. Select **Work on issue → Custom script** in Linear.

![Enable running a custom script configured in your code-tools.json file.](https://webassets.linear.app/images/ornj730p/production/a30f45fe64c7d4285680639d031478a36f78ced9-1234x408.png?w=1440&q=95&auto=format&dpr=2)

Linear will run your command locally and inject any variables you’ve configured.

The first time you use this feature, Linear will generate a starter config file. You can edit it to point to your executable and arguments.

### Configuration[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#configuration)

Each script is defined in `coding-tools.json` with the following fields:

* **path**: Absolute path to the executable
* **args** (optional): Command-line arguments; supports `{{variable}}` templating
* **env** (optional): List of `LINEAR_*` environment variables to expose

### Template variables[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#template-variables)

You can use variables in `args`:

* `prompt`
* `issue.identifier`
* `issue.branchName`
* `project.name`
* `pullRequestComment.id`
* `workDir`
* `tool.command`

### Environment variables[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#environment-variables)

Expose these via the `env` array:

* `LINEAR_PROMPT`: Full prompt text
* `LINEAR_ISSUE_IDENTIFIER`: Issue ID
* `LINEAR_ISSUE_BRANCH_NAME`: Suggested branch name
* `LINEAR_WORK_DIR`: Working directory selected by the user
* `LINEAR_PROJECT_NAME`: Project name (only present when the issue belongs to a project)
* `LINEAR_PULL_REQUEST_COMMENT_ID`: PR comment ID (only present when triggered from a pull request comment)
* `LINEAR_TOOL_COMMAND`: Command of the selected coding tool

### Example[⁠](https://linear.app/docs/open-issues-with-custom-scripts.html#example)

```
{
  "openIssue": {
    "path": "/absolute/path/to/executable",
    "args": [
      "--issue",
      "{{issue.identifier}}",
      "--branch",
      "{{issue.branchName}}",
      "{{prompt}}"
    ],
    "env": [
      "LINEAR_PROMPT",
      "LINEAR_WORK_DIR",
      "LINEAR_PROJECT_NAME"
    ]
  }
}
```

* [Overview](https://linear.app/docs/open-issues-with-custom-scripts.html#overview)
* [How it works](https://linear.app/docs/open-issues-with-custom-scripts.html#how-it-works)
* [Configuration](https://linear.app/docs/open-issues-with-custom-scripts.html#configuration)
* [Template variables](https://linear.app/docs/open-issues-with-custom-scripts.html#template-variables)
* [Environment variables](https://linear.app/docs/open-issues-with-custom-scripts.html#environment-variables)
* [Example](https://linear.app/docs/open-issues-with-custom-scripts.html#example)
