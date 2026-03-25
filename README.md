# 🪄 PromptBar

PromptBar is a macOS menu bar app for saving, searching, and instantly reusing AI prompts.

[Download for macOS](https://github.com/zijie-cai/PromptBar/releases/download/v1.0.0/PromptBar-1.0.0.zip)

## What It Does

PromptBar keeps your most-used prompts one shortcut away.

- Opens from the menu bar
- Launches with `⌘⇧P`
- Searches prompts instantly
- Copies prompts in one step
- Includes a clean built-in prompt editor

## Install

1. Download `PromptBar-1.0.0.zip`
2. Unzip the file
3. Move `PromptBar.app` to `Applications`
4. Open PromptBar

## Permissions

To use the global `⌘⇧P` shortcut, allow PromptBar in:

`System Settings` → `Privacy & Security` → `Accessibility`

## Download

- [Latest Release](https://github.com/zijie-cai/PromptBar/releases/latest)
- [Release Notes](https://github.com/zijie-cai/PromptBar/releases)

## For Developers

```bash
cd macOS-App
swift run
```

To build a release ZIP locally:

```bash
cd macOS-App
./scripts/build_zip.sh
```
