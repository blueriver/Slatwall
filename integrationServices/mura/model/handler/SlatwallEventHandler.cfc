component extends="handler" {

	public void function onSessionAccountLogout( required any slatwallScope ) {
		// Auto Logout of Mura if needed
		if(structKeyExists(session, "mura") && structKeyExists(session.mura, "isLoggedIn") && session.mura.isLoggedIn) {
			application.serviceFactory.getBean('loginManager').logout();
		}
	}
	
	public void function onSessionAccountLogin( required any slatwallScope ) {
		if(!isNull(arguments.slatwallScope.getAccount().getCMSAccountID()) && len(arguments.slatwallScope.getAccount().getCMSAccountID())) {
			param name="session.siteID" default="default";
			
			application.serviceFactory.getBean('userUtility').loginByUserID(arguments.slatwallScope.getAccount().getCMSAccountID(), getMuraSiteIDByMuraUserID(arguments.slatwallScope.getAccount().getCMSAccountID()));
		}
	}
	
	public void function afterSettingSaveSuccess( required any slatwallScope, required any entity ) {
		if(listFindNoCase("integrationMuraAccountSyncType,integrationMuraCreateDefaultPages,integrationMuraSuperUserSyncFlag", arguments.entity.getSettingName())) {
			updatePluginSetting(moduleID=getMuraPluginConfig().getModuleID(), settingName=replaceNoCase(arguments.entity.getSettingName(), "integrationmura", ""), settingValue=arguments.entity.getSettingValue());
		}
	}

}