component output="false" accessors="true" extends="HibachiController" {
	
	property name="hibachiService" type="any";
	
	public void function get( required struct rc ) {
		
		// If there is an entityID
		if(structKeyExists(arguments.rc, "entityID")) {
			var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
			var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID});
			writeOutput(serializeJSON(entity));
			abort;	
		}
		
		// If ther is no entityID then get a smart list
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		var smartList = entityService.invokeMethod("get#arguments.rc.entityName#SmartList", {1=arguments.rc});
		writeOutput(serializeJSON(smartList.getPageRecords()));
		abort;
		
		// TODO: SET METADATA IN THE HEADER!!!
	}
	
}