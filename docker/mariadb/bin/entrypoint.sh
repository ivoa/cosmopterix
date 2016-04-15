#!/bin/sh
#
# Copyright (c) 2016, ROE (http://www.roe.ac.uk/)
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#
# Strict error checking.
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

#
# Database configuration.
: ${databaseconfig:=/database.config}
if [ -e "${databaseconfig}" ]
then
    source "${databaseconfig}"
fi

#
# Saved configuration.
: ${databasesave:=/database.save}
if [ -e "${databasesave}" ]
then
    source "${databasesave}"
fi

#
# Database initialization.
: ${databaseinit:=/database.init}

#
# Default setings
: ${admindata:=mysql}
: ${adminuser:=root}
: ${adminpass:=$(pwgen 10 1)}

: ${serveruser:=mysql}
: ${serverdata:=/var/lib/mysql}
: ${serverport:=3306}
: ${serveripv4:=0.0.0.0}
: ${serversock:=/var/lib/mysql/mysql.sock}

# ${serverlocale:=en_GB.UTF8}
# ${serverencoding:=UTF8}

: ${databasename:=$(pwgen 10 1)}}
: ${databaseuser:=$(pwgen 10 1)}}

if [ "${databaseuser}" == "${adminuser}" ]
then
    : ${databasepass:=${adminpass}}
else
    : ${databasepass:=$(pwgen 10 1)}
fi

#
# Saved configuration.
cat > "${databasesave}" << EOF
#
# Admin settings
admindata=${admindata}
adminuser=${adminuser}
adminpass=${adminpass}

#
# System settings
serveruser=${serveruser}
serverdata=${serverdata}
serverport=${serverport}
serveripv4=${serveripv4}
serversock=${serversock}
#serverlocale=${serverlocale}
#serverencoding=${serverencoding}

#
# Database settings
databasename=${databasename}
databaseuser=${databaseuser}
databasepass=${databasepass}
EOF

#
# Start database server.
if [ "${1:-start}" = 'start' ]
then

    #
    # Set up the database directory.
    echo "Checking data directory [${serverdata}]"
    if [ ! -e "${serverdata:?}" ]
    then
        echo "Creating data directory [${serverdata}]"
        mkdir -p "${serverdata:?}"
    fi

    echo "Updating data directory [${serverdata}]"
    chown -R "${serveruser}" "${serverdata}"
    chgrp -R "${serveruser}" "${serverdata}"
    chmod u=rwx "${serverdata}"

    #
    # Set up the socket directory.
    echo "Checking socket directory [$(dirname ${serversock})]"
    if [ ! -e "$(dirname ${serversock})" ]
    then
        echo "Creating socket directory [$(dirname ${serversock})]"
        mkdir -p "$(dirname ${serversock})"
        chown -R "${serveruser}" "$(dirname ${serversock})"
        chgrp -R "${serveruser}" "$(dirname ${serversock})"
        chmod u=rwx "$(dirname ${serversock})"
    fi

    #
    # Check for existing database.
    # TODO Just check for any files, not just admindata.     
    echo "Checking for database data [${admindata}]"
	if [ ! -e "${serverdata}/${admindata}" ]
	then

        #
        # Initialise our database.
        echo "Creating database data [${admindata}]"
        gosu mysql mysql_install_db \
            --user="${serveruser}" \
            --datadir="${serverdata}" \
            --skip-name-resolve

        #
        # Run a local instance.
        echo "Running local instance"
        gosu "${serveruser}" \
            mysqld_safe \
                --socket="${serversock}" \
                --skip_networking \
                --skip_name_resolve \
                --datadir="${serverdata}" \
                &

        #
        # Wait for the local instance.
       echo "Waiting for local instance"
       for i in {10..0}
        do
            if [ ! -S "${serversock}" ]
            then
                echo "[${i}] ...."
                sleep 1
            fi
        done

        #
        # Configure the admin account.
        echo "Configuring admin account [${adminuser}]"
        mysql \
            --user=root \
            --protocol='socket' \
            --socket="${serversock}" \
            << EOF
-- What's done in this file shouldn't be replicated
--  or products like mysql-fabric won't work
SET @@SESSION.SQL_LOG_BIN=0;
DELETE FROM mysql.user ;
CREATE USER '${adminuser}'@'%' IDENTIFIED BY '${adminpass}' ;
GRANT ALL ON *.* TO '${adminuser}'@'%' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;        
EOF

        #
        # Create our user database.
        echo "Checking user database [${databasename}]"
        if [ "${databasename}" != "${admindata}" ]
        then

            echo "Creating user database [${databasename}]"
            mysqladmin \
                --protocol='socket' \
                --socket="${serversock}" \
                --user="${adminuser}" \
                --password="${adminpass}" \
                create "${databasename}"

        fi

        #
        # Create our user account.
        echo "Checking user account [${databaseuser}]"
        if [ "${databaseuser}" != "${adminuser}" ]
        then

            #
            # Create our database user
            echo "Creating user account [${databaseuser}]"
            mysql \
                --protocol='socket' \
                --socket="${serversock}" \
                --user="${adminuser}" \
                --password="${adminpass}" \
                --execute \
                "CREATE USER
                    '${databaseuser}'@'%'
                 IDENTIFIED BY
                    '${databasepass}'
                    "

            #
            # Grant access to our database
            echo "Creating user access [${databaseuser}][${databasename}]"
            mysql \
                --protocol='socket' \
                --socket="${serversock}" \
                --user="${adminuser}" \
                --password="${adminpass}" \
                --execute \
                "GRANT ALL ON
                    ${databasename}.*
                 TO
                    '${databaseuser}'@'%'
                    "

        fi

        echo
        echo "Checking init directory [${databaseinit}]"
        if [ -d "${databaseinit}" ]
        then
            echo ""
            echo "Running init scripts"
            mysqlcmd=( mysql --protocol='socket' --socket="${serversock}" --user="${adminuser}" --password="${adminpass}" --database="${databasename}" )
            for file in ${databaseinit}/*
            do
                case "${file}" in
                    *.sh)     echo "$0: running [${file}]"; source "${file}" ; echo ;;
                    *.sql)    echo "$0: running [${file}]"; "${mysqlcmd[@]}" < "${file}" ; echo ;;
                    *.sql.gz) echo "$0: running [${file}]"; gunzip --stdout "${file}" | "${mysqlcmd[@]}" ; echo ;;
                    *)        echo "$0: ignoring [${file}]" ;;
                esac
            done
        fi

        #
        # Shutdown the local instance.
        echo "Shutting down local instance"
        mysqladmin \
            --protocol='socket' \
            --socket="${serversock}" \
            --user="${adminuser}" \
            --password="${adminpass}" \
            shutdown

        echo ""
        echo "Initialization process complete."
        echo ""

	fi

    #
    # Create our local password file
    cat > /root/.my.cnf << EOF
[client]
host = localhost
port = ${serverport}
protocol = socket
database = ${databasename}
user = ${databaseuser}
password = ${databasepass}
EOF
    chown root:root  /root/.my.cnf
    chmod u=rw,g=,o= /root/.my.cnf

    echo ""
    echo "Starting database service"
    gosu "${serveruser}" \
        mysqld_safe \
            --datadir "${serverdata}"

#
# MariaDB client
elif [ "${1}" = 'mysql' ]
then

    echo ""
    echo "Running MariaDB client"
    mysql \
        $@

#
# User command.
else

    echo ""
    echo "Running user command"
    
    exec "$@"

fi

