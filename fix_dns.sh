#!/bin/bash

sudo chattr -i /etc/resolv.conf

sudo echo "nameserver 8.8.8.8" > /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" >> /etc/resolv.conf

sudo echo "[network]" >> /etc/wsl.conf
sudo echo "generateResolvConf = false" >> /etc/wsl.conf

sudo chattr +i /etc/resolv.conf
