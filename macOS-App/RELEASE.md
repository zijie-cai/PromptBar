# PromptBar DMG Release Setup

This repo can now build a standalone signed DMG locally and in GitHub Actions.

## What You Get

- `macOS-App/dist/PromptBar.app`
- `macOS-App/dist/PromptBar.dmg`
- Optional notarization and stapling
- Optional GitHub Release upload for one-click downloads

## Local Build

```bash
cd macOS-App
./scripts/build_dmg.sh
```

## GitHub Release Flow

After this folder is pushed into a GitHub repository, the workflow at [.github/workflows/release-dmg.yml](/Users/zai28/dev/promptbar-prototype/.github/workflows/release-dmg.yml) can:

- build the app on macOS
- sign it
- notarize it
- create a DMG
- upload the DMG as an artifact
- attach the DMG to a GitHub Release on tag push

Users can then click a GitHub Release asset and download the DMG directly.

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
- Run `Release DMG`
- Provide a version such as `1.0.0`

Tag-based release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

That will build and publish a release asset that users can download directly.

## Important Notes

- Without notarization secrets, the workflow can still produce a DMG, but macOS Gatekeeper will reject it.
- For true one-click distribution, use a notarized DMG attached to a GitHub Release or your website.
- This repo is not currently a git repository in the local workspace, so the workflow is prepared but cannot be executed from here until the code is pushed to GitHub.
