component extends="mxunit.framework.TestCase" output="false" {

	// @hint helper function for returning the any of the services in the application
	private any function getService(required string serviceName) {
		return getPluginConfig().getApplication().getValue("serviceFactory").getBean(arguments.serviceName);
	}
	
	// @hint Private helper function to return the Slatwall RB Factory in any component
	private any function getRBFactory() {
		return getPluginConfig().getApplication().getValue("rbFactory");
	}
	
	// @hint Private helper function for returning the fw
	private any function getFW() {
		return getPluginConfig().getApplication().getValue('fw');
	}
	
	// @hint Private helper function for returning the plugin config inside of any component in the application
	private any function getPluginConfig() {
		return application.slatwall.pluginConfig;
	}
	
}