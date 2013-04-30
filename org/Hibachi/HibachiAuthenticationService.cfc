component output="false" accessors="true" extends="HibachiService" {

	property name="hibachiSessionService" type="any";

	// ============================ PUBLIC AUTHENTICATION METHODS =================================
	
	public boolean function authenticateAction(required string action) {
		
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		var itemName = listLast( arguments.action, "." );
		var actionPermissions = getActionPermissionDetails();
		
		// Check if the subsystem & section are defined, if not then return true because that means authentication was not turned on
		if(!structKeyExists(actionPermissions, subsystemName) || !structKeyExists(actionPermissions[ subsystemName ], sectionName)) {
			return true;
		}

		// Check if the action is public, if public no need to worry about security
		if(listFindNocase(actionPermissions[ subsystemName ][ sectionName ].publicMethods, itemName)){
			return true;
		}
		
		
		// All these potentials require the account to be logged in
		if(getHibachiScope().getLoggedInFlag()) {
			
			// Check if the action is anyLogin, if so and the user is logged in, then we can return true
			if(listFindNocase(actionPermissions[ subsystemName ][ sectionName ].anyLoginMethods, itemName) && getHibachiScope().getLoggedInFlag()) {
				return true;
			}
			
			// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
			if(listFindNocase(actionPermissions[ subsystemName ][ sectionName ].anyAdminMethods, itemName) && getHibachiScope().getLoggedInAsAdminFlag()) {
				return true;
			}
			
			// Check to see if this is a defined secure method, and if so we can test it against the account
			if(listFindNocase(actionPermissions[ subsystemName ][ sectionName ].secureMethods, itemName)) {
				return authenticateAccountAcction(action=arguments.action, account=getHibachiScope().getAccount());
			}
			
			// Check to see if the controller is an entity or rest controller, and then verify against the entity itself
			if(getActionPermissionDetails()[ subsystemName ][ sectionName ].entityController || getActionPermissionDetails()[ subsystemName ][ sectionName ].apiController) {
				
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
					return true;
				} else if ( left(itemName, 12) == "multiProcess" ) {
					return true;
				} else if ( left(itemName, 10) == "preProcess" ) {
					return true;
				} else if ( left(itemName, 7) == "process" ) {
					return true;
				} else if ( left(itemName, 4) == "save" ) {
					var createOK = authenticateEntity(crudType="create", entityName=right(itemName, len(itemName)-4), account=arguments.account);
					if(createOK) {
						return true;	
					}
					var updateOK = authenticateEntity(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
					return updateOK;
				}
				
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
		
		// First check to see if this is cached
		if(!structKeyExists(variables, "actionPermissionDetails")){
			
			// Setup the all permisions structure which will later be set to the variables scope
			var allPermissions={};
			
			// Loop over each of the authentication subsytems
			var aspArr = listToArray(getApplicationValue("hibachiConfig").authenticationSubsystems);
			for(var s=1; s<=arrayLen(aspArr); s++) {
				
				// Figure out the correct directory for the subsytem
				var ssDirectory = getApplicationValue('application').getSubsystemDirPrefix( aspArr[s] );
				
				// expand the path of the controllers sub-directory
				var ssControllerPath = expandPath( "#ssDirectory#/controllers" );
				
				// Make sure the controllers sub-directory is actually there
				if(directoryExists(ssControllerPath)) {
					
					// Setup subsytem structure
					allPermissions[ aspArr[s] ] = {};
					
					// Grab a list of all the files in the controllers directory
					var ssDirectoryList = directoryList(ssControllerPath);
					
					// Loop over each file
					for(var d=1; d<=arrayLen(ssDirectoryList); d++) {
						
						var section = listFirst(listLast(ssDirectoryList[d],"/\"),".");
						var obj = createObject('component', '#replace(ssDirectory, '/','.','all')#controllers.#section#');
						
						// Setup section structure
						allPermissions[ aspArr[s] ][ section ] = {
							anyAdminMethods = "",
							anyLoginMethods = "",
							publicMethods = "",
							secureMethods = "",
							restController = false,
							entityController = false
						};
						
						// Check defined permissions
						if(structKeyExists(obj, 'anyAdminMethods')){
							allPermissions[ aspArr[s] ][ section ].anyAdminMethods = obj.anyAdminMethods;
						}
						if(structKeyExists(obj, 'anyLoginMethods')){
							allPermissions[ aspArr[s] ][ section ].anyLoginMethods = obj.anyLoginMethods;
						}
						if(structKeyExists(obj, 'publicMethods')){
							allPermissions[ aspArr[s] ][ section ].publicMethods = obj.publicMethods;
						}
						if(structKeyExists(obj, 'secureMethods')){
							allPermissions[ aspArr[s] ][ section ].secureMethods = obj.secureMethods;
						}
						
						// Check for Controller types
						if(structKeyExists(obj, 'entityController') && isBoolean(obj.entityController) && obj.entityController) {
							allPermissions[ aspArr[s] ][ section ].entityController = true;
						}
						if(structKeyExists(obj, 'restController') && isBoolean(obj.restController) && obj.restController) {
							allPermissions[ aspArr[s] ][ section ].restController = true;
						}
						
					} // END Section Loop
					
				}
				
			} // End Subsytem Loop
			
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