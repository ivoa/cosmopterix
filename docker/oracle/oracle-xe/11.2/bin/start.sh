#!/bin/bash
#
# Copyright 2015 Alexei Ledenev
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# https://github.com/alexei-led/docker-oracle-xe-11g/blob/master/start.sh
#

#
# Fix the hostname.
sed -i -E '
    s/HOST = [^)]+/HOST = $HOSTNAME/g
    ' /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora

#
# Start the service.
service oracle-xe start

#
# Forever loop just to prevent Docker container to exit.
while true; do sleep 1000; done
