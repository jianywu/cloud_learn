#!/bin/bash

sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_9.3.1_amd64.deb
sudo dpkg -i grafana-enterprise_9.3.1_amd64.deb