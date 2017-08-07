#!/bin/bash

# sudo wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.1-amd64.deb --no-check-certificate
# sudo dpkg -i filebeat-5.2.1-amd64.deb
# https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html
# curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.5.1-x86_64.rpm
# sudo rpm -vi filebeat-5.5.1-x86_64.rpm
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-x86_64.rpm
sudo rpm -vi filebeat-5.0.0-x86_64.rpm


sudo mkdir -p /var/log/dcos
sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.BAK

sudo tee /etc/filebeat/filebeat.yml <<-EOF 
filebeat.prospectors:
- input_type: log
  paths:
    - /var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stdout
    - /var/lib/mesos/slave/slaves/*/frameworks/*/executors/*/runs/latest/stderr
    - /var/log/mesos/*.log
    - /var/log/dcos/dcos.log
tail_files: true
output.elasticsearch:
   hosts: ["elasticsearch-executor.elasticsearch.mesos:1025"]
EOF

sudo tee /etc/systemd/system/dcos-journalctl-filebeat.service<<-EOF 
[Unit]
Description=DCOS journalctl parser to filebeat
Wants=filebeat.service
After=filebeat.service

[Service]
Restart=always
RestartSec=5
ExecStart=/bin/sh -c 'journalctl --no-tail -f      \
  -u dcos-3dt.service                      \
  -u dcos-logrotate-agent.timer            \
  -u dcos-3dt.socket                       \
  -u dcos-mesos-slave.service              \
  -u dcos-adminrouter-agent.service        \
  -u dcos-minuteman.service                \
  -u dcos-adminrouter-reload.service       \
  -u dcos-navstar.service                  \
  -u dcos-adminrouter-reload.timer         \
  -u dcos-rexray.service                   \
  -u dcos-cfn-signal.service               \
  -u dcos-setup.service                    \
  -u dcos-download.service                 \
  -u dcos-signal.timer                     \
  -u dcos-epmd.service                     \
  -u dcos-spartan-watchdog.service         \
  -u dcos-gen-resolvconf.service           \
  -u dcos-spartan-watchdog.timer           \
  -u dcos-gen-resolvconf.timer             \
  -u dcos-spartan.service                  \
  -u dcos-link-env.service                 \
  -u dcos-vol-discovery-priv-agent.service \
  -u dcos-logrotate-agent.service          \
  > /var/log/dcos/dcos.log 2>&1'
ExecStartPre=journalctl --vacuum-size=10M

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 0755 /etc/systemd/system/dcos-journalctl-filebeat.service
sudo systemctl daemon-reload
sudo systemctl start dcos-journalctl-filebeat.service
sudo systemctl enable dcos-journalctl-filebeat.service
sudo systemctl start filebeat
sudo systemctl enable filebeat

