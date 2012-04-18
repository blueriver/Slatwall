component {
	
	// On Application Load, we can clear the slatwall application key so that the application get reloaded on the next request
	public void function onApplicationLoad() {
		if(structKeyExists(application, "")) {
			
		}
	}
	
	
}