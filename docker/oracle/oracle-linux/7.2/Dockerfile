#
# Copyright (c) 2015, ROE (http://www.roe.ac.uk/)
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

FROM oraclelinux:7.2
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# Declare the system cache as a volume.
VOLUME /var/cache/

#
# Install common admin tools.
RUN yum install -y sed
RUN yum install -y tar
RUN yum install -y zip
RUN yum install -y wget
RUN yum install -y nano
RUN yum install -y gzip
RUN yum install -y unzip
#RUN yum install -y pwgen
RUN yum install -y gnupg
RUN yum install -y which

#
# Set the terminal type for exec.
# https://github.com/docker/docker/issues/9299
ENV TERM xterm

#
# Add our install scripts. 
#COPY bin /usr/local/bin/
#RUN chmod a+x /usr/local/bin/*.sh

#
# Run our install scripts.
#RUN /usr/local/bin/install-locale.sh
#RUN /usr/local/bin/install-gosu.sh

