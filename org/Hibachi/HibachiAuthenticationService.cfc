component output="false" accessors="true" extends="HibachiService" {

	property name="hibachiSessionService" type="any";

	// ============================ PUBLIC AUTHENTICATION METHODS =================================
	
	public boolean function authenticateAction(required string action, required any account) {
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		var itemName = listLast( arguments.action, "." );
		
		// Check if the subsystem is even defined
		if(!structKeyExists(getActionPermissionDetails(), subsystemName)) {
			return false;
		}
		
		// Check if the section is defined
		if(!structKeyExists(getActionPermissionDetails()[ subsystemName ], sectionName)) {
			return false;
		}

		// Check if the action is public, if public no need to worry about security
		if(listFindNocase(getActionPermissionDetails()[ subsystemName ][ sectionName ].publicMethods, itemName)){
			return true;
		}
		
		// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
		if(listFindNocase(getActionPermissionDetails()[ subsystemName ][ sectionName ].anyAdminMethods, itemName) && arguments.account.getAdminAccountFlag()) {
			return true;
		}
		
		// Check to see if this is a defined admin method
		if(listFindNocase(getActionPermissionDetails()[ subsystemName ][ sectionName ].secureMethods, itemName)) {
			return false;
		}
		
		// Check to see if the controller is an entity or rest controller, and then verify against the entity itself
		if(getActionPermissionDetails()[ subsystemName ][ sectionName ].entityController) {
			if ( left(itemName, 6) == "create" ) {
				return authenticateEntity(crudType="create", entityName=right(itemName, len(itemName)-6), account=arguments.account);
			} else if ( left(itemName, 6) == "detail" ) {
				return authenticateEntity(crudType="read", entityName=right(itemName, len(itemName)-6), account=arguments.account);
			} else if ( left(itemName, 6) == "delete" ) {
				return authenticateEntity(crudType="delete", entityName=right(itemName, len(itemName)-6), account=arguments.account);
			} else if ( left(itemName, 4) == "edit" ) {
				return authenticateEntity(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
			} else if ( left(itemName, 4) == "list" ) {
				return authenticateEntity(crudType="read", entityName=right(itemName, len(itemName)-4), account=arguments.account);
			} else if ( left(itemName, 15) == "multiPreProcess" ) {
			} else if ( left(itemName, 12) == "multiProcess" ) {
			} else if ( left(itemName, 10) == "preProcess" ) {	
			} else if ( left(itemName, 7) == "process" ) {
			} else if ( left(itemName, 4) == "save" ) {
				var createOK = authenticateEntity(crudType="create", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				if(createOK) {
					return true;	
				}
				var updateOK = authenticateEntity(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				return updateOK;
			}
		}
		
		return false;
	}
	
	public boolean function authenticateEntity(required string crudType, required string entityName, required any account) {
		var entityPermissions = getEntityPermissionDetails();
		
		// If the entity does not have the ability to have permissions set, then return false
		if(!structKeyExists(entityPermissions, arguments.entityName)) {
			return false;
		}
		
		// If this is an entity
		
		
		// If for some reason not of the above were meet then just return false
		return false;
	}
	
	public boolean function authenticateEntityProperty(required string crud, required string entityName, required string propertyName, required any account) {
		
	}
	
	// ================================ PUBLIC META INFO ==========================================
	
	public struct function getEntityPermissionDetails() {
		var entityDirectoryArray = directoryList(expandPath('/#getApplicationValue('applicationKey')#/model/entity'));
		var entityPermissionDetails = {};
		for(var e=1; e<=arrayLen(entityDirectoryArray); e++) {
			if(listLast(entityDirectoryArray[e], '.') eq 'cfc') {
				var entityName = listFirst(listLast(replace(entityDirectoryArray[e], '\', '/', 'all'), '/'), '.');
				var entityMetaData = createObject('component', '#getApplicationValue('applicationKey')#.model.entity.#entityName#').getThisMetaData();
				
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
	
	public struct function getActionPermissionDetails(){
		if(!structKeyExists(variables, "actionPermissionDetails")){
			var allPermissions={
				admin={}
			};
			
			// Setup Admin Permissions
			var adminDirectoryList = directoryList( expandPath("/#getApplicationValue('applicationKey')#/admin/controllers"), false, "path", "*.cfc" );
			for(var i=1; i <= arrayLen(adminDirectoryList); i++){
				
				var section = listFirst(listLast(adminDirectoryList[i],"/\"),".");
				var obj = createObject('component','#getApplicationValue('applicationKey')#.admin.controllers.' & section);
				
				allPermissions.admin[ section ] = {
					publicMethods = "",
					anyAdminMethods = "",
					secureMethods = "",
					securePermissionOptions = [],
					entityController = false,
					apiController = false
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
			
			/*
			// Setup Integration Permissions
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i <= arrayLen(activeFW1Integrations); i++){
				
				allPermissions[ activeFW1Integrations[i].subsystem ] = {};
				
				var integrationDirectoryList = directoryList( expandPath("/#getApplicationValue('applicationKey')#/integrationServices/#activeFW1Integrations[i].subsystem#/controllers"), false, "path", "*.cfc" );
				for(var j=1; j <= arrayLen(integrationDirectoryList); j++){
					
					var section = listFirst(listLast(integrationDirectoryList[j],"/\"),".");
					var obj = createObject('component','#getApplicationValue('applicationKey')#.integrationServices.#activeFW1Integrations[i].subsystem#.controllers.#section#');
					
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
			*/
			
			variables.actionPermissions = allPermissions;
		}
		return variables.actionPermissions;
	}
	
	public void function clearEntityPermissionDetails(){
		if(structKeyExists(variables, "entityPermissionDetails")) {
			structDelete(variables, "entityPermissionDetails");
		}
	}
	
	public void function clearActionPermissionDetails(){
		if(structKeyExists(variables, "actionPermissionDetails")) {
			structDelete(variables, "actionPermissionDetails");
		}
	}
	
	// ============================ PRIVATE HELPER FUNCTIONS =======================================
	
	private boolean function authenticateActionByPermissionGroup(required string action, required any permissionGroup) {
		return false;
	}
	
	private boolean function authenticateEntityByPermissionGroup(required string crud, required string entityName, required any permissionGroup) {
		
	}
	
	private boolean function authenticateEntityPropertyByPermissionGroup(required string crud, required string entityName, required string propertyName, required any permissionGroup) {
		
	}
	
	
}