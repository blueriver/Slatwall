<cfcomponent output="false" name="campaignManager" hint="">

	<cffunction name="init" returntype="any" output="false" access="public">
		<cfargument name="campaignDAO" type="any" required="yes"/>
		<cfargument name="campaignGateway" type="any" required="yes"/>
		
		<cfset variables.DAO=arguments.campaignDAO />
		<cfset variables.Gateway=arguments.campaignGateway />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getExistingCampaignNames" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getExistingCampaignNames() />
	</cffunction>
	
	<cffunction name="getExistingCampaignSources" access="public" returntype="query" output="false">
		<cfreturn variables.Gateway.getExistingCampaignSources() />
	</cffunction>
	
	<cffunction name="getBean" access="public" returntype="any" output="false">
		<cfreturn createObject("component","campaignBean") />
	</cffunction>
	
	<cffunction name="save" access="public" returntype="any" output="false">
		<cfargument name="campaignBean" required="true" />
		<cfreturn variables.DAO.save(campaignBean = arguments.campaignBean) />
	</cffunction>
	
</cfcomponent>
