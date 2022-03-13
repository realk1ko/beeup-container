#!/bin/bash

set -xe

wineboot

if [ ! -f "${HOME}/initialized" ]
then
  # Initialize database
  # FIXME sqlcmd actually never returns a non-zero status code (AFAIK), so the echos below will never be printed.
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${SA_PASSWORD}" -i "${HOME}/createUser.sql" || \
    echo "User already exists."
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${SA_PASSWORD}" -i "${HOME}/createDB.sql" || \
    echo "Database already exists."

  # Setup ODBC configuration
  cat <<EOF > "${HOME}/odbc.ini"
[beeup16_64]
Driver=ODBC Driver 17 for SQL Server
Server=${DATABASE_HOST}
Database=beeup16_64
AutoTranslate=no
EOF
  odbcinst -i -s "${DATABASE}" -f "${HOME}/odbc.ini"

  # Finish installation of Bee-Up
  wine "C:/Program Files/BOC/${TOOLFOLDER}/adbinst.exe" -d"${DATABASE}" -l"${LICENSE_KEY}" -sSQLServer -iNO_SSO -lang2057 || \
    echo "Installation failed. This installation is probably being upgraded."

  # Disables the required password change
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${SA_PASSWORD}" -i "${HOME}/postprocess.sql"

  # Remember that Bee-Up was intialized
  touch "${HOME}/initialized"
fi

wine "${WINEPREFIX}"/drive_c/Program\ Files/BOC/BEEUP16_ADOxx_SA/areena.exe -uAdmin -ppassword -d"${DATABASE}"
