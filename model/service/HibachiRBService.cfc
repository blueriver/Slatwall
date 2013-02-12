component accessors="true" extends="Slatwall.org.Hibachi.HibachiRBService" {

	property name="integrationService" type="any";

	// Override the getResourceBundle method so that we can look in other places as well
	public struct function getResourceBundle(required string locale="en_us") {
		if(!structKeyExists(variables.resourceBundles, arguments.locale)) {
			
			// Call the super, and at this point the structKeyExists, so there is a potential chance that one request might not get all the RB keys in a race condition type of setting.
			var thisRB = super.getResourceBundle(argumentcollection=arguments);
			var javaRB = new JavaRB.JavaRB();
			
			// Loop over the active FW/1 subsystems to look for a resource bundle there
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i<=arrayLen(activeFW1Integrations); i++) {
				try {
					structAppend(thisRB, javaRB.getResourceBundle(expandPath("/#getApplicationValue('applicationKey')#/integrationServices/#activeFW1Integrations[i].subsystem#/config/resourceBundles/#arguments.locale#.properties")), true);
				} catch (any e) {
					// No RB File Found
				}	
			}
			variables.resourceBundles[ arguments.locale ] = thisRB;
		}
		return variables.resourceBundles[ arguments.locale ];
	}
}