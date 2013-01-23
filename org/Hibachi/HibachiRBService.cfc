component output="false" accessors="true" extends="HibachiService" {

	property name="integrationService" type="any";

	variables.resourceBundles = {};
	variables.instantiaded = now();
	
	public string function getRBKey(required string key, string locale="en_us", string checkedKeys="", string originalKey) {
		// Check the exact bundle file
		var bundle = getResourceBundle( arguments.locale );
		if(structKeyExists(bundle, arguments.key)) {
			return bundle[ arguments.key ];
		}
		
		// Because the value was not found, we can add this to the checkedKeys, and setup the original Kye
		arguments.checkedKeys = listAppend(arguments.checkedKeys, arguments.key & "_" & arguments.locale & "_missing");
		if(!structKeyExists(arguments, "originalKey")) {
			arguments.originalKey = arguments.key;
		}
		
		// Check the broader bundle file
		if(listLen(arguments.locale, "_") == 2) {
			bundle = getResourceBundle( listFirst(arguments.locale, "_") );
			if(structKeyExists(bundle, arguments.key)) {
				return bundle[ arguments.key ];
			}
			// Add this more broad term to the checked keys
			arguments.checkedKeys = listAppend(arguments.checkedKeys, arguments.key & "_" & listFirst(arguments.locale, "_") & "_missing");
		}
		
		// Recursivly step the key back with the word 'define' replacing the previous.  Basically Look for just the "xxx.yyy.define.zzz" version of the end key and then "yyy.define.zzz" and then "define.zzz"
		if ( listLen(arguments.key, ".") >= 3 && listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".") eq "define" ) {
			var newKey = replace(arguments.key, "#listGetAt(arguments.key, listLen(arguments.key, ".") - 2, ".")#.define", "define", "one");
			
			return getRBKey(newKey, arguments.locale, arguments.checkedKeys, arguments.originalKey);
		} else if( listLen(arguments.key, ".") >= 2 && listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".") neq "define" ) {
			var newKey = replace(arguments.key, "#listGetAt(arguments.key, listLen(arguments.key, ".") - 1, ".")#.", "define.", "one");
			
			return getRBKey(newKey, arguments.locale, arguments.checkedKeys, arguments.originalKey);
		}
		
		if(listFirst(arguments.locale, "_") neq "en") {
			return getRBKey(arguments.originalKey, "en", arguments.checkedKeys);
		}
		
		return arguments.checkedKeys;
	}
	
	public struct function getResourceBundle(required string locale="en_us") {
		if(!structKeyExists(variables.resourceBundles, arguments.locale)) {
			var javaRB = new JavaRB.JavaRB();
			
			variables.resourceBundles[ arguments.locale ] = {};
			
			// Get the primary resource bundle for Slatwall
			try {
				variables.resourceBundles[ arguments.locale ] = javaRB.getResourceBundle(expandPath("/Slatwall/config/resourceBundles/#arguments.locale#.properties"));
			} catch (any e) {
				// No RB File Found
			}
			
			
			// Loop over the active FW/1 subsystems to look for a resource bundle there
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i<=arrayLen(activeFW1Integrations); i++) {
				try {
					structAppend(variables.resourceBundles[ arguments.locale ], javaRB.getResourceBundle(expandPath("/Slatwall/integrationServices/#activeFW1Integrations[i].subsystem#/config/resourceBundles/#arguments.locale#.properties")), true);
				} catch (any e) {
					// No RB File Found
				}	
			}
			
			// Get whatever resource bundle is in the custom config directory
			try {
				structAppend(variables.resourceBundles[ arguments.locale ], javaRB.getResourceBundle(expandPath("/Slatwall/config/custom/resourceBundles/#arguments.locale#.properties")), true);
			} catch (any e) {
				// No RB File Found
			}
		}
		
		return variables.resourceBundles[ arguments.locale ];
	}
	
	
}