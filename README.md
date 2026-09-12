<p align="center"><img src="assets/hero.svg" alt="Dimlet — Screens rest. Your Mac keeps going." width="100%"></p>

<p align="center">
  <a href="https://github.com/onodela2000/dimlet/releases/latest"><b>Download for macOS</b></a>
  &nbsp; · &nbsp; <a href="https://onodela2000.github.io/dimlet/">Website</a>
  &nbsp; · &nbsp; <a href="README.ja.md">日本語</a>
  &nbsp; · &nbsp; <a href="#build-it-yourself">Build from source</a>
</p>

**Dimlet is a tiny macOS menu bar app that blacks out external monitors or every screen, including the built-in display while your Mac keeps working.**

Running an AI agent, rendering a video, or waiting on a long build? Give your room a little less glow. Choose whether to keep your laptop display usable or darken everything. Your work keeps going and your monitors stay powered.

- **Two clear modes.** Darken external monitors only, or all monitors including the built-in display. New screens follow the active mode.
- **Your Mac stays awake.** Idle sleep is prevented while Dimlet is open, even with blackout off.
- **Charging can continue.** Displays stay connected and powered; Dimlet doesn't send a monitor power-off command.
- **A sleepy little friend in your menu bar.** Open eyes mean OFF. Sleepy eyes mean ON.
- **Native and small.** Swift + AppKit. No runtime dependencies, account, analytics, or automatic network requests.

> Dimlet covers screens with black windows. It does **not** turn off the panel or guarantee power savings. Keep your monitors' physical power switches on. USB-C charging still depends on the monitor, cable, and power supply.

## Install

Requires **macOS 13 or later**. The universal release includes **Apple Silicon and Intel** binaries.

1. Download `Dimlet-0.3.0-macos-universal.zip` from [Releases](https://github.com/onodela2000/dimlet/releases/latest).
2. Unzip it and drag **Dimlet.app** into **Applications**.
3. Open Dimlet. Look for the little monitor in your **menu bar**. Blackout starts **OFF**.

**First launch:** this early release is ad-hoc signed, but **not Apple-notarized or Developer ID signed**. macOS may block an app downloaded from the internet. If you trust the source, attempt to open it, then use **System Settings → Privacy & Security → Open Anyway**. Follow [Apple's instructions](https://support.apple.com/en-us/102445); don't disable Gatekeeper globally. Building from source is another option.

Dimlet doesn't need Accessibility, Screen Recording, or administrator access to run. To launch it at login, add it in **System Settings → General → Login Items**. This is optional; Dimlet doesn't add itself.

## Use

Click the monitor icon and choose a mode:

- **Darken external monitors only** — keep the built-in display usable.
- **Darken all monitors (built-in + external)** — cover every screen, including the MacBook display.

The active mode has a checkmark. Select it again to turn blackout off; select the other mode to switch directly. **Click any black screen to restore all screens**, including the built-in display. The app stays in the menu bar. Your last mode is remembered, but normal launches always start with blackout **OFF**.

| State | External displays | Built-in display | Mac idle sleep |
| --- | --- | --- | --- |
| OFF | Normal | Normal | Prevented |
| External monitors only | Black (independent displays) | Normal | Prevented |
| All monitors | Black | Black | Prevented |
| Quit | Normal | Normal | Dimlet's prevention is removed |

**Change language:** open **Language** in the menu and choose **English**, **日本語**, **简体中文**, **Français**, or **Deutsch**. English is the default, regardless of the macOS language. Your choice applies immediately and is remembered after restarting Dimlet. The language submenu always includes “Language” so you can find your way back. While blackout is on, display idle sleep is prevented too, so the monitor connection can remain active. When you're done with background work, **Quit Dimlet** to release its sleep-prevention assertions.

## A few honest limits

- **External monitors only** skips mirrored displays to protect the built-in screen. **All monitors** covers all available screen surfaces, including mirrored content.
- On a desktop Mac, all independent screens are external. Click a black screen to get them back.
- Keep a MacBook's lid open. Dimlet doesn't override lid-close sleep, manual Sleep, shutdown, or a depleted battery.
- It doesn't make a particular AI app or job run forever. App failures and network interruptions can still happen.
- Blackout is a visual cover, **not a privacy lock**. On an LCD, some backlight glow may remain.
- Other apps may keep the Mac awake after Dimlet quits. Dimlet only removes its own assertions.

## Why it exists

Turning off a USB-C monitor can also stop charging the laptop attached to it. That is inconvenient when you want a dark room and a Mac that keeps working. Dimlet leaves the display link alone and puts a black cover over the external screens instead.

The original setup was a MacBook Air M4 with two INNOCN GA32V1M monitors. That setup kept charging during blackout. This is an observation, **not a compatibility guarantee for every monitor**. No DDC/CI, DSC, firmware, or display-mode changes are required by Dimlet.

## Build it yourself

You need Xcode Command Line Tools with **Swift 5.9 or later** (or full Xcode).

```bash
git clone https://github.com/onodela2000/dimlet.git
cd dimlet
swift test
./scripts/build.sh
open dist/Dimlet.app
```

For a universal release:

```bash
./scripts/build.sh --universal
```

The script builds the app, renders the SVG icon into an `.icns`, applies an ad-hoc signature, and writes a ZIP with a SHA-256 checksum to `dist/`. Nothing is installed automatically. No third-party packages are downloaded.

Optional integration check in an interactive desktop session:

```bash
dist/Dimlet.app/Contents/MacOS/Dimlet --smoke-test
```

This briefly covers both external and built-in screens, checks both modes, click-to-restore, repeated-mode OFF, SVG resources, sleep assertions, and live switching across all five languages, then restores the screens and quits. Unit tests cover display selection, mirroring, hot-plug input changes, complete translations, and saved language and mode preferences. Runtime testing has been performed on Apple Silicon with macOS 26.3.1; Intel and older macOS releases need broader hands-on testing.

## Website

The [landing page](https://onodela2000.github.io/dimlet/) lives in `site/`: plain HTML, CSS, JavaScript, and local assets. No build step or third-party dependencies. Preview it with:

```bash
python3 -m http.server 8765 --directory site
```

Open `http://localhost:8765`. Changes to `site/` on `main` deploy automatically through `.github/workflows/pages.yml`. The page supports the same five languages as the app; its switch is a visual demo only.

## Contribute

Small, thoughtful improvements are welcome. Run `swift test` and `./scripts/build.sh` before opening a pull request. For display issues, include your macOS version, Mac model, connection type, and whether mirroring is enabled. Please omit serial numbers and other personal data.

The source code and original SVG artwork are [MIT licensed](LICENSE).
