import "slatwall.com.entity.ErrorBean";
component displayname="Base Entity" accessors="true" {
	
	property name="errorBean" type="ErrorBean";
	property name="searchScore" type="numeric";
	property name="updateKeys" type="string";
	
	public any function init() {
		
		// Create a new errorBean for all entities
		this.setErrorBean(new errorBean());
		
		// Automatically set the default search score to 0
		this.setSearchScore(0);
		
		// When called from getNewEntity() within base service a struct or query record can be passed to pre-populate;
		if(!structIsEmpty(arguments)){
			this.set(record=arguments);
		}
		
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
				if(isDefined("propertyStruct.Persistent") && propertyStruct.Persistent == true && !isDefined("propertyStruct.FieldType")) {
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

		for(var i=1; i <= listLen(keyList); i++) {
			var evalString = "";
			var subKeyArray = listToArray(listGetAt(keyList, i), "_");
			var data = arguments.record[listGetAt(keyList, i)];
			
			for(var ii=1; ii <= arrayLen(subKeyArray); ii++) {
				if(ii == arrayLen(subKeyArray)) {
					evalString &= "set#subKeyArray[ii]#( '#data#' )";
				} else {
					evalString &= "get#subKeyArray[ii]#().";
				}
			}
			
			evaluate("#evalString#");
		}
	}

	public any function isNew() {
		var identifierColumns = ormGetSessionFactory().getClassMetadata(getMetaData(this).entityName).getIdentifierColumnNames();
		var returnNew = true;
		for(var i=1; i <= arrayLen(identifierColumns); i++){
			if(structKeyExists(variables, identifierColumns[i]) && !isNull(variables[identifierColumns[i]])) {
				returnNew = false;
			}
		}
		return returnNew;
	}
	
	public string function getClassName(){
		writeDump(getMetaData(this));
		abort;
		return ListLast(GetMetaData(this).entitynam, "." );
	}
	
	// @hint Private helper function for returning the any of the services in the application
	private any function getService(required string service) {
		return application.slatwall.pluginConfig.getApplication().getValue("serviceFactory").getBean("#arguments.service#");
	}
	
	// @hint A way to see if the entity has any errors.
	public boolean function hasErrors() {
		return this.getErrors().hasErrors();
	}
	
	// Start: ORM functions
	public void function preInsert(){
		var timestamp = now();
		
		if(structKeyExists(this,"setDateCreated")){
			this.setDateCreated(timestamp);
		}
		if(structKeyExists(this,"setDateLastUpdated")){
			this.setDateLastUpdated(timestamp);
		}
		
	}
	
	public void function preUpdate(Struct oldData){
		var timestamp = now();
		
		if(structKeyExists(this,"setDateLastUpdated")){
			this.setDateLastUpdated(timestamp);
		}
	}
	
	public void function preDelete(any entity){

	}
	
	public void function preLoad(any entity){

	}
	
	public void function postInsert(any entity){

	}
	
	public void function postUpdate(any entity){

	}
	
	public void function postDelete(any entity){

	}
	
	public void function postLoad(any entity){

	}
	// End: ORM Functions
	
}