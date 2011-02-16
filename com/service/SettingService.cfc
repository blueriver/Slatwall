component extends="Slatwall.com.service.BaseService" persistent="false" output="false" {
	
	public any function init(required string entityName, required any dao) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		
		reloadSettings();
		
		return this;
	}
	
	public struct function getAllSettings(boolean reload=false) {
		if(!structKeyExists(variables, "allSettings") || arguments.reload == true) {
			var settingsList = list();
			for(var i = 1; i <= arrayLen(settingsList); i++) {
				variables.allSettings[ settingsList[i].getSettingName() ] = settingsList[i];
			}			
		}
		return variables.allSettings;
	}
	
	public any function getSettingValue(required string settingName) {
		return variables.allSettings[ arguments.settingName ].getSettingValue();
	}
	
	public any function getBySettingName(required string settingName) {
		return variables.allSettings[ arguments.settingName ];
	}
	
	public void function reloadSettings() {
		getAllSettings(reload=true);
	}
	
	public void function getAdminActionsStruct() {
		if(!structKeyExists(variables, "adminActions")) {
			var dirLocation = ExpandPath("/plugins/Slatwall/admin/controllers");
			var dirList = directoryList( dirLocation );
			writeDump(dirList);
			abort;
			for(var i=1; i<= arrayLen(dirList); i++) {
				
				
				var xmlRaw = FileRead(dirList[i]);
				
			}
		}
	}
	
}