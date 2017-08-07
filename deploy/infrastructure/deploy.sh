#!/bin/bash
############## PARAMETERS #########################
ELASTIC_NAME=elasticsearch
ELASTIC_EXECUTOR_NAME=elasticsearch-executor
KIBANA_NAME=kibana
KIBANA_FQDN=192.0.210.103
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

curl -X POST --data-binary @elasticdeploy.json http://marathon.mesos:8080/v2/apps --header "Content-Type:application/json"
sleep 5
curl -X POST --data-binary @kibanadeploy.json http://marathon.mesos:8080/v2/apps --header "Content-Type:application/json"
