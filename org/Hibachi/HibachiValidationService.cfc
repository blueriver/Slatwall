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
					throw("The Validation File: #coreValidationFile# is not a valid JSON object");
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
			
			// Loop over each proeprty in the validation struct looking for rule structures
			for(var property in validationStruct.properties) {
				
				// For each array full of rules for the property, loop over them and check for the context
				for(var r=1; r<=arrayLen(validationStruct.properties[property]); r++) {
					
					var rule = validationStruct.properties[property][r];
					
					// Verify that either context doesn't exist, or that the context passed in is in the list of contexts for this rule
					if(!structKeyExists(rule, "contexts") || listFindNoCase(rule.contexts, arguments.context)) {
						
						if(!structKeyExists(contextValidations, property)) {
							contextValidations[ property ] = [];
						}
						
						for(var constraint in rule) {
							if(constraint != "contexts" && constraint != "conditions") {
								var constraintDetails = {
									constraintType=constraint,
									constraintValue=rule[ constraint ]
								};
								if(structKeyExists(rule, "conditions")) {
									constraintDetails.conditions = listToArray(rule.conditions);
								}
								arrayAppend(contextValidations[ property ], constraintDetails);
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
		
		// Loop over each property in the validations for this context
		for(var propertyIdentifier in contextValidations) {
			
			// First make sure that the proerty exists
			if(arguments.object.hasProperty( propertyIdentifier )) {
				
				// Loop over each of the constraints for this given property
				for(var c=1; c<=arrayLen(contextValidations[ propertyIdentifier ]); c++) {
					
					// Check that one of the conditions were meet if there were conditions for this constraint
					var conditionMeet = true;
					if(structKeyExists(contextValidations[ propertyIdentifier ][c], "conditions")) {
						conditionMeet = false;
						// Loop over each condition to check if it is true
						for(var x=1; x<=arrayLen(contextValidations[ propertyIdentifier ][c].conditions); x++) {
							
							var conditionName = contextValidations[ propertyIdentifier ][c].conditions[x];
							var fullValidationStruct = getValidationStruct( object=arguments.object );
							
							// Make sure that the condition is defined in the meta data
							if(structKeyExists(fullValidationStruct, "conditions") && structKeyExists(fullValidationStruct.conditions, conditionName)) {
								
								var allConditionConstraintsMeet = true;
								
								// Loop over each propertyIdentifier for this condition
								for(var conditionPropertyIdentifier in fullValidationStruct.conditions[ conditionName ]) {
									
									// Loop over each constraint for the property identifier to validate the constraint
									for(var constraint in fullValidationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ]) {
										if(structKeyExists(variables, "validate_#constraint#") && !invokeMethod("validate_#constraint#", {object=arguments.object, propertyIdentifier=conditionPropertyIdentifier, constraintValue=fullValidationStruct.conditions[ conditionName ][ conditionPropertyIdentifier ][ constraint ]})) {
											allConditionConstraintsMeet = false;	
										}
									}
								}
								
								// If all constraints of this condition are meet, then we no that one condition is meet for this rule.
								if( allConditionConstraintsMeet ) {
									conditionMeet = true;
									break;
								}
							}
						}
					}
					
					// Now if a condition was meet we can actually test the individual validation rule
					if(conditionMeet) {
						validateConstraint(object=arguments.object, propertyIdentifier=propertyIdentifier, constraintDetails=contextValidations[ propertyIdentifier ][c], errorBean=errorBean, context=arguments.context);	
					}
				}	
			}
		}
		
		// If the setErrors was true, then we can set this error
		if(setErrors) {
			arguments.object.setHibachiErrors( errorBean );
		}
		
		return errorBean;
	}
	
	
	public any function validateConstraint(required any object, required string propertyIdentifier, required struct constraintDetails, required any errorBean, required string context) {
		if(!structKeyExists(variables, "validate_#arguments.constraintDetails.constraintType#")) {
			throw("You have an error in the #arguments.object.getClassName()#.json validation file.  You have a constraint defined for '#arguments.propertyIdentifier#' that is called '#arguments.constraintDetails.constraintType#' which is not a valid constraint type");
		}
		
		var isValid = invokeMethod("validate_#arguments.constraintDetails.constraintType#", {object=arguments.object, propertyIdentifier=arguments.propertyIdentifier, constraintValue=arguments.constraintDetails.constraintValue});	
					
		if(!isValid) {
			var replaceTemplateStruct = {};
			var thisPropertyName = listLast(arguments.propertyIdentifier, '._');
			if(arguments.object.isPersistent()) {
				var thisClassName = getLastEntityNameInPropertyIdentifier( arguments.object.getClassName(), arguments.propertyIdentifier);
				replaceTemplateStruct.className = getHibachiScope().rbKey('entity.#thisClassName#');
				replaceTemplateStruct.propertyName = getHibachiScope().rbKey('entity.#thisClassName#.#thisPropertyName#');
			} else {
				var thisClassName = arguments.object.getClassName();
				replaceTemplateStruct.className = getHibachiScope().rbKey('processObject.#thisClassName#');
				replaceTemplateStruct.propertyName = getHibachiScope().rbKey('processObject.#thisClassName#.#thisPropertyName#');
			}
			replaceTemplateStruct.constraintValue = arguments.constraintDetails.constraintValue;
			if(arguments.constraintDetails.constraintType eq "method") {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintValue#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			} else if (arguments.constraintDetails.constraintType eq "dataType") {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintType#.#arguments.constraintDetails.constraintValue#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			} else {
				var errorMessage = getHibachiScope().rbKey('validate.#arguments.context#.#thisClassName#.#thisPropertyName#.#arguments.constraintDetails.constraintType#');
				errorMessage = getHibachiUtilityService().replaceStringTemplate(errorMessage, replaceTemplateStruct);
				arguments.errorBean.addError(arguments.propertyIdentifier, errorMessage);
			}
		}
	}
	
	
	// ================================== VALIDATION CONSTRAINT LOGIC ===========================================
	
	public boolean function validate_required(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && (isObject(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue)) || (isStruct(propertyValue) && structCount(propertyValue)) || (isSimpleValue(propertyValue) && len(propertyValue)))) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_dataType(required any object, required string propertyIdentifier, required any constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		
		if(listFindNoCase("any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode",arguments.constraintValue)) {
			if(isNull(propertyValue) || isValid(arguments.constraintValue, propertyValue)) {
				return true;
			}
		} else {
			throw("The validation file: #arguments.object.getClassName()#.json has an incorrect dataType constraint value of '#arguments.constraintValue#' for one of it's properties.  Valid values are: any,array,binary,boolean,component,creditCard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,regular_expression,ssn,social_security_number,string,telephone,url,uuid,usdate,zipcode");
		}
		
		return false;
	}
	
	public boolean function validate_minValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxValue(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isNumeric(propertyValue) && propertyValue <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) >= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxLength(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isSimpleValue(propertyValue) && len(propertyValue) <= arguments.constraintValue) ) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) >= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) >= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxCollection(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue) || (isArray(propertyValue) && arrayLen(propertyValue) <= arguments.constraintValue) || (isStruct(propertyValue) && structCount(propertyValue) <= arguments.constraintValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_minList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) >= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_maxList(required any object, required string propertyIdentifier, required numeric constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if((!isNull(propertyValue) && isSimpleValue(propertyValue) && listLen(propertyValue) <= arguments.constraintValue) || (isNull(propertyValue) && arguments.constraintValue == 0)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_method(required any object, required string propertyIdentifier, required string constraintValue) {
		return arguments.object.invokeMethod(arguments.constraintValue);
	}
	
	public boolean function validate_lte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue <= arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_lt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue < arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gte(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue >= arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gt(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue > arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_eq(required any object, required string propertyIdentifier, required string constraintValue) {
		var objectOnly = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue == arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_neq(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && !isNull(propertyValue) && propertyValue != arguments.constraintValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_lteProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue <= compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_ltProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue < compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gteProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue >= compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_gtProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue > compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_eqProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue == compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_neqProperty(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		var compairPropertyValue =  arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#arguments.constraintValue#");
		if(!isNull(propertyValue) && !isNull(compairPropertyValue) && propertyValue != compairPropertyValue) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_inList(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && listFindNoCase(arguments.constraintValue, propertyValue)) {
			return true;
		}
		return false;
	}
	
	public boolean function validate_unique(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var uniqueObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		return getHibachiDAO().isUniqueProperty(propertyName=listLast(arguments.propertyIdentifier,'._'), entity=uniqueObject);
	}
	
	public boolean function validate_uniqueOrNull(required any object, required string propertyIdentifier, boolean constraintValue=true) {
		var uniqueObject = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier );
		var propertyValue = object.invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(isNull(propertyValue)) {
			return true;
		}
		return getHibachiDAO().isUniqueProperty(propertyName=listLast(arguments.propertyIdentifier,'._'), entity=uniqueObject);
	}
	
	public boolean function validate_regex(required any object, required string propertyIdentifier, required string constraintValue) {
		var propertyValue = arguments.object.getLastObjectByPropertyIdentifier( arguments.propertyIdentifier ).invokeMethod("get#listLast(arguments.propertyIdentifier,'._')#");
		if(!isNull(propertyValue) && isValid("regex", propertyValue, arguments.constraintValue)) {
			return true;
		}
		return false;
	}

}
