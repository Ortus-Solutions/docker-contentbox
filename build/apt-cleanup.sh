#!/bin/bash
set -e

apt-get purge -y man perl-modules wget mercurial subversion
apt-get clean autoclean
apt-get autoremove -y

# More unecessary files
rm -rf /var/lib/{apt,dpkg,cache,log}/
# Remove Unecessary OS FIles
rm -rf /usr/share/icons /usr/share/doc /usr/share/man /usr/share/locale /tmp/*.*