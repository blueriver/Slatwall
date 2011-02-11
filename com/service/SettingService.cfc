component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	property name="allSettings" type="array";
	
	public any function getAllSettings() {
		if(!isDefined("variables.allSettings")) {
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
	
}