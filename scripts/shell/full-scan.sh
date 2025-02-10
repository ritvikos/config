#!/bin/bash

sudo systemctl stop clamav-freshclam

sudo freshclam
sudo apt update && sudo apt upgrade clamav clamav-daemon clamav-freshclam

sudo systemctl start clamav-freshclam
sudo systemctl enable clamav-freshclam

sudo clamdscan -i --multiscan --fdpass /
