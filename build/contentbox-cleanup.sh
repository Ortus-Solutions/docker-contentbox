#!/bin/bash
set -ex

#######################################################################################
# Ckleanup Routines
#######################################################################################
echo "==> Starting ContentBox Cleanup"

# Clear downloaded artifacts
box artifacts clean --force
# Cleanup CommandBox files
rm -rfv $COMMANDBOX_HOME/cfml/system/config/server-icons/*.*
# Remove any temp files
rm -rf $COMMANDBOX_HOME/temp/*
# Remove any log files
rm -rf $COMMANDBOX_HOME/logs/*
# Remove cachebox caches
rm -rf $COMMANDBOX_HOME/cfml/system/mdCache/*
# Remove the felix cache
rm -rf $COMMANDBOX_HOME/engine/cfml/cli/lucee-server/felix-cache/*

# Cleanup
# More unecessary files
rm -rf /var/lib/{cache,log}/
# Remove Unecessary OS FIles
rm -rf /usr/share/icons /usr/share/doc /usr/share/man /usr/share/locale /tmp/*.*

echo "==> ContentBox Cleanup complete"