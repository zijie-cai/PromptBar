#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
APP_NAME="${PROMPTBAR_APP_NAME:-PromptBar}"
APP_DIR="${DIST_DIR}/${APP_NAME}.app"
ZIP_NAME="${PROMPTBAR_ZIP_NAME:-${APP_NAME}}"
ZIP_PATH="${DIST_DIR}/${ZIP_NAME}.zip"

log() {
  printf '%s
' "$1"
}

notarize_zip_if_configured() {
  local response=""
  local submit_args=()
  local submission_id=""

  if [[ -n "${PROMPTBAR_NOTARY_PROFILE:-}" ]]; then
    submit_args=(--keychain-profile "${PROMPTBAR_NOTARY_PROFILE}")
    log "Submitting ZIP for notarization with profile ${PROMPTBAR_NOTARY_PROFILE}..."
  elif [[ -n "${PROMPTBAR_NOTARY_KEY_PATH:-}" && -n "${PROMPTBAR_NOTARY_KEY_ID:-}" && -n "${PROMPTBAR_NOTARY_ISSUER:-}" ]]; then
    submit_args=(
      --key "${PROMPTBAR_NOTARY_KEY_PATH}"
      --key-id "${PROMPTBAR_NOTARY_KEY_ID}"
      --issuer "${PROMPTBAR_NOTARY_ISSUER}"
    )
    log "Submitting ZIP for notarization with App Store Connect API key..."
  else
    log "Skipping notarization. Set PROMPTBAR_NOTARY_PROFILE or PROMPTBAR_NOTARY_KEY_PATH/PROMPTBAR_NOTARY_KEY_ID/PROMPTBAR_NOTARY_ISSUER to notarize the ZIP."
    return
  fi

  set +e
  response="$(xcrun notarytool submit "${ZIP_PATH}" "${submit_args[@]}" --wait --output-format json 2>&1)"
  submit_exit_code=$?
  set -e

  printf '%s
' "$response"

  if printf '%s' "$response" | grep -q '"id"'; then
    submission_id="$(printf '%s' "$response" | /usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin).get("id",""))' 2>/dev/null || true)"
  fi

  if [[ $submit_exit_code -ne 0 ]]; then
    if [[ -n "$submission_id" ]]; then
      log "Fetching notarization log for ${submission_id}..."
      xcrun notarytool log "$submission_id" "${submit_args[@]}" || true
    fi
    return $submit_exit_code
  fi
}

"${SCRIPT_DIR}/build_app.sh"

rm -f "${ZIP_PATH}"
log "Creating ZIP..."
ditto -c -k --sequesterRsrc --keepParent "${APP_DIR}" "${ZIP_PATH}"

notarize_zip_if_configured

log "Built ZIP:"
log "${ZIP_PATH}"
