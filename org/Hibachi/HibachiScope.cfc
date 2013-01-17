component output="false" accessors="true" extends="Hibachi.HibachiTransient" {

	property name="hibachiApplicationKey" type="string";
	
	public any function init( required string hibachiApplicationKey ) {
		setHibachiApplicationKey( arguments.hibachiApplicationKey);
		
		return super.init();
	}
	
	public void function showErrorMessages() {
		for(var errorName in getErrors()) {
			for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
				showMessage(getErrors()[errorName][i], "error");
			}
		}
	}
	
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
	
	// @hint facade method to check the slatwall application scope for a value
	public boolean function hasApplicationValue(required any key) {
		if( structKeyExists(application, getHibachiApplicationKey()) && structKeyExists(application[ getHibachiApplicationKey() ], arguments.key)) {
			return true;
		}
		
		return false;
	}
	
	// @hint facade method to get values from the slatwall application scope
	public any function getApplicationValue(required any key) {
		
		if( structKeyExists(application, getHibachiApplicationKey()) && structKeyExists(application[ getHibachiApplicationKey() ], arguments.key)) {
			return application[ getHibachiApplicationKey() ][ arguments.key ];
		}
		
		throw("You have requested a value for '#arguments.key#' from the core slatwall application that is not setup.  This may be because the verifyApplicationSetup() method has not been called yet")
	}
	
	// @hint facade method to set values in the slatwall application scope 
	public void function setApplicationValue(required any key, required any value) {
		lock name="application_#getHibachiApplicationKey()#_#arguments.key#" timeout="10" {
			if(!structKeyExists(application, getHibachiApplicationKey())) {
				application[ getHibachiApplicationKey() ] = {};
			}
			application[ getHibachiApplicationKey() ][ arguments.key ] = arguments.value;
		}
	}
	
	
}