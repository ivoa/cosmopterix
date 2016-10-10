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

FROM cosmopterix/oracle-linux:7.2-1.1
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# Original code copied from madhead/docker-oracle-xe.
# https://github.com/madhead/docker-oracle-xe

# Pre-requirements
RUN mkdir -p /run/lock/subsys

RUN yum install -y libaio bc initscripts net-tools

# Install Oracle XE
ADD rpm/oracle-xe-11.2.0-1.0.x86_64.rpm.tar.gz /tmp/
RUN yum localinstall -y \
    /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm; \
    rm -rf /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

# Configure instance
ADD cfg/* /u01/app/oracle/product/11.2.0/xe/config/scripts/
RUN chown oracle:dba /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp
RUN chmod 755        /u01/app/oracle/product/11.2.0/xe/config/scripts/*.ora \
                     /u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID  XE
ENV PATH        $ORACLE_HOME/bin:$PATH

RUN /etc/init.d/oracle-xe configure responseFile=/u01/app/oracle/product/11.2.0/xe/config/scripts/xe.rsp

# Run the startup script.
ADD bin/start.sh /
RUN chmod a+x /start.sh
CMD /start.sh

EXPOSE 1521
EXPOSE 8080
