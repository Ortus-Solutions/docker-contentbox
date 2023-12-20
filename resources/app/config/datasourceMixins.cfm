<cfscript>

	isExpress = request.$envHelper.getSystemSetting( "EXPRESS", false );

	// Express H2SQL Database
	if( isExpress ){

		dbDirectory = request.$envHelper.getSystemSetting( "H2_DIR", '/data/contentbox/db' );

		datasourceConfig = {
			class 			 	: 'org.h2.Driver',
			connectionString 	: 'jdbc:h2:' & dbDirectory & '/contentbox;MODE=MySQL',
			storage			 	: true,
			clob 				: true,
			blob 				: true
		};

		this.ormSettings[ "dialect" ] = "MySQL";
	}
	// Else traditional RDBMS
	else {

		//ACF Syntax Datasources
		if( len( request.$envHelper.getSystemSetting( "DB_DRIVER" ) ) ){
			dbExpectedKeys = [ 'DB_HOST', 'DB_PORT','DB_NAME', 'DB_USER', 'DB_PORT' ];
			for( configExpectedKey in dbExpectedKeys ){

				if( !len( request.$envHelper.getSystemSetting( configExpectedKey, "" ) ) ){
					throw(
						type="ContentBox.Docker.DatasourceExpectationException",
						message="The system detected a custom `DB_DRIVER` configuration in the environment, but not all of the expected configuration key #configExpectedKey# was not present."
					);
				}
			}

			datasourceConfig = {
				driver			: request.$envHelper.getSystemSetting( "DB_DRIVER" ),
				host 			: request.$envHelper.getSystemSetting( "DB_HOST" ),
				port 			: request.$envHelper.getSystemSetting( "DB_PORT" ),
				database		: request.$envHelper.getSystemSetting( "DB_NAME" ),
				username		: request.$envHelper.getSystemSetting( "DB_USER" ),
				storage			: true,
				clob 			: true,
				blob 			: true
			};

			if( len( request.$envHelper.getSystemSetting( "DB_PASSWORD", "" ) ) ){
				datasourceConfig[ "password" ] = request.$envHelper.getSystemSetting( "DB_PASSWORD" );
			}



		} else if( len( request.$envHelper.getSystemSetting( "DB_CONNECTION_STRING", "" ) ) ){

			dbExpectedKeys = [ 'DB_CLASS', 'DB_USER' ];

			for( configExpectedKey in dbExpectedKeys ){

				if( !len( request.$envHelper.getSystemSetting( configExpectedKey, "" ) ) ){
					throw(
						type="ContentBox.Docker.DatasourceExpectationException",
						message="The system detected a custom `DB_CONNECTION_STRING` configuration in the environment, but not all of the expected configuration key #configExpectedKey# was not present."
					);
				}
			}

			datasourceConfig = {
				class           : request.$envHelper.getSystemSetting( "DB_CLASS" ),
				connectionString: request.$envHelper.getSystemSetting( "DB_CONNECTION_STRING" ),
				username        : request.$envHelper.getSystemSetting( "DB_USER" ),
				storage         : true,
				clob 			: true,
				blob 			: true
			};

			if( len( request.$envHelper.getSystemSetting( "DB_PASSWORD", "" ) ) ){
				datasourceConfig[ "password" ] = request.$envHelper.getSystemSetting( "DB_PASSWORD" );
			}

			if( findNoCase( "sqlserver", datasourceConfig.class ) ){
				this.ormSettings[ "dialect" ] = "MicrosoftSQLServer";
			}

		}

	}

	// If a datasource configuration is defined, assign it.  Otherwise we'll assume it's been handled in another way
	if( !isNull( datasourceConfig ) ){
		this.datasources[ request.$envHelper.getSystemSetting( "DATASOURCE_NAME", "contentbox" ) ] = datasourceConfig;
	}
</cfscript>