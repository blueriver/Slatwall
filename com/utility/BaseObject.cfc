/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Base Object" accessors="true" output="false" {
	
	
	property name="vtResult" type="any";							// This propery holds the ValidateThis result bean once it has been set.
	property name="errorBean" type="any";							// This porpery holds errors that are not part of ValidateThis, for example processing errors.
	property name="populatedSubProperties" type="array";
	
	// Constructor Metod
	public any function init() {
		// Sets the populated sub properties array to a new array
		setPopulatedSubProperties([]);
		
		return this;
	}
	
	// @hint Public populate method to utilize a struct of data that follows the standard property form format
	public any function populate( required struct data={} ) {
		// Param the ignoreProperties key so that we can count on it later
		param name="arguments.data.ignoreProperties" default="";
		
		// Get an array of All the properties for this object
		var properties = getProperties();
		
		// Loop over properties looking for a value in the incomming data
		for( var p=1; p <= arrayLen(properties); p++ ) {
			
			// Set the current property into variable of meta data
			var currentProperty = properties[p];
			
			// Check to see if this property has a key in the data that was passed in
			if( structKeyExists(arguments.data, currentProperty.name) && !listFind(arguments.data.ignoreProperties, currentProperty.name) ) {
			
				// (SIMPLE) Do this logic if this property should be a simple value, and the data passed in is a simple value
				if( (!structKeyExists(currentProperty, "fieldType") || currentProperty.fieldType == "column") && isSimpleValue(arguments.data[ currentProperty.name ]) ) {
					
						// If the value is blank, then we check to see if the property can be set to NULL.
						if( arguments.data[ currentProperty.name ] == "" && ( !structKeyExists(currentProperty, "notNull") || !currentProperty.notNull ) ) {
							_setProperty(currentProperty.name);
						
						// If the value isn't blank, or we can't set to null... then we just set the value.
						} else {
							_setProperty(currentProperty.name, arguments.data[ currentProperty.name ]);
						}
					
				// (MANY-TO-ONE) Do this logic if this property is a many-to-one relationship, and the data passed in is of type struct
				} else if( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "many-to-one" && isStruct( arguments.data[ currentProperty.name ] ) ) {
					
					// Set the data of this Many-To-One relationship into it's own local struct
					var manyToOneStructData = arguments.data[ currentProperty.name ];
					
					// Find the primaryID column Name
					var primaryIDPropertyName = getService( "utilityORMService" ).getPrimaryIDPropertyNameByEntityName( "Slatwall#currentProperty.cfc#" );
					
					// If the primaryID exists then we can set the relationship
					if(structKeyExists(manyToOneStructData, primaryIDPropertyName)) {
						
						// If the value passed in for the ID is blank, then set the value of the currentProperty to NULL
						if(manyToOneStructData[primaryIDPropertyName] == "") {
							_setProperty(currentProperty.name);
							
						// If it was an actual ID, then we will try to load that entity
						} else {
							
							// set the service to use to get the specific entity
							var entityService = getService( "utilityORMService" ).getServiceByEntityName( "Slatwall#currentProperty.cfc#" );
							
							// If there were additional values in the data, then we will get the entity by the primaryID and populate / validate by calling save in its service.
							if(structCount(manyToOneStructData) gt 1) {
								
								// Load the specifiv entity, if one doesn't exist, this will return a new entity
								var thisEntity = entityService.invokeMethod( "get#currentProperty.cfc#", {1=manyToOneStructData[primaryIDPropertyName],2=true});
								
								// Set the value of the property as the loaded entity
								_setProperty(currentProperty.name, thisEntity );
								
								// Call the save method for this sub property entity and pass in the data
								thisEntity = entityService.invokeMethod( "save#currentProperty.cfc#", {1=thisEntity, 2=manyToOneStructData});
								
								// Add this property to the array of populatedSubProperties so that when this object is validated, it also validates the sub-properties that were populated
								if( !arrayFind(getPopulatedSubProperties(), currentProperty.name) ) {
									arrayAppend(getPopulatedSubProperties(), currentProperty.name);
								}
								
							// If there were no additional values in the strucuture then we just try to get the entity and set it... in this way a null is a valid option
							} else {
								
								// Load the specifiv entity, if one doesn't exist... this will be null
								var thisEntity = entityService.invokeMethod( "get#currentProperty.cfc#", {1=manyToOneStructData[primaryIDPropertyName]});
								
								// Set the value of the property as the loaded entity
								_setProperty(currentProperty.name, thisEntity );
								
							}
						}
					}
					
				// (ONE-TO-MANY) Do this logic if this property is a one-to-many or many-to-many relationship, and the data passed in is of type array	
				} else if ( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "one-to-many" && isArray( arguments.data[ currentProperty.name ] ) ) {
					
					// Set the data of this One-To-Many relationship into it's own local array
					var oneToManyArrayData = arguments.data[ currentProperty.name ];
					
					// Find the primaryID column Name for the related object
					var primaryIDPropertyName = getService( "utilityORMService" ).getPrimaryIDPropertyNameByEntityName( "Slatwall#currentProperty.cfc#" );
					
					// Loop over the array of objects in the data... Then load, populate, and validate each one
					for(var a=1; a<=arrayLen(oneToManyArrayData); a++) {
						
						// Check to make sure that this array has the primary ID property in it, otherwise we can't do a populate.  Also check to make sure populateSubProperties was not set to false in the data (if not defined we asume true).
						if(structKeyExists(oneToManyArrayData[a], primaryIDPropertyName) && (!structKeyExists(arguments.data, "populateSubProperties") || arguments.data.populateSubProperties)) {
							
							// set the service to use to get the specific entity
							var entityService = getService( "utilityORMService" ).getServiceByEntityName( "Slatwall#currentProperty.cfc#" );
							
							// Load the specific entity, and if one doesn't exist yet then return a new entity
							var thisEntity = entityService.invokeMethod( "get#currentProperty.cfc#", {1=oneToManyArrayData[a][primaryIDPropertyName],2=true});
							
							// Add the entity to the existing objects properties
							this.invokeMethod("add#currentProperty.singularName#", {1=thisEntity});
							
							// If there were additional values in the data array, then we use those values to populate the entity, and validating it aswell.
							if(structCount(oneToManyArrayData[a]) gt 1) {
								
								// Call the save method for this sub property entity and pass in the data
								thisEntity = entityService.invokeMethod( "save#currentProperty.cfc#", {1=thisEntity, 2=oneToManyArrayData[a]});
								
								// Add this property to the array of populatedSubProperties so that when this object is validated, it also validates the sub-properties that were populated
								if( !arrayFind(getPopulatedSubProperties(), currentProperty.name) ) {
									arrayAppend(getPopulatedSubProperties(), currentProperty.name);
								}
							}
						}
					}
				// (MANY-TO-MANY) Do this logic if this property is a many-to-many relationship, and the data passed in as a list of ID's
				} else if ( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "many-to-many" && isSimpleValue( arguments.data[ currentProperty.name ] ) ) {
					
					// Set the data of this Many-To-Many relationship into it's own local struct
					var manyToManyIDList = arguments.data[ currentProperty.name ];
					
					// Find the primaryID column Name
					var primaryIDPropertyName = getService( "utilityORMService" ).getPrimaryIDPropertyNameByEntityName( "Slatwall#currentProperty.cfc#" );
					
					// Get all of the existing related entities
					var existingRelatedEntities = invokeMethod("get#currentProperty.name#");
					
					// Loop over the existing related entities and check if the primaryID exists in the list of data that was passed in.
					for(var m=arrayLen(existingRelatedEntities); m>=1; m-- ) {
						
						// Get the primary ID of this existing relationship
						var thisPrimrayID = existingRelatedEntities[m].invokeMethod("get#primaryIDPropertyName#");
						
						// Find out if hat ID is in the list
						var listIndex = listFind( manyToManyIDList, thisPrimrayID );
						
						// If the relationship already exist, then remove that id from the list
						if(listIndex) {
							manyToManyIDList = listDeleteAt(manyToManyIDList, listIndex);
						// If the relationship no longer exists in the list, then remove the entity relationship
						} else {
							this.invokeMethod("remove#currentProperty.singularname#", {1=existingRelatedEntities[m]});
						}
					}
					
					// Loop over all of the primaryID's that are still in the list, and add the relationship
					for(var n=1; n<=listLen( manyToManyIDList ); n++) {
						
						// set the service to use to get the specific entity
						var entityService = getService( "utilityORMService" ).getServiceByEntityName( "Slatwall#currentProperty.cfc#" );
							
						// set the id of this entity into a local variable
						var thisEntityID = listGetAt(manyToManyIDList, n);
						
						// Load the specific entity, if one doesn't exist... this will be null
						var thisEntity = entityService.invokeMethod( "get#currentProperty.cfc#", {1=thisEntityID});
						
						// If the entity exists, then add it to the relationship
						if(!isNull(thisEntity)) {
							this.invokeMethod("add#currentProperty.singularname#", {1=thisEntity});
						}
					}
				}	
			}
		}
		
		// Return this object
		return this;
	}
	
	// @hint pubic method to validate this object
	public any function validate( string context="save" ) {
		
		// Set up the validation arguments as a mirror of the arguments struct
		var validationArguments = arguments;
		
		// Add this as "theObject" to the validation arguments
		validationArguments.theObject = this;
		
		// Validate This object
		getValidateThis().validate( argumentCollection=validationArguments );
		
		// Validate each of the objects that are in the populatedSubProperties array, This array has properties added to it during the populate method
		for(var p=1; p<=arrayLen(getPopulatedSubProperties()); p++) {
			
			// Get the values of this sub property
			var subPropertyValuesArray = invokeMethod("get#getPopulatedSubProperties()[p]#");
			
			// Loop over each object in the subProperty array and validate it
			for(var e=1; e<=arrayLen(subPropertyValuesArray); e++ ) {
			
				// If after validation that sub object has errors, add a failure to this object
				if(subPropertyValuesArray[e].hasErrors()) {
					getVTResult().addFailure( failure={message="One or more items had invalid data"},propertyName=getPopulatedSubProperties()[p]);
				}
			}
			
		}
		
		
		// Return the VTResult object that was populated by ValidateThis
		return getVTResult();
	}
	
	// @hint Public method to retrieve a value based on a propertyIdentifier string format
	public any function getValueByPropertyIdentifier(required string propertyIdentifier) {
		var value = javaCast("null", "");
		var arrayValue = arrayNew(1);
		var pa = listToArray(propertyIdentifier, "._");
		
		for(var i=1; i<=arrayLen(pa); i++) {
			try {
				if(isNull(value)) {
					value = evaluate("get#pa[i]#()");
				} else if(isArray(value)) {
					for(var ii=1; ii<=arrayLen(value); ii++) {
						arrayAppend(arrayValue, value[ii].getPropertyValueByIdentifier(pa[i]));
					}
					return arrayValue;
				} else {
					value = evaluate("value.get#pa[i]#()");
				}	
			} catch (any e) {
				return "";
			}
		}
		if(isNull(value)) {
			return "";
		}
		return value;
	}

	public any function getFormattedValue(required string propertyName, string formatType ) {
			arguments.value = invokeMethod("get#arguments.propertyName#");
		
		// This is the null format option
		if(isNull(arguments.value)) {
			return "";
		// This is not a simple value, throw an exception
		} else if (!isSimpleValue(arguments.value)) {
			throw("You cannont convert complex values to formatted Values");
		}
		
		// check if a formatType was passed in, if not then use the getPropertyFormatType() method to figure out what it should be by default
		if(!structKeyExists(arguments, "formatType")) {
			arguments.formatType = getPropertyFormatType( arguments.propertyName );
		}
		
		return formatValue(value=arguments.value, formatType=arguments.formatType);
	}
	
	// @hint public method for getting the display format for a given property, this is used a lot by the SlatwallPropertyDisplay
	public string function getPropertyFormatType(required string propertyName) {
		
		var propertyMeta = getPropertyMetaData( arguments.propertyName );
		
		// First check to see if formatType was explicitly set for this property
		if(structKeyExists(propertyMeta, "formatType")) {
			return propertyMeta.formatType;
			
		// If it wasn't set, but this is a simple value field then inspect the dataTypes and naming convention to try an figure it out
		} else if( !structKeyExists(propertyMeta, "fieldType") || propertyMeta.fieldType == "column" ) {
			
			var dataType = "";
			
			// Check if there is an ormType attribute for this property to use first and asign it to the 'dataType' local var.  Otherwise check if the type attribute was set and use that.
			if( structKeyExists(propertyMeta, "ormType") ) {
				dataType = propertyMeta.ormType;
			} else if ( structKeyExists(propertyMeta, "type") ) {
				dataType = propertyMeta.type;
			}
			
			// Check the dataType against different lists of types for correct formatType
			if( listFindNoCase("boolean,yes_no,true_false", dataType) ) {
				return "yesno";	
			} else if ( listFindNoCase("date,timestamp", dataType) ) {
				return "datetime";
			} else if ( listFindNoCase("big_decimal", dataType) && right(arguments.propertyName, 6) == "weight" ) {
				return "weight";	
			} else if ( listFindNoCase("big_decimal", dataType) ) {
				return "currency";
			}
			
		}
		
		// By default just return non
		return "none";
	}
	
	// @hint public method for getting the title to be used for a property from the rbFactory, this is used a lot by the SlatwallPropertyDisplay
	public string function getPropertyTitle(required string propertyName) {
		return rbKey("entity.#getClassName()#.#arguments.propertyName#");
	}
	
	// @hint public method for returning the name of the field for this property, this is used a lot by the SlatwallPropertyDisplay
	public string function getPropertyFieldName(required string propertyName) {
		
		// Get the Meta Data for the property
		var propertyMeta = getPropertyMetaData( arguments.propertyName );
		
		// If this is a relational property, and the relationship is many-to-one, then return the propertyName and propertyName of primaryID
		if( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-one" ) {
			
			var primaryIDPropertyName = getService( "utilityORMService" ).getPrimaryIDPropertyNameByEntityName( "Slatwall#propertyMeta.cfc#" );
			return "#arguments.propertyName#.#primaryIDPropertyName#";
		}
		
		// Default case is just to return the property Name
		return arguments.propertyName;
	}
	
	// @hint public method for inspecting the property of a given object and determining the most appropriate field type for that property, this is used a lot by the SlatwallPropertyDisplay
	public string function getPropertyFieldType(required string propertyName) {
		
		// Get the Meta Data for the property
		var propertyMeta = getPropertyMetaData( arguments.propertyName );
		
		// If this isn't a Relationship property then run the lookup on ormType then type.
		if( !structKeyExists(propertyMeta, "fieldType") || propertyMeta.fieldType == "column" ) {
			
			var dataType = "";
			
			// Check if there is an ormType attribute for this property to use first and asign it to the 'dataType' local var.  Otherwise check if the type attribute was set and use that.
			if( structKeyExists(propertyMeta, "ormType") ) {
				dataType = propertyMeta.ormType;
			} else if ( structKeyExists(propertyMeta, "type") ) {
				dataType = propertyMeta.type;
			}
			
			// Check the dataType against different lists of types for correct fieldType
			if( listFindNoCase("boolean,yes_no,true_false", dataType) ) {
				return "yesno";	
			} else if ( listFindNoCase("date,timestamp", dataType) ) {
				return "dateTime";
			} else if ( listFindNoCase("array", dataType) ) {
				return "select";
			} else if ( listFindNoCase("struct", dataType) ) {
				return "checkboxgroup";
			}
			
			// If the propertyName has the word 'password' in it... then use a password field
			if(findNoCase("password", arguments.propertyName)) {
				return "password";
			}
			
		// If this is a Relationship property, then determine the relationship type and return the correct fieldType
		} else if( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-one" ) {
			return "select";
		} else if ( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "one-to-many" ) {
			throw("There is now property field type for one-to-many relationship properties");
		} else if ( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-many" ) {
			return "multiselect";
		}
		
		// Default case if no matches were found is a text field
		return "text";
	}
	
	// @help public method for getting a recursive list of all the meta data of the properties of an object
	public array function getProperties(struct metaData=getMetaData(this)) {
		var properties = arguments.metaData["properties"];
		var parentProperties = "";
		// recursively get properties of any super classes
		if(structKeyExists(arguments.metaData, "extends") && structKeyExists(arguments.metaData.extends,"properties")) {
			parentProperties = getProperties(arguments.metaData["extends"]);
			return getService("utilityService").arrayConcat(parentProperties,properties);
		} else {
			return properties;
		}
	}
	
	// @help public method for getting the meta data of a specific property
	public struct function getPropertyMetaData(string propertyName) {
		var properties = getProperties();
		for(var i=1; i<=arrayLen(properties); i++) {
			if(properties[i].name eq arguments.propertyName) {
				return properties[i];
			}
		}
		// If no properties found with the name throw error 
		throw("No property found with name #propertyName# in #getClassName()#");
	}
	
	// @hint return a simple representation of this entity
	public string function getSimpleRepresentation() {
		
		// get the representation propertyName
		var representationProperty = this.invokeMethod("get#getSimpleRepresentationPropertyName()#");
		
		// Make sure it wasn't blank
		if(representationProperty != "") {
			
			// Try to get the actual value of that property
			var representation = this.invokeMethod("get#getSimpleRepresentationPropertyName()#");
			
			// If the value isn't null, and it is simple, then return it.
			if(!isNull(representation) && isSimpleValue(representation)) {
				return representation;
			}	
		}
		
		// Default case is to return a blank value
		return "";
	}
	
	// @hint returns the propety who's value is a simple representation of this entity.  This can be overridden when necessary
	public string function getSimpleRepresentationPropertyName() {
		
		// Get the meta data for all of the porperties
		var properties = getProperties();
		
		// Look for a property that's last 4 is "name"
		for(var i=1; i<=arrayLen(properties); i++) {
			if(right(properties[i].name, 4) == "name") {
				return properties[i].name;
			}
		}
		
		// If no properties could be identified as a simpleRepresentaition 
		throw("There is no Simple Representation Property Name for #getClassName()#");
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
		return getMetaData( this ).fullname;
	}
	
	// @help Public method to determine if this is a persistent object
	public any function isPersistent() {
		var metaData = getMetaData( this );
		if(structKeyExists(metaData, "persistent") && metaData.persistent) {
			return true;
		}
		return false;
	}
	
	// @hint Returns the ValidateThis result object, if one hasn't been setup yet it returns a new one
	public any function getVTResult() {
		if(!structKeyExists(variables, "vtResult")) {
			variables.vtResult = getValidateThis().newResult(); 
		}
		return variables.vtResult;
	}
	
	// @hint Returns the errorBeant object, if one hasn't been setup yet it returns a new one
	public any function getErrorBean() {
		if(!structKeyExists(variables, "errorBean")) {
			variables.errorBean = new Slatwall.com.utility.ErrorBean(); 
		}
		return variables.errorBean;
	}
	
	// @hint Returns true if this object has any errors.
	public boolean function hasErrors() {
		if(getVTResult().hasErrors() || getErrorBean().hasErrors()) {
			return true;
		}
		
		return false;
	}
	
	// @hint Returns a struct of all the errors for this entity
	public struct function getErrors() {
		var errorsStruct = {};
		
		// Check the VTResult for any errors
		for(var key in getVTResult().getErrors()) {
			errorsStruct[key] = getVTResult().getErrors()[key];	
		}
		
		// Check the ErrorBean for any errors
		for(var key in getErrorBean().getErrors()) {
			if(structKeyExists(errorsStruct, key)) {
				for(var i=1; i<=arrayLen(getErrorBean().getErrors()[key]); i++) {
					arrayAppend(errorsStruct[key], getErrorBean().getErrors()[key][i]);	
				}
			} else {
				errorsStruct[key] = getErrorBean().getErrors()[key];	
			}
		}
		
		// Default behavior if this object hasn't been validated is to return a blank struct
		return errorsStruct;
	}
	
	// @hint Returns true if a specific error key exists
	public boolean function hasError( required string errorName ) {
		return structKeyExists(getErrors(), arguments.errorName);
	}
	
	// @hint Returns the error message of a given error name
	public array function getError( required string errorName ) {
		
		// Check First that the error exists, and if it does return it
		if( hasError(arguments.errorName) ) {
			return getErrors()[ arguments.errorName ];
		}
		
		// Default behavior if the error isn't found is to return an empty array
		return [];
	}
	
	// @hint helper method to add an error to the error bean	
	public void function addError( required string errorName, required string errorMessage ) {
		getErrorBean().addError(argumentCollection=arguments);
	}
	
	public any function formatValue( required string value, required string formatType ) {
		/*
			Valid formatType Strings are:
		
			none
			yesno
			truefalse
			currency
			datetime
			date
			time
			weight
			
		*/
		
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
				return LSCurrencyFormat(arguments.value, setting("advanced_currencyType"), setting("advanced_currencyLocale"));
			}
			case "datetime": {
				return dateFormat(arguments.value, setting("advanced_dateFormat")) & " " & TimeFormat(value, setting("advanced_timeFormat"));
			}
			case "date": {
				return dateFormat(arguments.value, setting("advanced_dateFormat"));
			}
			case "time": {
				return timeFormat(arguments.value, setting("advanced_timeFormat"));
			}
			case "weight": {
				return arguments.value & " " & setting("advanced_weightFormat");
			}
		}
		
		return arguments.value;
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
	
	// @hint helper function for returning the any of the services in the application
	public any function getService(required string serviceName) {
		return getPluginConfig().getApplication().getValue("serviceFactory").getBean(arguments.serviceName);
	}
	
	// @hint Private helper function absolute url path from site root
	private string function getSlatwallRootPath() {
		return "#application.configBean.getContext()#/plugins/Slatwall";
	}
	
	// @hint Private helper function the file system directory
	private string function getSlatwallRootDirectory() {
		return expandPath("/plugins/Slatwall");
	}
	
	// @hint Private helper function to return the Slatwall RB Factory in any component
	private any function getRBFactory() {
		return getPluginConfig().getApplication().getValue("rbFactory");
	}
	
	// @hint Private helper function for returning the plugin config inside of any component in the application
	private any function getPluginConfig() {
		return application.slatwall.pluginConfig;
	}
	
	// @hint Private helper function for returning the fw
	private any function getFW() {
		return getPluginConfig().getApplication().getValue('fw');
	}
	
	// @hint Private helper function for returning the Validate This Facade Object
	private any function getValidateThis() {
		return getPluginConfig().getApplication().getValue('validateThis');
	}
	
	// @hint Private helper function for returning the Validate This Facade Object
	private any function getCFStatic() {
		return getPluginConfig().getApplication().getValue('cfStatic');
	}
	
	// @hint Private helper function for returning a new API key for a specific resource for this session
	private string function getAPIKey(required string resource, required string verb) {
		return getService("sessionService").getAPIKey(argumentcollection=arguments);
	}
	
	// @hint Private helper function to return the RB Key from RB Factory in any component
	private string function rbKey(required string key, string local) {
		if( !structKeyExists(arguments, "local") ) {
			arguments.local = session.rb;
		}
		return getRBFactory().getKeyValue(arguments.local, arguments.key);
	}
	
	// @hint Private helper function to return a Setting
	private any function setting(required string settingName) {
		return getService("settingService").getSettingValue(arguments.settingName);
	}
	
	// @hint Private helper function for building URL's
	private string function buildURL() {
		return getFW().buildURL(argumentCollection = arguments);
	}
	
	// @hint Private helper function for getting checking security
	private boolean function secureDisplay() {
		return getFW().secureDisplay(argumentCollection = arguments);
	}
	
	
	// Used as a debugging to to perform a <cfdump> from anywhere within the application and have it show as full screen output. Provide any object as argument.
	public any function dumpScreen(required any obj){
		GetPageContext().getOut().clearBuffer();
    	savecontent variable="local.theContent" {
    		writeDump(obj);
    	}
    	GetPageContext().getResponse().getWriter().write(theContent);
    	abort;
	}
	
	// This can be expanded, but kept it simple for now.
	public void function logSlatwall(required string message){
		getService("logService").logMessage(message=arguments.message, generalLog=false);		
	}
	
	// TODO: Confirm with Greg what he intends to do with this method. 
	/*public string function getExternalSiteLink(required string address) {
		return arguments.address;	
	}*/
		
}
