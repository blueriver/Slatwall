component extends="handler" {

	public any function confirmMuraScope( required any slatwallScope ) {
		param name="session.siteID" default="default";
		param name="request.customMuraScopeKeys" default="#structNew()#";
		
		if(!structKeyExists(request, "muraScope")) {
			request.muraScope = application.serviceFactory.getBean('$'); 
		}
		
		request.muraScope.setCustomMuraScopeKey("slatwall", arguments.slatwallScope);
		
		return request.muraScope;
	}

	public void function onSessionAccountLogin( required any slatwallScope ) {
		if(!isNull(arguments.slatwallScope.getAccount().getCMSAccountID()) && len(arguments.slatwallScope.getAccount().getCMSAccountID())) {
			var $ = confirmMuraScope( arguments.slatwallScope );
			
			$.announceEvent("onBeforeGlobalLogin", $); 
			$.getBean("userUtility").loginByUserID(arguments.slatwallScope.getAccount().getCMSAccountID(), getMuraSiteIDByMuraUserID(arguments.slatwallScope.getAccount().getCMSAccountID()));
			$.announceEvent("onAfterGlobalLogin", $);
			$.announceEvent("onGlobalLoginSuccess", $);
		}
	}
	
	public void function onSessionAccountLogout( required any slatwallScope ) {
		// Auto Logout of Mura if needed
		if(structKeyExists(session, "mura") && structKeyExists(session.mura, "isLoggedIn") && session.mura.isLoggedIn) {
			var $ = confirmMuraScope( arguments.slatwallScope );
			
			$.getBean('loginManager').logout();
		}
	}
	
	public void function afterSettingSaveSuccess( required any slatwallScope, required any entity ) {
		if(listFindNoCase("integrationMuraAccountSyncType,integrationMuraCreateDefaultPages,integrationMuraSuperUserSyncFlag", arguments.entity.getSettingName())) {
			updatePluginSetting(moduleID=getMuraPluginConfig().getModuleID(), settingName=replaceNoCase(arguments.entity.getSettingName(), "integrationmura", ""), settingValue=arguments.entity.getSettingValue());
		}
	}
	
	public void function onEvent( required any slatwallScope, required any eventName ) {
		var $ = confirmMuraScope( arguments.slatwallScope );
		
		$.announceEvent("slatwall#arguments.eventName#", createObject("mura.event").init(arguments) );
	}

}