<cfcomponent output="false" name="campaignGateway" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getAllCampaignsQuery" access="package" returntype="query" output="false">
		<cfset var AllCampaignsQuery = queryNew('empty') />
		
		<cfquery name="AllCampaignsQuery" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			SELECT
				CampaignID,
				CampaignName,
				CampaignSource,
				AdMedium,
				AdContent,
				LandingPageContentID
			FROM
				tslatcampaign
		</cfquery>
		
		<cfreturn AllCampaignsQuery />
	</cffunction>

	<cffunction name="getExistingCampaignNames" access="package" returntype="query" output="false">
		<cfset var AllCampaignsQuery = getAllCampaignsQuery() />
		<cfset var ExistingCampaignNames = queryNew('empty') />
		
		<cfquery dbtype="query" name="ExistingCampaignNames">
			SELECT
				CampaignName
			FROM
				AllCampaignsQuery
			GROUP BY
				CampaignName
		</cfquery>
		
		<cfreturn ExistingCampaignNames />
	</cffunction>
	
	<cffunction name="getExistingCampaignSources" access="package" returntype="query" output="false">
		<cfset var AllCampaignsQuery = getAllCampaignsQuery() />
		<cfset var ExistingCampaignSources = queryNew('empty') />
		
		<cfquery dbtype="query" name="ExistingCampaignSources">
			SELECT
				CampaignSource
			FROM
				AllCampaignsQuery
			GROUP BY
				CampaignSource
		</cfquery>
		
		<cfreturn ExistingCampaignSources />
	</cffunction>
	
	<cffunction name="getExistingCampaignAdContent" access="package" returntype="query" output="false">
		<cfargument name="CampaignName" required="true" />
		<cfset var AllCampaignsQuery = getAllCampaignsQuery() />
		<cfset var ExistingCampaignAdContent = queryNew('empty') />
		
		<cfquery dbtype="query" name="ExistingCampaignSources">
			SELECT
				CampaignSource
			FROM
				AllCampaignsQuery
			GROUP BY
				CampaignSource
		</cfquery>
		
		<cfreturn ExistingCampaignSources />
	</cffunction>
	
	<cffunction name="getExistingCampaignAdKeyword" access="package" returntype="query" output="false">
	<cfargument name="CampaignName" required="true" />
		<cfset var AllCampaignsQuery = getAllCampaignsQuery() />
		<cfset var ExistingCampaignAdKeyword = queryNew('empty') />
		
		<cfquery dbtype="query" name="ExistingCampaignSources">
			SELECT
				CampaignSource
			FROM
				AllCampaignsQuery
			GROUP BY
				CampaignSource
		</cfquery>
		
		<cfreturn ExistingCampaignSources />
	</cffunction>
	
</cfcomponent>
