-- FIXME the bundled createDB.sql with BeeUp uses the incorrect path /opt/mssql/adoxx_data for the database files, the
--  correct path is /var/opt/mssql/adoxx_data (https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-docker-container-configure?view=sql-server-ver16&pivots=cs1-bash#persist)
CREATE DATABASE beeup16_64
    ON
    (NAME = 'beeup16_64',
        FILENAME = '/var/opt/mssql/adoxx_data/beeup16_64_dat.mdf',
        SIZE = 30 MB,
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 10%)
    LOG ON
    (NAME = 'beeup16_64_log',
        FILENAME = '/var/opt/mssql/adoxx_data/beeup16_64_log.ldf',
        SIZE = 5 MB,
        MAXSIZE = 200 MB,
        FILEGROWTH = 10%)
GO
USE beeup16_64
EXEC sp_grantdbaccess 'ADONIS'
GO
GRANT create table, create view TO ADONIS
GO