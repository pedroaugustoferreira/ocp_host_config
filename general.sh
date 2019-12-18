#!/bin/bash -l

echo "StrictHostKeyChecking no"       >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null"   >> /etc/ssh/ssh_config
echo "LogLevel QUIET"                 >> /etc/ssh/ssh_config
