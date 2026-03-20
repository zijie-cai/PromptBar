# PromptBar ZIP Release Setup

This repo builds a standalone signed macOS app and packages it as a downloadable ZIP.

## What You Get

- `macOS-App/dist/PromptBar.app`
- `macOS-App/dist/PromptBar.zip`
- Optional notarization and stapling for the app bundle
- Optional GitHub Release upload for one-click downloads

## Local Build

```bash
cd macOS-App
./scripts/build_zip.sh
```

## GitHub Release Flow

After this folder is pushed into a GitHub repository, the workflow at [.github/workflows/release-dmg.yml](/Users/zai28/dev/PromptBar/.github/workflows/release-dmg.yml) can:

- build the app on macOS
- sign it
- notarize it
- staple the app
- package a ZIP
- upload the ZIP as an artifact
- attach the ZIP to a GitHub Release on tag push

Users can then download the ZIP directly from a GitHub Release.

## Required GitHub Secrets

Set these in your repository settings before using the release workflow:

- `MACOS_CERTIFICATE_P12_BASE64`
  Base64-encoded `.p12` signing certificate export.
- `MACOS_CERTIFICATE_PASSWORD`
  Password for the `.p12` certificate export.
- `MACOS_KEYCHAIN_PASSWORD`
  Temporary CI keychain password.
- `MACOS_SIGN_IDENTITY`
  Example: `Apple Distribution: Your Name (TEAMID)`
- `MACOS_BUNDLE_ID`
  Example: `com.yourcompany.promptbar`
- `APPLE_API_KEY_P8_BASE64`
  Base64-encoded App Store Connect API private key `.p8`.
- `APPLE_API_KEY_ID`
  App Store Connect API key id.
- `APPLE_API_ISSUER_ID`
  App Store Connect issuer id.

## Release Usage

Manual run:

- Open GitHub Actions
- Run `Release ZIP`
- Provide a version such as `1.0.0`

Tag-based release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

That will build and publish a release asset that users can download directly.

## Important Notes

- ZIP is simpler than DMG for early public releases.
- Without notarization secrets, the workflow can still produce a ZIP, but macOS Gatekeeper may reject the app.
- If notarization fails, the build script now prints the Apple notarization response so the rejection is easier to debug.
