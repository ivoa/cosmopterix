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
# Install directory
: ${servercode:=/usr/lib/hsqldb}
hsqldbdir=${servercode}/hsqldb-${hsqldbversion}/hsqldb
hsqldbbin=${hsqldbdir}/bin
hsqldblib=${hsqldbdir}/lib

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
: ${admindata:=hsqldb}
: ${adminuser:=hsqldb}
: ${adminpass:=$(pwgen 10 1)}

: ${serveruser:=hsqldb}
: ${serverdata:=/var/lib/hsqldb}
: ${serverport:=9001}
: ${serveripv4:=0.0.0.0}

: ${databasename:=$(pwgen 10 1)}}
: ${databaseuser:=$(pwgen 10 1)}}

if [ "${databaseuser}" == "${adminuser}" ]
then
    : ${databasepass:=${adminpass}}
else
    : ${databasepass:=$(pwgen 10 1)}
fi

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

#
# HSQLDB settings
hsqldbbin=${hsqldbbin}
hsqldblib=${hsqldblib}
hsqldbversion=${hsqldbversion}

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
    # Check the system user account.
    echo "Checking system user [${serveruser}]"
    if [ -z $(id -u "${serveruser}" 2> /dev/null) ]
    then
        echo "Creating system user [${serveruser}]"
        useradd \
            --system \
            --home-dir "${serverdata}" \
            "${serveruser}"
    fi

    #
    # Check the database directory.
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
    # Create our client properties file.
    cat > ${serverdata}/sqltool.rc << EOF
urlid ${databasename}
url jdbc:hsqldb:file:${serverdata}/${databasename};shutdown=true
username ${databaseuser}
password ${databasepass}
transiso TRANSACTION_READ_COMMITTED
EOF

    #
    # Check for user database.
    echo "Checking for database [${databasename}]"
    if [ ! -d "${serverdata}/${databasename}" ]
    then

        #
        # Create our user database.
        echo "Creating database [${databasename}]"
        gosu ${serveruser} \
            java \
                -classpath ${hsqldblib} \
                -jar ${hsqldblib}/sqltool.jar \
                --sql '' \
                ${databasename}

    fi

    #
    # SQLtool command
    toolcmd=( gosu "${serveruser}" )
    toolcmd+=( java )
    toolcmd+=( -classpath "${hsqldblib}" )
    toolcmd+=( -jar ${hsqldblib}/sqltool.jar )
    toolcmd+=( --autoCommit )
    toolcmd+=( ${databasename} )

    echo
    echo "Checking init directory [${databaseinit}]"
    if [ -d "${databaseinit}" ]
    then
        echo ""
        echo "Running init scripts"
        for file in ${databaseinit}/*; do
            case "${file}" in
                *.sh)     echo "Running [${file}]"; source "${file}" ; echo ;;
                *.sql)    echo "Running [${file}]"; cat "${file}" | "${toolcmd[@]}" ; echo ;;
                *.sql.gz) echo "Running [${file}]"; gunzip --stdout "${file}" | "${toolcmd[@]}" ; echo ;;
                *)        echo "Ignoring [${file}]" ;;
            esac
        done
    fi

    echo ""
    echo "Initialization process complete."
    echo ""

    #
    # Create our client properties file.
    cat > /root/sqltool.rc << EOF
urlid ${databasename}
url jdbc:hsqldb:hsql://localhost:${serverport}/${databasename}
username ${databaseuser}
password ${databasepass}
transiso TRANSACTION_READ_COMMITTED
EOF
    chown root:root  /root/sqltool.rc
    chmod u=rw,g=,o= /root/sqltool.rc

    #
    # Create our server properties file.
    cat > ${serverdata}/server.properties << EOF
server.port=${serverport}
server.address=${serveripv4}
server.database.0=${serverdata}/${databasename}
server.dbname.0=${databasename}
EOF

    echo ""
    echo "Starting database service"
    gosu "${serveruser}" \
        java \
        -classpath ${hsqldblib}/hsqldb.jar \
        org.hsqldb.server.Server \
        --props ${serverdata}/server.properties\

#
# SQLTool client.
elif [ "${1}" = 'sqltool' ]
then

    shift

    echo ""
    echo "Running SQLTool client"
    java \
        -classpath ${hsqldblib} \
        -jar ${hsqldblib}/sqltool.jar \
        ${databasename} \
        $@

#
# User command.
else

    echo ""
    echo "Running user command"
    
    exec "$@"

fi

