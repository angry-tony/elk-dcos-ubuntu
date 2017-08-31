#!/bin/bash
curl -X POST --cacert /tmp/dcos-ca.crt -H "Authorization: token=$(dcos config show core.dcos_acs_token)" --data-binary @marathon-lb-for-elk.json https://marathon.mesos:8443/v2/apps -H 'Content-Type: application/json'
