#!/usr/bin/env bash

set -euo pipefail

cat << EOF
============================================================
Uninstalling Bee-Up...
============================================================
EOF

sudo docker stop beeup
sudo docker rm beeup
sudo docker rmi ghcr.io/realk1ko/beeup:latest

sudo docker volume rm beeup

cat << EOF
============================================================
Done. You can now remove the repository folder.
============================================================
EOF

read -p "Press ENTER to continue..."
