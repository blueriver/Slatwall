component output="false" accessors="true" extends="HibachiService" {
	
	variables.validationStructs = {};
	variables.validationByContextStructs = {};
	
	public struct function getValidationStruct(required any object) {
		if(!structKeyExists(variables.validationStructs, arguments.object.getClassName())) {
			
			// Get CORE Validations
			var coreValidationFile = expandPath('/#getApplicationValue('applicationKey')#/model/validation/#arguments.object.getClassName()#.json'); 
			var validation = {};
			if(fileExists( coreValidationFile )) {
				var rawCoreJSON = fileRead( coreValidationFile );
				if(isJSON( rawCoreJSON )) {
					validation = deserializeJSON( rawCoreJSON );
				} else {
					logHibachi("The Validation File: #coreValidationFile# is not a valid JSON object");
				}
			}
			
			// Get Custom Validations
			var customValidationFile = expandPath('/#getApplicationValue('applicationKey')#/custom/model/validation/#arguments.object.getClassName()#.json');
			var customValidation = {};
			if(fileExists( customValidationFile )) {
				var rawCustomJSON = fileRead( customValidationFile );
				if(isJSON( rawCustomJSON )) {
					customValidation = deserializeJSON( rawCustomJSON );
				} else {
					logHibachi("The Validation File: #customValidationFile# is not a valid JSON object");
				}
			}
			
			// Make sure that the validation struct has contexts & properties
			param name="validation.contexts" default="#arrayNew(1)#";
			param name="validation.properties" default="#structNew()#";
			
			// Add any custom contexts
			if(structKeyExists(customValidation, "contexts")) {
				for(var c=1; c<=arrayLen(customValidation.contexts); c++) {
					if(!arrayFindNoCase(validation.contexts, customValidation.contexts[c])) {
						arrayAppend(validation.contexts, customValidation.contexts[c]);
					}
				}
			}
			
			// Add any additional rules
			if(structKeyExists(customValidation, "properties")) {
				for(var key in customValidation.properties) {
					if(!structKeyExists(validation.properties, key)) {
						validation.properties[ key ] = customValidation.properties[ key ];
					} else {
						for(var r=1; r<=arrayLen(customValidation.properties[ key ]); r++) {
							arrayAppend(validation.properties[ key ],customValidation.properties[ key ][r]);	
						}
					}
				}
			}
			
			variables.validationStructs[ arguments.object.getClassName() ] = validation;
		}
		
		return variables.validationStructs[ arguments.object.getClassName() ];
	}
	
	public struct function getValidationsByContext(required any object, string context="") {
		if(!structKeyExists(variables.validationByContextStructs, "#arguments.object.getClassName()#-#arguments.context#")) {
			var contextValidations = {};
			var validationStruct = getValidationStruct(object=arguments.object);
			for(var property in validationStruct.properties) {
				for(var r=1; r<=arrayLen(validationStruct.properties[property]); r++) {
					var rule = validationStruct.properties[property][r];
					if(!structKeyExists(rule, "contexts") || listFindNoCase(rule.contexts, arguments.context)) {
						if(!structKeyExists(contextValidations, property)) {
							contextValidations[ property ] = {};
						}
						for(var constraint in rule) {
							if(constraint != "contexts") {
								contextValidations[ property ][ constraint ] = rule[ constraint ];
							}
						}
					}
				}
			}
			variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"] = contextValidations;
		}
		return variables.validationByContextStructs["#arguments.object.getClassName()#-#arguments.context#"];
	}
	
	public any function validate(required any object, string context="", boolean setErrors=true) {
		// Setup an error bean
		if(setErrors) {
			var errorBean = arguments.object.getHibachiErrors();
		} else {
			var errorBean = getTransient("hibachiErrors");
		}
		
		// Get the valdiations for this context
		var contextValidations = getValidationsByContext(object=arguments.object, context=arguments.context);
		for(var propertyName in contextValidations) {
			if(arguments.object.hasProperty( propertyName )) {
				for(var constraint in contextValidations[ propertyName ]) {
					this.invokeMethod("validate_#constraint#", {object=arguments.object, propertyName=propertyName, constraintValue=contextValidations[ propertyName ][ constraint ]});
				}
			}
		}
		
		// If the setErrors was true, then we can set this error
		if(setErrors) {
			var errorBean = arguments.object.getHibachiErrors();
		}
		return errorBean;
	}
	
	public boolean function validate_required(required any object, required string propertyName, boolean constraintValue=true) {
		var value = arguments.object.invokeMethod("get#arguments.property#");
		if(!isNull(value) && len(value)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_dataType(required any object, required string propertyName, required any constraintValue) {
		var value = arguments.object.invokeMethod("get#arguments.property#");
		
		if(isNull(value)) {
			return true;
		} else if(arguments.constraintValue eq "email") {
			return true;
		} else if (arguments.constraintValue eq "url") {
			return true;
		} else if (arguments.constraintValue eq "numeric" && isNumeric(value)) {
			return true;
		} else if (arguments.constraintValue eq "array" && isArray(value)) {
			return true;
		} else if (arguments.constraintValue eq "boolean" && isBoolean(value)) {
			return true;
		} else if (arguments.constraintValue eq "date" && isDate(value)) {
			return true;
		} else if (arguments.constraintValue eq "json" && isJSON(value)) {
			return true;
		} else if (arguments.constraintValue eq "object" && isObject(value)) {
			return true;
		} else if (arguments.constraintValue eq "query" && isQuery(value)) {
			return true;
		} else if (arguments.constraintValue eq "query" && isSimpleValue(value)) {
			return true;
		}
		
		return false;
	}
	
	public boolean function validate_minValue(required any object, required string propertyName, required any constraintValue) {
		var value = arguments.object.invokeMethod("get#arguments.property#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue gte arguments.propertyValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxValue(required any object, required string propertyName) {
		var propertyValue = arguments.object.invokeMethod("get#arguments.property#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue lte arguments.propertyValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minLength(required any object, required string propertyName) {
	}
	
	public boolean function validate_maxLength(required any object, required string propertyName) {
	}
	
	public boolean function validate_minCollection(required any object, required string propertyName) {
	}
	
	public boolean function validate_maxCollection(required any object, required string propertyName) {
	}
	
	public boolean function validate_method(required any object, required string propertyName) {
	}
	
	public boolean function validate_lteProperty(required any object, required string propertyName) {
		
	}
	
	public boolean function validate_ltProperty(required any object, required string propertyName) {
		
	}
	
	public boolean function validate_gteProperty(required any object, required string propertyName) {
		
	}
	
	public boolean function validate_gtProperty(required any object, required string propertyName) {
		
	}
	
	public boolean function validate_eqProperty(required any object, required string propertyName) {
		
	}
	
	public boolean function validate_neqProperty(required any object, required string propertyName) {
		
	}
	
	
	
	
	
	
	/*
	Required	Boolean	Whether the property must have a non-null value
	
	IsValid *	String	Validates that the value is of a certain format type. Our included types are: 
	ssn,email,url,alpha,boolean,date,usdate,eurodate,numeric,GUID,UUID,integer,string,telephone,zipcode,ipaddress,creditcard,binary,
	component,query,struct,json,xml
	
	Size	Numeric or Range	The size or length of the value which can be a struct, string, array, or query. The value can be a single numeric value or our cool ranges. 
	Ex: size=4, size=6..8, size=-5..0
	
	Range	Range	Range is a range of values the property value should exist in. Ex: range=1..10, range=6..8
	
	Regex	Regular Expression	The regular expression to try and match the value with for validation. This is a no case regex check.
	
	SameAs	Property Name	Makes sure the value of the constraint is the same as the value of another property in the object. This is a case sensitive check.
	
	SameAsNoCase	Property Name	Makes sure the value of the constraint is the same as the value of another property in the object with no case sensitivity.
	
	InList	List	A list of values that the property value must exist in
	
	Discrete	String	Do discrete math in the property value. The valid values are: eq,neq,lt,lte,gt,gte. Example: discrete="eq:4" or discrete="lte:10"
	
	Method	Method Name	The name of a method to call in the target object for validation. The function must return boolean.
	
	Min	Numeric	The value must be greater than or equal to this minimum value
	
	Max	Numeric	The value must be less than or equal to this maximum value
	
	Validator	Instantiation Path	You can also build your own validators instead of our internal ones. This value will be the instantiation path to the validator and method.
	Example: validator="com.user.UserService.isUsernameCool". com.user.UserService is the path to the component and isUsernameCool
	is the method that will return a boolean.
	
	Numeric	Any	Whether the value is a numeric value. This constraint uses the built in function isNumeric under the hood.
	
	Unique	Boolean	I will determine if the value already exists in the database. This constraint works with ORM to determine if the property value is a duplicate.
	
	*/
}