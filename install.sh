#!/bin/bash
systemctl disable magic_helper;
systemctl disable log-last-arp;
cp ./magic_helper.service /usr/lib/systemd/system/;
cp ./log-last-arp.service /usr/lib/systemd/system/;
systemctl daemon-reload;
systemctl enable magic_helper;
systemctl enable log-last-arp;
systemctl start magic_helper;
systemctl start log-last-arp;
