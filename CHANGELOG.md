# Changelog

## 0.2.0 — 2026-09-12

- Add a Language submenu with English, Japanese, Simplified Chinese, French, and German.
- Default to English on first launch and save the selected language across restarts.
- Translate menus, status descriptions, accessibility labels, and the About dialog immediately without interrupting blackout or sleep prevention.
- Keep native language names and an English “Language” label for easy navigation.
- Test translation completeness, preference persistence, and live switching in the desktop smoke test.

## 0.1.0 — 2026-09-12

- Toggle black overlays on every independent external display from the menu bar.
- Leave the built-in display usable; skip mirrored displays.
- Follow display connections and disconnections while blackout is enabled.
- Keep the Mac awake while the app is open, and preserve display wakefulness while blackout is on.
- Restore all screens with a click on a black overlay.
- Original SVG mascot and stateful menu bar icons; English and Japanese menus.
- Universal macOS app, source build script, unit tests, and a desktop smoke test.

First public preview. The release is ad-hoc signed, not Apple-notarized. Blackout does not power down a monitor or guarantee power savings.
