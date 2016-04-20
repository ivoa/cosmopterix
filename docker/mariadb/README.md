This container is based on the [Fedora](../fedora/23) base container, using the OS package manager to install the
[MariaDB](https://mariadb.org/) database server and client.

Running the container with no arguments will create a new database, with random database name, user name and password.

```
    #
    # Run a container in the background. 
    docker run \
        --detach \
        --name 'albert' \
       'cosmopterix/mariadb'

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
    admindata=mysql
    adminuser=root
    adminpass=lieng3gaeY

    ....
    
    #
    # Database settings
    databasename=Oreeleif3i
    databaseuser=Hiegh4ooyu
    databasepass=Aht3Shisho
```

The entry point script checks for a `/database.config` script file
at startup. If the config file is found it is executed using the
bash `source` command.

This provides a method for setting environment variables at the
begining of the initialization process which can then be used  by
the rest of the entrypoint script.

* The entry point script uses `adminuser` and `adminpass` environment
variables to configure the server admin account.
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
       'cosmopterix/mariadb'

```

In this container, the adminuser will be set to `helen`, and the 
database name and user name will be `testdb` and `stephany`.

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
    admindata=mysql
    adminuser=helen
    adminpass=aingo2aiY4

    ....

    #
    # Database settings
    databasename=testdb
    databaseuser=stephany
    databasepass=ahTahbi3zo

```

The entry point script also checks for `.sh`, `.sql` or `.sql.gz` files
in the `/database.init/` directory inside the container.

* Shell script, `*.sh`, files will be executed inside the container using the database server login.
* SQL, `*.sql`, files will be run on the new database using the `mysql` command line client.
* Gzipped, `*.sql.gz`, files will be unzipped and then run on the new database using the `mysql` command line client.

You can use the Docker `--volume` option to mount a local directory as `/database.init/` inside the container.

```

    #
    # Create a temp directory.
    tempdir=$(mktemp -d)
    
    #
    # Copy our SQL scripts into the temp directory
    cp "mariadb/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql"   "${tempdir}/002.sql"

    #
    # Run our database container with ${tempdir} mounted
    # as /database.init/ inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/mariadb'

```

In this container, the new database will be initialized with the SQL commands
from the `alpha-source.sql` and `alpha-source-data.sql` SQL files.

```
    docker logs \
        --follow \
        'albert'

    ....
    ....
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

```

The container image also includes a startup script for the the`mysql` commandline client.

Using the Docker `exec` command to run `mysql-client` will launch the mysql commandline client and automatically connects it to the new database.

```
    docker exec \
        --tty \
        --interactive \
        'albert' \
        'msql-client'

        SHOW DATABASES ;

        \q

```

Combining these fatures, we can create a new database,
initialise it with data from our SQL scripts, and then
login and run our tests.

```
    #
    # Create our config file.
    tempcfg=$(mktemp)
    cat > "${tempcfg:?}" << EOF
databasename=testdb
databaseuser=stephany
databasepass=$(pwgen 10 1)
EOF

    #
    # Create our scripts directory.
    tempdir=$(mktemp -d)
    cp "mariadb/sql/alpha-source.sql" "${tempdir}/001.sql"
    cp "data/alpha-source-data.sql" "${tempdir}/002.sql"

    #
    # Run our database container with ${tempcfg} mounted
    # as /database.config inside the container
    docker run \
        --detach \
        --name 'albert' \
        --volume "${tempdir}:/database.init/" \
       'cosmopterix/mariadb'

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

