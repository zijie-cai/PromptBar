# PromptBar

PromptBar is a native macOS menu bar utility for quickly searching, copying, and managing saved AI prompts.

The app is designed around a lightweight command palette workflow:

- open PromptBar from the menu bar or global shortcut
- search saved prompts instantly
- copy a prompt without leaving your current context
- manage prompt titles, descriptions, favorites, and content in a simple editor

## Repo Layout

- [`macOS-App`](/Users/zai28/dev/PromptBar/macOS-App)
  Native SwiftUI/AppKit macOS app and release packaging scripts.
- [`src`](/Users/zai28/dev/PromptBar/src)
  Earlier web prototype built with Vite and React.

If you are working on the actual product, start with `macOS-App`.

## Native macOS App

Requirements:

- macOS 14+
- Xcode 15+ or Swift 5.10+

Run the native app in development:

```bash
cd macOS-App
swift run
```

This launches PromptBar as a menu bar app.  
If you want the global `⌘⇧P` shortcut to work, macOS will require Accessibility permission.

More native app details are in [`macOS-App/README.md`](/Users/zai28/dev/PromptBar/macOS-App/README.md).

## Build A Standalone App

Build a `.app` bundle that runs without Terminal:

```bash
cd macOS-App
./scripts/build_app.sh
```

Output:

```bash
macOS-App/dist/PromptBar.app
```

## Build A DMG

Create a distributable DMG:

```bash
cd macOS-App
./scripts/build_dmg.sh
```

Output:

```bash
macOS-App/dist/PromptBar.dmg
```

Release setup, signing, notarization, and GitHub Actions publishing are documented in [`macOS-App/RELEASE.md`](/Users/zai28/dev/PromptBar/macOS-App/RELEASE.md).

## GitHub Release Flow

The repo includes a release workflow at [`.github/workflows/release-dmg.yml`](/Users/zai28/dev/PromptBar/.github/workflows/release-dmg.yml).

Once the required GitHub secrets are configured, you can:

- run the workflow manually from GitHub Actions
- or push a tag like `v1.0.0`

That workflow can:

- build the app
- sign it
- notarize it
- package a DMG
- attach the DMG to a GitHub Release

## Web Prototype

The original web prototype is still available if you need to reference earlier UI work:

```bash
npm install
npm run dev
```

This is not the preferred distribution target. The native app in `macOS-App` is the main product path.
