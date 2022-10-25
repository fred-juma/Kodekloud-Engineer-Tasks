#!/bin/bash

yum install zip -y && \
zip -r /backup/xfusioncorp_beta.zip /var/www/html/beta && \
scp /backup/xfusioncorp_beta.zip clint@172.16.238.16:/backup