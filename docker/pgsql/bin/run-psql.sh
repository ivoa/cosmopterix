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
# Load our database settings.
source /database.saved 

#
# Create our password file
if [ ! -e "${HOME}/.pgpass" ]
then
    echo "*:*:*:${databaseuser}:${databasepass}" > "${HOME}/.pgpass"
    chown "$(id -un)" "${HOME}/.pgpass"
    chgrp "$(id -un)" "${HOME}/.pgpass"
    chmod u=rw,g=,o=  "${HOME}/.pgpass"
fi

#
# Connect to our database.
eval "psql --user \"${databaseuser}\" --dbname \"${databasename}\" $@"

