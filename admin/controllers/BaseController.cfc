/*

    Slatwall - An Open Source eCommerce Platform
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
component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	property name="emailService" type="any";
	property name="integrationService" type="any";
	property name="sessionService" type="any";
	property name="utilityORMService" type="any";
	property name="accountService" type="any";
	property name="permissionService" type="any";
	property name="commentService" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return super.init();
	}
	
	public void function subSystemBefore(required struct rc) {
		param name="rc.modal" default="false";
		param name="rc.edit" default="false";
		
		// Check to see if any message keys were passed via the URL
		if(structKeyExists(rc, "messageKeys")) {
			var messageKeys = listToArray(rc.messageKeys);
			for(var i=1; i<=arrayLen(messageKeys); i++) {
				showMessageKey(messageKeys[i]);
			}
		}
		
		// Make sure the current user has access to this action
		if(!secureDisplay(rc.slatAction, getSlatwallScope().getCurrentAccount())) {
			getFW().redirect('main.noaccess');
		}
		
		var subsystemName = getFW().getSubsystem(rc.slatAction);
		var sectionName = getFW().getSection(rc.slatAction);
		var itemName = getFW().getItem(rc.slatAction);
		
		rc.itemEntityName = "";
		rc.listAction = rc.slatAction;
		rc.saveAction = rc.slatAction;
		rc.detailAction = rc.slatAction;
		rc.deleteAction = rc.slatAction;
		rc.editAction = rc.slatAction;
		rc.createAction = rc.slatAction;
		
		if(left(itemName, 4) == "list") {
			rc.itemEntityName = right(itemName, len(itemName)-4);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		} else if (left(itemName, 4) == "edit") {
			rc.itemEntityName = right(itemName, len(itemName)-4);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";	
		} else if (left(itemName, 4) == "save") {
			rc.itemEntityName = right(itemName, len(itemName)-4);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		} else if (left(itemName, 6) == "detail") {
			rc.itemEntityName = right(itemName, len(itemName)-6);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		} else if (left(itemName, 6) == "delete") {
			rc.itemEntityName = right(itemName, len(itemName)-6);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		} else if (left(itemName, 6) == "create") {
			rc.itemEntityName = right(itemName, len(itemName)-6);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		} else if (left(itemName, 7) == "process") {
			rc.itemEntityName = right(itemName, len(itemName)-7);
			rc.listAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#"; 
			rc.saveAction = "admin:#getFW().getSection(rc.slatAction)#.save#rc.itemEntityName#";
			rc.detailAction = "admin:#getFW().getSection(rc.slatAction)#.detail#rc.itemEntityName#";		
			rc.deleteAction = "admin:#getFW().getSection(rc.slatAction)#.delete#rc.itemEntityName#";
			rc.editAction = "admin:#getFW().getSection(rc.slatAction)#.edit#rc.itemEntityName#";
			rc.createAction = "admin:#getFW().getSection(rc.slatAction)#.create#rc.itemEntityName#";
			rc.cancelAction = "admin:#getFW().getSection(rc.slatAction)#.list#rc.itemEntityName#";
		}
		
		rc.pageTitle = rbKey(replace(rc.slatAction,':','.','all'));
		if(right(rc.pageTitle, 8) eq "_missing") {
			if(left(listLast(rc.slatAction, "."), 4) eq "list") {
				rc.pageTitle = replace(rbKey('admin.define.list'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));
			} else if (left(listLast(rc.slatAction, "."), 4) eq "edit") {
				rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));
			} else if (left(listLast(rc.slatAction, "."), 6) eq "create") {
				rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));
			} else if (left(listLast(rc.slatAction, "."), 6) eq "detail") {
				rc.pageTitle = replace(rbKey('admin.define.detail'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));
			} else if (left(listLast(rc.slatAction, "."), 7) eq "process") {
				rc.pageTitle = replace(rbKey('admin.define.process'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));
			}
		}
		
		// Place the framework in the rc
		rc.fw = getFW();
	}
	
	// Implicit onMissingMethod() to handle standard CRUD
	public void function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		if(structKeyExists(arguments, "missingMethodName")) {
			if( left(arguments.missingMethodName, 4) == "list" ) {
				genericListMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "edit" ) {
				genericEditMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "save" ) {
				genericSaveMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "detail" ) {
				genericDetailMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "delete" ) {
				genericDeleteMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "create" ) {
				genericCreateMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 7) == "process" ) {
				genericProcessMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			}	
		}
	}
	
	public void function genericListMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		var httpRequestData = getHTTPRequestData();
		
		var savedStateKey = lcase( rc.slatAction );

		/*
		Commenting back out because this now works, but we need to have display in the admin to show that filter(s) have been applied
		if(getSessionService().hasValue( savedStateKey )) {
			rc.savedStateID = getSessionService().getValue( savedStateKey );
		}
		*/
		
		rc["#arguments.entityName#smartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=rc} );
		
		getSessionService().setValue( savedStateKey, rc["#arguments.entityName#smartList"].getSavedStateID() );
		
	}
	
	public void function genericCreateMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		
		loadEntitiesFromRCIDs( rc );
		
		rc.edit = true;
		getFW().setView(rc.detailAction);
	}
	
	public void function genericEditMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( rc );
		
		if(!structKeyExists(rc,arguments.entityName) || !isObject(rc[arguments.entityName])){
			getFW().redirect(rc.listAction);
		}
		
		rc.pageTitle = rc[arguments.entityName].getSimpleRepresentation();
		
		rc.edit = true;
		getFW().setView(rc.detailAction);
	}
	
	public void function genericDetailMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( rc );
		
		if(!structKeyExists(rc,arguments.entityName) || !isObject(rc[arguments.entityName])){
			getFW().redirect(rc.listAction);
		}
		
		rc.pageTitle = rc[arguments.entityName].getSimpleRepresentation();
		
		rc.edit = false;
	}
	
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#rc.itemEntityName#", {1=rc[ entityPrimaryID ]} );
		
		if(isNull(entity)) {
			getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_error");
		}
		
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		if (deleteOK) {
			if(structKeyExists(rc, "returnAction") && rc.returnAction != "") {
				redirectToReturnAction( "messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success" );
			} else {
				getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success");	
			}
		}
		
		getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_error");
	}
	
	
	public void function genericSaveMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
		rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=entity, 2=rc} );
		
		// If OK, then check for processOptions
		if(!rc[ arguments.entityName ].hasErrors() && structKeyExists(rc, "process") && isBoolean(rc.process) && rc.process) {
			param name="rc.processOptions" default="#structNew()#";
			param name="rc.processContext" default="process";
			
			processData = rc;
			structAppend(processData, rc.processOptions, false);
			
			rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=rc[ arguments.entityName ], 2=processData, 3=rc.processContext} );
			
			if(rc[ arguments.entityName ].hasErrors()) {
				// Add the error message to the top of the page
				entity.showErrorMessages();	
			}
		}
		
		// If still OK then check what to do next
		if(!rc[ arguments.entityName ].hasErrors()) {
			
			if(structKeyExists(rc, "returnAction")) {
				redirectToReturnAction( "messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success&#entityPrimaryID#=#rc[ arguments.entityName ].getPrimaryIDValue()#" );
			} else {
				getFW().redirect(action=rc.detailAction, querystring="#entityPrimaryID#=#rc[ arguments.entityName ].getPrimaryIDValue()#&messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success");	
			}
			
		// If Errors
		} else {
			rc.edit = true;
			getFW().setView(action=rc.detailAction);
			showMessageKey("#replace(rc.slatAction, ':', '.', 'all')#_error");
			for( var p in rc[ arguments.entityName ].getErrors() ) {
				local.thisErrorArray = rc[ arguments.entityName ].getErrors()[p];
				for(var i=1; i<=arrayLen(local.thisErrorArray); i++) {
					showMessage(local.thisErrorArray[i], "error");
				}
			}
			if(rc[ arguments.entityName ].isNew()) {
				rc.slatAction = rc.createAction;
				rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));	
			} else {
				rc.slatAction = rc.editAction;
				rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#rc.itemEntityName#'));	
			}
			rc.edit = true;
			loadEntitiesFromRCIDs( rc );
		}
	}
	
	public void function genericProcessMethod(required string entityName, required struct rc) {
		param name="rc.edit" default="false";
		param name="rc.processContext" default="process";
		param name="rc.multiProcess" default="false";
		param name="rc.processOptions" default="#{}#";
		param name="rc.additionalData" default="#{}#";
		
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		getFW().setLayout( "admin:process.default" );
		
		if(len(rc.processContext) && rc.processContext != "process") {
			rc.pageTitle = rbKey( "admin.#getFW().getSection(rc.slatAction)#.process#arguments.entityName#.#rc.processContext#" );
		}
		
		// If we are actually posting the process form, then this logic gets calls the process method for each record
		if(structKeyExists(rc, "process") && rc.process) {
			rc.errorData = [];
			var errorEntities = [];
			
			// If there weren't any process records passed in, then we will make a sinlge processrecord with the entire rc
			if(!structKeyExists(rc, "processRecords") || !isArray(rc.processRecords)) {
				rc.processRecords = [rc];
			}
			
			for(var i=1; i<=arrayLen(rc.processRecords); i++) {
				
				if(structKeyExists(rc.processRecords[i], entityPrimaryID)) {
					
					structAppend(rc.processRecords[i], rc.processOptions, false);
					var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=rc.processRecords[i][ entityPrimaryID ], 2=true} );
					
					logSlatwall("Process Called: Enity - #arguments.entityName#, EntityID - #rc.processRecords[i][ entityPrimaryID ]#, processContext - #rc.processContext# ");
					
					entity = entityService.invokeMethod( "process#arguments.entityName#", {1=entity, 2=rc.processRecords[i], 3=rc.processContext} );
					
					// If there were errors, then add to the errored entities
					if( !isNull(entity) && entity.hasErrors() ) {
						
						// Add the error message to the top of the page
						entity.showErrorMessages();
						
						arrayAppend(errorEntities, entity);
						arrayAppend(rc.errorData, rc.processRecords[i]);
						
					// If there were not error messages then que and process emails & print options
					} else if (!isNull(entity)) {
						
						// Send out E-mails
						if(structKeyExists(rc.processOptions, "email")) {
							for(var emailEvent in rc.processOptions.email) {
								getEmailService().sendEmailByEvent(eventName="process#arguments.entityName#:#emailEvent#", entity=entity);
							}
						}
						
						// Create any process Comments
						if(structKeyExists(rc, "processComment") && isStruct(rc.processComment) && len(rc.processComment.comment)) {
							
							// Create new Comment
							var newComment = getCommentService().newComment();
							
							// Create Relationship
							var commentRelationship = {};
							commentRelationship.commentRelationshipID = "";
							commentRelationship[ arguments.entityName ] = {};
							commentRelationship[ arguments.entityName ][ entityPrimaryID ] = entity.getPrimaryIDValue();
							rc.processComment.commentRelationships = [];
							arrayAppend(rc.processComment.commentRelationships, commentRelationship);
							
							// Save new Comment 
							getCommentService().saveComment(newComment, rc.processComment);
						}
					}
				}
			}
			
			if(arrayLen(errorEntities)) {
				rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
				rc[ "process#arguments.entityName#SmartList" ].setRecords(errorEntities);
				if(arrayLen(errorEntities) gt 1) {
					rc.multiProcess = true;
				}
			} else {
				redirectToReturnAction( "messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success" );
			}
			
		
		// IF we are just doing the process setup page, run this logic
		} else {
			
			// Go get the correct type of SmartList
			rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
			
			// If no ID was passed in create a smartList with only 1 new entity in it
			if(!structKeyExists(rc, entityPrimaryID) || rc[entityPrimaryID] == "") {
				var newEntity = entityService.invokeMethod( "new#arguments.entityName#" );
				rc[ "process#arguments.entityName#SmartList" ].setRecords([newEntity]);
			} else {
				rc[ "process#arguments.entityName#SmartList" ].addInFilter(entityPrimaryID, rc[entityPrimaryID]);	
			}
			
			// If there are no records then redirect to the list action
			if(!rc[ "process#arguments.entityName#SmartList" ].getRecordsCount()) {
				getFW().redirect(action=rc.listaction);
			} else if (rc[ "process#arguments.entityName#SmartList" ].getRecordsCount() gt 1) {
				rc.multiProcess = true;
			}
		}
	}
	
	private void function loadEntitiesFromRCIDs(required struct rc) {
		try{
			for(var key in rc) {
				if(!find('.',key) && right(key, 2) == "ID" && len(rc[key]) == "32") {
					var entityName = left(key, len(key)-2);
					var entityService = getUtilityORMService().getServiceByEntityName( entityName=entityName );
					var entity = entityService.invokeMethod("get#entityName#", {1=rc[key]});
					if(!isNull(entity)) {
						rc[ entityName ] = entity;
					}
				}
			}
		}catch(any e){
			writedump(e);abort;
		}
	}
	
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
}
