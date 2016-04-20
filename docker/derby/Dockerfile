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

FROM cosmopterix/java:8-1.0
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# Derby version
ENV derbyversion=10.12.1.1

#
# Default port number.
ENV serverport 1527
EXPOSE ${serverport}

#
# Default code path.
ENV servercode /usr/lib/derby

#
# Default data path.
ENV serverdata /var/lib/derby
VOLUME ${serverdata}

#
# Add our install scripts. 
COPY bin /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

#
# Run our install scripts.
RUN /usr/local/bin/install-derby

#
# Install our entry point script.
ENTRYPOINT ["/usr/local/bin/entrypoint"]

#
# Set the default command.
CMD ["start"]

