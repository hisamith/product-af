#!/bin/bash

JENKINS_HOME='/mnt/10.100.5.95/buildserver/wso2as-5.2.1'
for i in `ls ${JENKINS_HOME}/repository/tenants | sort -h`
do
   if  [ -f ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war ]; then

       echo -n "Updating Tenant ${i} "
       jar xvf ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war META-INF/context.xml
       echo "backup the jenkins.war"
       mv ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war_ori
       echo "coping jenkins.war to ${i}"
       cp ${JENKINS_HOME}/repository/resources/jenkins.war ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war
       echo "Adding context.xml to ${i}"
       jar uvf ${JENKINS_HOME}/repository/tenants/${i}/webapps/jenkins.war META-INF/context.xml
       read
       echo "Removing ${i} the context.xml"
       rm -rf META-INF/
       echo "Tenant ${i} [done]"
   fi
done