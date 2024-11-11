#!/bin/sh

sudo -s -- <<END_SUDO_EXECUTION
cp /etc/keyd/keyd.conf /etc/keyd/keyd.conf.save
cp ./keyd.conf /etc/keyd/keyd.conf
keyd reload
END_SUDO_EXECUTION
