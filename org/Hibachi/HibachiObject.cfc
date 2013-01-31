component accessors="true" output="false" persistent="false" {
	
	// Constructor Metod
	public any function init( ) {
		return this;
	}
	
	// ========================== START: FRAMEWORK ACCESS ===========================================
	
	// @hint gets a bean out of whatever the fw1 bean factory is
	public any function getBeanFactory() {
		return application[ getApplicationValue('applicationKey') ].factory;
	}
	
	// @hint gets a bean out of whatever the fw1 bean factory is
	public any function getBean(required string beanName) {
		return getBeanFactory().getBean( arguments.beanName );
	}
	
	// @hint returns an application scope cached version of the service
	public any function getService(required string serviceName) {
		if( !hasApplicationValue("service_#arguments.serviceName#") ) {
			setApplicationValue("service_#arguments.serviceName#", getBean(arguments.serviceName) );
		}
		return getApplicationValue("service_#arguments.serviceName#");
	}
	
	// @hint returns a new transient bean
	public any function getTransient(required string transientName) {
		return getBean(arguments.transientName);
	}
	
	// @hint returns an application specfic virtual filesystem
	public any function getVirtualFileSystemPath() {
		return "ram:///#getHibachiInstanceApplicationScopeKey()#";
	}
	
	// @hint helper function for returning the hibachiScope from the request scope
	public any function getHibachiScope() {
		return request[ "#getApplicationValue("applicationKey")#Scope" ];
	}
	
	// @hint helper function to get the applications baseURL
	public string function getBaseURL() {
		return getApplicationValue("baseURL");
	}
	
	// ==========================  END: FRAMEWORK ACCESS ============================================
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
	public any function invokeMethod(required string methodName, struct methodArguments={}) {
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
	
	public string function createHibachiUUID() {
		return replace(lcase(createUUID()), '-', '', 'all');
	}
	
	// ===========================  END:  UTILITY METHODS ===========================================
	
	
	// ========================= START: DELIGATION HELPERS ==========================================
	
	public string function encryptValue(string value) {
		return getService("hibachiUtilityService").encryptValue(argumentcollection=arguments);
	}
	
	public string function decryptValue(string value) {
		return getService("hibachiUtilityService").decryptValue(argumentcollection=arguments);
	}
	
	public void function logHibachi(required string message, boolean generalLog=false){
		getService("hibachiUtilityService").logMessage(message=arguments.message, generalLog=arguments.generalLog);		
	}
	
	public void function logHibachiException(required any exception){
		getService("hibachiUtilityService").logException(exception=arguments.exception);		
	}
	
	public string function rbKey(required string key) {
		return getHibachiScope().rbKey(arguments.key);
	}
	
	public string function buildURL() {
		return getApplicationValue("application").buildURL(argumentcollection=arguments);
	}
	
	public any function formatValue() {
		return getService("hibachiUtilityService").formatValue(argumentcollection=arguments);
	}
	
	// =========================  END:  DELIGATION HELPERS ==========================================
	// ========================= START: APPLICATION VAUES ===========================================
	
	// @hint setups an application scope value that will always be consistent
	private any function getHibachiInstanceApplicationScopeKey() {
		var metaData = getMetaData( this );
		do {
			var filePath = metaData.path;
			metaData = metaData.extends;
		} while( structKeyExists(metaData, "extends") );
		
		filePath = lcase(getDirectoryFromPath(filePath));
		var appKey = hash(filePath);
		
		return appKey;
	}
	
	// @hint facade method to check the application scope for a value
	public boolean function hasApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	// @hint facade method to get values from the application scope
	public any function getApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiInstanceApplicationScopeKey()) && structKeyExists(application[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#arguments.key#' from the core hibachi application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	// @hint facade method to set values in the application scope 
	public void function setApplicationValue(required any key, required any value) {
		lock name="application_#getHibachiInstanceApplicationScopeKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(application, getHibachiInstanceApplicationScopeKey())) {
				application[ getHibachiInstanceApplicationScopeKey() ] = {};
				application[ getHibachiInstanceApplicationScopeKey() ].initialized = false;
			}
			application[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ] = arguments.value;
			if(isSimpleValue(arguments.value) && hasApplicationValue("applicationKey")) {
				writeLog(file="#getApplicationValue('applicationKey')#", text="General Log - Application Value '#arguments.key#' set as: #arguments.value#");
			}
		}
	}
	
	// @hint facade method to check the application scope for a value
	public boolean function hasSessionValue(required any key) {
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	// @hint facade method to get values from the application scope
	public any function getSessionValue(required any key) {
		if( structKeyExists(session, getHibachiInstanceApplicationScopeKey()) && structKeyExists(session[ getHibachiInstanceApplicationScopeKey() ], arguments.key)) {
			return session[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#arguments.key#' from the core application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	// @hint facade method to set values in the application scope 
	public void function setSessionValue(required any key, required any value) {
		lock name="session_#getHibachiInstanceApplicationScopeKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(session, getHibachiInstanceApplicationScopeKey())) {
				session[ getHibachiInstanceApplicationScopeKey() ] = {};
			}
			session[ getHibachiInstanceApplicationScopeKey() ][ arguments.key ] = arguments.value;
		}
	}
	
	// ========================= START: APPLICATION VAUES ===========================================
}
