#!/bin/bash
rm ../yourKey/PLACEyourKEYhere

ssh-add ../yourKey/!PRIVATEKEYNAME!
# Will be prompted for you passphrase

sudo yum install jq -y
curl --unix-socket /run/dcos/3dt.sock http://localhost/system/health/v1/nodes | jq '.nodes[].host_ip' | sed 's/\"//g' | sed '/172/d' > nodes.txt

cat nodes.txt | while read line
do
   ssh root@$line -o StrictHostKeyChecking=no -i ../yourKey/id_rsa < ./deployFilebeatNodes.sh
done
