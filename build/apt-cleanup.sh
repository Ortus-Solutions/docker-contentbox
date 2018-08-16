#!/bin/bash
set -e

apt-get purge -y man perl-modules wget mercurial subversion jq
apt-get clean autoclean
apt-get autoremove -y

# More unecessary files
rm -rf /var/lib/{apt,dpkg,cache,log}/