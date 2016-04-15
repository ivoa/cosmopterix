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
: ${admindata:=postgres}
: ${adminuser:=postgres}
: ${adminpass:=$(pwgen 10 1)}

: ${serveruser:=postgres}
: ${serverdata:=/var/lib/pgsql/data}
: ${serverport:=5432}
: ${serveripv4:=0.0.0.0}
: ${serversock:=/var/lib/pgsql/pgsql.sock}
: ${serverlocale:=en_GB.UTF8}
: ${serverencoding:=UTF8}

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
serverlocale=${serverlocale}
serverencoding=${serverencoding}

#
# Database settings
databasename=${databasename}
databaseuser=${databaseuser}
databasepass=${databasepass}
EOF

#
# Create our password file
cat > /root/.pgpass << EOF
*:*:*:${adminuser}:${adminpass}
*:*:*:${databaseuser}:${databasepass}
EOF
chown root  /root/.pgpass
chgrp root  /root/.pgpass
chmod u=rw,g=,o= /root/.pgpass

#
# Start database server.
if [ "${1:-start}" = 'start' ]
then

    #
    # Set up the database directory.
    echo "Checking database directory [${serverdata}]"
    if [ ! -e "${serverdata:?}" ]
    then
        echo "Creating database directory [${serverdata}]"
        mkdir -p "${serverdata:?}"
    fi

    echo "Updating database directory [${serverdata}]"
    chown -R "${serveruser}" "${serverdata}"
    chgrp -R "${serveruser}" "${serverdata}"
    chmod 'u=rwx,g=,o=' "${serverdata}"

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

        pwfile=$(mktemp)
        echo "${adminpass}" > ${pwfile}
        chown "${serveruser}" ${pwfile}
        chgrp "${serveruser}" ${pwfile}
        chmod 'u=r,g=,o=' ${pwfile}
        
        gosu postgres \
            /usr/bin/initdb \
            --auth     md5 \
            --pgdata   ${serverdata} \
            --username ${adminuser} \
            --locale   ${serverlocale} \
            --encoding ${serverencoding} \
            --pwfile   ${pwfile}

        rm -f ${pwfile}

        #
        # Run a local instance.
        # Does not listen on TCP/IP and waits until start finishes
        echo "Running local PostgreSQL instance"
        gosu "${serveruser}" \
            /usr/bin/pg_ctl \
            --pgdata "${serverdata}"  \
            -o "-c listen_addresses=''" \
            -w start

        #
        # Create our user account.
        echo "Checking database user [${databaseuser}]"
        if [ "${databaseuser}" != "${adminuser}" ]
        then
            echo "Creating database user [${databaseuser}]"
            psql \
                --set ON_ERROR_STOP=1 \
                --username "${adminuser}" \
                --dbname   "${admindata}" \
                --command \
                "CREATE USER \"${databaseuser}\" WITH PASSWORD '${databasepass}'"
        fi

        #
        # Create our user database.
        echo "Checking database data [${databasename}]"
        if [ "${databasename}" != "${admindata}" ]
            then
            echo "Creating database data [${databasename}]"
            psql \
                --set ON_ERROR_STOP=1 \
                --username "${adminuser}" \
                --dbname   "${admindata}" \
                --command \
                "CREATE DATABASE \"${databasename}\" WITH OWNER \"${databaseuser}\""
        fi

        echo
        echo "Checking init directory [${databaseinit}]"
        if [ -d "${databaseinit}" ]
        then
            echo ""
            echo "Running init scripts"
            psqlcmd=(psql --set ON_ERROR_STOP=1 --username "${databaseuser}" --dbname "${databasename}" )
            for file in ${databaseinit}/*
            do
                case "${file}" in
                    *.sh)     echo "$0: running [${file}]"; source "${file}" ; echo ;;
                    *.sql)    echo "$0: running [${file}]"; "${psqlcmd[@]}" --file "${file}" ; echo ;;
                    *.sql.gz) echo "$0: running [${file}]"; gunzip --stdout "${file}" | "${psqlcmd[@]}" ; echo ;;
                    *)        echo "$0: ignoring [${file}]" ;;
                esac
            done
        fi

        #
        # Stop the local instance.
        echo "Shutting down local instance"
        gosu "${serveruser}" \
            /usr/bin/pg_ctl \
            --pgdata "${serverdata}"  \
            -m fast \
            -w stop

        echo ""
        echo "Initialization process complete."
        echo ""

	fi

    echo ""
    echo "Starting database service"
    gosu "${serveruser}" \
        /usr/bin/postgres \
            -h '*' \
            -D "${serverdata}" \
            -p "${serverport}" \

#
# PostgreSQL client
elif [ "${1}" = 'psql' ]
then

    echo ""
    echo "Running PostgreSQL client"
    psql \
        --user "${databaseuser}" \
        --dbname "${databasename}" \
        $@

#
# User command.
else

    echo ""
    echo "Running user command"
    
    exec "$@"

fi

