component output="false" accessors="true" extends="HibachiTransient" {

	property name="account" type="any";
	property name="session" type="any";
	
	property name="ormHasErrors" type="boolean" default="false";
	property name="rbLocale";
	
	public any function init() {
		setORMHasErrors( false );
		setRBLocale( "en_us" );
		
		return super.init();
	}
	
	public string function renderJSObject() {
		var config = {};
		config[ 'baseURL' ] = getApplicationValue('baseURL');
		
		var returnHTML = '';
		returnHTML &= '<script type="text/javascript" src="#getApplicationValue('baseURL')#/org/Hibachi/HibachiAssets/js/hibachi-scope.js"></script>';
		returnHTML &= '<script type="text/javascript">(function( $ ){$.#lcase(getApplicationValue('applicationKey'))# = new Hibachi(#serializeJSON(config)#);})( jQuery );</script>';
		return returnHTML;
	}
	
	public boolean function getLoggedInFlag() {
		if(!getSession().getAccount().isNew()) {
			return true;
		}
		return false;
	}
	
	public boolean function getLoggedInAsAdminFlag() {
		if(getAccount().getAdminAccountFlag()) {
			return true;
		}
		return false;
	}
	
	// ==================== SESSION / ACCOUNT SETUP ===========================
	
	public any function getSession() {
		if(!structKeyExists(variables, "session")) {
			getService("hibachiSessionService").setPropperSession();
		}
		return variables.session;
	}
	
	public any function getAccount() {
		return getSession().getAccount();
	}
	
	// ==================== REQUEST CACHING METHODS ===========================
	public boolean function hasValue(required string key) {
		return structKeyExists(variables, arguments.key);
	}

	public any function getValue(required string key) {
		if(hasValue( arguments.key )) {
			return variables[ arguments.key ]; 
		}
		
		throw("You have requested '#arguments.key#' as a value in the #getApplicationValue('applicationKey')# scope, however that value has not been set in the request.  In the futuer you should check for it's existance with hasValue().");
	}
	
	public void function setValue(required string key, required any value) {
		variables[ arguments.key ] = arguments.value;
	}
	
	
	// ==================== RENDERING HELPERS ================================
	
	public void function showMessageKey(required any messageKey) {
		var messageType = listLast(messageKey, "_");
		var message = rbKey(arguments.messageKey);
		
		if(right(message, 8) == "_missing") {
			if(left(listLast(arguments.messageKey, "."), 4) == "save") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-4), "_");
				message = rbKey("admin.define.save_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			} else if (left(listLast(arguments.messageKey, "."), 6) == "delete") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-6), "_");
				message = rbKey("admin.define.delete_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			} else if (left(listLast(arguments.messageKey, "."), 7) == "process") {
				var entityName = listFirst(right(listLast(arguments.messageKey, "."), len(listLast(arguments.messageKey, "."))-7), "_");
				message = rbKey("admin.define.process_#messageType#");
				message = replace(message, "${itemEntityName}", rbKey("entity.#entityName#") );
			}
		}
		
		showMessage(message=message, messageType=messageType);
	}
	
	public void function showMessage(string message="", string messageType="info") {
		param name="request.context.messages" default="#arrayNew(1)#";
		
		arrayAppend(request.context.messages, arguments);
	}
	
	// ========================== HELPER DELIGATION METHODS ===============================
	
	// @hint helper function to return the RB Key from RB Factory in any component
	public string function rbKey(required string key, struct replaceStringData) {
		var keyValue = getService("hibachiRBService").getRBKey(arguments.key, getRBLocale());
		if(structKeyExists(arguments, "replaceStringData") && findNoCase("${", keyValue)) {
			keyValue = getService("hibachiUtilityService").replaceStringTemplate(keyValue, arguments.replaceStringData);
		}
		return keyValue;
	}
	
	public boolean function authenticateAction( required string action ) {
		return getService("hibachiAuthenticationService").authenticateActionByAccount( action=arguments.action, account=getAccount() );
	}

	public boolean function authenticateEntity( required string crudType, required string entityName ) {
		return getService("hibachiAuthenticationService").authenticateEntityCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, account=getAccount() );
	}
	
	public boolean function authenticateEntityProperty( required string crudType, required string entityName, required string propertyName ) {
		return getService("hibachiAuthenticationService").authenticateEntityPropertyCrudByAccount( crudType=arguments.crudType, entityName=arguments.entityName, propertyName=arguments.propertyName, account=getAccount() );
	}
	
	// =========================== onMissingMethod() ===================================
	/*
	public any function onMissingMethod() {
		// getXXX() WHERE XXX is an entityName and the object gets stored in request cache
		
		// getXXXSmartList() WHERE XXX is an entityName and the smart list gets stored in request cache
		
		// setXXX() WHERE XXX is an entityName and the object will get stored in cache
		
		// xxx() WHERE XXX is an entity name and ('yyy') means get that yyy property, while ('yyy', 'simple') means set the property
	}
	*/
	
}