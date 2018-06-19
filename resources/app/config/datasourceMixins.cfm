<cfscript>

	isExpress = systemEnv[ "EXPRESS" ] ?: false;

	// Express H2SQL Database
	if( isExpress ){

		dbDirectory = systemEnv[ "H2_DIR" ] ?: '/data/contentbox/db';
		
		datasourceConfig = {
			class 			 	: 'org.h2.Driver',
			connectionString 	: 'jdbc:h2:' & dbDirectory & '/contentbox;MODE=MySQL',
			storage			 	: true,
			clob 				: true,
			blob 				: true
		};
	} 
	// Else traditional RDBMS
	else {

		//ACF Syntax Datasources
		if( structKeyExists( systemEnv , "DB_DRIVER" ) ){
			dbExpectedKeys = [ 'DB_HOST', 'DB_PORT','DB_NAME', 'DB_USER', 'DB_PORT' ];
			for( configExpectedKey in dbExpectedKeys ){

				if( !structKeyExists( systemEnv, configExpectedKey ) ){
					throw( 
						type="ContentBox.Docker.DatasourceExpectationException",
						message="The system detected a custom `DB_DRIVER` configuration in the environment, but not all of the expected configuration key #configExpectedKey# was not present."
					);
				}
			}

			datasourceConfig = {
				driver			: systemEnv[ 'DB_DRIVER' ],
				host 			: systemEnv[ 'DB_HOST' ],
				port 			: systemEnv[ 'DB_PORT' ],
				database		: systemEnv[ 'DB_NAME' ],
				username		: systemEnv[ 'DB_USER' ],
				storage			: true,
				clob 			: true,
				blob 			: true
			};

			if( structKeyExists( systemEnv, "DB_PASSWORD" ) ){
				datasourceConfig[ "password" ] = systemEnv[ "DB_PASSWORD" ];
			}



		} else if( structKeyExists( systemEnv, "DB_CONNECTION_STRING" ) ){

			dbExpectedKeys = [ 'DB_CLASS', 'DB_USER' ];

			for( configExpectedKey in dbExpectedKeys ){

				if( !structKeyExists( systemEnv, configExpectedKey ) ){
					throw( 
						type="ContentBox.Docker.DatasourceExpectationException",
						message="The system detected a custom `DB_CONNECTION_STRING` configuration in the environment, but not all of the expected configuration key #configExpectedKey# was not present."
					);
				}
			}

			datasourceConfig = {
				class           : systemEnv[ "DB_CLASS" ],
				connectionString: systemEnv[ "DB_CONNECTION_STRING" ],
				username        : systemEnv[ "DB_USER" ],
				storage         : true,
				clob 			: true,
				blob 			: true
			};

			if( structKeyExists( systemEnv, "DB_PASSWORD" ) ){
				datasourceConfig[ "password" ] = systemEnv[ "DB_PASSWORD" ];
			}

			if( findNoCase( "sqlserver", datasourceConfig.class ) ){
				this.ormSettings[ "dialect" ] = "MicrosoftSQLServer";
			}

		}

	}

	// If a datasource configuration is defined, assign it.  Otherwise we'll assume it's been handled in another way

	if( !isNull( datasourceConfig ) ){
		this.datasources[ "contentbox" ] = datasourceConfig;	
	}
</cfscript>