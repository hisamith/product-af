#!/bin/sh
#
# Copyright 2015  WSO2, Inc. (http://wso2.com)
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

# !/bin/bash

#set -o nounset

PEM_PATH=/home/samith/WSO2/AppFactory/pem/appfackey.pem

UPGRADE_HOME=`pwd`

# Product versions
APPFACTORY_VERSION=2.1.0-SNAPSHOT
APIM_VERSION=1.7.0
BAM_VERSION=2.4.1
AS_VERSION=5.2.1
MB_VERSION=2.2.0
UES_VERSION=1.1.0
ACTIVEMQ_VERSION=5.9.1
BPS_VERSION=3.2.0
STORAGE_VERSOIN=1.1.0

INSTALLATION_DIR=/mnt/$MACHINE_IP/
afpath=$INSTALLATION_DIR/appfactory/wso2appfactory-$APPFACTORY_VERSION
bampath=$INSTALLATION_DIR/bam/wso2bam-$BAM_VERSION
mbpath=$INSTALLATION_DIR/mb/wso2mb-$MB_VERSION
aspath=$INSTALLATION_DIR/buildserver/wso2as-$AS_VERSION
bpspath=$INSTALLATION_DIR/bps/wso2bps-$BPS_VERSION
uespath=$INSTALLATION_DIR/ues/wso2ues-$UES_VERSION
apimpath=$INSTALLATION_DIR/api-manager/wso2am-$APIM_VERSION
gitblitpath=$INSTALLATION_DIR/gitblit
s2gitblitpath=$INSTALLATION_DIR/s2gitblit



DATE_COMMAND=$(which date)
TIME_STAMP=`${DATE_COMMAND} '+%Y-%m-%d'`
TIME_STAMP="2015-03-02"

# This is the location where puppet will store the sql dumps.
# This value should be equal to dump_dir argument of the backup.devsetup and restore.devsetup nodes in puppet master
MYSQL_PUPPET_BK_DIR=/mnt/backups/mysqldump

BACKUP_HOME=/mnt/${MACHINE_IP}/backup
TODAY="$(date +'%d-%m-%Y')"
CURRENT_BACKUP_DIR=${BACKUP_HOME}/${TIME_STAMP}

JENKINS_BK_DIR=${CURRENT_BACKUP_DIR}/jenkins
GITBLIT_BK_DIR=${CURRENT_BACKUP_DIR}/gitblit
S2GITBLIT_BK_DIR=${CURRENT_BACKUP_DIR}/s2gitblit
LDAP_BK_DIR=${CURRENT_BACKUP_DIR}/ldap


##### PAAS DEV APP SERVER ######
paas_dev_ip='appserver.dev.appfactory.private.wso2.com'
paas_dev_as_path=/mnt/1*/wso2as-5.2.1
paas_dev_bk_dir=${CURRENT_BACKUP_DIR}/paas_dev_as
declare -A PAAS_DEV_AS_DATA=(
["paas_ip"]=${paas_dev_ip} \
["paas_path"]=${paas_dev_as_path} \
["source_dir"]=${paas_dev_as_path} \
["backup_dir"]=${paas_dev_bk_dir} \
["folders_to_backup"]="repository/tenants" \
["folders_to_update"]="repository/tenants" \
["folders_to_restore"]="repository/tenants")

##### PAAS TEST APP SERVER ######
paas_test_ip='appserver.test.appfactory.private.wso2.com'
paas_test_as_path=/mnt/1*/wso2as-5.2.1
paas_test_bk_dir=${CURRENT_BACKUP_DIR}/paas_test_as
declare -A PAAS_TEST_AS_DATA=(
["paas_ip"]=${paas_test_ip} \
["paas_path"]=${paas_test_as_path} \
["source_dir"]=${paas_test_as_path} \
["backup_dir"]=${paas_test_bk_dir} \
["folders_to_backup"]="repository/tenants" \
["folders_to_update"]="repository/tenants" \
["folders_to_restore"]="repository/tenants")

##### PAAS PROD APP SERVER ######
paas_prod_ip='appserver.appfactory.private.wso2.com'
paas_prod_as_path=/mnt/1*/wso2as-5.2.1
paas_prod_bk_dir=${CURRENT_BACKUP_DIR}/paas_prod_as
declare -A PAAS_PROD_AS_DATA=(
["paas_ip"]=${paas_prod_ip} \
["paas_path"]=${paas_prod_as_path} \
["source_dir"]=${paas_prod_as_path} \
["backup_dir"]=${paas_prod_bk_dir} \
["folders_to_backup"]="repository/tenants" \
["folders_to_update"]="repository/tenants" \
["folders_to_restore"]="repository/tenants")

declare -A JENKINS_DATA=(
["source_dir"]=${aspath} \
["backup_dir"]=${JENKINS_BK_DIR} \
["folders_to_backup"]="repository/tenants repository/jenkins repository/resources/jenkins.war" \
["folders_to_update"]="repository/tenants repository/jenkins" \
["folders_to_restore"]="repository/tenants repository/jenkins")

declare -A S2GITBLIT_DATA=(
["source_dir"]=${s2gitblitpath} \
["backup_dir"]=${S2GITBLIT_BK_DIR} \
["folders_to_backup"]="data" \
["folders_to_update"]="data/git data/groovy data/gitblit.properties" \
["folders_to_restore"]="data")

declare -A GITBLIT_DATA=(
["source_dir"]=${gitblitpath} \
["backup_dir"]=${GITBLIT_BK_DIR} \
["folders_to_backup"]="data" \
["folders_to_update"]="data/git data/groovy data/gitblit.properties" \
["folders_to_restore"]="data")

declare -A LDAP_DATA=(
["source_dir"]=${afpath} \
["backup_dir"]=${LDAP_BK_DIR} \
["folders_to_backup"]="repository/data/org.wso2.carbon.directory" \
["folders_to_update"]="repository/data/org.wso2.carbon.directory" \
["folders_to_restore"]="repository/data/org.wso2.carbon.directory")