/*
Copyright: ten24, LLC
Author: Sumit Verma(sumit.verma@ten24web.com)
$Id: Validator.cfc 77 2010-03-05 05:06:12Z sumit.verma $

Notes:
*/
import slat.com.entity.ErrorBean;
component accessors="true"
{

	/**
	 * @hint name/path of properties file that contains default validation messages
	 */
	property string resourceBundle;
	property array validationMessages;
	property ErrorBean errors;

	/**
	 * @hint constructor for the validator class
	 */
	public Validator function init(String rb="DefaultValidationMessages",Boolean isAbsolutePath=false){
		this.setResourceBundle(arguments.rb);
		this.setValidationMessages(arrayNew(1));
		this.setErrors(new ErrorBean());
		loadResourceBundle(arguments.isAbsolutePath);
		return this;
	}
	
	/**
	 * @hint main validation method that calls the individual validator class
	 */
	public void function validate(
		String rule,
		Any objectValue,
		String objectName,
		String objectLabel,
		String message=""
		 ){
		
		var validatorClass = getClassNameByRule(arguments.rule);
		var isValid = createObject("component",validatorClass).init(argumentCollection=arguments);
		
		if(!isValid){
			addError(argumentCollection=arguments);
		}

	}
	
	/**
	* @hint method to validate entity based on property definition 
	*/
	public function validateObject(required any obj, struct objMD){
		var objMetadata = isNull(objMD) ? getMetadata(obj) : objMD ;
		// get the object property array 
		var props = isNULL(objMetadata.properties) ? [] : objMetadata.properties;
		//loop through each property;
		for(var i=1; i <= arrayLen(props); i++) {
			var prop = props[i] ;
			var name = prop["name"] ;
			var val =  isNull(evaluate("obj." & "get#name#()")) ? "" : evaluate("obj." & "get#name#()") ;
			var displayName = structKeyExists(prop,"displayName") ? prop["displayName"] : "" ;
			var attrib = "";
			//loop through each attribute to look for validation rule
			for(attrib in prop){
				if(attrib.toLowerCase().startsWith("validate")){
					var validationRule = replaceNoCase(attrib,"validate","","one") ;
					if(len(validationRule)){
						var message = prop[attrib] ;
						validate(validationRule,val,name,displayName,message) ;
					}
				}
			}
		}
		//if error bean exists in the object set it
		if(arrayLen(structFindValue({mainprop=props,extendedprop=objMetadata.extends.properties},'errorBean'))){
			obj.setErrorBean(this.geterrors()) ;
		}
		return this.getErrors();
	}
	
	/**
	 * @hint returns the validator class name by validation rule.
	 */
	private string function getClassNameByRule(String rule){
		var className = "validator." & arguments.rule & "Validator";
		
		return className;
	}
	
	/**
	 * @hint A way to see if the validate method produced any errors.
	 */
	public boolean function hasErrors(){
		return this.getErrors().hasErrors();
	}

	/**
	 * @hint adds an error to the errors errorBean
	 */
	public void function addError(Any objectValue="",String objectName="",String objectLabel="",String Message=""){
		//if lable is not defined, default it to name
		var displayName = arguments.objectLabel != "" ? arguments.objectLabel : arguments.objectName; 
		var msg = arguments.message != "" ? arguments.message : getMessageByRule(arguments.rule);
		msg = replaceNoCase(msg,"{objectLabel}",displayName,"all");
		msg = replaceNoCase(msg,"{objectValue}",arguments.objectValue,"all");
		var errorName = arguments.objectName != "" ? arguments.objectName : arguments.rule;
		this.getErrors().addError(errorName,msg);
	}
	
	/**
	 * @hint returns default error message by validation rule
	 */
	private string function getMessageByRule(String rule){
		var message = "";
		var messages = this.getValidationMessages();

		for(i=1; i <= arrayLen(messages); ++i){
			if(messages[i].rule == arguments.rule){
				message = messages[i].message;
				break;
			}
		}

		return message;
	}

	/**
	 * @hint Loads the default error messages from the properties file
	 */
	private void function loadResourceBundle(Boolean isAbsolutePath=false){
		if(arguments.isAbsolutePath){
			var rbpath = this.getResourceBundle();
		} else {
			var dir = getDirectoryFromPath(getCurrentTemplatePath());
			var rbPath = dir & "validator/resources/" & this.getResourceBundle();
		}

		// read in the properties for the resource bundle
		if(findNoCase(".properties",this.getResourceBundle())){
			var file = fileOpen(rbPath);
		} else {
			var file = fileOpen(rbPath & ".properties");
		}

	    while (! fileIsEOF(file)) {
	        var x = fileReadLine(file);
			var rule = listFirst(x,"=");
			var message = listLast(x,"=");
			var messageStruct = {rule=rule,message=message};
			arrayAppend(this.getValidationMessages(),messageStruct);
	    }
		fileClose(file);
	}

}