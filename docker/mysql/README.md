This container is based on the [Fedora](../fedora/23) base container.

The Docker file uses the distribution package manager to install the [MySQL](https://www.mysql.com/) database server and client.

Running the container with no arguments will create a new database, with random database name, user name and password.

```Shell
    #
    # Run a container in the foreground. 
    docker run \
       'cosmopterix/mysql'
```

    Checking data directory [/var/lib/mysql]
    Updating data directory [/var/lib/mysql]
    Checking socket directory [/var/lib/mysql]
    Checking for database data [mysql]
    Creating database data [mysql]
    ....
    ....
    Configuring admin account [root]
    Checking user database [Ce8cu9aigh]
    Creating user database [Ce8cu9aigh]
    Checking user account [quuPaa6aik]
    Creating user account [quuPaa6aik]
    Creating user access [quuPaa6aik][Ce8cu9aigh]
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
       'cosmopterix/mysql'
```

The Docker `ps` command will list running containers.

```Shell
    #
    # List the active containers.
    docker ps
```

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    9b9635dd4587        cosmopterix/mysql   "/usr/local/bin/entry"   3 seconds ago       Up 2 seconds        3306/tcp            hungry_aryabhata

When running in the background, you need to use use the Docker `stop` command with either the container id or name to stop the container.

```Shell
    #
    # Stop an active container.
    docker stop 9b9635dd4587
```

Naming the container makes it easier to refer to it in subsequent commands.

```Shell
    #
    # Run a named container in the background.
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/mysql'
```

```Shell
    #
    # List the active containers.
    docker ps
```

    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    1fd0fbc7167e        cosmopterix/mysql   "/usr/local/bin/entry"   6 seconds ago       Up 5 seconds        3306/tcp            albert

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
    # Run a bash shell in a running container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'bash'

        ls -al

        exit
```

The container entrypoint script saves deatils of the database configuration in a `/database.save` file inside the container.

You can use the Docker `exec` command to connect to the container and read the `/database.save` config file.

```Shell
    #
    # Display the contents of /database.save in the container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        cat '/database.save'

```

    #
    # Admin settings
    admindata=mysql
    adminuser=root
    adminpass=lieng3gaeY

    ....
    
    #
    # Database settings
    databasename=Oreeleif3i
    databaseuser=Hiegh4ooyu
    databasepass=Aht3Shisho

The entry point script checks for a `/database.config` script file
at startup. If the config file is found it is run using the bash shell
`source` command.

This can be used to set some environment variables at the begining
to be uused by the rest of the entrypoint script.

* The entry point script uses `adminuser` and `adminpass` environment
variables to configure the database server admin account.
* The entry point script uses `databasename` `databaseuser` and `databasepass`
environment variables to configure the new database.
* If the values are not specified then random default values are generated.

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
       'cosmopterix/mysql'

```

In this container, the adminuser will be set to `helen`, and the 
database name and user name will be `testdb` and `stephany`.

```Shell
    #
    # Display the contents of /database.save in the container.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        cat '/database.save'

```

    #
    # Admin settings
    admindata=mysql
    adminuser=helen
    adminpass=aingo2aiY4

    ....

    #
    # Database settings
    databasename=testdb
    databaseuser=stephany
    databasepass=ahTahbi3zo

The entry point script also checks for `.sh`, `.sql` or `.sql.gz` files
in the `/database.init/` directory inside the container.

* Shell script, `*.sh`, files will be run inside the container.
* SQL, `*.sql`, files will be run on the new database using the `mysql` command line client.
* Gzipped, `*.sql.gz`, files will be unzipped and then run on the new database using the `mysql` command line client.

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
       'cosmopterix/mysql'

```

In this container, the new database will have been initialized with the SQL
commands from the `alpha-source.sql` and `alpha-source-data.sql` SQL files.

```Shell
    docker logs \
        --follow \
        'albert'
```

    Running local instance
    ....
    Checking user database [eiGheeseM0]
    Creating user database [eiGheeseM0]
    Checking user account [vee0aseo5Z]
    Creating user account [vee0aseo5Z]
    Creating user access [vee0aseo5Z][eiGheeseM0]

    Checking init directory [/database.init]

    Running init scripts
    /usr/local/bin/entrypoint: running [/database.init/001.sql]
    /usr/local/bin/entrypoint: running [/database.init/002.sql]
    ....

The container image also includes a startup script for the the`mysql` commandline client.

Using the Docker `exec` command to run `mysql-client` will launch the mysql commandline client and automatically connect it to the new database.

```Shell
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'msql-client'

        SHOW DATABASES ;

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
       'cosmopterix/mysql'

    #
    # Login and run a test.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'mysql-client'

            SELECT id, ra, decl FROM alpha_source ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10,10 ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 OFFSET 10 ;
            SELECT id, ra, decl FROM alpha_source LIMIT 4294967295 OFFSET 10 ;

            \q

```

