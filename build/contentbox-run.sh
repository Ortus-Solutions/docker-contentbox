#!/bin/bash
set -e

cd ${APP_DIR}

#######################################################################################
# ContentBox BE Edition
#######################################################################################
if [[ $BE ]] && [[ $BE = true ]]; then
	echo ">INFO: Bleeding Edge installation specified. Overwriting install"
	box install contentbox-installer@be --production --force
fi;

#######################################################################################
# Express Edition
#######################################################################################
if [[ $EXPRESS ]] && [[ $EXPRESS == true ]]; then

	echo ">INFO: Express installation specified.  Configuring H2 Database."

	if [[ ! $H2_DIR ]]; then
		export H2_DIR=/data/contentbox/db
		# H2 Database Directory
		mkdir -p ${H2_DIR}
	fi

	echo ">INFO: H2 Database set to ${H2_DIR}"

	#check for a lock file and remove it so we can start up
	if [[ -f ${H2_DIR}/contentbox.lck ]]; then
		rm -f ${H2_DIR}/contentbox.lck
	fi

fi

#######################################################################################
# Enabling Rewrites
#######################################################################################
if [[ ! -f ${APP_DIR}/server.json ]]; then
	echo ">INFO: Enabling rewrites..."
	box server set web.rewrites.enable=true
fi

#######################################################################################
# INSTALLER
# If our installer flag has not been passed, then remove that module
#######################################################################################
if [[ ! $INSTALL ]] || [[ $INSTALL == false ]]; then
	echo ">INFO: Removing installer..."
	rm -rf ${APP_DIR}/modules/contentbox-installer
fi

#######################################################################################
# REMOVE_CBADMIN
# If true, then remove the contentbox admin
#######################################################################################
if [[ $REMOVE_CBADMIN ]] && [[ $REMOVE_CBADMIN == true ]]; then
	echo ">INFO: Removing admin module..."
	rm -rf ${APP_DIR}/modules/contentbox/modules/contentbox-admin
fi

#######################################################################################
# Media Directory
# Check for path environment variables and then apply convention routes to them if not specified
#######################################################################################
if [[ ! $contentbox_default_cb_media_directoryRoot ]]; then
	export contentbox_default_cb_media_directoryRoot=/app/modules_app/contentbox-custom/_content 
fi
# Create media directory, just in case.
mkdir -p $contentbox_default_cb_media_directoryRoot
echo ">INFO: Contentbox media root set as ${contentbox_default_cb_media_directoryRoot}"
echo "==> ContentBox Environment Finalized"

# Run CommandBox Now
${BUILD_DIR}/run.sh