---
title: "Coding Sessions – Linear"
source_url: "https://linear.app/coding-sessions"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



Coding Sessions

# Assign your issues to Linear

Linear Agent can now write code using Claude Code and Codex. Triage, plan, build, and review all in one place.

Watch video

ENG-2498Dimmed Status Cards+34-18

ActivityGuideDiff

Submit reviewPreview

useRideHistory.tsclient/src/views/RideHistory

+21-14

76

77 // Build sections from ride history state

- const dimmedIds: Set<string> = useComputed(() => {

- const ids = new Set<string>();

- for (const id of cancelledRideIds) {

- ids.add(id);

- }

78 const waitingStatusById: Map<string, string> = useComputed(() => {

79 const map = new Map<string, string>();

80 for (const ride of ridesAwaitingPickup) {

- ids.add(ride.id);

81 map.set(ride.id, "Driver en route");

82 }

83 for (const ride of ridesInProgress) {

84 map.set(ride.id, "Trip in progress");

85 }

86

RideHistoryPage.tsxclient/src/views/RideHistory

+2-1

36 background-color: ${props.theme.color.bgBase};

37 box-shadow: none;

38

39 ${props.highlighted && css`

40 &:hover {

41 background-color: ${props.theme.color.bgBaseHover};

42 opacity: 1;

43 }

44 `}

45`;

46

47const RowContent = styled.div`

48 display: flex;

49

![Linear Agent](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/4552f8d7-6f37-4319-68b4-12654bef4e00/f=auto,fit=scale-down,metadata=none,width=64)LinearOpus 5.5

![Avatar of Conor](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/f6242d9a-5171-4978-5519-b9eab8123b00/f=auto,fit=scale-down,metadata=none,width=72)

Conorstarted this session

Worked for 32s

Pushed and opened a draft PR. Changes:

useRideHistory.ts: build awaitingStatusByIdmap and

use it as thegetLastActionbyline

RideHistoryPage.tsx: dimmed rows reset to full opacity

Tell Linear what to do next...

Start from anywhere. Kick off a coding session from an issue, a chat, a comment, or a Slack thread. Linear gathers the relevant context and gets to work.

![01. Chat](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/52780e15-c5b1-471e-2c22-be5111a67b00/f=auto,fit=scale-down,metadata=none,width=1600)![01. Chat](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/e296b5b1-3ba1-46d8-b54d-bca7e9bbd600/f=auto,fit=scale-down,metadata=none)![02. Issues](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/d0328081-ab02-429d-a6dc-230c689b1e00/f=auto,fit=scale-down,metadata=none,width=1600)![02. Issues](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/f2a47910-8fdb-4f2c-3f9d-adb4a4d64500/f=auto,fit=scale-down,metadata=none)![03. Diffs](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/82fddd35-cf7f-4ce2-91e3-717022a29300/f=auto,fit=scale-down,metadata=none,width=1600)![03. Diffs](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/cec3506a-d530-4aea-cd17-ad83e8e81b00/f=auto,fit=scale-down,metadata=none)![04. Mobile](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/d0f705b3-896d-4213-1457-163735bfd800/f=auto,fit=scale-down,metadata=none,width=1600)![04. Mobile](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/797a8b49-db89-46fa-1749-3030f6394900/f=auto,fit=scale-down,metadata=none)![05. Slack](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/2bb2a18a-6de6-4dc0-af27-7b6841887100/f=auto,fit=scale-down,metadata=none,width=1600)![05. Slack](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/d3d10235-74aa-4249-dec5-72849bee5f00/f=auto,fit=scale-down,metadata=none)![06. Teams](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/8d451b14-170d-4e82-f7b6-5df4bf59d700/f=auto,fit=scale-down,metadata=none,width=1600)![06. Teams](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/e49b6930-61ee-4739-5ac3-b0e4ddf13300/f=auto,fit=scale-down,metadata=none)

Linear Agent works where you work

01. Chat02. Issues03. Diffs

04. Mobile05. Slack06. Teams

Delegate or automate. Assign issues directly, or let Linear pick them up the moment they land in Triage. Bugs can be investigated and fixed before anyone touches a keyboard.

ENG-2498DIMMED STATUS

ENG-2486TRIP COUNT

Jori

DIMMED STATUS CARDS

FIX TRIP COUNT

Automate

Delegate

ENG-2498DIMMED STATUS

ENG-2486TRIP COUNT

Jori

DIMMED STATUS CARDS

FIX TRIP COUNT

Close your laptop. Every coding session runs in a secure cloud sandbox. No local setup or babysitting required. When the work is ready, review the diff, ask for changes, or merge the result.

![](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/999402d6-1ba8-4124-27a1-ee86135acd00/f=auto,fit=scale-down,metadata=none)

![](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/9bfa3c37-27a3-4cf8-7021-adb9c162da00/f=auto,fit=scale-down,metadata=none)

![](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/7a9ea90b-be41-450a-cdc7-bac6b363f800/f=auto,fit=scale-down,metadata=none)

Delegate an issue from your backlog and get back a diff for review

Built for teams. Linear Agent is part of your workspace and collaborative by default. Sessions are multiplayer and run on shared context.

![Steer the session while it runs, or iterate from the diff](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/5edf7ace-7c74-4b1e-760a-2758284ecb00/f=auto,fit=scale-down,metadata=none,width=1400)

![Point Linear Agent to a project and let it work from the spec](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/0d910c74-d1c3-4e44-305d-deb806eee600/f=auto,fit=scale-down,metadata=none,width=1400)

![Turn a decision in a thread into a diff](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/77ff0be2-1101-4265-b1d2-0d4caed9ff00/f=auto,fit=scale-down,metadata=none,width=1400)

![Point Linear Agent to a project and let it work from the spec](https://linear.app/cdn-cgi/imagedelivery/fO02fVwohEs9s9UHFwon6A/a08478e1-a007-4daf-56d3-85d3d787a400/f=auto,fit=scale-down,metadata=none)

Steer the session while it runs, or iterate from the diffSteer the session while it runs, or iterate from the diff

Point Linear Agent to a project and let it work from the specPoint Linear Agent to a project and let it work from the spec

Full context

Linear natively understands your issues, projects, documents, discussions, and customer requests.

Frontier models

Sessions are powered by Claude Code and Codex, configured at the workspace level.

End-to-end

Investigate, implement, and review in one continuous workflow. No handoffs between tools.

Multiplayer

Follow progress, ask questions, and steer the work together.

## Start a coding session today

[Get started](https://linear.app/signup.html)[Contact sales](https://linear.app/contact/sales.html)[Open app](https://linear.app/login.html)[Download](https://linear.app/download.html)
