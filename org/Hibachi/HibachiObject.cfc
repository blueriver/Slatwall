component accessors="true" output="false" persistent="false" {
	
	// Constructor Metod
	public any function init( ) {
		
		return this;
	}
	
	// =========================== START: UTILITY METHODS ===========================================
	
	// @hint public method to return a a default value, if the value passed in is null
	public any function nullReplace(any value, required any defaultValue) {
		if(!structKeyExists(arguments, "value")) {
			return arguments.defaultValue;
		}
		return arguments.value;
	}
	
	
	// @help Public Method that allows you to get a serialized JSON struct of all the simple values in the variables scope.  This is very useful for compairing objects before and after a populate
	public string function getSimpleValuesSerialized() {
		var data = {};
		for(var key in variables) {
			if( isSimpleValue(variables[key]) ) {
				data[key] = variables[key];
			}
		}
		return serializeJSON(data);
	}
		
	// @help Public Method to invoke any method in the object, If the method is not defined it calls onMissingMethod
	public any function invokeMethod(required string methodName, struct methodArguments={}, boolean testing=false) {
		
		if(structKeyExists(this, arguments.methodName)) {
			var theMethod = this[ arguments.methodName ];
			return theMethod(argumentCollection = methodArguments);
		}
		
		return this.onMissingMethod(missingMethodName=arguments.methodName, missingMethodArguments=arguments.methodArguments);
	}
	
	// @help Public method to get everything in the variables scope, good for debugging purposes
	public any function getVariables() {
		return variables;
	}
	
	// @help Public method to get the class name of an object
	public any function getClassName() {
		return listLast(getClassFullname(), "."); 
	}
	
	// @help Public method to get the fully qualified dot notation class name
	public any function getClassFullname() {
		return getThisMetaData().fullname;
	}
	
	// @hint this method allows you to properly format a value against a formatType
	public any function formatValue( required string value, required string formatType ) {
		
		//	Valid formatType Strings are:	none	yesno	truefalse	currency	datetime	date	time	weight
		
		// Do a switch on the seperate formatTypes and return a formatted value
		switch(arguments.formatType) {
			case "none": {
				return arguments.value;
			}
			case "yesno": {
				if(isBoolean(arguments.value) && arguments.value) {
					return rbKey('define.yes');
				} else {
					return rbKey('define.no');
				}
			}
			case "truefalse": {
				if(isBoolean(arguments.value) && arguments.value) {
					return rbKey('define.true');
				} else {
					return rbKey('define.false');
				}
			}
			case "currency": {
				// Check to see if this object has a currencyCode
				if( this.hasProperty("currencyCode") && !isNull(getCurrencyCode()) && len(getCurrencyCode()) eq 3 ) {
					
					var currency = getService("currencyService").getCurrency( getCurrencyCode() );
					
					return currency.getCurrencySymbol() & LSNumberFormat(arguments.value, ',.__');
				}
				
				// Otherwsie use the global currencyLocal
				return LSCurrencyFormat(arguments.value, setting("globalCurrencyType"), setting("globalCurrencyLocale"));
			}
			case "datetime": {
				return dateFormat(arguments.value, setting("globalDateFormat")) & " " & TimeFormat(value, setting("globalTimeFormat"));
			}
			case "date": {
				return dateFormat(arguments.value, setting("globalDateFormat"));
			}
			case "time": {
				return timeFormat(arguments.value, setting("globalTimeFormat"));
			}
			case "weight": {
				return arguments.value & " " & setting("globalWeightUnitCode");
			}
			case "pixels": {
				return arguments.value & "px";
			}
			case "percentage" : {
				return arguments.value & "%";
			}
			case "url": {
				return '<a href="#arguments.value#" target="_blank">' & arguments.value & '</a>';
			}
			/*
			case "email": {
				return '<a href="mailto:#arguments.value#" target="_blank">' & arguments.value & '</a>';
			}
			*/
		}
		
		return arguments.value;
	}
	
	private string function createSlatwallUUID() {
		return replace(lcase(createUUID()), '-', '', 'all');
	}
	
	// @help private method only used by populate
	private void function _setProperty( required any name, any value ) {
		
		// If a value was passed in, set it
		if( structKeyExists(arguments, 'value') ) {
			// Defined the setter method
			var theMethod = this["set" & arguments.name];
			
			// Call Setter
			theMethod(arguments.value);
		} else {
			// Remove the key from variables, represents setting as NULL for persistent entities
			structDelete(variables, arguments.name);
		}
	}
	
	public string function encryptValue(string value) {
		var encryptedValue = "";
		if(!isNull(arguments.value) && arguments.value != "") {
			if(setting("globalEncryptionService") == "internal"){
				encryptedValue = getService("encryptionService").encryptValue(arguments.value);
			} else {
				encryptedValue = getService("integrationService").getIntegrationByIntegrationPackage( setting("globalEncryptionIntegration") ).getIntegrationCFC().encryptValue(arguments.value);
			}
		}
		return encryptedValue;
	}
	
	public string function decryptValue(string value) {
		var decryptedValue = "";
		if(!isNull(arguments.value) && arguments.value != "") {
			if(setting("globalEncryptionService") == "internal"){
				decryptedValue = getService("encryptionService").decryptValue(arguments.value);
			} else {
				decryptedValue = getService("integrationService").getIntegrationByIntegrationPackage( setting("globalEncryptionIntegration") ).getIntegrationCFC().decryptValue(arguments.value);
			}
		}
		return decryptedValue;
	}
	
	
	// @hint  rounding function
	public string function round(required any value, string roundingExpression="0.00", string roundingDirection="Closest") {
		return getService("roundingRuleService").roundValue(argumentcollection=arguments);
	}
	
	// ===========================  END:  UTILITY METHODS ===========================================
	
	
	
	// ========================= START: DELIGATION HELPERS ==========================================
	
	// @hint gets a bean out of whatever the fw1 bean factory is
	public any function getBean(required string beanName) {
		return application.slatwallfw1.factory.getBean( arguments.beanName );
	}
	
	// @hint returns an application scope cached version of the service
	public any function getService(required string serviceName) {
		if( !hasApplicationValue("serviceCache_#arguments.serviceName#") ) {
			setApplicationValue("serviceCache_#arguments.serviceName#", getBean( arguments.serviceName ));
		}
		
		return getApplicationValue("serviceCache_#arguments.serviceName#");
	}
		
	// @hint  helper function to return the Slatwall RB Factory in any component
	public any function getRBFactory() {
		if( !hasApplicationValue("rbFactory") ) {
			setApplicationValue("rbFactory", getService("utilityRBService"));
		}
		
		return getApplicationValue("rbFactory");
	}
	
	// @hint  helper function for returning the Validate This Facade Object
	public any function getValidateThis() {
		if( !hasApplicationValue("validateThis") ) {
			setApplicationValue("validateThis", new ValidateThis.ValidateThis({definitionPath = expandPath('/Slatwall/model/validation/'),injectResultIntoBO = true,defaultFailureMessagePrefix = ""}) );
		}
		return getApplicationValue("validateThis");
	}
	
	// @hint  helper function to return the RB Key from RB Factory in any component
	public string function rbKey(required string key, string locale="en_us") {
		return getRBFactory().getRBKey(arguments.key, arguments.locale);
	}
	
	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}

	// @hint helper function to return the details of a setting
	public struct function getSettingDetails(required any settingName, array filterEntities=[]) {
		return getService("settingService").getSettingDetails(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities);
	}
	
	// @hint helper function for using the Slatwall Log service.
	public void function logHibachi(required string message, boolean generalLog=false){
		getService("hibachiLogService").logMessage(message=arguments.message, generalLog=arguments.generalLog);		
	}
	
	// @hint helper function for using the Slatwall Log Exception service.
	public void function logHibachiException(required any exception){
		getService("hibachiLogService").logException(exception=arguments.exception);		
	}
	
	// @hint returns an application specfic virtual filesystem
	public any function getVirtualFileSystemPath() {
		return "ram:///#getHibachiInstanceApplicationScopeKey()#";
	}
	
	// @hint  helper function for returning the slatwallScope from the request scope
	public any function getHibachiScope() {
		var test = getApplicationValue("hibachiApplicationKey");
		
		return request[ "slatwallScope" ];
	}
	
	// =========================  END:  DELIGATION HELPERS ==========================================
	// ========================= START: APPLICATION VAUES ===========================================
	
	// @hint setups an application scope value that will always be consistent
	public any function getHibachiInstanceApplicationScopeKey() {
		var metaData = getMetaData( this );
		do {
			var filePath = metaData.path;
			metaData = metaData.extends;
		} while( structKeyExists(metaData, "extends") );
		
		filePath = lcase(getDirectoryFromPath(filePath));
		var appKey = hash(filePath);
		
		return appKey;
	}
	
	// @hint facade method to check the slatwall application scope for a value
	public boolean function hasApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	// @hint facade method to get values from the slatwall application scope
	public any function getApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#arguments.key#' from the core slatwall application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	// @hint facade method to set values in the slatwall application scope 
	public void function setApplicationValue(required any key, required any value) {
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(application, getHibachiInstanceApplicationScopeKey())) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ] = arguments.value;
		}
	}
	
	// ========================= START: APPLICATION VAUES ===========================================
	
	
	
}
