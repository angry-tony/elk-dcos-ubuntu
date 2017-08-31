#!/bin/bash
############## PARAMETERS #########################
ELASTIC_NAME=elasticsearch
ELASTIC_EXECUTOR_NAME=elasticsearch-executor
KIBANA_NAME=kibana
KIBANA_FQDN=192.0.220.103 #public node ip
PRIVATE_KEY_NAME=id_rsa
############## PARAMETERS #########################

sed -i 's/!ELASTICNAME!/'${ELASTIC_NAME}'/g' elasticdeploy.json
sed -i 's/!ELASTICEXECUTORNAME!/'${ELASTIC_EXECUTOR_NAME}'/g' elasticdeploy.json

sed -i 's/!ELASTICNAME!/'${ELASTIC_NAME}'/g' kibanadeploy.json
sed -i 's/!ELASTICEXECUTORNAME!/'${ELASTIC_EXECUTOR_NAME}'/g' kibanadeploy.json
sed -i 's/!KIBANANAME!/'${KIBANA_NAME}'/g' kibanadeploy.json
sed -i 's/!KIBANAFQDN!/'${KIBANA_FQDN}'/g' kibanadeploy.json

sed -i 's/!ELASTICNAME!/'${ELASTIC_NAME}'/g' ../filebeat/deployFilebeatNodes.sh
sed -i 's/!ELASTICEXECUTORNAME!/'${ELASTIC_EXECUTOR_NAME}'/g' ../filebeat/deployFilebeatNodes.sh
sed -i 's/!PRIVATEKEYNAME!/'${PRIVATE_KEY_NAME}'/g' ../filebeat/copyPrerequisitesNodes.sh

curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @elasticdeploy.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'

sleep 5

curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @kibanadeploy.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'
