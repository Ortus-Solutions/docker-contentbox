#!/bin/bash
set -ex

# Move to CommandBox app Directory
cd ${APP_DIR}

# Create Image Version File for debugging purposes
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo ">INFO: Creating Image Version File - ${TAGS} - ${IMAGE_VERSION} at ${TIMESTAMP} > ${APP_DIR}/.image-version"
echo "${TAGS} - ${IMAGE_VERSION} at ${TIMESTAMP}" > ${APP_DIR}/.image-version

# Install ContentBox Latest Stable
echo ">INFO: Latest Stable Release installation specified."
box install contentbox-installer --production

# Remove DSN creator no need to use it
rm -Rf ${APP_DIR}/modules/contentbox-dsncreator
# Remove unecessary apidocs
rm -Rfv ${APP_DIR}/**/apidocs/**

# Ensure the modules_app directory exists or ACF will blow up
mkdir -p ${APP_DIR}/modules_app

# Ensure no server.json file exists
rm -f ${APP_DIR}/server.json

# Copy over our resources
echo ">INFO: Copying over ContentBox Container Overrides"
cp -rvf ${BUILD_DIR}/contentbox-app/* ${APP_DIR}

# Debug the App Dir
#echo "Final App Dir"
#ls -la ${APP_DIR}
#cat ${APP_DIR}/Application.cfc
#cat ${APP_DIR}/config/CacheBox.cfc

# Cleanup copied resources
echo ">INFO: Cleanup resources"
rm -Rfv ${BUILD_DIR}/contentbox-app

# Debug LS
ls -la ${APP_DIR}
echo "==> ContentBox and dependencies installed"

#######################################################################################
# WARM UP THE ENGINE
#######################################################################################
#${BUILD_DIR}/util/warmup-server.sh
#echo "==> Engine Warmup Complete!"

# Run Cleanups
$BUILD_DIR/contentbox/contentbox-cleanup.sh