#!/bin/bash

EXECUTION_PATH='/usr/local/bin'

## Stop systemctl service
sudo systemctl stop save_history.service
sudo systemctl disable save_history.service
sudo systemctl daemon-reload

## Remove files
sudo rm -f /etc/systemd/system/save_history.service
sudo rm -f $EXECUTION_PATH/save_history.sh

## Revert .bashrc modifications
sed -i '/\-save_history_installed$/d' ~/.bashrc

## Get list of current crontab jobs
crontab -l > /tmp/crontab.tmp

## Remove crontab job
sed -i '/\-save_history_installed$/d' /tmp/crontab.tmp

# Update the crontab with the modified file
crontab /tmp/crontab.tmp

# Remove temporary file
rm -f /tmp/crontab.tmp