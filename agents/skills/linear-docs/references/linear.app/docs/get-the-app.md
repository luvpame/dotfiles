---
title: "Download Linear – Linear Docs"
source_url: "https://linear.app/docs/get-the-app"
fetched_at: "2026-10-27T08:17:41.028425+00:00"
---



* Getting started

  + [![Start Guide](https://webassets.linear.app/images/ornj730p/production/cdcefdd220c8e2e8eb7c912375014aa15d614ae3-16x16.svg?q=95&auto=format&dpr=2)Start Guide](tutorials.html)
  + [![Concepts](https://webassets.linear.app/images/ornj730p/production/ee14be7f55be005cf38b6f9c9d8e9fa20a78c561-16x16.svg?q=95&auto=format&dpr=2)Concepts](conceptual-model.html)
  + [![Download Linear](https://webassets.linear.app/images/ornj730p/production/aebd535cb7e6a2ded134f41574d0495431a2299f-16x16.svg?q=95&auto=format&dpr=2)Download Linear](get-the-app.html)
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

# Download Linear

Linear is available on browsers, macOS, Windows, iOS and Android.

![Image showing Linear icon](https://webassets.linear.app/images/ornj730p/production/02a966c3cd681da332c12dbd92735ff3ad01bb7f-2160x1326.png?w=1440&q=95&auto=format&dpr=2)

## Overview[⁠](https://linear.app/docs/get-the-app.html#overview)

Linear is available as a desktop application, from the browser, as native mobile apps or on a PWA on mobile and tablet.

We recommend using our desktop clients and mobile apps for the best experience.

## Desktop Clients [⁠](https://linear.app/docs/get-the-app.html#desktop-clients)

Linear is available for macOS Intel, macOS Apple Silicon, and Windows. Download the desktop app at [linear.app/download](https://linear.app/download.html).

The benefits of using the desktop app are:

* Notifications are integrated with your operating system, so you can stay up to date on Linear activity from your desktop.
* Linear is always on and the dock and taskbar quickly alerts you of unread notifications.
* Keyboard shortcuts have less risk of conflicting with browser-based presets or custom shortcuts.
* Tab support within the app.

## Browsers[⁠](https://linear.app/docs/get-the-app.html#browsers)

The Linear web app can be accessed by logging in to [linear.app](https://linear.app/index.html). Linear will launch directly in your browser window.

Nearly all functionality in the desktop app including offline mode is available on the web in most browsers. We support the most recent three versions of Chrome, Firefox, and Safari.

**Open in desktop app:** This browser preference opens Linear links in the desktop app if installed. Universal links can be configured from the browser version [Account > Preferences > Behavior > Open in desktop app](https://linear.app/settings/account/preferences.html).

![](https://webassets.linear.app/images/ornj730p/production/f6960914cab642b179c9038ace32663367211d21-16x16.svg?q=95&auto=format&dpr=2)

**Brave Shields**
Brave users should disable “Brave Shields” for the linear.app domain to allow the website to connect to and open the desktop app automatically.

## iOS and Android[⁠](https://linear.app/docs/get-the-app.html#ios-and-android)

Linear on mobile lets you unblock work wherever you are and complement use of Linear on other clients. Download these apps from the App Store or Google Play Store, or learn more [here](https://linear.app/mobile.html).

Work with issues, projects, initiatives, and documents in the Linear iOS and Android apps.

On both apps, tabs offer entrypoints to common mobile workflows:

### Home[⁠](https://linear.app/docs/get-the-app.html#home)

Review your assigned, created or subscribed issues through “My issues”, quickly access your favorites, and explore teams to view their issues, cycles, and triage queues.

### Inbox[⁠](https://linear.app/docs/get-the-app.html#inbox)

Check your Inbox and take action on notifications by sending comments or updating issues directly from the app. Your inbox syncs with Linear on other clients and supports reading, snoozing and deleting your notifications.

### Create issues[⁠](https://linear.app/docs/get-the-app.html#create-issues)

Create issues through the center tab. Add more context by attaching media from your camera roll and use rich formatting like codeblocks and quotes.

### Search[⁠](https://linear.app/docs/get-the-app.html#search)

Search across your workspace.

### Settings[⁠](https://linear.app/docs/get-the-app.html#settings)

Switch workspaces, customize your notification schedule, change between light and dark themes or send feedback.

You can also use Linear on your mobile or tablet devices through your browser with our PWA. Go to [linear.app](https://linear.app/index.html) to sign in.

## Having Trouble?[⁠](https://linear.app/docs/get-the-app.html#having-trouble)

### Real time sync and offline[⁠](https://linear.app/docs/get-the-app.html#real-time-sync-and-offline)

Linear automatically syncs all changes in realtime as they happen. This is critical to your team’s ability to collaborate well and work quickly. If for some reason changes cannot be sent to the backend, the app will store changes locally and re-try whenever connectivity is restored (e.g. internet is back up).

You’ll start seeing the words “Syncing” appear next to the workspace name at the top of your sidebar when the app detects that there are a lot of changes waiting to be synced or when sending changes take longer than expected. The number next to it shows how many changes are waiting to be sent. They’ll be reloaded and retried even if you restart the application before restoring connectivity.

**Offline mode is designed as a failsafe and not a full-fledged feature.**
We do not check the creation date of each change before updating data. This means that if you make a lot of edits while in offline mode, you could overwrite changes from someone on your team (e.g. if you edited the issue description or they had updated status).

### Network requests to localhost[⁠](https://linear.app/docs/get-the-app.html#network-requests-to-localhost)

We periodically check if the Linear desktop app is installed on your computer. We achieve this by sending network requests to your localhost (your computer) on different ports. Each port check helps us determine if our desktop app is running. This then allows us to seamlessly open certain URLs directly in the desktop app, enhancing your user experience and ensuring better integration between our web and desktop applications.

The ports we check are `44450`, `18450`, and `33234`.

### Automatic app updates[⁠](https://linear.app/docs/get-the-app.html#automatic-app-updates)

For updates, the desktop app downloads and installs updates automatically in the background. To disable automatic updates for MacOS:

#### **Terminal**[⁠](https://linear.app/docs/get-the-app.html#terminal)

`defaults write /Users/$USER/Library/Preferences/com.linear AutoUpdateDisabled -bool YES`. The Linear desktop app must be quit and relaunched for the preference to take effect.

Use the following command to re-enable automatic updates: `defaults write /Users/$USER/Library/Preferences/com.linear AutoUpdateDisabled -bool NO`

#### Plist[⁠](https://linear.app/docs/get-the-app.html#plist)

Using a `/Users/$USER/Library/Preferences/com.linear.plist` file deployed through MDM, the contents would be:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<key>AutoUpdateDisabled</key>
<true/>
</plist>
```

## FAQ[⁠](https://linear.app/docs/get-the-app.html#faq)

Do you support Linux?

We may in the future but it’s not on the roadmap for now. Linux users can use Linear on one of our supported browsers.

My app is stuck in offline mode.

Being stuck in offline mode may relate to a known Chromium bug. Please toggle your wifi off and on again from your computer’s menubar.

Can I open a Linear URL in the desktop app automatically?

Yes, using a `linear://` protocol followed by the rest of the URL will open that page in the desktop app instead of a browser. Example: `linear://linear.app/issue/ENG-123`

I'm seeing a "Couldn't open in desktop app" error, how do I resolve this?

If accessing Linear in browser and encountering a *Local Network access was denied* error unexpectedly when attempting to navigate through links, this can indicate a browser-specific configuration that blocks Local Network Access.

![Local Network access was denied error, "Couldn't open in desktop app"](https://webassets.linear.app/images/ornj730p/production/af3a2265ff0a5a9e67e93b702a0cea8caf08f785-917x297.png?w=1440&q=95&auto=format&dpr=2)

To resolve, navigate into your browser settings and search for *Local Network Access*—you should spot the configuration specific to Linear under *Site Settings*:

![linear.app Allowed local network access](https://webassets.linear.app/images/ornj730p/production/032fbed63738c8603cf6b48b90a26c4d2012be00-1456x218.png?w=1440&q=95&auto=format&dpr=2)

After clicking into this setting, ensure *Local network access* is set to *Allow*:

![Local network access settings configured to Allow](https://webassets.linear.app/images/ornj730p/production/7ba14535c3e6b31a708c878e3ec7c64d351780e6-1384x210.png?w=1440&q=95&auto=format&dpr=2)

Note that these screenshots are specific to Chrome, and other affected browsers’ navigation may look slightly different—feel free to reach out to [support@linear.app](mailto:support@linear.app) if you’re having trouble spotting this!

[Previous

Concepts](https://linear.app/docs/conceptual-model.html)[Next

Triage](https://linear.app/docs/triage.html)

* [Overview](https://linear.app/docs/get-the-app.html#overview)
* [Desktop Clients](https://linear.app/docs/get-the-app.html#desktop-clients)
* [Browsers](https://linear.app/docs/get-the-app.html#browsers)
* [iOS and Android](https://linear.app/docs/get-the-app.html#ios-and-android)
* [Home](https://linear.app/docs/get-the-app.html#home)
* [Inbox](https://linear.app/docs/get-the-app.html#inbox)
* [Create issues](https://linear.app/docs/get-the-app.html#create-issues)
* [Search](https://linear.app/docs/get-the-app.html#search)
* [Settings](https://linear.app/docs/get-the-app.html#settings)
* [Having Trouble?](https://linear.app/docs/get-the-app.html#having-trouble)
* [Real time sync and offline](https://linear.app/docs/get-the-app.html#real-time-sync-and-offline)
* [Network requests to localhost](https://linear.app/docs/get-the-app.html#network-requests-to-localhost)
* [Automatic app updates](https://linear.app/docs/get-the-app.html#automatic-app-updates)
* [Terminal](https://linear.app/docs/get-the-app.html#terminal)
* [Plist](https://linear.app/docs/get-the-app.html#plist)
* [FAQ](https://linear.app/docs/get-the-app.html#faq)
