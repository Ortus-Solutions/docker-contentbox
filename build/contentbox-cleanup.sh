#!/bin/bash
set -e

#######################################################################################
# Ckleanup Routines
#######################################################################################
# Cleanup CommandBox files
rm -Rf /root/.CommandBox/temp/*.* /root/.CommandBox/cfml/system/mdCache/*.* /root/.CommandBox/cfml/system/config/server-icons/*.*
# Remove Unecessary OS FIles
rm -Rf /usr/share/icons /usr/share/doc /usr/share/man /usr/share/locale /tmp/*.*