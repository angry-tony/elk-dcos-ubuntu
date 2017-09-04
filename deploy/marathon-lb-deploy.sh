#!/bin/bash

DCOS_MASTER_NODE_IP=192.0.220.102

curl -k -v https://${DCOS_MASTER_NODE_IP}/ca/dcos-ca.crt -o /tmp/dcos-ca.crt
dcos config set core.ssl_verify /tmp/dcos-ca.crt
dcos auth login --username=root --password=a

dcos security org service-accounts keypair marathon-lb-privatekey.pem marathon-lb-publickey.pem
dcos security org service-accounts create -p marathon-lb-publickey.pem -d "Marathon-LB service account" mlb-principal
dcos security secrets create-sa-secret --strict marathon-lb-privatekey.pem mlb-principal marathon-lb/marathon-lb-sn

curl -X PUT --cacert /tmp/dcos-ca.crt \
-H 'Content-Type: application/json' \
-H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:services:%252F \
-d '{"description":"Allows access to any service launched by the native Marathon instance"}'

curl -X PUT --cacert /tmp/dcos-ca.crt \
-H 'Content-Type: application/json' \
-H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:admin:events \
-d '{"description":"Allows access to Marathon events"}' 

curl -X PUT --cacert /tmp/dcos-ca.crt \
-H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:services:%252F/users/mlb-principal/read

curl -X PUT --cacert /tmp/dcos-ca.crt \
-H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/acs/api/v1/acls/dcos:service:marathon:marathon:admin:events/users/mlb-principal/read

#curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @marathon-lb.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'
curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @marathon-lb.json https://${DCOS_MASTER_NODE_IP}:8443/v2/apps -H 'Content-Type: application/json'
