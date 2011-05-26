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
component extends="Slatwall.com.utility.BaseObject" accessors="true" {

	// @hint constructor for the validator class
	public Validator function init(){
		return this;
	}
	
	// @hint main validation method that calls the individual validator class
	public struct function validateValue(
		String rule,
		any criteria,
		Any objectValue,
		String objectName,
		String objectLabel,
		String message
		 ){
		
		var validatorClass = getClassNameByRule(arguments.rule);
		var isValid = createObject("component",validatorClass).init(argumentCollection=arguments);
		
		if(!isValid){
			// if the error message wasn't passed in, get it now
			if(!structKeyExists(arguments,"message")) {
				arguments.message = getMessageByRule(arguments.rule,arguments.objectName);
			}
			var error = getError(argumentCollection=arguments);
			return error;
		} else {
			return {};
		}
	}
	
	// @hint method to validate entity based on property definition, returns a responseBean 
	public function validate(required any entity, struct objMD){
		var objMetadata = isNull(objMD) ? getMetadata(entity) : objMD ;
		// get the object property array 
		var props = isNULL(objMetadata.properties) ? [] : objMetadata.properties;
		var errors = {};
		//loop through each property;
		for(var i=1; i <= arrayLen(props); i++) {
			var prop = props[i] ;
			var name = prop["name"] ;
			var val =  isNull(evaluate("arguments.entity." & "get#name#()")) ? "" : evaluate("arguments.entity." & "get#name#()") ;
			var displayName = structKeyExists(prop,"displayname") ? prop["displayName"] : getPropertyLabel(entity=arguments.entity, propertyName=name);
			var attrib = "";
			//loop through each attribute to look for validation rule
			for(attrib in prop){
				if(attrib.toLowerCase().startsWith("validate")){
					var validationRule = replaceNoCase(attrib,"validate","","one");
					var criteria = prop[attrib];
					var message = getMessageByRule(validationRule,name,arguments.entity);
					if(len(validationRule)){
						var error = validateValue(validationRule,criteria,val,name,displayName,message);
						if(!structIsEmpty(error)){
							errors[error.name] = error.Message;
						}
					}
				}
			}
		}
		response = new Slatwall.com.utility.ResponseBean({data=arguments.entity});
		if( !structIsEmpty(errors) ) {
			response.getErrorBean().setErrors(errors);
		}
		return response;
	}
	
	// @hint method to validate entity based on property definition, returns a the entity with errors in the errorBean 
	public any function validateObject(required any entity) {
		var response = validate(arguments.entity);
		if( hasErrorBean(arguments.entity) && response.hasErrors() ) {
			arguments.entity.getErrorBean().setErrors(response.getErrorBean().getErrors());
		}
		return arguments.entity;
	}


	//@hint method for setting errors in the entity that come from outside the property value (i.e. file uploads)
	public void function setError(required any entity, string errorName, string rule) {
		var message=getMessageByRule(entity=arguments.entity,propertyName=arguments.errorName,rule=arguments.rule);
		arguments.entity.addError(name=arguments.errorName,message=message);
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

	// @hint returns an error name/message struct
	public struct function getError(Any objectValue="",String objectName="",String objectLabel="",any criteria = "", String Message=""){
		//if label is not defined, default it to name
		var displayName = arguments.objectLabel != "" ? arguments.objectLabel : arguments.objectName; 
		var msg = arguments.message;
		msg = replaceNoCase(msg,"{objectLabel}",displayName,"all");
		msg = replaceNoCase(msg,"{objectValue}",arguments.objectValue,"all");
		msg = replaceNoCase(msg,"{criteria}",arguments.criteria,"all");
		var errorName = arguments.objectName != "" ? arguments.objectName : arguments.rule;
		return {name=errorName, message=msg};
	}
	
	
	//@hint gets the entity's property label from the rb
	private string function getPropertyLabel(required any entity, required string propertyName) {
		//first remove the "Slatwall" prefix from the entity name
		var entityName = replaceNoCase(arguments.entity.getClassName(),"Slatwall","","one");
		return rbKey("entity." & entityName & "." & arguments.propertyName);
	}
	
	// @hint returns error message by validation rule from the resource bundle
	private string function getMessageByRule(required string rule, required string propertyName, any entity){
		var message = "";
		if(structKeyExists(arguments,"entity")) {
			//if this is an entity-related error, first remove the "Slatwall" prefix from the entity name
			if(structKeyExists(arguments.entity,"getClassName")) {
				var entityName = replaceNoCase(arguments.entity.getClassName(),"Slatwall","","one");
				message = rbKey("entity.#entityName#.#arguments.propertyName#_validate#arguments.rule#");
			}
			if(right(message,8) == "_missing" || !structKeyExists(arguments.entity,"getClassName") ) {
				message = rbKey("validator.#arguments.rule#");
			}	
		} else {
			// error isn't necessarily entity-related, so get generic message for rule
			message = rbKey("validator.#arguments.rule#");
		}
		return message;
	}

	private string function rbKey(required string key) {
		return getRBFactory().getKeyValue(session.rb,arguments.key);
	}

}
