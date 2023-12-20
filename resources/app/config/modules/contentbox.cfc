component {

	function configure(){
		/**
		 * --------------------------------------------------------------------------
		 * ContentBox Runtime Config
		 * --------------------------------------------------------------------------
		 */
		// Choose a distributed cache
		var distributedCache = getSystemSetting( "DISTRIBUTED_CACHE", getSystemSetting( "EXPRESS", false ) ? "express" : "jdbc" );

		return {
			// Array of mixins (eg: /includes/contentHelpers.cfm) to inject into all content objects
			"contentHelpers" = [],
			// Setting Overrides
			"settings" : {
				// Global settings
				"global" : {
				  // Distributed Cache For ContentBox
				  "cb_content_cacheName"   = distributedCache == "express" ? "template" : distributedCache,
				  "cb_rss_cacheName"       = distributedCache == "express" ? "template" : distributedCache,
				  "cb_site_settings_cache" = distributedCache
				},
				// Site specific settings according to site slug
				"sites" : {
					// Default site
					"default" = {
					// Distributed Cache For ContentBox
					"cb_content_cacheName"   = distributedCache == "express" ? "template" : distributedCache,
					"cb_rss_cacheName"       = distributedCache == "express" ? "template" : distributedCache,
					"cb_site_settings_cache" = distributedCache
					}
				}
			}
		};
	}

}
