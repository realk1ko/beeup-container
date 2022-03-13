#!/bin/bash

set -xe

# Setup VNC password
mkdir -p "${HOME}/.vnc/"
echo "${VNC_PASSWORD}" | tigervncpasswd -f > "${HOME}/.vnc/passwd"

Xtigervnc -desktop "${APP_NAME}" \
  -localhost \
  -rfbport 5900 \
  -SecurityTypes VncAuth \
  -PasswordFile "${HOME}/.vnc/passwd" \
  -AlwaysShared \
  -AcceptKeyEvents \
  -AcceptPointerEvents \
  -AcceptCutText \
  -SendCutText \
  -AcceptSetDesktopSize \
  "${DISPLAY}"
