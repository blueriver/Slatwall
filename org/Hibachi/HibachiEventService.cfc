/*

-------------- Explicitly Defined Events ------------------

// onApplicationRequest
// onApplicationBootstrapRequest
// onApplicationSetup
// onApplicationFullUpdate

// onSessionAccountLogin
// onSessionAccountLogout

-------------- Implicitly Defined Events ------------------

// before{EntityName}Save
// after{EntityName}Save
// after{EntityName}SaveSuccess
// after{EntityName}SaveFailure

// before{EntityName}Delete
// after{EntityName}Delete
// after{EntityName}DeleteSuccess
// after{EntityName}DeleteFailure

// before{EntityName}Process
// after{EntityName}Process
// after{EntityName}ProcessSuccess
// after{EntityName}ProcessFailure

// before{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}Success
// after{EntityName}Process_{processContext}Failure

*/
component output="false" update="true" extends="HibachiService" {

	variables.registeredEvents = {};
	variables.registeredEventHandlers = {};
	
	public any function getEventHandler( required string objectFullname ) {
		if(!structKeyExists(variables.registeredEventHandlers, arguments.objectFullname)) {
			try {
				variables.registeredEventHandlers[ arguments.objectFullname ] = createObject("component", arguments.objectFullname);
			} catch(any e) {
				logHibachi("The event handler: #arguments.objectFullname# could not be instantiated.  Please verify that this component does not have errors.  In addition whenever possible eventHandler names should start from the Application root mapping at #getApplicationValue('applicationKey')#.xxx");
			}
		}
		if(structKeyExists(variables.registeredEventHandlers, arguments.objectFullname)) {
			return variables.registeredEventHandlers[ arguments.objectFullname ];
		}
	}
	
	private any function setEventHandler( required any object ) {
		var objectFullname = getMetadata(arguments.object).fullname;
		variables.registeredEventHandlers[ objectFullname ] = arguments.object;
		return objectFullname;
	}
	
	public void function announceEvent(required string eventName, struct eventData={}) {
		logHibachi("Event Announced: #arguments.eventName#");
		
		// Check to see if there are any events registered
		if(structKeyExists(variables.registeredEvents, arguments.eventName)) {
			
			// Loop over all of the different registered events for a given eventName
			for(var i=1; i<=arrayLen(variables.registeredEvents[ arguments.eventName ]); i++) {
				
				// Attempt to setup and call the event
				try {
					
					// Get the object to call the method on
					var object = variables.registeredEvents[ arguments.eventName ].object;
					
					// Stick the Hibachi Scope in with the rest of the event data
					eventData[ "#getApplicationValue('applicationKey')#Scope" ] = getHibachiScope();
					
					// Attempt to evaluate this method
					evaluate("object.#eventName#( argumentscollection=arguments.eventData )");	
				} catch(any e) {
					logHibachi("There was an error trying to execute one of the registered events for #arguments.eventName#");
				}
				
			}
		}
	}
	
	public void function registerEvent( required string eventName, required any object, string objectFullname ) {
		if(!structKeyExists(variables.registeredEvents, arguments.eventName)) {
			variables.registeredEvents[ arguments.eventName ] = [];
		}
		if(!structKeyExists(arguments, "objectFullname")) {
			arguments.objectFullname = getMetaData(arguments.object).fullname;
		}
		arrayAppend(variables.registeredEvents[ arguments.eventName ], arguments.objectFullname);
	}
	
	public void function registerEventHandler( required any eventHandler ) {
		if(isObject(arguments.eventHandler)) {
			var objectFullname = setEventHandler( arguments.eventHandler );
			var object = arguments.eventHandler;
		} else if (isSimpleValue(arguments.eventHandler)) {
			var objectFullname = arguments.eventHandler;
			var object = getEventHandler( arguments.eventHandler );
		}
		
		if(!isNull(object)) {
			var objectMetaData = getMetaData(object);
			for(var f=1; f<=arrayLen(objectMetaData.functions); f++) {
				if(!structKeyExists(objectMetaData.functions[f], "access") || objectMetaData.functions[f].access == "public") {
					registerEvent(eventName=objectMetaData.functions[f].name, object=object, objectFullname=objectFullname);
				}
			}
		}
	}
	
}