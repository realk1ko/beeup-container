#!/usr/bin/env bash

set -euo pipefail

cat << EOF
============================================================
Uninstalling Bee-Up...
============================================================
EOF

sudo docker stop beeup
sudo docker rm beeup

if [[ "$(uname -m)" = 'arm64' ]]; then
  sudo docker stop beeup-db
  sudo docker rm beeup-db
  sudo docker rmi mcr.microsoft.com/azure-sql-edge:latest
  sudo docker rmi ghcr.io/realk1ko/beeup:latest-arm64-emulation
else
  sudo docker rmi ghcr.io/realk1ko/beeup:latest
fi

sudo docker volume rm beeup-db

cat << EOF
============================================================
Done. You can now remove the repository folder.
============================================================
EOF
