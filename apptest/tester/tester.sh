#!/bin/bash
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -xeo pipefail
shopt -s nullglob

POD_NAME=$(kubectl get pod -oname \
         --namespace ${NAMESPACE} | \
         sed -n "/\\/${APP_INSTANCE_NAME}-cic-k8s-ingress-controller/s.pods\\?/..p")

POD_IP=$(kubectl get pods "${POD_NAME}" \
       --namespace ${NAMESPACE} -ojsonpath="{.status.podIP}")

POD_STATUS=$(kubectl get pods "${POD_NAME}" \
           --namespace ${NAMESPACE} -ojsonpath="{.status.phase}")

export POD_NAME
export POD_IP
export POD_STATUS

for test in /tests/*; do
  testrunner -logtostderr "--test_spec=${test}"
done
