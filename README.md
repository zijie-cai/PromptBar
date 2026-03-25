# PromptBar

PromptBar is a native macOS menu bar app for saving, searching, and copying AI prompts.

[Download for macOS](https://github.com/zijie-cai/PromptBar/releases/download/v1.0.0/PromptBar-1.0.0.zip)

## Overview

PromptBar keeps your most-used prompts one shortcut away.

- menu bar utility
- quick access with `⌘⇧P`
- instant search
- fast copy
- simple prompt management

## Install

1. Download `PromptBar-1.0.0.zip`
2. Unzip the archive
3. Move `PromptBar.app` to `Applications`
4. Open PromptBar

## Permissions

To use the global `⌘⇧P` shortcut, allow PromptBar in:

`System Settings` → `Privacy & Security` → `Accessibility`

## Development

```bash
cd macOS-App
swift run
```

## Build

```bash
cd macOS-App
./scripts/build_app.sh
./scripts/build_zip.sh
```

## Notes

The native app in [`macOS-App`](/Users/zai28/dev/PromptBar/macOS-App) is the main product. The repository also includes an earlier web prototype.
