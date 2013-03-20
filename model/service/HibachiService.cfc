component accessors="true" extends="Slatwall.org.Hibachi.HibachiService" {

	public any function getSlatwallScope() {
		return getHibachiScope();
	} 
	
	// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
	public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
		return getEntityHasAttributeByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), attributeCode=listLast(arguments.propertyIdentifier, "._") );
	}
	
	// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
	public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
		if(listFindNoCase(getAttributeService().getAttributeCodesListByAttributeSetType( "ast#getProperlyCasedShortEntityName(arguments.entityName)#" ), arguments.attributeCode)) {
			return true;
		}
		return false; 
	}
	
	public boolean function delete(required any entity){
			
		// If the entity Passes validation
		if(arguments.entity.isDeletable()) {
			
			// Remove any Many-to-Many relationships
			arguments.entity.removeAllManyToManyRelationships();
			
			// Remove all of the entity settings
			getService("settingService").removeAllEntityRelatedSettings( entity=arguments.entity );
			
			// Remove all of the entity comments and comments related to this entity
			// TODO: Impliment This
			//getService("commentService").removeAllCommentsAndCommentRelationships( entity=arguments.entity );
			
			// Call delete in the DAO
			getHibachiDAO().delete(target=arguments.entity);
			
			// Return that the delete was sucessful
			return true;
			
		}
			
		// Setup ormHasErrors because it didn't pass validation
		getHibachiScope().setORMHasErrors( true );

		return false;
	}
}