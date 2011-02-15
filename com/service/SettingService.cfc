component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	property name="allSettings" type="array";
	
	public any function getAllSettings(boolean reload=false) {
		if(!structKeyExists(variables, "allSettings") || arguments.reload == true) {
			variables.allSettings = list();
		}
		return variables.allSettings;
	}
	
	public any function getSettingValue(required string settingName) {
		var allSettings = getAllSettings();
		for(var i = 1; i <= arrayLen(allSettings); i++) {
			if(allSettings[i].getSettingName() == arguments.settingName) {
				return 	allSettings[i].getSettingValue();
			}
		}
	}
	
	public any function getBySettingName(required string settingName) {
		var allSettings = getAllSettings();
		for(var i = 1; i <= arrayLen(allSettings); i++) {
			if(allSettings[i].getSettingName() == arguments.settingName) {
				return 	allSettings[i];
			}
		}
		return getNewEntity();
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