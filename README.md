# cosmopterix
Named after the <a href='http://ukmoths.org.uk/systematic-list/#Cosmopteriginae'>Cosmopteriginae</a> family of moths.

Create a set of Docker containers for each of the main database platforms that are used within the IVOA.

The aim is to make it easy to SQL commands across the different platform by configuring them all in the same way, using the same commands to create a database and to run the command line client for each platform.

Cross platform SQL tests :
* [OFFSET and LIMIT](wiki/OFFSET)

Working containers for :
* [PostgreSQL](docker/pgsql)
* [MySQL](docker/mysql)
* [MariaDB](docker/mariadb)
* [HyperSQL](docker/hsqldb)
* [Apache Derby](docker/derby)
* [Oracle](docker/oracle) (requires external download)

Work in progress for :
* [SQLite](docker/sqlite)

Plans and notes for :
* [Firebird](docker/firebird)
* [SQLServer](docker/sqlserver)
* [Sybase](docker/sybase)
* [DB2](docker/db2)



