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

#Fedora 26 2017-07-20
#FROM fedora@sha256:b27b4c551b1d06be25a3c76c1a9ceefd7ff189f6f8b1711d3e4b230c2081bff3
#Fedora 26 2017-10-25
FROM fedora@sha256:613830d906f8897c05fd737aea8c7c00e4ecb5a518eedf71958c2c110532957c
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# Declare the system cache as a volume.
VOLUME /var/cache/

#
# Clean and update the yum cache
RUN dnf clean all
RUN dnf makecache

#
# Install common admin tools.
RUN dnf install -y sed
RUN dnf install -y tar
RUN dnf install -y zip
RUN dnf install -y wget
RUN dnf install -y nano
RUN dnf install -y gzip
RUN dnf install -y pwgen
RUN dnf install -y gnupg
RUN dnf install -y which

#
# Install dnf admin tools.
RUN dnf install -y dnf-plugins-core

#
# Set the terminal type for exec.
# https://github.com/docker/docker/issues/9299
ENV TERM xterm

#
# Add our install scripts. 
COPY bin /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.sh

#
# Run our install scripts.
RUN /usr/local/bin/install-locale.sh
RUN /usr/local/bin/install-gosu.sh

