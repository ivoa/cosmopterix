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

FROM cosmopterix/fedora:23-1.1
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# PostgreSQL version
ENV pgsqlversion=9.4.9

#
# Default port number.
ENV serverport 5432
EXPOSE ${serverport}

#
# Default data path.
ENV serverdata /var/lib/pgsql
VOLUME ${serverdata}

#
# Add our shell scripts. 
COPY bin /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

#
# Run our install script.
RUN /usr/local/bin/install-pgsql

#
# Install our entrypoint script.
ENTRYPOINT ["/usr/local/bin/entrypoint"]

#
# The default entrypoint command.
CMD ["start"]

