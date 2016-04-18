This container is based on the Cosmopterix Fedora [base container](../fedora/23).

The Docker file uses the distribution package manager to install the [PostgreSQL](http://www.postgresql.org/) database server and command line client.

Running the container with no arguments will create a new database, with random database name, user name and password.

```Shell
    #
    # Run a container in the foreground. 
    docker run \
       'cosmopterix/pgsql'
```

    Checking database directory [/var/lib/pgsql]
    Updating database directory [/var/lib/pgsql]
    Checking socket directory [/var/lib/pgsql]
    Checking for database data [postgres]
    Creating database data [postgres]
    ....
    ....
    Checking database user [neDei3iewa]
    Creating database user [neDei3iewa]
    CREATE ROLE
    Checking database data [Athie6uJ0i]
    Creating database data [Athie6uJ0i]
    CREATE DATABASE
    ....
    ....
    Initialization process complete.
    Starting database service
    

When running in the foreground, you can use `Ctrl+C` to stop the container.

The Docker `--detach` option will run the container in the background.

```Shell
    #
    # Run a container in the background. 
    docker run \
        --detach \
       'cosmopterix/pgsql'
```

The Docker `ps` command will list running containers.

```Shell
    #
    # List the active containers.
    docker ps
```

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    9b9635dd4587        cosmopterix/pgsql   "/usr/local/bin/entry"   3 seconds ago       Up 2 seconds        5432/tcp            hungry_aryabhata

When running in the background, you need to use use the Docker `stop` command with either the container id or name to stop the container.

```Shell
    #
    # Stop an active container.
    docker stop 9b9635dd4587
```

Naming the container makes it easier to refer to it in subsequent commands.

```Shell
    #
    # Run a container in the background.
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/pgsql'
```

```Shell
    #
    # List the active containers.
    docker ps
```

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    668c480863b2        cosmopterix/pgsql   "/usr/local/bin/entry"   3 seconds ago       Up 2 seconds        5432/tcp            albert

To use the same name again you need to stop and then remove the container. 

```Shell
    #
    # Stop an active container.
    docker stop albert
```

```Shell
    #
    # Remove a container.
    docker rm albert
```

The stop and remove steps can be nested together as a single command using `$()` .

```Shell
    #
    # Stop and remove the container.
    docker rm $(docker stop 'albert')
```

The Docker `exec` command can be used to connect to a running container and run
another program, for example the following command will start a bash shell
inside the container.

```Shell
    #
    # Run a container in the background.
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/pgsql'
```

```Shell
    #
    # Run a bash shell in the running container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'bash'

        ls -al
        pwd
        exit
```

```Shell
    #
    # Stop and remove the container.
    docker rm $(docker stop 'albert')
```

The container entrypoint script saves deatils of the database configuration in a `/database.save` file inside the container.

You can use the Docker `exec` command to connect to the container and read the `/database.save` config file.

```Shell
    #
    # Run a container in the background.
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/pgsql'
```
 
```Shell
    #
    # Display the contents of /database.save in the container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        cat '/database.save'

```

```Shell
    #
    # Stop and remove the container.
    docker rm $(docker stop 'albert')
```

The entry point script checks for a `/database.config` script file
at startup. If the config file is found it is run using the bash shell
`source` command.

The entry point script uses `adminuser` and `adminpass` environment
variables to configure the database server admin account.
If the values are not specified then random default values are generated.

The entry point script uses `databasename` `databaseuser` and `databasepass`
environment variables to configure the new database.
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
       'cosmopterix/pgsql'

```

In this container, the adminuser will be set to `helen`, and the 
database name and user name will be `testdb` and `stephany`.

The entry point script also checks for `.sh`, `.sql` or `.sql.gz` files
in the `/database.init/` directory inside the container.

* Shell script, `.sh`, files will be run as root inside the container.
* SQL, `.sql`, files will be run on the new database using the `psql` command line client.
* Gzipped, `.sql.gz`, files will be unzipped and then run on the new database using the `psql` command line client.

You can use the Docker `--volume` option to mount a local directory as `/database.init/` inside the container.

```Shell

    #
    # Create a temp directory.
    tempdir=$(mktemp -d)
    
    #
    # Copy our SQL scripts into the temp directory
    cp "mysql/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempdir} mounted
    # as /database.init/ inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/pgsql'

```

In this container, the new database will have been initialized with the SQL
commands from the `alpha-source.sql` and `alpha-source-data.sql` SQL files.

The container image also includes a startup script for the the`psql` commandline client.

Using the Docker `exec` command to run `psql-client` will launch the psql commandline client and automatically connect it to the new database.

```Shell
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'psql-client'

        \l
        \q

```

Combining all of the above, we can create a database with
specific username and passwords, initialise the database with
data from our SQL scripts, and then login
and run our tests.

```Shell

    #
    # Create our config file.
    tempcfg=$(mktemp)
    cat > "${tempcfg:?}" << EOF
adminuser=helen
adminpass=$(pwgen 10 1)

databasename=testdb
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
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
        --volume "${tempcfg}:/database.config" \
       'cosmopterix/pgsql'


    #
    # Login and run a test.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        psql

            SELECT ra, decl FROM alpha_source ;

        \q

```

