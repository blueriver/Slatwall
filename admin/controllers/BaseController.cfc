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
		
		// If user is not logged in redirect to front end otherwise If the user does not have access to this, then display a page that shows "No Access"
		if (!structKeyExists(session, "mura") || !len(rc.$.currentUser().getMemberships())) {
			if(left(rc.$.siteConfig().getLoginURL(), 1) eq "/") {
				location(url=rc.$.siteConfig().getLoginURL(), addtoken=false);
			} else {
				location(url="/#rc.$.siteConfig().getLoginURL()#", addtoken=false);	
			}
		} else if( getFW().secureDisplay(rc.slatAction) == false ) {
			getFW().setView("admin:main.noaccess");
		}
		
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
		
	}
	
	private void function showMessageKey(required any messageKey) {
		showMessage(message=rbKey(arguments.messageKey), messageType=listLast(messageKey, "_"));
	}
	
	private void function showMessage(string message="", string messageType="info") {
		if(!structKeyExists(request.context, "messages")) {
			request.context.messages = [];
		}
		arrayAppend(request.context.messages, arguments);
	}
	
	// Implicet onMissingMethod() to handle standard CRUD
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
		
		var savedStateKey = lcase( "list#arguments.entityName#smartlistsavedstateid" );
		
		if(getSessionService().hasValue( savedStateKey )) {
			rc.savedStateID = getSessionService().getValue( savedStateKey );
		}
		
		rc["#arguments.entityName#smartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=rc} );
		
		getSessionService().setValue( savedStateKey, rc["#arguments.entityName#smartList"].getSavedStateID() );
	}
	
	public void function genericCreateMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		rc.edit = true;
		getFW().setView(rc.detailAction);
	}
	
	public void function genericEditMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		rc["#arguments.entityName#"] = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
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
	}
	
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#rc.itemEntityName#", {1=rc[ entityPrimaryID ]} );
		
		if(isNull(entity)) {
			getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_failure");
		}
		
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		if (deleteOK) {
			getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_success");
		}
		
		getFW().redirect(action=rc.listAction, querystring="messagekeys=#replace(rc.slatAction, ':', '.', 'all')#_failure");
	}
	
	public void function genericSaveMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		rc[ arguments.entityName ] = entityService.invokeMethod( "get#arguments.entityName#", {1=rc[ entityPrimaryID ], 2=true} );
		rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=rc[ arguments.entityName ], 2=rc} );
		
		getFW().setView(action=rc.detailAction);
		
		if(!rc[ arguments.entityName ].hasErrors()) {
			showMessageKey("#replace(rc.slatAction, ':', '.', 'all')#_success");
			rc.slatAction = rc.detailAction;
		} else {
			showMessageKey("#replace(rc.slatAction, ':', '.', 'all')#_failure");
			if(rc[ arguments.entityName ].isNew()) {
				rc.slatAction = rc.createAction;
			} else {
				rc.slatAction = rc.editAction;
			}
			rc.edit = true;
		}
	}
	
}
