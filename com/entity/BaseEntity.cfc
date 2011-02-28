component displayname="Base Entity" accessors="true" extends="Slatwall.com.utility.BaseObject" {
	
	property name="errorBean" type="Slatwall.com.utility.ErrorBean";
	property name="searchScore" type="numeric";
	property name="updateKeys" type="string";
	
	public any function init() {
		
		// Create a new errorBean for all entities
		this.setErrorBean(new Slatwall.com.utility.ErrorBean());
		
		// Automatically set the default search score to 0
		this.setSearchScore(0);
		
		// When called from getNewEntity() within base service a struct or query record can be passed to pre-populate;
		if(!structIsEmpty(arguments)){
			// TODO: Debug this
			//this.set(record=arguments);
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
				if(!isDefined("propertyStruct.Persistent") or (isDefined("propertyStruct.Persistent") && propertyStruct.Persistent == true && !isDefined("propertyStruct.FieldType"))) {
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
	
	// @hint utility function to sort array of ojbects can be used to override getCollection() method to add sorting. 
	// From Aaron Greenlee http://cookbooks.adobe.com/post_How_to_sort_an_array_of_objects_or_entities_with_C-17958.html
	public array function sortObjectArray(required array objects, required string sortby, string sorttype="text", string direction = "asc") {
		var property = arguments.sortby;
		var sortedStruct = {};
		var sortedArray = [];
        for (var i=1; i <= arrayLen(arguments.objects); i++) {
                // Each key in the struct is in the format of
                // {VALUE}.{RAND NUMBER} This is important otherwise any objects
                // with the same value would be lost.
                var rn = randRange(1,100);
                var sortedStruct[ evaluate("arguments.objects[i].get#property#() & '.' & rn") ] = objects[i];
		}
		var keyArray = structKeyArray(sortedStruct);
		arraySort(keyArray,arguments.sorttype,arguments.direction);
		for(var i=1; i<=arrayLen(keyArray);i++) {
			arrayAppend(sortedArray, sortedStruct[keyArray[i]]);
		}
		return sortedArray;
	}



	public any function isNew() {
		var identifierColumns = ormGetSessionFactory().getClassMetadata(getMetaData(this).entityName).getIdentifierColumnNames();
		var returnNew = true;
		for(var i=1; i <= arrayLen(identifierColumns); i++){
			if(structKeyExists(variables, identifierColumns[i]) && (!isNull(variables[identifierColumns[i]]) && variables[identifierColumns[i]] != "" )) {
				returnNew = false;
			}
		}
		return returnNew;
	}
	
	public string function getClassName(){
		return ListLast(GetMetaData(this).entityname, "." );
	}
	
	public void function addError(required string name, required string message) {
		getErrorBean().addError(argumentCollection=arguments);
	}
	
	public void function clearErrors() {
		structClear(getErrorBean().getErrors());
	}
	
	// @hint A way to see if the entity has any errors.
	public boolean function hasErrors() {
		return this.getErrorBean().hasErrors();
	}
	
	// Start: ORM functions
	public void function preInsert(){
		var timestamp = now();
		
		if(structKeyExists(this,"setCreatedDateTime")){
			this.setDateCreated(timestamp);
		}
		if(structKeyExists(this,"setLastUpdatedDateTime")){
			this.setDateLastUpdated(timestamp);
		}
		
	}
	
	public void function preUpdate(Struct oldData){
		var timestamp = now();
		
		if(structKeyExists(this,"setLastUpdatedDateTime")){
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