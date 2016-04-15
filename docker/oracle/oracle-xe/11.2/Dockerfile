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

FROM cosmopterix/oracle-linux:6.7-1
#FROM cosmopterix/oracle-linux:7.2-1
MAINTAINER Dave Morris <docker-admin@metagrid.co.uk>

#
# Tools for installing Oracle
RUN yum install -y bc
RUN yum install -y unzip
RUN yum install -y net-tools
RUN yum install -y unixODBC

#
# Temp fix
RUN mkdir /temp
COPY bin/oracle-shm /temp
COPY bin/chkconfig  /temp
COPY bin/init.ora   /temp
COPY bin/initXETemp.ora /temp


#
# Configure a shared memory device.
#COPY bin/oracle-shm /etc/init.d/oracle-shm
#RUN chmod 755 /etc/init.d/oracle-shm
#RUN /etc/init.d/oracle-shm start

#
#RUN mv /init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
#RUN mv /initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts
#
#RUN printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure
#
#RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc
#RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
#RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

#VOLUME /usr/lib/oracle/xe/oradata/XE

#EXPOSE 1521
#EXPOSE 8080

#COPY start.sh /
#RUN chmod 755 /start.sh
#
#CMD /start.sh

