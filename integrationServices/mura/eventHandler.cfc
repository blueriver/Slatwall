component extends="mura.plugin.pluginGenericEventHandler" {
	
	// On Application Load, we can clear the slatwall application key and register all of the methods in this eventHandler with the config
	public void function onApplicationLoad(required any event) {
		if(structKeyExists(application, "slatwall")) {
			structDelete(application, "slatwall");
		}
		variables.pluginConfig.addEventHandler(this);
	}
	
	public void function onSiteRequestStart(required any rc) {
		
	}
}