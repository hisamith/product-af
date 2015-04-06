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


source ./config.properties
source ./utils.sh
source ./puppet_utils.sh
source ./backup_configs.sh
source ./backup_function.sh


read -p $'\e[33m01). Have you updated dev, test and prod IPs with correct values in /etc/hosts?(y/n)\e[0m: ' response
_yes_no_check $response "" "Please update dev, test and prod IPs with correct values in /etc/hosts and re run the script" true


read -p $'\e[33m02). Have you configured PEM_PATH correctly in backup_configs.sh?(y/n)\e[0m: ' response
_yes_no_check $response $PEM_PATH "Please update PEM_PATH correctly in backup_configs.sh and rerun the script" true

if [[ ! $response =~ ^[Yy]$ ]]
then
        _echo_yellow "\nPlease update dev, test and prod IPs with correct values in /etc/hosts and re run the script"
        exit 1
fi

if [ -d "$CURRENT_BACKUP_DIR" ]; then
    _echo_yellow "\nRemoving ${CURRENT_BACKUP_DIR}"
    rm -rf -I ${CURRENT_BACKUP_DIR}
fi
mkdir -p ${CURRENT_BACKUP_DIR}/

#_echo_green "\n[JENKINS] Backing up jenkins..."
#_backup JENKINS_DATA
#
#_echo_green "\n[GITBLIT] Backing up gitblit..."
#_backup GITBLIT_DATA
#
#_echo_green "\n[S2GITBLIT] Backing up s2gitblit..."
#_backup S2GITBLIT_DATA
#
_echo_green "\n[LDAP] Backing up ldap..."
_backup LDAP_DATA
#
_echo_green "\n[PAAS_DEV_AS] Backing up PAAS DEV AS..."
_backup_paas_as PAAS_DEV_AS_DATA

_echo_green "\n[PAAS_TEST_AS] Backing up PAAS TEST AS..."
_backup_paas_as PAAS_TEST_AS_DATA

_echo_green "\n[PAAS_PROD_AS] Backing up PAAS PROD AS..."
_backup_paas_as PAAS_PROD_AS_DATA

#_echo_green "\n[MYSQL] Back up mysql databases..."
#pull_from_master "backup.devsetup"
#echo -e "Moving mysql dumps from ${MYSQL_PUPPET_BK_DIR} to ${CURRENT_BACKUP_DIR}/"
#mv  ${MYSQL_PUPPET_BK_DIR} ${CURRENT_BACKUP_DIR}/

_echo_yellow "\n***Please update /etc/hosts again since when backing up it might have changed!***"
