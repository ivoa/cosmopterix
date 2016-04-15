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
# Version numbers
gosuversion=1.7
#systemarch=$(uname --hardware-platform)
systemarch=amd64

echo ""
echo "Installing gosu [${gosuversion:?}][${systemarch:?}]"

#
# Use a temp directory.
tempdir=$(mktemp -d)
pushd "${tempdir:?}"

    #
    # Download the files.
    echo "Downloading files"
    wget --quiet -O 'gosu'     "https://github.com/tianon/gosu/releases/download/${gosuversion:?}/gosu-${systemarch:?}"
    wget --quiet -O 'gosu.asc' "https://github.com/tianon/gosu/releases/download/${gosuversion:?}/gosu-${systemarch:?}.asc"

    #
    # Verify the signature.
    echo "Checking signature"
    gpg --quiet --homedir "$(pwd)" --keyserver 'ha.pool.sks-keyservers.net' --recv-keys 'B42F6819007F00F88E364FD4036A9C25BF357DD4'
    gpg --quiet --homedir "$(pwd)" --batch --verify 'gosu.asc' 'gosu'

    #
    # Install the binary
    echo "Installing binary"
    mv 'gosu' '/usr/local/bin/gosu'
    chmod a+x '/usr/local/bin/gosu'

    #
    # Test the program.
    echo "Testing gosu"
    gosu nobody true

popd

#
# Tidy up the temp directory.
echo "Final tidy up"
rm -rf "${tempdir:?}"

