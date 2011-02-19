component extends="BaseController" output="false" accessors="true" {
			
	property name="settingService" type="any";
	property name="userManager" type="any";
	
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
		getSettingService().reloadConfiguration();
		variables.fw.redirect(action="admin:setting.detail");
	}
	
	public void function editpermissions(required struct rc) {
		rc.muraUserGroups = getUserManager().getUserGroups();
		rc.permissionActions = getSettingService().getPermissionActions();
		rc.permissionSettings = getSettingService().getAllPermissions();
	}
	
	public void function savepermissions(required struct rc) {
		param name="rc.muraUserGroupID" default="";
		
		for(var item in rc) {
			if(!isObject(item)) {
				if(left(item,10) == "permission") {
					var setting = getSettingService().getByPermissionName(item);
					if(setting.isNew()) {
						setting.setSettingName(item);	
					}
					setting.setSettingValue(rc[item]);
					getSettingService().save(entity=setting);
				}
			}
		}
		getSettingService().reloadConfiguration();
		variables.fw.redirect(action="admin:main.dashboard");
	}
}