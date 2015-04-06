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

# This function will replace the files in the given node(Specified in the source_dir).
# Input Array should contain following details
# "source_dir"          - Source directory. ex: /mnt/10.10.10.14/appfactory/wso2appfactory-2.1.0
# "backup_dir"          - Directory which contains the backed up folders. ex: /mnt/backup//wso2appfactory-2.1.0
# "folders_to_update"   - Relative paths of the folders to be updated on the app server as space sperated values.
#                         ex: "repository/tenants repository/components". Note that when updating, it will replace the
#                         {source_dir}/{folder_to_update} with {backup_dir}/{folder_to_update}
function _replace(){
    local -n inputArray=$1
    local SOURCE=/mnt/test
    local BACKUP_DIR=${inputArray["backup_dir"]}
    local UPGRADE_FOLDERS_ARRAY=( ${inputArray["folders_to_update"]})

    cd ${BACKUP_DIR}
    _check_error $? "Source ${BACKUP_DIR} directory not found" true

    for folder in "${UPGRADE_FOLDERS_ARRAY[@]}"
    do
        echo -e "Replacing from ${BACKUP_DIR}/${folder} to ${SOURCE}/${folder}"
        cp -r --parent ./${folder} ${SOURCE}/
        _check_error $? "Error occured while replacing from ${SOURCE}/${folder} to ${DESTINATION}/${folder}" true
    done
    cd ${UPGRADE_HOME}
}

# This function will replace the files in PAAS App Servers.
# Input Array should contain following details
# "source_dir"          - source directory. ex: /mnt/10.10.10.14/wso2as-5.2.1
# "paas_ip"             - IP or URI of the PAAS instance. ex: appserver.dev.appfactory.private.wso2.com
# "backup_dir"          - Directory which contains the backed up folders. ex: /mnt/backup//paas_dev_as
# "folders_to_update"   - Relative paths of the folders to be updated on the app server as space sperated values.
#                         ex: "repository/tenants repository/components". Note that when updating, it will replace the
#                         {source_dir}/{folder_to_update} with {backup_dir}/{folder_to_update}
function _replace_paas_as(){
    local -n inputArray=$1
    local SOURCE=${inputArray["source_dir"]}
    local PASS_HOST_IP=${inputArray["paas_ip"]}
    local FULL_HOST=ubuntu@${PASS_HOST_IP}
    local BACKUP_DIR=${inputArray["backup_dir"]}
    local UPGRADE_FOLDERS_ARRAY=( ${inputArray["folders_to_update"]})
    local TMP_DIR="temp"
    eval USR_HOME_DIR=~$USER

    echo "Removing ECDSA key for ${PASS_HOST_IP}"
    ssh-keygen -f "${USR_HOME_DIR}/.ssh/known_hosts" -R ${PASS_HOST_IP}

    for folder in "${UPGRADE_FOLDERS_ARRAY[@]}"
    do
        echo -e "Removing existing files and directories under ubutnu@${PASS_HOST_IP}:${SOURCE}/${folder}"
        # Here we are creating a temporary directory and giving permission 777, since we cannot scp as root
        ssh -i ${PEM_PATH} -l ubuntu ${PASS_HOST_IP} "sudo rm -rf -I ${SOURCE}/${folder}/* && \
        sudo mkdir -p ${SOURCE}/${folder}/${TMP_DIR} && sudo chmod -R 777 ${SOURCE}/${folder}/${TMP_DIR}"

        echo -e "Copying from ${BACKUP_DIR}/${folder} to ubutnu@${PASS_HOST_IP}:${SOURCE}/${folder}/${TMP_DIR}"
        scp -i ${PEM_PATH} -r ${BACKUP_DIR}/${folder}/* ${FULL_HOST}:${SOURCE}/${folder}/${TMP_DIR}/

        # Moving data to correct directory and and remove temp directory
        echo -e "Moving from ${SOURCE}/${folder}/${TMP_DIR} to ${SOURCE}/${folder}/"
        ssh -i ${PEM_PATH} -l ubuntu ${PASS_HOST_IP} "sudo mv ${SOURCE}/${folder}/${TMP_DIR}/* ${SOURCE}/${folder}/ && \
        sudo rm -rf ${SOURCE}/${folder}/${TMP_DIR}"
    done
    cd ${UPGRADE_HOME}
}

_replace_paas_as PAAS_DEV_AS_DATA

#_echo_yellow "\nRemoving /mnt/test/*"
#rm -rf -I /mnt/test/*
#
#_echo_green "\n[JENKINS] Migrating previous data to jenkins..."
#_replace JENKINS_DATA
#_echo_green "\n[JENKINS] Upgrade jenkins war"
#./set_jenkinks.sh
#
#_echo_green "\n[GITBLIT] Migrating previous data to gitblit..."
#_replace GITBLIT_DATA
#
#_echo_green "\n[S2GITBLIT] Migrating previous data to s2gitblit..."
#_replace S2GITBLIT_DATA
#
#_echo_green "\n[LDAP] Migrating previous data to ldap..."
#_replace LDAP_DATA
#
#_echo_green "\n[DB] Backing up database..."
#_echo_red TODO

