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
	
	
	
}