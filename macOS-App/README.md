# PromptBar (Native macOS App)

This directory contains the native Swift code for PromptBar, designed with Apple's modern Liquid Glass aesthetic.

## Requirements
- macOS 14.0+
- Xcode 15+ or Swift 5.10+ CLI

## How to Build & Run Locally

1. Open Terminal and navigate to this directory (`macOS-App`).
2. Run the app directly using Swift Package Manager:
   ```bash
   swift run
   ```
3. The PromptBar icon (✨) will appear in your menu bar.
4. **Important:** To use the global hotkey (⌘⇧P), macOS requires you to grant Accessibility permissions to the Terminal or the built app (System Settings > Privacy & Security > Accessibility).

## Build A Standalone App Bundle

Build a standalone `.app` that runs without Terminal:

```bash
./scripts/build_app.sh
```

Output:

```bash
dist/PromptBar.app
```

Useful environment overrides:

```bash
PROMPTBAR_VERSION=1.0.0
PROMPTBAR_BUILD_VERSION=100
PROMPTBAR_BUNDLE_ID=com.yourcompany.promptbar
PROMPTBAR_SIGN_IDENTITY="Apple Distribution: Your Name (TEAMID)"
PROMPTBAR_SKIP_SIGNING=1
```

## Build A ZIP

Create a distributable ZIP containing `PromptBar.app`:

```bash
./scripts/build_zip.sh
```

Output:

```bash
dist/PromptBar.zip
```

Optional notarization:

```bash
PROMPTBAR_NOTARY_PROFILE=promptbar-notary ./scripts/build_zip.sh
```

This expects a preconfigured keychain profile created with `xcrun notarytool store-credentials`.

## Distribution Notes

- A signed `.app` or `.dmg` is better than `swift run` for normal users because the app runs independently from Terminal.
- For public distribution outside the App Store, use a Developer ID Application certificate and notarize the ZIP before distribution.
- Until notarization is configured, `spctl`/Gatekeeper will still reject the app even if it is signed.
- The first time users enable the global hotkey, macOS will ask for Accessibility access for `PromptBar.app`.

## Packaging for Homebrew

PromptBar is distributed as a Homebrew cask through:

`zijie-cai/homebrew-promptbar`

Install with:

```bash
brew install --cask zijie-cai/promptbar/promptbar
```

That command installs the notarized `PromptBar.app` from the GitHub Release ZIP into `Applications`.

To update the cask for a new release:

1. Publish a new GitHub Release ZIP for PromptBar.
2. Compute the ZIP SHA-256.
3. Update `Casks/promptbar.rb` in the tap repo with the new `version`, `sha256`, and release URL.
4. Push the tap repo changes.
