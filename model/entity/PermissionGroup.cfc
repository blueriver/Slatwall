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
component entityname="SlatwallPermissionGroup" table="SwPermissionGroup" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="this" {
	
	// Persistent Properties
	property name="permissionGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="permissionGroupName" ormtype="string";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="permissions" singularname="permission" cfc="Permission" type="array" fieldtype="one-to-many" fkcolumn="permissionGroupID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	property name="accounts" singularname="account" cfc="Account" fieldtype="many-to-many" linktable="SlatwallAccountPermissionGroup" fkcolumn="permissionGroupID" inversejoincolumn="accountID" inverse="true";
	
	// Remote Properties
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="permissionsByDetails" persistent="false"; 
	
	public struct function getPermissionsByDetails() {
		if(!structKeyExists(variables, "permissionsByDetails")) {
			
			// Create the start of the structure
			variables.permissionsByDetails = {
				entity = {
					entities = {}
				},
				action = {
					subsystems = {}
				}
			};
			
			// Get all of the permissions & the arrayLen
			var permissions = getPermissions(); 
			var l = arrayLen(permissions);
			
			// Loop over each permission
			for(var p=1; p<=l; p++) {
				
				// setup a local variable for the permission
				var thisPermission = permissions[p];
				
				// If the permission is an 'entity' access type
				if(thisPermission.getAccessType() eq "entity") {
					
					// Check to see if this is the 'core' or very top level permission
					if(isNull(thisPermission.getEntityClassName())) {
						variables.permissionsByDetails.entity.permission = thisPermission;
						
					// Otherwise this is a property or entity level permission
					} else {
						
						// Make sure the default data for this entity exists
						if(!structKeyExists(variables.permissionsByDetails.entity.entities, thisPermission.getEntityClassName())) {
							variables.permissionsByDetails.entity.entities[ thisPermission.getEntityClassName() ] = {
								properties = {}
							};	
						}
						
						// Check if this is a property level permission
						if(isNull(thisPermission.getPropertyName())) {
							variables.permissionsByDetails.entity.entities[ thisPermission.getEntityClassName() ].permission = thisPermission;
						} else {
							variables.permissionsByDetails.entity.entities[ thisPermission.getEntityClassName() ].properties[ thisPermission.getPropertyName() ] = thisPermission;
						}
					}
				} else if (thisPermission.getAccessType() eq "action" && !isNull(thisPermission.getSubsystem())) {
					
					// Setup default data structure for subsystem
					if(!structKeyExists(variables.permissionsByDetails.action.subsystems, thisPermission.getSubsystem())) {
						variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ] = {
							sections = {}
						};
					}
					// Setup default data structure for section
					if(!isNull(thisPermission.getSection()) && !structKeyExists(variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ].sections, thisPermission.getSection())) {
						variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ].sections[ thisPermission.getSection() ] = {
							items = {}
						};
					}
					
					if(!isNull( thisPermission.getSubsystem() ) && !isNull( thisPermission.getSection()) && !isNull(thisPermission.getItem())) {
						variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ].sections[ thisPermission.getSection() ].items[ thisPermsission.getItem() ] = thisPermission;	
					} else if (!isNull( thisPermission.getSubsystem() ) && !isNull( thisPermission.getSection())) {
						variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ].sections[ thisPermission.getSection() ].permission = thisPermission;
					} else {
						variables.permissionsByDetails.action.subsystems[ thisPermission.getSubsystem() ].permission = thisPermission;
					}
				}
			}
		}
		return variables.permissionsByDetails;
	}
	
	public any function getPermissionByDetails(required string accessType, string entityClassName, string propertyName, string subsystem, string section, string item) {
		
		// We are looking for an entity permission
		if(arguments.accessType eq "entity") {
			if(structKeyExists(arguments, "entityClassName") && structKeyExists(arguments, "propertyName")) {
				if(structKeyExists(getPermissionsByDetails().entity.entities, arguments.entityClassName) && structKeyExists(getPermissionsByDetails().entity.entities[ arguments.entityClassName ].properties, arguments.propertyName)) {
					return getPermissionsByDetails().entity.entities[ arguments.entityClassName ].properties[ arguments.propertyName ];
				}
			} else if(structKeyExists(arguments, "entityClassName")){
				if(structKeyExists(getPermissionsByDetails().entity.entities, arguments.entityClassName) && structKeyExists(getPermissionsByDetails().entity.entities[ arguments.entityClassName ], "permission")) {
					return getPermissionsByDetails().entity.entities[ arguments.entityClassName ].permission;
				}
			} else if(structKeyExists(getPermissionsByDetails().entity, "permission")) {
				return getPermissionsByDetails().entity.permission;
			}
		} else if (arguments.accessType eq "action") {
			if(structKeyExists(arguments, "subsystem") && structKeyExists(arguments, "section") && structKeyExists(arguments, "item")) {
				if(structKeyExists(getPermissionsByDetails().action.subsystems, arguments.subsystem) && structKeyExists(getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections, arguments.section) && structKeyExists(getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections[ arguments.section ].items, arguments.item)) {
					return getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections[ arguments.section ].items[ item ];
				}
			} else if(structKeyExists(arguments, "subsystem") && structKeyExists(arguments, "section")){
				if(structKeyExists(getPermissionsByDetails().action.subsystems, arguments.subsystem) && structKeyExists(getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections, arguments.section) && structKeyExists(getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections[ arguments.section ], "permission")) {
					return getPermissionsByDetails().action.subsystems[ arguments.subsystem ].sections[ arguments.section ].permission;
				}
			} else if(structKeyExists(arguments, "subsystem")) {
				if(structKeyExists(getPermissionsByDetails().action.subsystems, arguments.subsystem) && structKeyExists(getPermissionsByDetails().action.subsystems[ arguments.subsystem ], "permission")) {
					return getPermissionsByDetails().action.subsystems[ arguments.subsystem ].permission;
				}
			}
		}
		
		return getService("accountService").newPermission();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Permissions (one-to-many)    
	public void function addPermission(required any permission) {    
		arguments.permission.setPermissionGroup( this );    
	}    
	public void function removePermission(required any permission) {    
		arguments.permission.removePermissionGroup( this );    
	}
	
	// Accounts (many-to-many - inverse)
	public void function addAccount(required any account) {
		arguments.account.addPermissionGroup( this );
	}
	public void function removeAccount(required any account) {
		arguments.account.removePermissionGroup( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
}
