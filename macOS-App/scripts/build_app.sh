#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

APP_NAME="${PROMPTBAR_APP_NAME:-PromptBar}"
EXECUTABLE_NAME="${PROMPTBAR_EXECUTABLE_NAME:-PromptBar}"
BUNDLE_ID="${PROMPTBAR_BUNDLE_ID:-com.promptbar.app}"
APP_VERSION="${PROMPTBAR_VERSION:-1.0.0}"
BUILD_VERSION="${PROMPTBAR_BUILD_VERSION:-${APP_VERSION}}"
MIN_SYSTEM_VERSION="${PROMPTBAR_MIN_SYSTEM_VERSION:-14.0}"
CONFIGURATION="${PROMPTBAR_CONFIGURATION:-release}"
DIST_DIR="${ROOT_DIR}/dist"
APP_DIR="${DIST_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"
TEMPLATE_PATH="${ROOT_DIR}/packaging/Info.plist.template"
EXECUTABLE_PATH="${ROOT_DIR}/.build/${CONFIGURATION}/${EXECUTABLE_NAME}"
ICON_PATH="${ROOT_DIR}/packaging/AppIcon.icns"

log() {
  printf '%s\n' "$1"
}

detect_signing_identity() {
  if [[ -n "${PROMPTBAR_SIGN_IDENTITY:-}" ]]; then
    printf '%s' "${PROMPTBAR_SIGN_IDENTITY}"
    return
  fi

  local distribution_identity
  distribution_identity="$(security find-identity -v -p codesigning 2>/dev/null | sed -n 's/.*"\(Apple Distribution:.*\)"/\1/p' | head -n 1)"
  if [[ -n "${distribution_identity}" ]]; then
    printf '%s' "${distribution_identity}"
    return
  fi

  local development_identity
  development_identity="$(security find-identity -v -p codesigning 2>/dev/null | sed -n 's/.*"\(Apple Development:.*\)"/\1/p' | head -n 1)"
  if [[ -n "${development_identity}" ]]; then
    printf '%s' "${development_identity}"
    return
  fi
}

log "Building ${EXECUTABLE_NAME} (${CONFIGURATION})..."
swift build -c "${CONFIGURATION}" --product "${EXECUTABLE_NAME}"

if [[ ! -x "${EXECUTABLE_PATH}" ]]; then
  log "Expected executable not found at ${EXECUTABLE_PATH}"
  exit 1
fi

rm -rf "${APP_DIR}"
mkdir -p "${MACOS_DIR}" "${RESOURCES_DIR}"

cp "${EXECUTABLE_PATH}" "${MACOS_DIR}/${EXECUTABLE_NAME}"

sed \
  -e "s|__APP_NAME__|${APP_NAME}|g" \
  -e "s|__EXECUTABLE_NAME__|${EXECUTABLE_NAME}|g" \
  -e "s|__BUNDLE_ID__|${BUNDLE_ID}|g" \
  -e "s|__APP_VERSION__|${APP_VERSION}|g" \
  -e "s|__BUILD_VERSION__|${BUILD_VERSION}|g" \
  -e "s|__MIN_SYSTEM_VERSION__|${MIN_SYSTEM_VERSION}|g" \
  "${TEMPLATE_PATH}" > "${CONTENTS_DIR}/Info.plist"

printf 'APPL????' > "${CONTENTS_DIR}/PkgInfo"

if [[ -f "${ICON_PATH}" ]]; then
  cp "${ICON_PATH}" "${RESOURCES_DIR}/AppIcon.icns"
  /usr/libexec/PlistBuddy -c "Add :CFBundleIconFile string AppIcon" "${CONTENTS_DIR}/Info.plist" >/dev/null 2>&1 || \
  /usr/libexec/PlistBuddy -c "Set :CFBundleIconFile AppIcon" "${CONTENTS_DIR}/Info.plist"
fi

SIGNING_IDENTITY="$(detect_signing_identity || true)"
if [[ -n "${SIGNING_IDENTITY}" && "${PROMPTBAR_SKIP_SIGNING:-0}" != "1" ]]; then
  log "Signing app bundle with ${SIGNING_IDENTITY}..."
  codesign --force --deep --options runtime --timestamp --sign "${SIGNING_IDENTITY}" "${APP_DIR}"
  codesign --verify --deep --strict --verbose=2 "${APP_DIR}"
else
  log "Skipping code signing."
fi

log "Built app bundle:"
log "${APP_DIR}"
