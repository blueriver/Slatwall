component output="false" accessors="true" extends="HibachiController" {
	
	property name="fw" type="any";
	property name="hibachiService" type="any";
	
	public void function init( required any fw ) {
		setFW(arguments.fw);
	}
	
	public void function before( required any rc ) {
		arguments.rc.edit = false;
		arguments.rc.fw = getFW();
		
		// Setup a Private structure in the RC that can't be overridden by the form scope
		arguments.rc.crudActionDetails = {};
		arguments.rc.crudActionDetails.thisAction = arguments.rc[ getFW().getAction() ];
		arguments.rc.crudActionDetails.subsystemName = getFW().getSubsystem( arguments.rc.crudActionDetails.thisAction );
		arguments.rc.crudActionDetails.sectionName = getFW().getSection( arguments.rc.crudActionDetails.thisAction );
		arguments.rc.crudActionDetails.itemName = getFW().getItem( arguments.rc.crudActionDetails.thisAction );
		
		arguments.rc.crudActionDetails.itemEntityName = "";
		arguments.rc.crudActionDetails.cancelAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.createAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.deleteAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.detailAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.editAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.exportAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.listAction = arguments.rc.crudActionDetails.thisAction;
		arguments.rc.crudActionDetails.saveAction = arguments.rc.crudActionDetails.thisAction;
		
		if(left(arguments.rc.crudActionDetails.itemName, 4) == "list") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-4);
		} else if (left(arguments.rc.crudActionDetails.itemName, 4) == "edit") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-4);
		} else if (left(arguments.rc.crudActionDetails.itemName, 4) == "save") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-4);
		} else if (left(arguments.rc.crudActionDetails.itemName, 6) == "detail") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-6);
		} else if (left(arguments.rc.crudActionDetails.itemName, 6) == "delete") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-6);
		} else if (left(arguments.rc.crudActionDetails.itemName, 6) == "create") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-6);
		} else if (left(arguments.rc.crudActionDetails.itemName, 7) == "process") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-7);
		} else if (left(arguments.rc.crudActionDetails.itemName, 6) == "export") {
			arguments.rc.crudActionDetails.itemEntityName = right(arguments.rc.crudActionDetails.itemName, len(arguments.rc.crudActionDetails.itemName)-6);
		}
		
		if(arguments.rc.crudActionDetails.itemEntityName != "") {
			arguments.rc.crudActionDetails.listAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.list#arguments.rc.crudActionDetails.itemEntityName#"; 
			arguments.rc.crudActionDetails.saveAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.save#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.detailAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.detail#arguments.rc.crudActionDetails.itemEntityName#";		
			arguments.rc.crudActionDetails.deleteAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.delete#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.editAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.edit#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.createAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.create#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.exportAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.export#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.exportAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.preprocess#arguments.rc.crudActionDetails.itemEntityName#";
			arguments.rc.crudActionDetails.exportAction = "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.preprocess#arguments.rc.crudActionDetails.itemEntityName#"; 
		}
		
		arguments.rc.pageTitle = rbKey(replace(arguments.rc.crudActionDetails.thisAction,':','.','all'));
		if(right(arguments.rc.pageTitle, 8) eq "_missing") {
			if(left(listLast(arguments.rc.crudActionDetails.thisAction, "."), 4) eq "list") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.list'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));
			} else if (left(listLast(arguments.rc.crudActionDetails.thisAction, "."), 4) eq "edit") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));
			} else if (left(listLast(arguments.rc.crudActionDetails.thisAction, "."), 6) eq "create") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));
			} else if (left(listLast(arguments.rc.crudActionDetails.thisAction, "."), 6) eq "detail") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.detail'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));
			} else if (left(listLast(arguments.rc.crudActionDetails.thisAction, "."), 7) eq "process") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.process'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));
			}
		}
	}
	
	// Implicit onMissingMethod() to handle standard CRUD
	public void function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		if(structKeyExists(arguments, "missingMethodName")) {
			if( left(arguments.missingMethodName, 4) == "list" ) {
				genericListMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "edit" ) {
				genericEditMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "save" ) {
				genericSaveMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "detail" ) {
				genericDetailMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "delete" ) {
				genericDeleteMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "create" ) {
				genericCreateMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 7) == "process" ) {
				genericProcessMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "export" ) {
				genericExportMethod(entityName=arguments.missingMethodArguments.rc.crudActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			}
		}
	}
	
	// LIST
	public void function genericListMethod(required string entityName, required struct rc) {
		// TODO: Verify List Permission
		
		// Find the correct service
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		// Place the standard smartList in the rc
		arguments.rc["#arguments.entityName#SmartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.rc} );
	}
	
	// CREATE
	public void function genericCreateMethod(required string entityName, required struct rc) {
		// TODO: Verify Create Permission
		
		// Find the correct service
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Call the new method on that service to inject an object into the RC
		arguments.rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		
		// Set the edit to true
		arguments.rc.edit = true;
		
		// Set the view to the correct one
		getFW().setView(arguments.rc.crudActionDetails.detailAction);
	}
	
	// EDIT
	public void function genericEditMethod(required string entityName, required struct rc) {
		// TODO: Verify Edit Permission
		
		// TODO: Verify Edit Validation
		
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Make sure that the object we are trying to request was set in the RC
		if(!structKeyExists(arguments.rc, arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.crudActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.crudActionDetails.listAction, preserve="messages");
		}
		
		// Setup the values needed for this type of layout
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		arguments.rc.edit = true;
		
		// Switch the view to use the same as the detail view
		getFW().setView(arguments.rc.crudActionDetails.detailAction);
	}
	
	// DETAIL
	public void function genericDetailMethod(required string entityName, required struct rc) {
		// TODO: Verify Detail Permission
		
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Make sure that the object was actually defined
		if(!structKeyExists(arguments.rc, arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.crudActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.crudActionDetails.listAction, preserve="messages");
		}
		
		// Setup the values needed for this type of layout
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		arguments.rc.edit = false;
	}
	
	// DELETE
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		
		// Find the correct service and this object PrimaryID
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// Attempt to find the entity
		var entity = entityService.invokeMethod( "get#arguments.rc.crudActionDetails.itemEntityName#", {1=arguments.rc[ entityPrimaryID ]} );
		
		// If the entity was null, then redirect to the falureAction
		if(isNull(entity)) {
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.crudActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.crudActionDetails.listAction, preserve="messages");
		}
		
		// Check how the delete went
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		// SUCCESS
		if (deleteOK) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.crudActionDetails.subsystemName#.#arguments.rc.crudActionDetails.sectionName#.delete_success" ), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'), "all" ), "success");
			
			// Render or Redirect a Success
			renderOrRedirectSuccess( defaultAction=arguments.rc.crudActionDetails.listAction, maintainQueryString=true, rc=arguments.rc);
			
		// FAILURE
		} else {
			// Add the Generic Action Failure Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.crudActionDetails.subsystemName#.#arguments.rc.crudActionDetails.sectionName#.error_success" ), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'), "all" ), "error");
			
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// Render or Redirect a faluire
			renderOrRedirectSuccess( defaultAction=arguments.rc.crudActionDetails.detailAction, maintainQueryString=false, rc=arguments.rc);	
		}
		
	}
	
	// SAVE
	public void function genericSaveMethod(required string entityName, required struct rc) {
		
		// Find the correct service and this object PrimaryID
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// Attempt to find the entity
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc[ entityPrimaryID ], 2=true} );
		
		// Call the save method on the entity, and then populate it back into the RC
		arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=entity, 2=arguments.rc} );
		
		// If the entity was saved OK, then check for process=1 and a processContext in the RC
		if(!arguments.rc[ arguments.entityName ].hasErrors() && structKeyExists(arguments.rc, "process") && isBoolean(arguments.rc.process) && arguments.rc.process && structKeyExists(arguments.rc, "processContext")) {
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=arguments.rc[ arguments.entityName ], 2=arguments.rc, 3=arguments.rc.processContext} );
		}
		
		// SUCCESS
		if(!arguments.rc[ arguments.entityName ].hasErrors()) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.crudActionDetails.subsystemName#.#arguments.rc.crudActionDetails.sectionName#.save_success" ), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'), "all" ) , "success");
			
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// Render or Redirect a Success
			renderOrRedirectSuccess( defaultAction=arguments.rc.crudActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);
			
		// FAILURE
		} else {
			// Add the Generic Action Failure Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.crudActionDetails.subsystemName#.#arguments.rc.crudActionDetails.sectionName#.save_error" ), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'), "all" ) , "error");
			
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// Render or Redirect a faluire
			renderOrRedirectSuccess( defaultAction=arguments.rc.crudActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);
			
		}
	}
	
	public void function genericPreProcessMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		getFW().setView("#getSubsystem()#:#getSubsystem()#");
	}
	
	public void function genericProcessMethod(required string entityName, required struct rc) {
		param name="arguments.rc.processContext" default="process";
		param name="arguments.rc.multiProcess" default="false";
		param name="arguments.rc.processOptions" default="#{}#";
		param name="arguments.rc.additionalData" default="#{}#";
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		getFW().setLayout( "admin:process.default" );
		
		if(len(arguments.rc.processContext) && arguments.rc.processContext != "process") {
			arguments.rc.pageTitle = rbKey( "admin.#getFW().getSection(arguments.rc.crudActionDetails.thisAction)#.process#arguments.entityName#.#arguments.rc.processContext#" );
		}
		
		// If we are actually posting the process form, then this logic gets calls the process method for each record
		if(structKeyExists(arguments.rc, "process") && arguments.rc.process) {
			arguments.rc.errorData = [];
			var errorEntities = [];
			
			// If there weren't any process records passed in, then we will make a sinlge processrecord with the entire rc
			if(!structKeyExists(arguments.rc, "processRecords") || !isArray(arguments.rc.processRecords)) {
				arguments.rc.processRecords = [arguments.rc];
			}
			
			for(var i=1; i<=arrayLen(arguments.rc.processRecords); i++) {
				
				if(structKeyExists(arguments.rc.processRecords[i], entityPrimaryID)) {
					
					structAppend(arguments.rc.processRecords[i], arguments.rc.processOptions, false);
					var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc.processRecords[i][ entityPrimaryID ], 2=true} );
					
					logSlatwall("Process Called: Enity - #arguments.entityName#, EntityID - #arguments.rc.processRecords[i][ entityPrimaryID ]#, processContext - #arguments.rc.processContext# ");
					
					entity = entityService.invokeMethod( "process#arguments.entityName#", {1=entity, 2=arguments.rc.processRecords[i], 3=arguments.rc.processContext} );
					
					// If there were errors, then add to the errored entities
					if( !isNull(entity) && entity.hasErrors() ) {
						
						// Add the error message to the top of the page
						entity.showErrorMessages();
						
						arrayAppend(errorEntities, entity);
						arrayAppend(arguments.rc.errorData, arguments.rc.processRecords[i]);
						
					// If there were not error messages then que and process emails & print options
					} else if (!isNull(entity)) {
						
						// TODO: Sending email needs to get moved out of this loop
						// We need to persist the records to db before we send out emails
						// Send out E-mails
						if(structKeyExists(arguments.rc.processOptions, "email")) {
							for(var emailEvent in arguments.rc.processOptions.email) {
								getEmailService().sendEmailByEvent(eventName="process#arguments.entityName#:#emailEvent#", entity=entity);
							}
						}
						
						// Create any process Comments
						if(structKeyExists(arguments.rc, "processComment") && isStruct(arguments.rc.processComment) && len(arguments.rc.processComment.comment)) {
							
							// Create new Comment
							var newComment = getCommentService().newComment();
							
							// Create Relationship
							var commentRelationship = {};
							commentRelationship.commentRelationshipID = "";
							commentRelationship[ arguments.entityName ] = {};
							commentRelationship[ arguments.entityName ][ entityPrimaryID ] = entity.getPrimaryIDValue();
							arguments.rc.processComment.commentRelationships = [];
							arrayAppend(arguments.rc.processComment.commentRelationships, commentRelationship);
							
							// Save new Comment 
							getCommentService().saveComment(newComment, arguments.rc.processComment);
						}
					}
				}
			}
			
			if(arrayLen(errorEntities)) {
				arguments.rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
				arguments.rc[ "process#arguments.entityName#SmartList" ].setRecords(errorEntities);
				if(arrayLen(errorEntities) gt 1) {
					arguments.rc.multiProcess = true;
				}
			} else {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_success" );
			}
			
		
		// IF we are just doing the process setup page, run this logic
		} else {
			
			// Go get the correct type of SmartList
			arguments.rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
			
			// If no ID was passed in create a smartList with only 1 new entity in it
			if(!structKeyExists(arguments.rc, entityPrimaryID) || arguments.rc[entityPrimaryID] == "") {
				var newEntity = entityService.invokeMethod( "new#arguments.entityName#" );
				arguments.rc[ "process#arguments.entityName#SmartList" ].setRecords([newEntity]);
			} else {
				arguments.rc[ "process#arguments.entityName#SmartList" ].addInFilter(entityPrimaryID, arguments.rc[entityPrimaryID]);	
			}
			
			// If there are no records then redirect to the list action
			if(!arguments.rc[ "process#arguments.entityName#SmartList" ].getRecordsCount()) {
				getFW().redirect(action=arguments.rc.crudActionDetails.listAction);
			} else if (arguments.rc[ "process#arguments.entityName#SmartList" ].getRecordsCount() gt 1) {
				arguments.rc.multiProcess = true;
			}
		}
	}
	
	public void function genericExportMethod(required string entityName, required struct rc) {
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		entityService.invokeMethod("export#arguments.entityName#");
	}
	
	private void function loadEntitiesFromRCIDs(required struct rc) {
		try{
			for(var key in arguments.rc) {
				if(!find('.',key) && right(key, 2) == "ID" && len(arguments.rc[key]) == "32") {
					var entityName = left(key, len(key)-2);
					var entityService = getHibachiService().getServiceByEntityName( entityName=entityName );
					var entity = entityService.invokeMethod("get#entityName#", {1=arguments.rc[key]});
					if(!isNull(entity)) {
						arguments.rc[ entityName ] = entity;
					}
				}
			}
		}catch(any e){
			writedump(e);abort;
		}
	}
	
	private void function renderOrRedirectSuccess( required string defaultAction, required boolean maintainQueryString, required struct rc ) {
		param name="arguments.rc.fRedirectQS" default="";
		
		// First look for a sRedirectURL in the rc, and do a redirectExact on that
		if(structKeyExists(arguments.rc, "sRedirectURL")) {
			getFW().redirectExact( url=arguments.rc.sRedirectURL );
		
		// Next look for a sRedirectAction in the rc, and do a redirect on that
		} else if (structKeyExists(arguments.rc, "sRedirectAction")) {
			getFW().redirect( action=arguments.rc.sRedirectAction, preserve="messages", queryString=arguments.rc.fRedirectQS );
			
		// Next look for a sRenderCrudAction in the rc, set the view to that, and then call the controller for that action
		} else if (structKeyExists(arguments.rc, "sRenderCrudAction")) {
			getFW().setView( "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.#arguments.rc.sRenderCrudAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.rc.sRenderCrudAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.rc.sRenderCrudAction, {rc=arguments.rc});
		
		// Lastly if nothing was defined then we just do a redirect to the defaultAction
		} else {
			getFW().setView( "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.#arguments.defaultAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.defaultAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.defaultAction, {rc=arguments.rc});
			
		}
	}
	
	private void function renderOrRedirectFailure( required string defaultAction, required boolean maintainQueryString, required struct rc ) {
		param name="arguments.rc.fRedirectQS" default="";
		 
		// First look for a fRedirectURL in the rc, and do a redirectExact on that
		if(structKeyExists(arguments.rc, "fRedirectURL")) {
			getFW().redirectExact( url=arguments.rc.rRedirectURL );
		
		// Next look for a fRedirectAction in the rc, and do a redirect on that
		} else if (structKeyExists(arguments.rc, "sRedirectAction")) {
			getFW().redirect( action=arguments.rc.fRedirectAction, preserve="messages", queryString=arguments.rc.fRedirectQS );
			
		// Next look for a fRenderCrudAction in the rc, set the view to that, and then call the controller for that action
		} else if (structKeyExists(arguments.rc, "fRenderCrudAction")) {
			getFW().setView( "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.#arguments.rc.fRenderCrudAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.rc.fRenderCrudAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.rc.fRenderCrudAction, {rc=arguments.rc});
		
		// Lastly if nothing was defined then we just do a redirect to the defaultAction
		} else {
			getFW().setView( "#arguments.rc.crudActionDetails.subsystemName#:#arguments.rc.crudActionDetails.sectionName#.#arguments.defaultAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.defaultAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.defaultAction, {rc=arguments.rc});
			
		}
	}
	
	
	/*
	private void function redirectToReturnAction(string additionalQueryString="") {
		var raArray = listToArray(request.context.returnAction, chr(35));
		var qs = buildReturnActionQueryString( arguments.additionalQueryString );
		if(arrayLen(raArray) eq 2) {
			qs &= "#chr(35)##raArray[2]#";
		}
		
		getFW().redirect(action=raArray[1], querystring=qs);
	}
	
	private string function buildReturnActionQueryString(string additionalQueryString="", string ignoreKeys="") {
		var queryString = "";
		for(var key in url) {
			if(!listFindNoCase(ignoreKeys, key) && key != "returnAction" && key != "slatAction") {
				queryString = listAppend(queryString, key & "=" & url[key], "&");
			}
		}
		if(len(arguments.additionalQueryString)) {
			queryString = listAppend(queryString, arguments.additionalQueryString, "&");
		}
		return queryString;
	}
	*/
}