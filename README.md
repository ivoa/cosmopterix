# cosmopterix
Named after the <a href='http://ukmoths.org.uk/systematic-list/#Cosmopteriginae'>Cosmopteriginae</a> family of moths.

A set of Docker containers for each of the main database platforms providing a common framework for creating and configuring test databases.

The framework makes it easy to compare the same set of SQL queries across all of the database platforms to see how they handle different query constructs, enabling us to test if proposed changes to the ADQL language will be implemetable on all of the target platforms.

Cross platform SQL tests :
* [OFFSET and LIMIT](../../wiki/OFFSET-and-LIMIT)
* [MOD for -ve numbers](../../wiki/MOD-for-negative-numbers)
* [Unnamed-columns](../../wiki/Unnamed-columns)

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

The work involved in this project has received funding from the following sources :
* The European Community's Seventh Framework Programme (FP7-SPACE-2013-1) under grant agreement n°606740, Gaia [GENIUS](https://cordis.europa.eu/project/id/606740) 
* The European Commission Framework Programme Horizon 2020 Research and Innovation action under grant agreement n°653477, [ASTERICS](https://cordis.europa.eu/project/id/653477)
* The UK Science and Technology Facilities Council under grant numbers [ST/M001989/1](https://gtr.ukri.org/projects?ref=ST%2FM001989%2F1), [ST/M007812/1](https://gtr.ukri.org/projects?ref=ST%2FM007812%2F1), and [ST/N005813/1](https://gtr.ukri.org/projects?ref=ST%2FN005813%2F1)
