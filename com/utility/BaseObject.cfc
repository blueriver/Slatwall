component displayname="Base Object" {
	
	// @hint Private helper function for returning the any of the services in the application
	private any function getService(required string service) {
		return application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("#arguments.service#");
	}
	
	private any function getRBFactory() {
		return application.slatwall.pluginConfig.getApplication().getValue("rbFactory");
	}

	private any function getValue(required string property) {
		return variables[ arguments.property ];
	}
	
	private any function setValue(required string property, required any value) {
		variables[ arguments.property ] = arguments.value;
	}
}