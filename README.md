# cosmopterix
Named after the <a href='http://ukmoths.org.uk/systematic-list/#Cosmopteriginae'>Cosmopteriginae</a> family of moths.

A set of Docker containers for each of the main database platforms used in the IVOA to provide a common interface for creating and configuring test databases.

The aim is to create a framework that makes it easy to experiment with SQL queries across all of the database platforms to see how they handle different query constructs. 

The test framework enables us to verify that any proposed changes to the ADQL grammar and syntax are in fact implementable on all of the target platforms. 

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



