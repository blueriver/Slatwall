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
		arguments.rc.crudActionDetails.thisAction = arguments.rc[ getFW().getConfig()[ "action" ] ];
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
	
	public void function genericListMethod(required string entityName, required struct rc) {
		// TODO: Verify List Permission
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		arguments.rc["#arguments.entityName#smartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.rc} );
		
	}
	
	
	public void function genericCreateMethod(required string entityName, required struct rc) {
		// TODO: Verify Create Permission
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		arguments.rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		arguments.rc.edit = true;
		getFW().setView(arguments.rc.detailAction);
	}
	
	public void function genericEditMethod(required string entityName, required struct rc) {
		// TODO: Verify Edit Permission
		// TODO: Verify Edit Validation
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		if(!structKeyExists(arguments.rc,arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getFW().redirect(arguments.rc.listAction);
		}
		
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		
		arguments.rc.edit = true;
		getFW().setView(arguments.rc.detailAction);
	}
	
	public void function genericDetailMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		if(!structKeyExists(arguments.rc,arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getFW().redirect(arguments.rc.listAction);
		}
		
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		
		arguments.rc.edit = false;
	}
	
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#arguments.rc.crudActionDetails.itemEntityName#", {1=arguments.rc[ entityPrimaryID ]} );
		
		if(isNull(entity)) {
			getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_error");
		}
		
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		if (deleteOK) {
			if(structKeyExists(arguments.rc, "returnAction") && arguments.rc.returnAction != "") {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_success" );
			} else {
				getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_success");	
			}
		}
		
		getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_error");
	}
	
	
	public void function genericSaveMethod(required string entityName, required struct rc) {
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc[ entityPrimaryID ], 2=true} );
		arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=entity, 2=arguments.rc} );
		
		// If OK, then check for processOptions
		if(!arguments.rc[ arguments.entityName ].hasErrors() && structKeyExists(arguments.rc, "process") && isBoolean(arguments.rc.process) && arguments.rc.process) {
			param name="arguments.rc.processOptions" default="#structNew()#";
			param name="arguments.rc.processContext" default="process";
			
			processData = arguments.rc;
			structAppend(processData, arguments.rc.processOptions, false);
			
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=arguments.rc[ arguments.entityName ], 2=processData, 3=arguments.rc.processContext} );
			
			if(arguments.rc[ arguments.entityName ].hasErrors()) {
				// Add the error message to the top of the page
				entity.showErrorMessages();	
			}
		}
		
		// If still OK then check what to do next
		if(!arguments.rc[ arguments.entityName ].hasErrors()) {
			
			if(structKeyExists(arguments.rc, "returnAction")) {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_success&#entityPrimaryID#=#arguments.rc[ arguments.entityName ].getPrimaryIDValue()#" );
			} else {
				getFW().redirect(action=arguments.rc.detailAction, querystring="#entityPrimaryID#=#arguments.rc[ arguments.entityName ].getPrimaryIDValue()#&messagekeys=#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_success");	
			}
			
		// If Errors
		} else {
			
			arguments.rc.edit = true;
			getFW().setView(action=arguments.rc.detailAction);
			showMessageKey("#replace(arguments.rc.crudActionDetails.thisAction, ':', '.', 'all')#_error");
			
			for( var p in arguments.rc[ arguments.entityName ].getErrors() ) {
				local.thisErrorArray = arguments.rc[ arguments.entityName ].getErrors()[p];
				for(var i=1; i<=arrayLen(local.thisErrorArray); i++) {
					showMessage(local.thisErrorArray[i], "error");
				}
			}
			
			if(arguments.rc[ arguments.entityName ].isNew()) {
				arguments.rc.crudActionDetails.thisAction = arguments.rc.createAction;
				arguments.rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));	
			} else {
				arguments.rc.crudActionDetails.thisAction = arguments.rc.editAction;
				arguments.rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#arguments.rc.crudActionDetails.itemEntityName#'));	
			}
			
			arguments.rc.edit = true;
			loadEntitiesFromRCIDs( arguments.rc );
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
				getFW().redirect(action=arguments.rc.listaction);
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