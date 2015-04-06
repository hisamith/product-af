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

RESET_CLR='\033[00;00m'
RED="\033[33;31m"
GREEN="\033[33;32m"
MAGENTA="\033[33;35m"
CYAN="\033[33;36m"
YELLOW="\033[33;33m"

function _echo_red() {
    MSG=${1}
    echo -e "${RED}${MSG}${RESET_CLR}"
}

function _echo_green() {
    MSG=${1}
    echo -e "${GREEN}${MSG}${RESET_CLR}"
}

function _echo_cyan() {
    MSG=${1}
    echo -e "${CYAN}${MSG}${RESET_CLR}"
}

function _echo_yellow() {
    MSG=${1}
    echo -e "${YELLOW}${MSG}${RESET_CLR}"
}

function _check_error() {
    STATUS=${1}
    ERROR_MSG=${2}
    EXIT=${3}
    if [ ${STATUS} -ne 0 ]; then
        _echo_red "${ERROR_MSG}"
        if [ "$EXIT" = true ] ; then
            cd ${UPGRADE_HOME}
            exit 1
        fi
    fi
}

function _yes_no_check() {
    local RESPONSE=${1}
    local SUCCESS_MSG=${2}
    local  ERROR_MSG=${3}
    local  EXIT=${4}
    if [[ ! $RESPONSE =~ ^[Yy]$ ]]; then
        _echo_yellow "${ERROR_MSG}"
        if [ "$EXIT" = true ] ; then
        exit 1
    fi
    else
        _echo_green "${SUCCESS_MSG}"
    fi
}