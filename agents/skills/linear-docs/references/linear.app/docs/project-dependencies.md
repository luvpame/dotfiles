---
title: "Project dependencies – Linear Docs"
source_url: "https://linear.app/docs/project-dependencies"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started
* Intake
* Projects and initiatives

  + [![Projects](https://webassets.linear.app/images/ornj730p/production/8abe33188378ed585e006bacf32274dc4351763a-16x16.svg?q=95&auto=format&dpr=2)Projects](projects.html)
  + [![Project milestones](https://webassets.linear.app/images/ornj730p/production/b4ed29b2721bb179949f9f22d0a90b775eda1d73-16x16.svg?q=95&auto=format&dpr=2)Project milestones](project-milestones.html)
  + [![Project priority](https://webassets.linear.app/images/ornj730p/production/7041c586d1c75c94fee7204624db842bed4b1f12-16x16.png?q=95&auto=format&dpr=2)Project priority](project-priority.html)
  + [![Project status](https://webassets.linear.app/images/ornj730p/production/c30668a94deaa3be4feb8500ea42ff00711e442f-16x16.svg?q=95&auto=format&dpr=2)Project status](project-status.html)
  + [![Project labels](https://webassets.linear.app/images/ornj730p/production/71b5665d0601a111c6bc80f4cfc50bc3d026da09-16x16.svg?q=95&auto=format&dpr=2)Project labels](project-labels.html)
  + [![Project dependencies](https://webassets.linear.app/images/ornj730p/production/da444f790a8ba4c00a3a08ee81336fa0746a4c8b-16x16.svg?q=95&auto=format&dpr=2)Project dependencies](project-dependencies.html)
  + [![Project notifications](https://webassets.linear.app/images/ornj730p/production/f46ea66a6999ffc68bead92dd87ae8555130a35e-16x16.svg?q=95&auto=format&dpr=2)Project notifications](project-notifications.html)
  + [![Project templates](https://webassets.linear.app/images/ornj730p/production/aee950dabcf625d0ff74c8332028f5ce64dc04b1-16x16.svg?q=95&auto=format&dpr=2)Project templates](project-templates.html)
  + [![Initiatives](https://webassets.linear.app/images/ornj730p/production/8eab02b0c05576b540b0dcf1099b97bda94da77e-16x16.svg?q=95&auto=format&dpr=2)Initiatives](initiatives.html)
  + [![Sub-initiatives](https://webassets.linear.app/images/ornj730p/production/8eab02b0c05576b540b0dcf1099b97bda94da77e-16x16.svg?q=95&auto=format&dpr=2)Sub-initiatives](sub-initiatives.html)
  + [![Initiative and project updates](https://webassets.linear.app/images/ornj730p/production/a7ef91c6cba83515b6cd5119a458abd6a7b42548-16x16.svg?q=95&auto=format&dpr=2)Initiative and project updates](project-updates.html)
* Issues and cycles
* Coding and review
* Agents and automation
* Insights and outcomes
* Working in Linear
* Integrations
* Administration
* Importers

# Project dependencies

Visualize blocked and blocking relationships amongst projects.

![stylized image of lines connecting projects with dependencies](https://webassets.linear.app/images/ornj730p/production/1e5e2fc2de4cd906689e5bf0751223bc70010e99-3312x1734.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/project-dependencies.html#overview)

Project dependencies provide a visual depiction of blocking relationships on timeline views. Currently we only support a end -> start dependency.

## Create a project dependency[⁠](https://linear.app/docs/project-dependencies.html#create-a-project-dependency)

You can establish a project dependency from the project’s contextual menu by clicking the three dots next to the project name, or using command bar `Cmd/Ctrl` `K`. Select or hover over *Dependencies,* select or hover over **Blocked by...** or **Blocking...**, then select the related project.

You can also create dependencies from the timeline view. Hover at the end of a project bar to see a circle. Click and drag from that circle to another projects to create a new dependency.

## Working with dependencies on the timeline[⁠](https://linear.app/docs/project-dependencies.html#working-with-dependencies-on-the-timeline)

* Click on any dependency line to jump to a project, or remove that dependency.
* When dragging a project with dependencies, there are several ergonomics to help you plan quickly:
  + Any projects in the dependency chain that are backlog or planned will be “bumped” with the dragged project. Hold `Cmd/Ctrl` to keep the chain in place.
  + Hold `Shift` to move all projects in the dependency together, regardless of status.

## View project dependencies[⁠](https://linear.app/docs/project-dependencies.html#view-project-dependencies)

When a dependency relationship has been established, the Project Overview and the Project Properties right side panel will display “Blocked by” and “Blocking” fields.

Project dependencies can be seen on the project timeline view. You will see lines connecting the blocked and blocking projects.

### Dependency line color[⁠](https://linear.app/docs/project-dependencies.html#dependency-line-color)

* The blue line depicts a dependency that has not been violated.
* The red line is a dependency that has been violated.

![blocked and blocking projects visualized in a timeline with lines connecting them](https://webassets.linear.app/images/ornj730p/production/09ba034e341bdc7d30000031f69b7d4760f58f01-1752x482.png?w=1440&q=95&auto=format&dpr=2)

### Dates used for dependency start/end[⁠](https://linear.app/docs/project-dependencies.html#dates-used-for-dependency-startend)

* The dependency line will start at either the **target end date** or **predicted end date** (if no target end date is available) of the blocking project.
* The ferry line will link with either the **target start date** or the **target end date** of the blocked project.

## Filtering for project dependencies[⁠](https://linear.app/docs/project-dependencies.html#filtering-for-project-dependencies)

There are several filter options related to project dependencies:

* `Project has dependencies`
* `Project has blocking dependency`
* `Project has blocked by dependency`
* `Project has violated dependencies`

[Previous

Project labels](https://linear.app/docs/project-labels.html)[Next

Project notifications](https://linear.app/docs/project-notifications.html)

* [Overview](https://linear.app/docs/project-dependencies.html#overview)
* [Create a project dependency](https://linear.app/docs/project-dependencies.html#create-a-project-dependency)
* [Working with dependencies on the timeline](https://linear.app/docs/project-dependencies.html#working-with-dependencies-on-the-timeline)
* [View project dependencies](https://linear.app/docs/project-dependencies.html#view-project-dependencies)
* [Dependency line color](https://linear.app/docs/project-dependencies.html#dependency-line-color)
* [Dates used for dependency start/end](https://linear.app/docs/project-dependencies.html#dates-used-for-dependency-startend)
* [Filtering for project dependencies](https://linear.app/docs/project-dependencies.html#filtering-for-project-dependencies)
