# cosmopterix
Named after the <a href='http://ukmoths.org.uk/systematic-list/#Cosmopteriginae'>Cosmopteriginae</a> family of moths.

A set of Docker containers for each of the main database platforms used in the IVOA to provide a common interface for creating and configuring test databases.

The test framework makes it easy to run the same set of SQL queries across all of the database platforms to see how they handle different query constructs. Enabling us to verify that it will be possible to implement proposed changes to the ADQL grammar and syntax on all of the target platforms. 

Cross platform SQL tests :
* [OFFSET and LIMIT](../../wiki/OFFSET-and-LIMIT)

Working containers for :
* [PostgreSQL](docker/pgsql)
* [MySQL](docker/mysql)
* [MariaDB](docker/mariadb)
* [Apache Derby](docker/derby)
* [HyperSQL](docker/hsqldb)

Work in progress for :
* [Oracle Xe](docker/oracle/oracle-xe/11.2)
* [SQLite](docker/sqlite)

Plans for :
* [SQLServer](docker/mssql)
* [Firebird](docker/firebird)
* [Sybase](docker/sybase)
* [DB2](docker/db2)
* [Qserv](https://dev.lsstcorp.org/trac/wiki/db/Qserv)
* [SpiderEngine](https://mariadb.com/kb/en/mariadb/spider-storage-engine-overview/)
* [Oracle TimesTen](http://www.oracle.com/technetwork/database/database-technologies/timesten/overview/index.html)

