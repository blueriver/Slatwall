component extends="BaseController" output="false" accessors="true" {
			
	property name="settingService" type="any";
	
	public void function detail(required struct rc) {
		rc.edit = false;
		rc.allSettings = getSettingService().getAllSettings();
	}
	
	public void function edit(required struct rc) {
		detail(rc);
		variables.fw.setView("admin:setting.detail");
		rc.edit = true;
		
	}
	
	public void function save(required struct rc) {
		for(var item in rc) {
			if(!isObject(item)) {
				var setting = getSettingService().getBySettingName(item);
				if(setting.isNew() == false) {
					setting.setSettingValue(rc[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		getSettingService().reloadSettings();
		variables.fw.redirect(action="admin:setting.detail");
	}
	
	public void function permission() {
		getSettingService().getAdminActionsStruct();
	}
}