component {

	// Helper Method for doAction()
	private string function doAction(required any action) {
		if(!structKeyExists(url, "$")) {
			url.$ = request.muraScope;
		}
		return getSlatwallApplication().doAction(arguments.action);
	}
	
	// Helper method to get the Slatwall Application
	private any function getSlatwallApplication() {
		if(!structKeyExists(variables, "slatwallApplication")) {
			variables.slatwallApplication = createObject("component", "Slatwall.Application");
		}
		return variables.slatwallApplication;
	}
	
	// Helper method to get the SlatwallScope
	private any function getSlatwallScope() {
		return request.slatwallScope;
	}
	
	// Helper method to return the mura plugin config for the slatwall-mura connector
	private any function getPluginConfig() {
		if(!structKeyExists(variables, "pluginConfig")) {
			variables.pluginConfig = application.pluginManager.getConfig("slatwall-mura");
		}
		return variables.pluginConfig;
	}
	
	// For admin request start, we call the Slatwall Event Handler that gets the request setup
	private void function startSlatwallAdminRequest(required any $) {
		if(!structKeyExists(request, "slatwallScope")) {
			// Call the Slatwall Event Handler that gets the request setup
			getSlatwallApplication().setupGlobalRequest();
					
			// Setup the newly create slatwallScope into the muraScope
			arguments.$.setCustomMuraScopeKey("slatwall", request.slatwallScope);
		}
	}
	
	// For admin request end, we call the endLifecycle
	private void function endSlatwallAdminRequest(required any $) {
		getSlatwallApplication().endHibachiLifecycle();
	}
}