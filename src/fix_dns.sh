#!/bin/bash

# Script name: fix_dns.sh
# Description: Fix WSL 2 DNS overwriting bug on Windows 10.
# Commit ID: $Id$
# Last Author: $Author$
# Commit Date: $Date$
# Revision: $Revision$
# Repository URL: $HeadURL$
# Full path: $Source$

# OpenDNS/Cisco Umbrella: 208.67.222.222 208.67.220.220
# Google DNS: 8.8.8.8 8.8.4.4

# CloudFlare DNS used by default here
DNS1="1.1.1.1"
DNS2="1.0.0.1"

if [[ -n "$1" ]]; then
    DNS1="$1"
fi

if [[ -n "$2" ]]; then
    DNS2="$2"
fi

if [[ $EUID -ne 0 ]]; then
  echo -e "This script must be run as root. Please use 'sudo'... \n" 1>&2
  exit 1
fi

if sudo chattr -i /etc/resolv.conf; then
    echo -e "Immutable flag removed from '/etc/resolv.conf'... \n"
else
    echo -e "Failed to remove the immutable flag from '/etc/resolv.conf'... \n" >&2
    exit 1
fi

{
  echo -e "nameserver $DNS1"
  echo -e "nameserver $DNS2\n"
} | sudo tee /etc/resolv.conf > /dev/null

echo -e "DNS nameservers set to $DNS1 and $DNS2 in '/etc/resolv.conf'... \n"

{
  echo -e "[network]\n"
  echo -e "generateResolvConf = false\n"
} | sudo tee -a /etc/wsl.conf > /dev/null

echo -e "WSL configuration updated to prevent automatic 'resolv.conf' generation... \n"

if sudo chattr +i /etc/resolv.conf; then
  echo -e "Immutable flag added to '/etc/resolv.conf'... \n"
else
  echo -e "Failed to add the immutable flag to '/etc/resolv.conf'... \n" >&2
  exit 1
fi
