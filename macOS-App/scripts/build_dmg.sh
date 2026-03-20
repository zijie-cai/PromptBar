#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
APP_NAME="${PROMPTBAR_APP_NAME:-PromptBar}"
APP_DIR="${DIST_DIR}/${APP_NAME}.app"
STAGING_DIR="${DIST_DIR}/dmg-root"
DMG_NAME="${PROMPTBAR_DMG_NAME:-${APP_NAME}}"
DMG_PATH="${DIST_DIR}/${DMG_NAME}.dmg"
VOLUME_NAME="${PROMPTBAR_DMG_VOLUME_NAME:-${APP_NAME}}"

log() {
  printf '%s\n' "$1"
}

sign_dmg_if_needed() {
  if [[ "${PROMPTBAR_SKIP_SIGNING:-0}" == "1" ]]; then
    return
  fi

  local identity="${PROMPTBAR_SIGN_IDENTITY:-}"
  if [[ -z "${identity}" ]]; then
    identity="$(security find-identity -v -p codesigning 2>/dev/null | sed -n 's/.*"\(Apple Distribution:.*\)"/\1/p' | head -n 1)"
  fi

  if [[ -n "${identity}" ]]; then
    log "Signing DMG with ${identity}..."
    codesign --force --sign "${identity}" "${DMG_PATH}"
  fi
}

notarize_if_configured() {
  if [[ -n "${PROMPTBAR_NOTARY_PROFILE:-}" ]]; then
    log "Submitting DMG for notarization with profile ${PROMPTBAR_NOTARY_PROFILE}..."
    xcrun notarytool submit "${DMG_PATH}" --keychain-profile "${PROMPTBAR_NOTARY_PROFILE}" --wait
    xcrun stapler staple "${DMG_PATH}"
    return
  fi

  if [[ -n "${PROMPTBAR_NOTARY_KEY_PATH:-}" && -n "${PROMPTBAR_NOTARY_KEY_ID:-}" && -n "${PROMPTBAR_NOTARY_ISSUER:-}" ]]; then
    log "Submitting DMG for notarization with App Store Connect API key..."
    xcrun notarytool submit "${DMG_PATH}" \
      --key "${PROMPTBAR_NOTARY_KEY_PATH}" \
      --key-id "${PROMPTBAR_NOTARY_KEY_ID}" \
      --issuer "${PROMPTBAR_NOTARY_ISSUER}" \
      --wait
    xcrun stapler staple "${DMG_PATH}"
    return
  fi

  log "Skipping notarization. Set PROMPTBAR_NOTARY_PROFILE or PROMPTBAR_NOTARY_KEY_PATH/PROMPTBAR_NOTARY_KEY_ID/PROMPTBAR_NOTARY_ISSUER to notarize and staple the DMG."
}

"${SCRIPT_DIR}/build_app.sh"

rm -rf "${STAGING_DIR}" "${DMG_PATH}"
mkdir -p "${STAGING_DIR}"
cp -R "${APP_DIR}" "${STAGING_DIR}/${APP_NAME}.app"
ln -s /Applications "${STAGING_DIR}/Applications"

log "Creating DMG..."
hdiutil create \
  -volname "${VOLUME_NAME}" \
  -srcfolder "${STAGING_DIR}" \
  -ov \
  -format UDZO \
  "${DMG_PATH}" >/dev/null

rm -rf "${STAGING_DIR}"

sign_dmg_if_needed
notarize_if_configured

log "Built DMG:"
log "${DMG_PATH}"
