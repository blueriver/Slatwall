<cfcomponent extends="baseController" output="false">

	<cffunction name="detail">
		<cfargument name="rc" />
		
		<cfset var I = "">
		
		<cfif isDefined('rc.fieldnames')>
			<cfloop list="#rc.fieldnames#" index="I">
				<cfif application.slatsettings.getSetting("#I#") neq rc["#I#"]>
					<cfset application.slatsettings.updateSetting(Setting = I, SettingValue=rc["#I#"]) />
				</cfif>
			</cfloop>
			
			<cfset application.slatsettings.loadSettings() />
			<cfset variables.fw.redirect(action="setting.detail") />
		</cfif>
		
	</cffunction>
	
	<cffunction name="permissions">
		<cfargument name="rc" />
		
		<cfset var I = "">
		
		<cfif isDefined('rc.fieldnames')>
			<cfset application.slatsettings.clearPermission() />
			<cfloop list="#rc.fieldnames#" index="I">
				<cfset application.slatsettings.addPermission(Permission="#I#") />	
			</cfloop>
			<cfset application.slatsettings.loadSettings() />
			<cfset variables.fw.redirect(action="setting.permissions") />
		</cfif>
		
	</cffunction>	
</cfcomponent>