#!/bin/bash
#
# Copyright 2005-2014 WSO2, Inc. (http://wso2.com)
#
#      Licensed under the Apache License, Version 2.0 (the "License");
#      you may not use this file except in compliance with the License.
#      You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#      Unless required by applicable law or agreed to in writing, software
#      distributed under the License is distributed on an "AS IS" BASIS,
#      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#      See the License for the specific language governing permissions and
#      limitations under the License.
#

#set -e
source ./../setup-script/config.properties
source ./util.sh

JENKINS_HOME='/mnt/test'

NEW_JENKINS_WAR=/mnt/10.100.5.95/backup/2015-03-02/jenkins/repository/resources/jenkins.war
_echo_yellow "TODO: CHANGE ${NEW_JENKINS_WAR}"


_echo_green "Updating tenats in ${JENKINS_HOME}/repository/tenants with new jenkins war in ${NEW_JENKINS_WAR}"
for i in `ls ${JENKINS_HOME}/repository/tenants | sort -h`
do
   if  [ -f ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war ]; then

       _echo_cyan "\nUpdating Tenant ${i} "
       jar xvf ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war META-INF/context.xml
       echo "backup the jenkins.war in tenant ${i}"
       mv ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war_ori
       echo "coping jenkins.war to tenant ${i}"
       cp ${NEW_JENKINS_WAR} ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war
       echo "Adding context.xml to tenant ${i}"
       jar uvf ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war META-INF/context.xml
       echo "Removing the extracted context.xml from tenant ${i}"
       rm -rf META-INF/
       echo "Tenant ${i} [done]"
   fi
done