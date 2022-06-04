#!/bin/bash
systemctl disable magic_helper;
cp ./magic_helper.service /usr/lib/systemd/system;
systemctl daemon-reload;
systemctl enable magic_helper;
systemctl start magic_helper;
