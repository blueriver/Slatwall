component displayname="Base Object" {
	
	// @hint Private helper function for returning the any of the services in the application
	private any function getService(required string service) {
		return application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("#arguments.service#");
	}
	
	// @hint Private helper function to return the Slatwall RB Factory in any component
	private any function getRBFactory() {
		return application.slatwall.pluginConfig.getApplication().getValue("rbFactory");
	}
	
	// @hint Private helper function for returning the plugin config inside of any component in the application
	private any function getPluginConfig() {
		return application.slatwall.pluginConfig;
	}

	private any function inject(required string property, required any value) {
		variables[ arguments.property ] = arguments.value;
	}
	
	private any function injectRemove(required string property) {
		structDelete(variables, arguments.property);
	}
	
	private any function getVariables() {
		return variables;
	}
	
}