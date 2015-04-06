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

. ./config.properties
. ./utils.sh

function remove_cartridge_mainifests() {
    echo -ne  "Removing Cartridge puppet manifest....."
    sudo rm -rf /etc/puppet/manifests/*
    sudo rm -rf /etc/puppet/modules/*
    echo -ne "                           [OK]\n"
}

function remove_agent_certificates() {
    echo -ne "Removing previous agent certificates..."
    sudo rm -rf /var/lib/puppet/ssl/*
    echo -ne "                           [OK]\n"
}

function clean_puppet_data() {
    remove_cartridge_mainifests
    remove_agent_certificates
}

# Pull the node from puppet master. Note: Must be root to run this method
# Parametes:
#   NODE_NAME   - ex. backup.devsetup
function pull_from_master() {
    local NODE_NAME=${1}
    if [ $(whoami) != 'root' ]; then
            _echo_red "Must be root to run puppet agent on node ${NODE_NAME}"
            exit 1;
    fi
    clean_puppet_data
    #constructing the pattern to beused in uniqueid
    numeric="0-9"
    pattern=$DEV_ID$numeric

    # generating a unique name for this node
    NODE_UNIQUE_ID=$(cat /dev/urandom | tr -dc $pattern | fold -w 6 | head -n 1 | tr '[:upper:]' '[:lower:]' )

    NODE_UNIQUE_CERTNAME="$NODE_UNIQUE_ID-${NODE_NAME}"
    puppet agent --enable ; puppet agent -vt  --certname  $NODE_UNIQUE_CERTNAME  2>&1 | tee -a setup-logs/puppet${TIME_STAMP}.log; puppet agent --disable;

}