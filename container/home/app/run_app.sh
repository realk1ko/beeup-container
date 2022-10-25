#!/bin/bash

set -xe

wineboot

if [ ! -f "${HOME}/initialized" ]
then
  # initialize database
  # FIXME sqlcmd actually never returns a non-zero status code (AFAIK), so the echos below will never be printed
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${DATABASE_PASSWORD}" -i "${HOME}/createUser.sql" || \
    echo "User already exists."
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${DATABASE_PASSWORD}" -i "${HOME}/createDB.sql" || \
    echo "Database already exists."

  # set up ODBC configuration
  cat <<EOF > "${HOME}/odbc.ini"
[beeup16_64]
Driver=ODBC Driver 17 for SQL Server
Server=${DATABASE_HOST}
Database=beeup16_64
AutoTranslate=no
EOF
  odbcinst -i -s "${DATABASE_NAME}" -f "${HOME}/odbc.ini"

  # finish installation of Bee-Up
  wine "C:/Program Files/BOC/BEEUP16_ADOxx_SA/adbinst.exe" -d"${DATABASE_NAME}" -l"${ADOXX_LICENSE_KEY}" -sSQLServer -iNO_SSO -lang2057 || \
    echo "Installation failed. This installation is probably being upgraded."

  # disables the required password change
  /opt/mssql-tools/bin/sqlcmd -S "${DATABASE_HOST}" -U SA -P "${DATABASE_PASSWORD}" -i "${HOME}/postprocess.sql"

  # remember that Bee-Up was initialized
  touch "${HOME}/initialized"
fi

wine "${WINEPREFIX}"/drive_c/Program\ Files/BOC/BEEUP16_ADOxx_SA/areena.exe -uAdmin -ppassword -d"${DATABASE_NAME}"
