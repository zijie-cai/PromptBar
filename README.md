# PromptBar

PromptBar is a native macOS menu bar app for saving, searching, and instantly copying AI prompts.

It gives you a fast command-palette workflow for the prompts you use most, without keeping a notes file, document, or browser tab open all day.

## Features

- native macOS menu bar app
- quick access palette with `⌘⇧P`
- instant prompt search
- one-click prompt copy
- favorites support
- built-in prompt editor
- lightweight, keyboard-first workflow

## How It Works

PromptBar lives in your macOS menu bar.

From there you can:

- open the quick access palette
- search your saved prompts by title, description, or category
- copy a prompt immediately
- manage your prompt library in the editor view

## Download

PromptBar is distributed as a downloadable macOS ZIP release.

Download the latest version from the repository's Releases page.

## Install

1. Download `PromptBar.zip`
2. Unzip the archive
3. Drag `PromptBar.app` into `Applications`
4. Open `PromptBar`

PromptBar runs as a menu bar app, so after launch it appears in the macOS menu bar.

## Permissions

If you want to use the global `⌘⇧P` shortcut, macOS will ask for Accessibility access.

To enable it:

1. Open `System Settings`
2. Go to `Privacy & Security`
3. Open `Accessibility`
4. Enable `PromptBar`

You can still open PromptBar from the menu bar icon even without that permission.

## Built For macOS

PromptBar is built as a native macOS app using SwiftUI and AppKit.

The repository also includes an earlier web prototype, but the native app in [`macOS-App`](/Users/zai28/dev/PromptBar/macOS-App) is the main product.

## For Developers

Run the native app locally:

```bash
cd macOS-App
swift run
```

Build a standalone app bundle:

```bash
cd macOS-App
./scripts/build_app.sh
```

Build a release ZIP:

```bash
cd macOS-App
./scripts/build_zip.sh
```

Additional development and release details:

- [`macOS-App/README.md`](/Users/zai28/dev/PromptBar/macOS-App/README.md)
- [`macOS-App/RELEASE.md`](/Users/zai28/dev/PromptBar/macOS-App/RELEASE.md)
