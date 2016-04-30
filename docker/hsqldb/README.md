This container is based on the [Cosmopterix Java 8](../java/8) base container.
The container build script downloads and installs version 2.3.3 of the [HyperSQL](http://hsqldb.org/)
database from the Apache website.

Running the container with no arguments will create a new database, with random database name, user name and password.

```
    #
    # Run a container in the background. 
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/hsqldb'

```

The entrypoint script saves details of the database configuration in a `/database.save` file inside the container.

```
    #
    # Display the contents of /database.save in the container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        cat '/database.save'

            #
            # System settings
            serveruser=hsqldb
            serverdata=/var/lib/hsqldb
            serverport=9001
            serveripv4=0.0.0.0

            #
            # HSQLDB settings
            hsqldbbin=/usr/lib/hsqldb/hsqldb-2.3.3/hsqldb/bin
            hsqldblib=/usr/lib/hsqldb/hsqldb-2.3.3/hsqldb/lib
            hsqldbversion=2.3.3

            #
            # Database settings
            databasename=thi6Pae3ah
            databaseuser=Eet0iex4zu
            databasepass=Chet4Eo8oo

```

The entry point script checks for a `/database.config` script file
at startup. If the config file is found it is executed using the
bash `source` command.

This provides a method for setting environment variables at the
begining of the initialization process which can then be used  by
the rest of the entrypoint script.

* The entry point script uses `databasename` `databaseuser` and `databasepass`
environment variables to configure the new database.
* If the user names and passwords are not specified then random default
values are generated.

```
    #
    # Create a temp file.
    tempcfg=$(mktemp)
    
    #
    # Write to our database config.
    cat > "${tempcfg:?}" << EOF
databasename=testdb
databaseuser=stephany
databasepass=$(pwgen 10 1)
EOF

    #
    # Run a new container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempcfg}:/database.config" \
       'cosmopterix/hsqldb'

```

In this container, the database name and user name will be
set to `testdb` and `stephany`.

```
    #
    # Display the contents of /database.save in the container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        cat '/database.save'

            ....
            ....
            #
            # Database settings
            databasename=testdb
            databaseuser=stephany
            databasepass=ooph8XohGu

```

The entry point script also checks for `.sh`, `.sql` or `.sql.gz` files
in the `/database.init/` directory inside the container.

* Shell script, `*.sh`, files will be executed inside the container using the `source` command.
* SQL, `*.sql`, files will be run on the new database using the command line client.
* Gzipped, `*.sql.gz`, files will be unzipped and then run on the new database using the command line client.

You can use the Docker `--volume` option to mount a local directory as `/database.init/` inside the container.

```

    #
    # Create a temp directory.
    tempdir=$(mktemp -d)
    
    #
    # Copy our SQL scripts into the temp directory
    cp "hsqldb/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempdir} mounted
    # as /database.init/ inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/hsqldb'

```

In this container, the new database will be initialized with the SQL commands
from the `alpha-source.sql` and `alpha-source-data.sql` SQL files.

```
    docker logs \
        --follow \
        'albert'

            ....
            Running init scripts
            Running [/database.init/001.sql]

                SqlTool v. 5337.
                JDBC Connection established to a HSQL Database Engine v. 2.3.3 database
                as "jeipeeFi5y" with R/W TRANSACTION_READ_COMMITTED Isolation.
                ....

            Running [/database.init/002.sql]

                SqlTool v. 5337.
                JDBC Connection established to a HSQL Database Engine v. 2.3.3 database
                as "jeipeeFi5y" with R/W TRANSACTION_READ_COMMITTED Isolation.
                ....

```

The container image also includes a startup script for the `SqlTool` commandline client.

Using the Docker `exec` command to run `hsqldb-client` will launch the `SqlTool` commandline client and automatically connect it to the database.

```
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'hsqldb-client'

            \dt

            \q

```

Using these tools we can create a new database, initialise it with data from our SQL scripts,
and then login and run our tests.

```
    #
    # Create our scripts directory.
    tempdir=$(mktemp -d)
    cp "hsqldb/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
        --volume "${tempcfg}:/database.config" \
       'cosmopterix/hsqldb'

    #
    # Login and run our tests.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'hsqldb-client'

            SELECT id, ra, decl FROM alpha_source ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 ;
            SELECT id, ra, decl FROM alpha_source OFFSET 10 ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 OFFSET 10 ;

            \q

```

