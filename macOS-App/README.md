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
- For public distribution, use an Apple Distribution certificate and package the app as a ZIP and notarize that ZIP for distribution.
- Until notarization is configured, `spctl`/Gatekeeper will still reject the app even if it is signed.
- The first time users enable the global hotkey, macOS will ask for Accessibility access for `PromptBar.app`.

## Packaging for Homebrew

If you still want a CLI distribution path, you can package the release binary separately:

1. Build the release executable:
   ```bash
   swift build -c release
   ```
2. The compiled binary will be located at `.build/release/PromptBar`.
3. Create a Homebrew Tap and Formula (e.g., `promptbar.rb`):

```ruby
class Promptbar < Formula
  desc "Minimal command palette for AI prompts"
  homepage "https://github.com/yourusername/promptbar"
  url "https://github.com/yourusername/promptbar/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "YOUR_TAR_SHA256"
  license "MIT"

  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/PromptBar"
  end

  service do
    run opt_bin/"PromptBar"
    keep_alive true
  end
end
```

4. Users can then install it via:
   ```bash
   brew tap yourusername/promptbar
   brew install promptbar
   brew services start promptbar
   ```
