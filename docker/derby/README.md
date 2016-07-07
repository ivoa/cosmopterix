This container is based on the [Cosmopterix Java 8](../java/8) base container.
The container build script downloads and installs version 10.12.1.1 of the [Apache Derby](https://db.apache.org/derby/)
database from the Apache website.

Running the container with no arguments will create a new database, with random database name, user name and password.

```
    #
    # Run a container in the background. 
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/derby'

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
            # Admin settings
            adminuser=derby
            adminpass=Ciewila2di

            #
            # System settings
            serveruser=derby
            serverdata=/var/lib/derby
            serverport=1527
            serveripv4=0.0.0.0

            #
            # Derby settings
            derbybin=/usr/lib/derby/db-derby-10.12.1.1-bin
            derbylib=/usr/lib/derby/db-derby-10.12.1.1-bin/lib
            derbyversion=10.12.1.1

            #
            # Database settings
            databasename=Zatha0ohpa
            databaseuser=ahpod7eeWu
            databasepass=taiseh3Ahh

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
       'cosmopterix/derby'

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
            #
            # Database settings
            databasename=testdb
            databaseuser=stephany
            databasepass=joo9Liephe

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
    cp "derby/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempdir} mounted
    # as /database.init/ inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/derby'

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
                ij version 10.12
                CONNECTION0* - 	jdbc:derby:Medainoo9i
                ....

            Running [/database.init/002.sql]
                ij version 10.12
                CONNECTION0* - 	jdbc:derby:Medainoo9i
                ....

```

The container image also includes a startup script for the `ij` commandline client.

Using the Docker `exec` command to run `derby-client` will launch the `ij` commandline client and automatically connect it to the database.

```
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'derby-client'

            SHOW TABLES ;

            EXIT;

```

Using these tools we can create a new database, initialise it with data from our SQL scripts,
and then login and run our tests.

```
    #
    # Create our scripts directory.
    tempdir=$(mktemp -d)
    cp "derby/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/derby'

    #
    # Login and run our tests.
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'derby-client'

            SELECT id, ra, decl FROM alpha_source ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 ;
            SELECT id, ra, decl FROM alpha_source OFFSET 10 ;
            SELECT id, ra, decl FROM alpha_source LIMIT 10 OFFSET 10 ;

            EXIT;

```

