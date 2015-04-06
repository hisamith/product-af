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
source ./restore_functions.sh

_echo_green "\n[PAAS_DEV_AS] Restore last backed up data to PAAS DEV AS..."
_replace_paas_as PAAS_DEV_AS_DATA

#_echo_green "\n[PAAS_TEST_AS] Restore last backed up data to PAAS TEST AS..."
#_replace_paas_as PAAS_TEST_AS_DATA
#
#_echo_green "\n[PAAS_PROD_AS] Restore last backed up data to PAAS PROD AS..."
#_replace_paas_as PAAS_PROD_AS_DATA