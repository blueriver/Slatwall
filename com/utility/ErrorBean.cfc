component displayName="ErrorBean" persistent="false" accessors="true" hint="Bean to manage validation errors" output="false" {

	// @hint stores any validation errors for the entity
	property name="errors" type="struct";

	// @hint Constructor for error bean. Initializes the error bean.
	public function init() {
		variables.errors = structNew();
		return this;
	}
	
	/**
	 * @hint Adds a new error to the error structure.
	 * @param name - best practice to use form field name if available
	 */
	public void function addError(required string name,required string message) {
		variables.errors[arguments.name] = arguments.message;
	}
	
	/**
	 * @hint Returns an error from the error structure.
	 * @param name - Name of the error to return; if error doesn't exist, returns empty string
	 */
	public string function getError(required string name) {
		if(hasError(name=arguments.name)){
			return variables.errors[arguments.name];
		} else {
			return '';
		}
	}
	
	/**
	 * @hint Returns true if the error exists within the error structure.
	 * @param name - Name of the error to check;
	 */
	public string function hasError(required string name) {
		return structKeyExists(variables.errors, arguments.name) ;
	}
	
	// @hint Returns true if there is at least one error.
	public boolean function hasErrors() {
		return !structIsEmpty(variables.errors) ;
	}
	
}
