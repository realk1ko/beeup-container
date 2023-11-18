#!/usr/bin/env bash

set -euo pipefail

Xtigervnc -desktop "${APP_NAME}" \
  -localhost \
  -rfbport 5900 \
  -SecurityTypes None \
  -AlwaysShared \
  -AcceptKeyEvents \
  -AcceptPointerEvents \
  -AcceptCutText \
  -SendCutText \
  -AcceptSetDesktopSize \
  "${DISPLAY}"
