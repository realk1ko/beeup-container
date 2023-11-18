#!/usr/bin/env bash

set -euo pipefail

# FIXME automate initialization in Dockerfile (if possible)
# The initialization part of Wine (wineboot --init) can be moved to the Dockerfile, but it breaks the printer support,
# since the PDF printer is only setup once the container is running (see run_cupsd.sh). As a result Wine is initialized
# on first container startup.
wineboot

# setup license files, unless they already exist
if [ ! -f "${INSTALL_PATH}/license.ini" ] || [ ! -f "${INSTALL_PATH}/alicdat.ini" ]
then
  wine64 "${INSTALL_PATH}/asetlic.exe" "-p${INSTALL_PATH}/license.ini" "-L${INSTALL_PATH}/alicdat.ini" -cBOCGmbH "-l${ADO_LICENSE_KEY}"
fi

# if no database file exists, create it
if [ ! -f "${ADO_SQLITE_DBFOLDER}/beeup.sqlite3" ]
then
  wine64 "${INSTALL_PATH}/adbinst.exe" -dbeeup "-l${ADO_LICENSE_KEY}" -sSQLITE -iNO_SSO -lang2057 -c+ "-sample${INSTALL_PATH}/adostd.adl"
fi

wine64 "${INSTALL_PATH}/areena.exe" -uAdmin -ppassword -sSQLITE -dbeeup
