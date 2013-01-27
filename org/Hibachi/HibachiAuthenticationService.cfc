component output="false" accessors="true" extends="HibachiService" {

	property name="hibachiSessionService" type="any";

	public boolean function authenticateAction(required string action, required any account) {
		return true;
		if(!structKeyExists(arguments, "account")) {
			arguments.account = getHibachiScope().getCurrentAccount();
		}
		
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		var itemName = listLast( arguments.action, "." );
		
		// Verify that there is a subsystem and section setup for that action
		if( !structKeyExists(getActionPermissionDetails(), subsystemName) || !structKeyExists(getActionPermissionDetails()[ subsystemName ], sectionName) ) {
			return false;
		}
		
		//check if the page is public, if public no need to worry about security
		if(listFindNocase(getActionPermissionDetails()[ subsystemName ][ sectionName ].publicMethods, itemName)){
			return true;
		}	
		/*
		// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
		if(listFindNocase(getPermissions()[ subsystemName ][ sectionName ].anyAdminMethods, itemName) && len(arguments.account.getAllPermissions())) {
			return true;
		}
		
		// Check if the acount has access to a secure method
		if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(arguments.action, ".", "", "all"), ":", "", "all")) ) {
			return true;
		}
		
		// If this is a save method, then we can check create and edit
		if(left(listLast(arguments.action, "."),4) eq "save") {
			var createAction = replace(arguments.action, '.save', '.create');
			var editAction = replace(arguments.action, '.save', '.edit');
			if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(createAction, ".", "", "all"), ":", "", "all")) ) {
				return true;
			}
			if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(editAction, ".", "", "all"), ":", "", "all")) ) {
				return true;
			}
		}
		*/
		
		return false;
	}
	
	public boolean function authenticateEntity(required string crudType, required string entityName) {
		var entityPermissions = getEntityPermissionDetails();
		
		// If the entity does not have the ability to have permissions set, then return false
		if(!structKeyExists(entityPermissions, arguments.entityName)) {
			return false;
		}
		
		// If this is an entity
		
		
		
		
		// If for some reason not of the above were meet then just return false
		return false;
	}
	
	public boolean function authenticateEntityProperty(required string crud, required string entityName, required string propertyName) {
		
	}
	
	public boolean function authenticateEntityByPermissionGroup(required string crud, required string entityName, required any permissionGroup) {
		
	}
	
	public boolean function authenticateEntityPropertyByPermissionGroup(required string crud, required string entityName, required string propertyName, required any permissionGroup) {
		
	}
	
	
	
	
	
	
	
	
	
	public boolean function authenticateEntityPropertyRead( required any entity, required string propertyName ) {
		
	}
	
	public boolean function authenticateEntityPropertyWrite( required any entity, required string propertyName ) {
		arguments.entity.invokeProperty( "authenticate#arguments.propertyName#Write" );
	}
	
	
	private array function getSecureActions() {
		
	}
	
	private array function getAnyAdminActions() {
		
	}
	
	public struct function getEntityPermissionDetails() {
		
		var entityDirectoryArray = directoryList(expandPath('/Slatwall/model/entity'));
		var entityPermissionDetails = {};
		for(var e=1; e<=arrayLen(entityDirectoryArray); e++) {
			if(listLast(entityDirectoryArray[e], '.') eq 'cfc') {
				var entityName = listFirst(listLast(replace(entityDirectoryArray[e], '\', '/', 'all'), '/'), '.');
				var entityMetaData = createObject('component', 'Slatwall.model.entity.#entityName#').getThisMetaData();
				
				if(structKeyExists(entityMetaData, "hb_permission") && (entityMetaData.hb_permission eq "this" || getHasPropertyByEntityNameAndPropertyIdentifier(entityName=entityName, propertyIdentifier=entityMetaData.hb_permission))) {
					entityPermissionDetails[ entityName ] = {};
					entityPermissionDetails[ entityName ].properties = {};
					entityPermissionDetails[ entityName ].mtmproperties = {};
					entityPermissionDetails[ entityName ].mtoproperties = {};
					entityPermissionDetails[ entityName ].otmproperties = {};
					if(entityMetaData.hb_permission neq "this") {
						entityPermissionDetails[ entityName ].inheritPermissionEntityName = getLastEntityNameInPropertyIdentifier(entityName=entityName, propertyIdentifier=entityMetaData.hb_permission);
						entityPermissionDetails[ entityName ].inheritPermissionPropertyName = listLast(entityMetaData.hb_permission, ".");	
					}
					for(var p=1; p<=arrayLen(entityMetaData.properties); p++) {
						if( (!structKeyExists(entityMetaData.properties[p], "fieldtype") || entityMetaData.properties[p].fieldtype neq "ID")
							&& (!structKeyExists(entityMetaData.properties[p], "persistent") || entityMetaData.properties[p].persistent)
							&& (!structKeyExists(entityMetaData.properties[p], "hb_editable") || entityMetaData.properties[p].hb_editable)
							&& !listFindNoCase("createdByAccount,createdDateTime,modifiedByAccount,modifiedDateTime", entityMetaData.properties[p].name)) {

							if(structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "many-to-one") {
								entityPermissionDetails[ entityName ].mtoproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
							} else if (structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "one-to-many") {
								entityPermissionDetails[ entityName ].otmproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
							} else if (structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "many-to-many") {
								entityPermissionDetails[ entityName ].mtmproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
							} else {
								entityPermissionDetails[ entityName ].properties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];	
							}
						}
					}
					structSort(entityPermissionDetails[ entityName ].properties, "text", "ASC", "name");
				}
			}
		}
		return entityPermissionDetails;
	}
	
	
	public void function clearActionPermissions(){
		if(structKeyExists(variables, "actionPermissions")) {
			structDelete(variables, "actionPermissions");
		}
	}
	
	public struct function getActionPermissionDetails(){
		if(!structKeyExists(variables, "actionPermissions")){
			var allPermissions={
				admin={}
			};
			
			// Setup Admin Permissions
			var adminDirectoryList = directoryList( expandPath("/Slatwall/admin/controllers"), false, "path", "*.cfc" );
			for(var i=1; i <= arrayLen(adminDirectoryList); i++){
				
				var section = listFirst(listLast(adminDirectoryList[i],"/\"),".");
				var obj = createObject('component','Slatwall.admin.controllers.' & section);
				
				allPermissions.admin[ section ] = {
					publicMethods = "",
					anyAdminMethods = "",
					secureMethods = "",
					securePermissionOptions = []
				};
				
				if(structKeyExists(obj, 'publicMethods')){
					allPermissions.admin[ section ].publicMethods = obj.publicMethods;
				}
				if(structKeyExists(obj, 'anyAdminMethods')){
					allPermissions.admin[ section ].anyAdminMethods = obj.anyAdminMethods;
				}
				if(structKeyExists(obj, 'secureMethods')){	
					allPermissions.admin[ section ].secureMethods = obj.secureMethods;
					
					for(j=1; j <= listLen(allPermissions.admin[ section ].secureMethods); j++){
						
						var item = listGetAt(allPermissions.admin[ section ].secureMethods, j);
						
						if(left(item, 2) eq '**') {
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.list_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#list#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#detail#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#create#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#edit#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-2)#')), value="admin#section#delete#item#"});
						} else if(left(item, 1) eq '*') {
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#detail#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#create#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#edit#item#"});
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-1)#')), value="admin#section#delete#item#"});
						} else {
							
							var permissionTitle = rbKey( 'admin.#section#.#item#_permission' );
							
							if(right(permissionTitle, 8) eq "_missing") {
								if(left(item, 4) eq "list") {
									permissionTitle = replace(rbKey( 'admin.define.list_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-4)#'));
								} else if (left(item, 6) eq "detail") {
									permissionTitle = replace(rbKey( 'admin.define.detail_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 6) eq "create") {
									permissionTitle = replace(rbKey( 'admin.define.create_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 4) eq "edit") {
									permissionTitle = replace(rbKey( 'admin.define.edit_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-4)#'));
								} else if (left(item, 6) eq "delete") {
									permissionTitle = replace(rbKey( 'admin.define.delete_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-6)#'));
								} else if (left(item, 7) eq "process") {
									permissionTitle = replace(rbKey( 'admin.define.process_permission'), '${itemEntityName}', rbKey('entity.#right(item, len(item)-7)#'));
								}
							}
							
							arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {name=permissionTitle, value="admin#section##item#"});
						}
					}
				}
			}
			
			// Setup Integration Permissions
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i <= arrayLen(activeFW1Integrations); i++){
				
				allPermissions[ activeFW1Integrations[i].subsystem ] = {};
				
				var integrationDirectoryList = directoryList( expandPath("/Slatwall/integrationServices/#activeFW1Integrations[i].subsystem#/controllers"), false, "path", "*.cfc" );
				for(var j=1; j <= arrayLen(integrationDirectoryList); j++){
					
					var section = listFirst(listLast(integrationDirectoryList[j],"/\"),".");
					var obj = createObject('component','Slatwall.integrationServices.#activeFW1Integrations[i].subsystem#.controllers.#section#');
					
					allPermissions[ activeFW1Integrations[i].subsystem ][ section ] = {
						publicMethods = "",
						secureMethods = "",
						anyAdminMethods = "",
						securePermissionOptions = []
					};
					
					if(structKeyExists(obj, 'publicMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].publicMethods = obj.publicMethods;
					}
					if(structKeyExists(obj, 'anyAdminMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].anyAdminMethods = obj.anyAdminMethods;
					}
					if(structKeyExists(obj, 'secureMethods')){	
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods = obj.secureMethods;
					
						for(k=1; k <= listLen(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods); k++){
							
							var item = listGetAt(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods, k);
							
							arrayAppend(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].securePermissionOptions, {
								name=rbKey("#activeFW1Integrations[i].subsystem#.#section#.#item#_permission"),
								value="#activeFW1Integrations[i].subsystem##section##item#"
							});
						}
					}
					
				}
			}
			
			variables.actionPermissions = allPermissions;
		}
		return variables.actionPermissions;
	}
}



/*
component entityName="SlatwallAccount" hb_permission="inherit:propertyName"	
component entityName="SlatwallAccount" hb_permission="admin"				
component entityName="SlatwallAccount" hb_permission="public"				
component entityName="SlatwallAccount" hb_permission="system"				

hb_nopopulate="true"







Permission Setup				
	Account (read|write|delete)								Entity					
		firstName				(read|write)				Field					
															Non-Persistent Field	
		accountEmailAddresses	(add|delete)				One-to-Many				
		primaryEmailAddress		(read|write)										
		emailAddress			(read)												
		permissions				(read|write)				Many-to-Many			
		Permissions				(read|write)				Many-to-Many			
	Order																			
																					
	Product																			
																					






*/