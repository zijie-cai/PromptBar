# PromptBar

PromptBar is a native macOS menu bar app for saving, searching, and copying AI prompts instantly.

It is built for a fast command-palette workflow:

- open PromptBar from the menu bar
- press `⌘⇧P` to bring up quick access
- search prompts as you type
- copy the prompt you need in one step
- manage saved prompts in a clean built-in editor

## What It Does

PromptBar helps you keep frequently used prompts close at hand without switching between documents, notes, or browser tabs.

Use it to:

- store reusable prompts for writing, coding, research, and email
- favorite your most-used prompts
- search by title, description, or category
- copy prompts quickly from a lightweight floating palette

## Download

PromptBar is distributed as a downloadable macOS app ZIP.

Download the latest release from the repository's Releases page once available.

## Install

1. Download `PromptBar.zip`
2. Unzip the archive
3. Drag `PromptBar.app` into `Applications`
4. Open PromptBar from Applications

The app runs as a menu bar utility, so it lives in the macOS menu bar instead of the Dock.

## Permissions

If you want to use the global `⌘⇧P` shortcut, macOS will ask you to grant Accessibility access to PromptBar:

- open `System Settings`
- go to `Privacy & Security`
- open `Accessibility`
- enable `PromptBar`

Without that permission, you can still use PromptBar from the menu bar icon.

## Built For macOS

PromptBar is designed as a native macOS utility using SwiftUI and AppKit. The current product includes:

- a menu bar app shell
- a floating quick access palette
- prompt search and copy flow
- a prompt management editor

## For Developers

If you want to run or build PromptBar locally, see:

- [`macOS-App/README.md`](/Users/zai28/dev/PromptBar/macOS-App/README.md)
- [`macOS-App/RELEASE.md`](/Users/zai28/dev/PromptBar/macOS-App/RELEASE.md)

The repo also contains an earlier web prototype, but the native macOS app in [`macOS-App`](/Users/zai28/dev/PromptBar/macOS-App) is the main product.
