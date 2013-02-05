<cfcomponent>
	
	<!--- ======================= Helper Methods ================================ --->
		
	<cfscript>
		// Helper Method for doAction()
		public string function doAction(required any action) {
			if(!structKeyExists(url, "$")) {
				url.$ = getMuraScope();
			}
			return getSlatwallApplication().doAction( arguments.action );
		}
		
		// Helper method to get the Slatwall Application
		public any function getSlatwallApplication() {
			if(!structKeyExists(variables, "slatwallApplication")) {
				variables.slatwallApplication = createObject("component", "Slatwall.Application");
			}
			return variables.slatwallApplication;
		}
		
		// Helper method to return the mura plugin config for the slatwall-mura connector
		public any function getMuraPluginConfig() {
			if(!structKeyExists(variables, "muraPluginConfig")) {
				variables.pluginConfig = application.pluginManager.getConfig("slatwall-mura");
			}
			return variables.pluginConfig;
		}
		
		// For admin request end, we call the endLifecycle
		public void function verifySlatwallRequest( required any $ ) {
			if(!structKeyExists(request, "slatwallScope")) {
				getSlatwallApplication().setupGlobalRequest();	
			}
			if(!structKeyExists(arguments.$, "slatwall")) {
				$.setCustomMuraScopeKey("slatwall", request.slatwallScope);	
			}
		}
		
		// For admin request end, we call the endLifecycle
		public void function endSlatwallRequest() {
			getSlatwallApplication().endHibachiLifecycle();
		}
	</cfscript>
	
	<cffunction name="getMuraIntegrationID">
		<cfif not structKeyExists(variables, "muraIntegrationID")>
			<cfset var muraIntegrationQuery = "" />
			<cfquery name="muraIntegrationQuery">
				SELECT integrationID FROM SlatwallIntegration WHERE integrationPackage = <cfqueryparam cfsqltype="cf_sql_varchar" value="mura" />
			</cfquery>
			<cfset variables.muraIntegrationID = muraIntegrationQuery.integrationID />
		</cfif>
		<cfreturn variables.muraIntegrationID />
	</cffunction>
	
	<cffunction name="getMuraSiteIDByMuraUserID">
		<cfargument name="muraUserID" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			SELECT siteID FROM tusers WHERE userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.muraUserID#" > 
		</cfquery>
		
		<cfreturn rs.siteID />
	</cffunction>
</cfcomponent>