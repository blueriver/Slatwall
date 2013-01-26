component output="false" accessors="true" extends="HibachiService" {

	public boolean function authenticateAction() {
			
	}
	
	public boolean function authenticateReadEntity() {
		
	}
	
	public boolean function authenticateWriteEntity() {
		
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
	
	
	public struct function getPermissions(){
		if(!structKeyExists(variables, "permissions")){
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
			
			variables.permissions = allPermissions;
		}
		return variables.permissions;
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