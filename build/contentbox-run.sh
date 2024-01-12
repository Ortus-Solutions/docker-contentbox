#!/bin/bash
set -ex

# Move into CommandBox image work dir
cd ${APP_DIR}

#######################################################################################
# ContentBox BE Edition
# This has to be here, since our original image is baked with the latest stable
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

	echo ">INFO: H2 Database set to ${H2_DIR}/contentbox"

	touch /app/.env
	printf "DB_CONNECTIONSTRING=jdbc:hsqldb:file:$H2_DIR/contentbox;sql.ignore_case=true\n" >> /app/.env
	printf "DB_BUNDLEVERSION=2.7.2.jdk11\n" >> /app/.env
	printf "DB_BUNDLENAME=org.lucee.hsqldb\n" >> /app/.env
	printf "DB_CLASS=org.hsqldb.jdbc.JDBCDriver\n" >> /app/.env
	printf "DB_DATABASE=contentbox\n" >> /app/.env
	printf "DB_USER=SA\n" >> /app/.env
	printf "DB_PASSWORD=\n" >> /app/.env
	printf "DB_GRAMMAR=MySQLGrammar@qb\n" >> /app/.env


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

#######################################################################################
# CONTENTBOX_MIGRATE AND RUN - Fail if migrations do not execute
#######################################################################################
echo ">INFO: Running any outstanding ContentBox migrations..."
cd $APP_DIR && box migrate install manager=contentbox && box migrate up manager=contentbox && ${BUILD_DIR}/run.sh