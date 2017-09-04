#!/bin/bash

#sudo yum install jq -y
#curl --unix-socket /run/dcos/3dt.sock http://localhost/system/health/v1/nodes | jq '.nodes[].host_ip' | sed 's/\"//g' | sed '/172/d' > nodes.txt

sudo tee nodes.txt <<-EOF 
192.0.220.101
192.0.220.102
EOF

cat nodes.txt | while read line
do
   ssh root@$line -o StrictHostKeyChecking=no < ./filebeatdeploy.sh
done
