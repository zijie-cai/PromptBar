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

notarize_app_if_configured() {
  local response=""
  local submit_args=()

  if [[ -n "${PROMPTBAR_NOTARY_PROFILE:-}" ]]; then
    submit_args=(--keychain-profile "${PROMPTBAR_NOTARY_PROFILE}")
    log "Submitting app for notarization with profile ${PROMPTBAR_NOTARY_PROFILE}..."
  elif [[ -n "${PROMPTBAR_NOTARY_KEY_PATH:-}" && -n "${PROMPTBAR_NOTARY_KEY_ID:-}" && -n "${PROMPTBAR_NOTARY_ISSUER:-}" ]]; then
    submit_args=(
      --key "${PROMPTBAR_NOTARY_KEY_PATH}"
      --key-id "${PROMPTBAR_NOTARY_KEY_ID}"
      --issuer "${PROMPTBAR_NOTARY_ISSUER}"
    )
    log "Submitting app for notarization with App Store Connect API key..."
  else
    log "Skipping notarization. Set PROMPTBAR_NOTARY_PROFILE or PROMPTBAR_NOTARY_KEY_PATH/PROMPTBAR_NOTARY_KEY_ID/PROMPTBAR_NOTARY_ISSUER to notarize and staple the app."
    return
  fi

  set +e
  response="$(xcrun notarytool submit "${APP_DIR}" "${submit_args[@]}" --wait --output-format json 2>&1)"
  status=$?
  set -e

  printf '%s
' "$response"

  local submission_id
  submission_id="$(printf '%s' "$response" | python3 - <<'PY2'
import json, sys
text = sys.stdin.read().strip()
if not text:
    raise SystemExit(0)
try:
    data = json.loads(text)
except Exception:
    raise SystemExit(0)
print(data.get('id', ''))
PY2
)"

  if [[ $status -ne 0 ]]; then
    if [[ -n "$submission_id" ]]; then
      log "Fetching notarization log for ${submission_id}..."
      xcrun notarytool log "$submission_id" "${submit_args[@]}" || true
    fi
    return $status
  fi

  xcrun stapler staple "${APP_DIR}"
}

"${SCRIPT_DIR}/build_app.sh"
notarize_app_if_configured

rm -f "${ZIP_PATH}"
log "Creating ZIP..."
ditto -c -k --sequesterRsrc --keepParent "${APP_DIR}" "${ZIP_PATH}"

log "Built ZIP:"
log "${ZIP_PATH}"
