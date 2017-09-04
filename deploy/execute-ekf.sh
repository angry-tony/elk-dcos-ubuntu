#!/bin/bash
ELASTIC_SERVICE_NAME=elasticsearch
HOST_VOLUMES_PATH=elasticsearch-data
CONTAINER_VOLUMES_PATH='usr\/share\/elasticsearch\/data'
ELA_CLUSTER_NAME=ELASTICCLUSTER
ELA_NETWORK_HOST=RUNING_ELA_ON_SLAVE_NODE_IP

KIBANA_SERVICE_NAME=kibana

PRIVATE_KEY_NAME=id_rsa
############## PARAMETERS #########################

sed -i 's/CHANGE_ELASTIC_SERVICE_NAME/'${ELASTIC_SERVICE_NAME}'/g' elasticdeploy.json
sed -i 's/CHANGE_HOST_VOLUMES_PATH/'${HOST_VOLUMES_PATH}'/g' elasticdeploy.json
sed -i 's/CHANGE_CONTAINER_VOLUMES_PATH/'${CONTAINER_VOLUMES_PATH}'/g' elasticdeploy.json
sed -i 's/CHANGE_ELA_CLUSTER_NAME/'${ELA_CLUSTER_NAME}'/g' elasticdeploy.json
sed -i 's/CHANGE_ELA_NETWORK_HOST/'${ELA_NETWORK_HOST}'/g' elasticdeploy.json

sed -i 's/CHANGE_ELASTIC_SERVICE_NAME/'${ELASTIC_SERVICE_NAME}'/g' kibanadeploy.json
sed -i 's/CHANGE_KIBANA_SERVICE_NAME/'${KIBANA_SERVICE_NAME}'/g' kibanadeploy.json

sed -i 's/CHANGE_ELASTIC_SERVICE_NAME/'${ELASTIC_SERVICE_NAME}'/g' filebeatdeploy.sh


#
curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @elasticdeploy.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'
#
#curl -u elastic http://RUNING_ELA_ON_SLAVE_NODE_IP:9200
sleep 5
#
curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @kibanadeploy.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'
