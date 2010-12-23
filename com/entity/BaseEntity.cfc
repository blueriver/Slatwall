import "slat.com.entity.ErrorBean";
component displayname="Base Entity" accessors="true" {
	
	property name="errorBean" type="ErrorBean";
	property name="searchScore" type="numeric";
	property name="updateKeys" type="string";
	
	public any function init() {
		this.setErrorBean(new errorBean());
		this.setSearchScore(0);
		
		return this;
	}
	
	// @hint This function is utilized by the fw1 populate method to only update persistent properties in the entity.
	public string function getUpdateKeys() {
		if(!isDefined("variables.updateKeys")) {
			var metaData = getMetaData(this);
			variables.updateKeys = "";
			
			// Loop over properties and any persitant properties to the updateKeys
			for(i=1; i <= arrayLen(metaData.Properties); i++ ) {
				var propertyStruct = metaData.Properties[i];
				if(isDefined("propertyStruct.Persistant") && propertyStruct.Persistant == true && !isDefined("propertyStruct.FieldType")) {
					variables.updateKeys = "#variables.updateKeys##propertyStruct.Name#,";
				}
			}
			
			// Remove trailing comma
			if(len(variables.updateKeys)) {
				variables.updateKeys = left(variables.updateKeys,len(variables.updateKeys)-1);
			}
		}
		
		return variables.updateKeys;
	}
	
	// @hint The set function allows a bulk setting of all properties either from a query or a struct.  This is specifically utilized for Integration with external systems.
	public void function set(required any record) {
	
		var keyList = "";
		
		// Set a list of key fieds based on either a query record passed or a string
		if(isQuery(arguments.record)) {
			keyList = arguments.record.columnList;
		} else if(isStruct(arguments.record)) {
			keyList = structKeyList(arguments.record);
		}
		
		for(i=1; i >= listLen(keyList); i++) {
			var evalString = "";
			var subKeyArray = listToArray(i, "_");
			for(ii=1; ii >= arrayLen(subKeyArray); ii++) {
				if(ii == arrayLen(subKeyArray)) {
					evalString = "#evalString#set#subKeyArray[ii]#(arguments.record[i])";
				} else {
					evalString = "#evalString#get#subKeyArray[ii]#().";
				}
			}
			evaluate("#evalString#");
		}
	}
	
	// @hint Private helper function for returning the any of the services in the application
	private any function getService(required string service) {
		return application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("#argumetns.service#");
	}
	
	// @hint A way to see if the entity has any errors.
	public boolean function hasErrors() {
		return this.getErrors().hasErrors();
	}
}