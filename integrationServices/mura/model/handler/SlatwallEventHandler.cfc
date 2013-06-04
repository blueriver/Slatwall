component extends="handler" output="false" accessors="true" {

	property name="assignedSiteIDArray";

	// Cached the assigned sites
	private array function getAssignedSiteIDArray() {
		if(!structKeyExists(variables, "assignedSiteIDArray")) {
			var arr = [];
			var assignedSitesQuery = getMuraPluginConfig().getAssignedSites();
			for(var i=1; i<=assignedSitesQuery.recordCount; i++) {
				arrayAppend(arr, assignedSitesQuery["siteid"][i]);
			}
			variables.assignedSiteIDArray = arr;
		}
		return variables.assignedSiteIDArray;
	}
	
	// Helper function meant to be used by events to get a mura scope
	private any function getMuraScope() {
		if(structKeyExists(request, "siteID")) {
			arguments.siteID = request.siteID;
		} else if(structKeyExists(form, "siteID")) {
			arguments.siteID = form.siteID;
		} else if(structKeyExists(url, "siteID")) {
			arguments.siteID = url.siteID;	
		} else if(structKeyExists(session, "siteID")) {
			arguments.siteID = session.siteID;
		}
		
		var $ = application.serviceFactory.getBean('$').init( arguments );
		
		$.setCustomMuraScopeKey("slatwall", arguments.slatwallScope);
		
		return $;
	}

	// Special Function to relay all events called in Slatwall over to mura
	public void function onEvent( required any slatwallScope, required any eventName ) {
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			if(!structKeyExists(request.customMuraScopeKeys, "slatwall")) {
				request.customMuraScopeKeys.slatwall = arguments.slatwallScope;	
			}
			
			// If there was a request.siteID defined, then announce the event against that specific site.  This would typically happen on a Frontend mura request
			if(structKeyExists(request, "siteID")) {
				arguments.siteID = request.siteID;
				application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				
			// If there was no siteID in the request the event probably originated in the Slatwall admin.  In this situation we need to re-announce to all sites that Slatwall is defined for
			} else {
				var asArr = getAssignedSiteIDArray();
				for(var i=1; i<=arrayLen(asArr); i++) {
					arguments.siteID = asArr[i];
					application.serviceFactory.getBean('$').init( arguments ).announceEvent("slatwall#arguments.eventName#");
				}
			}
		}
	}

	// Login to Mura when Slatwall user is logged in
	public void function onSessionAccountLogin( required any slatwallScope ) {
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			if(!isNull(arguments.slatwallScope.getAccount().getCMSAccountID()) && len(arguments.slatwallScope.getAccount().getCMSAccountID())) {
				var $ = getMuraScope(argumentCollection=arguments);
				
				$.getBean("userUtility").loginByUserID(arguments.slatwallScope.getAccount().getCMSAccountID(), getMuraSiteIDByMuraUserID(arguments.slatwallScope.getAccount().getCMSAccountID()));
				$.announceEvent("onGlobalLoginSuccess");
			}
		}
	}
	
	// Logout of Mura when Slatwall user is logged out
	public void function onSessionAccountLogout( required any slatwallScope ) {
		param name="session" default="#structNew()#";
		
		if(structKeyExists(application,"appinitialized") && application.appinitialized) {
			// Auto Logout of Mura if needed
			if(structKeyExists(session, "mura") && structKeyExists(session.mura, "isLoggedIn") && session.mura.isLoggedIn) {
				getMuraScope(argumentCollection=arguments).getBean('loginManager').logout();
			}
		}
	}
	
	// When a "mura" setting gets saved it should also be updated on the Mura plugin config side.
	public void function afterSettingSaveSuccess( required any slatwallScope, required any entity ) {
		if(listFindNoCase("integrationMuraAccountSyncType,integrationMuraCreateDefaultPages,integrationMuraSuperUserSyncFlag", arguments.entity.getSettingName())) {
			updatePluginSetting(moduleID=getMuraPluginConfig().getModuleID(), settingName=replaceNoCase(arguments.entity.getSettingName(), "integrationmura", ""), settingValue=arguments.entity.getSettingValue());
		}
	}

}