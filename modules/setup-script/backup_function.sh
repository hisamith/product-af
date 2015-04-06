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
source ./config.properties
source ./utils.sh


# This function will backup the folders specified in "folders_to_backup" in the given node which is specified in the
# "source_dir"
# Input Array should contain following details
# "source_dir"          - Source directory. ex: /mnt/10.10.10.14/appfactory/wso2appfactory-2.1.0
# "backup_dir"          - ex: /mnt/backup//wso2appfactory-2.1.0
# "folders_to_backup"   - Relative paths of the folders to be back up on the node as space sperated values.
#                         ex: "repository/tenants repository/components". Note that when updating or restoring, it will
#                         replace the {source_dir}/{folders_to_backup} with {backup_dir}/{folders_to_backup}
function _backup(){
    local -n inputArray=$1
    local SOURCE=${inputArray["source_dir"]}
    local DESTINATION=${inputArray["backup_dir"]}
    local BACKUP_FOLDERS_ARRAY=( ${inputArray["folders_to_backup"]})

    cd ${SOURCE}
    _check_error $? "Source ${SOURCE} directory not found" true

    for folder in "${BACKUP_FOLDERS_ARRAY[@]}"
    do
        echo -e "Copying from ${SOURCE}/${folder} to ${DESTINATION}/${folder}"
        mkdir -p ${DESTINATION}/
        cp -r --parents ./${folder} ${DESTINATION}/
        _check_error $? "Error occured while copying from ${SOURCE}/${folder} to ${DESTINATION}/${folder}" true
    done
    cd ${UPGRADE_HOME}

}

# This function will backup the folders specified in "folders_to_backup" in the given app server
# Input Array should contain following details
# "source_dir"          - source directory. ex: /mnt/10.10.10.14/wso2as-5.2.1
# "paas_ip"             - IP or URI of the PAAS instance. ex: appserver.dev.appfactory.private.wso2.com
# "backup_dir"          - Directory which should place the backup. ex: /mnt/backup//paas_dev_as
# "folders_to_backup"   - Relative paths of the folders to be back up on the app server as space sperated values.
#                         ex: "repository/tenants repository/components". Note that when updating or restoring, it will
#                         replace the {source_dir}/{folders_to_backup} with {backup_dir}/{folders_to_backup}
function _backup_paas_as() {
    local -n inputArray=$1
    local PASS_HOST_IP=${inputArray["paas_ip"]}
    local SOURCE=ubuntu@${PASS_HOST_IP}:${inputArray["source_dir"]}
    local DESTINATION=${inputArray["backup_dir"]}/repository
    local BACKUP_FOLDERS_ARRAY=( ${inputArray["folders_to_backup"]})

    eval USR_HOME_DIR=~$USER
    ssh-keygen -f "${USR_HOME_DIR}/.ssh/known_hosts" -R ${PASS_HOST_IP}
    for folder in "${BACKUP_FOLDERS_ARRAY[@]}"
    do
        echo -e "Copying from ${SOURCE}/${folder} to ${DESTINATION}/${folder}"
        mkdir -p ${DESTINATION}
        scp -i ${PEM_PATH} -r ${SOURCE}/${folder} ${DESTINATION}/

    done
    cd ${UPGRADE_HOME}
}




