

This container is based on the Cosmopterix Fedora base container.
It uses the distribution package manager to install the PostgreSQL client and server packages.

Running the container with no arguments will create a new database, with random database name, user name and password.

```Shell
    docker run \
        --detach \
       'cosmopterix/pgsql'

```

Naming the container makes it easier to refer to the container in subsequent commands.

```Shell
    docker run \
        --detach \
        --name 'pgsql' \
       'cosmopterix/pgsql'

    docker logs -f pgsql

```

In addition to the database server, the container also includes the corresponding `psql` commandline client.

The passing the command `psql` to the entrypoint script will run the commandline client and connect it to the new database.

```Shell
    docker run \
        --detach \
        --name pgsql \
       'cosmopterix/pgsql'

    docker exec \
        --tty \
        --interactive \
        psql

        \l
        \dt
        \q

```

The entrypoint script will save deatils of the database configuration in a file called `/database.save` inside the container.

You can use the Docker `exec` command to connect to the container and read the `/database.save` config file.
 
```Shell
    docker run \
        --detach \
        --name pgsql \
       'cosmopterix/pgsql'

    docker exec \
        --tty \
        --interactive \
        cat '/database.save'

```

The entry point script checks for a `/database.config` script file
at startup. If the config file is found it is run using the bash shell
`source` command.

The entry point script checks for `adminuser` and `adminpass` environment
variables to use when configuring the database server.
If the values are not specified then random default values are generated.

The entry point script checks for `databasename` `databaseuser` and `databasepass`
environment variables to use when creating the new database.
If the values are not specified then random default values are generated.

You can use the Docker `--volume` option to mount a local file as `/database.config` inside the container.


```Shell

    #
    # Create a temp file.
    tempcfg=$(mktemp)
    
    #
    # Write to our database config.
    cat > "${tempcfg:?}" << EOF
adminuser=helen
adminpass=$(pwgen 10 1)

databasename=mydatabase
databaseuser=stephany
databasepass=$(pwgen 10 1)
EOF

    #
    # Run our database container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name pgsql \
        --volume "${tempcfg}:/database.config" \
       'cosmopterix/pgsql'

```

The entry point script will check for `.sh`, `.sql` or `.sql.gz` files
in the `/database.init/` directory.

* Shell script, `.sh`, files will be run inside the container as root.
* SQL, `.sql`, files will be run on the new database using the `psql` command line client.
* Gzipped, `.sql.gz`, files will be unzipped and then run on the new database using the `psql` command line client.

You can use the Docker `--volume` option to mount a local directory as `/database.init/` inside the container.

```Shell

    #
    # Create a temp directory.
    tempdir=$(mktemp -d)
    
    #
    # Copy the SQL scripts into our temp directory
    cp "mysql/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempdir} mounted
    # as /database.init/ inside the container
    docker run \
        --detach \
        --name pgsql \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/pgsql'

```

Combining all of the above, we can create a named database,
initialise it with data from our SQL scripts, and then login
and run our tests.

```Shell

    #
    # Create our config file.
    tempcfg=$(mktemp)
    cat > "${tempcfg:?}" << EOF
adminuser=helen
adminpass=$(pwgen 10 1)

databasename=mydatabase
databaseuser=stephany
databasepass=$(pwgen 10 1)
EOF

    #
    # Create our scripts directory.
    tempdir=$(mktemp -d)
    cp "mysql/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"


    #
    # Run our database container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name pgsql \
        --volume "${tempdir}:/database.init/" \
        --volume "${tempcfg}:/database.config" \
       'cosmopterix/pgsql'


    #
    # Login and run a test.
    docker exec \
        --tty \
        --interactive \
        psql

            SELECT ra, decl FROM alpha_source ;

        \q

```
