component extends="Slatwall.com.utility.BaseObject" accessors="true" {

	// @hint constructor for the validator class
	public Validator function init(){
		return this;
	}
	
	// @hint main validation method that calls the individual validator class
	public struct function validate(
		String rule,
		Any objectValue,
		String objectName,
		String objectLabel,
		String message
		 ){
		
		var validatorClass = getClassNameByRule(arguments.rule);
		var isValid = createObject("component",validatorClass).init(argumentCollection=arguments);
		
		if(!isValid){
			var error = getError(argumentCollection=arguments);
			return error;
		} else {
			return {};
		}
	}
	
	// @hint method to validate entity based on property definition 
	public function validateObject(required any entity, struct objMD){
		var objMetadata = isNull(objMD) ? getMetadata(entity) : objMD ;
		// get the object property array 
		var props = isNULL(objMetadata.properties) ? [] : objMetadata.properties;
		//loop through each property;
		for(var i=1; i <= arrayLen(props); i++) {
			var prop = props[i] ;
			var name = prop["name"] ;
			var val =  isNull(evaluate("arguments.entity." & "get#name#()")) ? "" : evaluate("arguments.entity." & "get#name#()") ;
			var displayName = getPropertyLabel(entity=arguments.entity, propertyName=name);
			var attrib = "";
			//loop through each attribute to look for validation rule
			for(attrib in prop){
				if(attrib.toLowerCase().startsWith("validate")){
					var validationRule = replaceNoCase(attrib,"validate","","one");
					var message = getMessageByRule(validationRule,name,arguments.entity);
					if(len(validationRule)){
						var error = validate(validationRule,val,name,displayName,message);
						if(!structIsEmpty(error) and hasErrorBean(arguments.entity)){
							arguments.entity.addError(argumentCollection=error);
						}
					}
				}
			}
		}
		return arguments.entity;
	}
	
	// @hint Checks if entity has an error bean
	private boolean function hasErrorBean(required any entity) {
		var objMetadata = getMetadata(arguments.entity);
		var props = isNULL(objMetadata.properties) ? [] : objMetadata.properties;	
		return arrayLen(structFindValue({mainprop=props,extendedprop=objMetadata.extends.properties},'errorBean'));
	}
	
	
	// @hint returns the validator class name by validation rule.
	private string function getClassNameByRule(String rule){
		var className = "validator." & arguments.rule & "Validator";
		
		return className;
	}
	
	// @hint A way to see if the validate method produced any errors.
	/*public boolean function hasErrors(){
		return this.getErrors().hasErrors();
	}*/

	// @hint returns an error name/message struct
	public struct function getError(Any objectValue="",String objectName="",String objectLabel="",String Message=""){
		//if lable is not defined, default it to name
		var displayName = arguments.objectLabel != "" ? arguments.objectLabel : arguments.objectName; 
		var msg = arguments.message;
		msg = replaceNoCase(msg,"{objectLabel}",displayName,"all");
		msg = replaceNoCase(msg,"{objectValue}",arguments.objectValue,"all");
		var errorName = arguments.objectName != "" ? arguments.objectName : arguments.rule;
		return {name=errorName, message=msg};
	}
	
	
	//@hint gets the entitie's property label from the rb
	private string function getPropertyLabel(required any entity, required string propertyName) {
		//first remove the "Slatwall" prefix from the entity name
		var entityName = replaceNoCase(arguments.entity.getClassName(),"Slatwall","","one");
		return rbKey("entity." & entityName & "." & arguments.propertyName);
	}
	
	// @hint returns error message by validation rule from the resource bundle
	private string function getMessageByRule(required string rule, required string propertyName, required any entity){
		//first remove the "Slatwall" prefix from the entity name
		var entityName = replaceNoCase(arguments.entity.getClassName(),"Slatwall","","one");
		var message = rbKey("entity.#entityName#.#arguments.propertyName#_validate#arguments.rule#");
		if(right(message,8) == "_missing") {
			message = rbKey("validator.#arguments.rule#");
		}
		return message;
	}

	private string function rbKey(required string key) {
		return getRBFactory().getKeyValue(session.rb,arguments.key);
	}

}
