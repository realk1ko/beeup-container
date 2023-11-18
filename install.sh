#!/usr/bin/env bash

set -euo pipefail

mkdir -p ./pdf

cat << EOF
============================================================
Running generic installation procedure...
============================================================
EOF

sudo docker run --name beeup \
  --restart unless-stopped \
  -d \
  -p 8080:8080 \
  -v beeup:/home/app/data \
  -v "$(pwd)/pdf":/home/app/pdf \
  ghcr.io/realk1ko/beeup:latest

cat << EOF
============================================================
You have to finish the installation manually:
1) Open http://localhost:8080/vnc.html in your favorite
   browser and click 'Connect'.
2) Then click through the installation process and wait.
3) Wait some more.

That should be it, you're good to go.
============================================================
EOF

read -p "Press ENTER to continue..."
