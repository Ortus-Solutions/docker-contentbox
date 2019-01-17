#!/bin/bash
set -e

#######################################################################################
# Ckleanup Routines
#######################################################################################
echo "==> Starting ContentBox Cleanup"

# Cleanup CommandBox files
rm -rf /root/.CommandBox/temp/*.* /root/.CommandBox/cfml/system/mdCache/*.* /root/.CommandBox/cfml/system/config/server-icons/*.*

echo "==> ContentBox Cleanup complete"