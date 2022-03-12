#!/bin/bash

# CUPS is a bit finicky when it comes to setting up printers. For some reason it does not work when the installation of
# the printer via lpadmin is done within the Dockerfile. As a result I moved the entire block in here.

# FIXME automate this properly in the Dockerfile (if possible)

set -xe

# Start CUPS in background and fetch the PID
cupsd -f & CUPS_PID=$!

# Wait for startup
while [ ! -S /run/cups/cups.sock ]; do
  sleep 1;
done

# Set up the PDF printer
lpadmin -p PDF -v cups-pdf:/ -m lsb/usr/cups-pdf/CUPS-PDF_opt.ppd -E && \

# Kill CUPS again
while [ "$(kill "${CUPS_PID}" 2>/dev/null)" ]; do
  sleep 1;
done

# And start CUPS again in foreground (for supervisord)
cupsd -f
