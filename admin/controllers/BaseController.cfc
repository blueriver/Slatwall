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
component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	property name="integrationService" type="any";
	property name="sessionService" type="any";
	property name="utilityORMService" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return super.init();
	}
	
	public void function subSystemBefore(required struct rc) {
		rc.fw = getFW();
		
		// Check to see if any message keys were passed via the URL
		if(structKeyExists(rc, "messageKeys")) {
			var messageKeys = listToArray(rc.messageKeys);
			for(var i=1; i<=arrayLen(messageKeys); i++) {
				showMessageKey(messageKeys[i]);
			}
		}
		
		var itemName = getFW().getItem( rc.slatAction );
		
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
			}
		}
		
	}
	
	// Implicit onMissingMethod() to handle standard CRUD
	public void function onMissingMethod() {
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
		}
	}
	
	public void function genericListMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		var httpRequestData = getHTTPRequestData();
		
		// If this is an ajax call, just get the smart list
		if(structKeyExists(httpRequestData.headers, "Content-Type") and httpRequestData.headers["content-type"] eq "application/json") {
			
			param name="rc.propertyIdentifiers" type="string" default="";
			
			var smartList = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=rc} );
			var smartListPageRecords = smartList.getPageRecords();
			var piArray = listToArray(rc.propertyIdentifiers);
			 
			rc.records = [];
			rc.pageRecordsCount = arrayLen(smartListPageRecords);
			
			for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
				var thisRecord = {};
				for(var p=1; p<=arrayLen(piArray); p++) {
					thisRecord[ piArray[p] ] = smartListPageRecords[i].getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );	
				}
				arrayAppend(rc.records, thisRecord);
			}
			
		// If this is a standard call, then look to save the state
		} else {
			var savedStateKey = lcase( rc.slatAction );
			
			/*
			
			Commented out until I can figure out all the listing display stuff -Greg
			
			if(getSessionService().hasValue( savedStateKey )) {
				rc.savedStateID = getSessionService().getValue( savedStateKey );
			}
			*/
			
			rc["#arguments.entityName#smartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=rc} );
			
			getSessionService().setValue( savedStateKey, rc["#arguments.entityName#smartList"].getSavedStateID() );
		}
	}
	
	public void function genericCreateMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		
		loadEntitiesFromRCIDs( rc );
		
		rc.edit = true;
		getFW().setView(rc.detailAction);
	}
	
	public void function genericEditMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		rc[ "#arguments.entityName#" ] = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
		
		loadEntitiesFromRCIDs( rc );
		
		rc.edit = true;
		getFW().setView(rc.detailAction);
	}
	
	public void function genericDetailMethod(required string entityName, required struct rc) {
		param name="rc.edit" default="false";
		
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// If no ID was passed in, redirect to list
		if(!structKeyExists(rc, entityPrimaryID)) {
			getFW().redirect(action=rc.listaction);
		}
		
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
		
		// If ID was passed but there is no entity for that id, redirect to list
		if(isNull(entity)) {
			getFW().redirect(action=rc.listaction);
		}
		
		rc["#arguments.entityName#"] = entity;
		
		loadEntitiesFromRCIDs( rc );
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
		
		var data = rc;
		
		rc[ arguments.entityName ] = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
		rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=rc[ arguments.entityName ], 2=data} );

		if(!rc[ arguments.entityName ].hasErrors()) {
			if(structKeyExists(rc, "returnAction")) {
				redirectToReturnAction( "messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success" );
			} else {
				getFW().redirect(action=rc.detailAction, querystring="#entityPrimaryID#=#rc[ arguments.entityName ].getPrimaryIDValue()#&messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success");	
			}
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
		}
	}
	
	private void function loadEntitiesFromRCIDs(required struct rc) {
		for(var key in rc) {
			if(right(key, 2) == "ID" && len(rc[key]) == "32" && !structKeyExists(rc, left(key, len(key)-2))) {
				var entityName = left(key, len(key)-2);
				var entityService = getUtilityORMService().getServiceByEntityName( entityName=entityName );
				var entity = entityService.invokeMethod("get#entityName#", {1=rc[key]});
				if(!isNull(entity)) {
					rc[ entityName ] = entity;
				}
			}
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
