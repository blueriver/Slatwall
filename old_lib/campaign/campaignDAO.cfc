<cfcomponent output="false" name="campaignDAO" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="save" access="package" returntype="any" output="false">
		<cfargument name="campaignBean" required="true" />
		<cfset var rs = querynew('empty') />
		
		<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
			SELECT
				CampaignName
			FROM
				tslatcampaign
			WHERE
				CampaignName = <cfqueryparam value="#arguments.campaignBean.getCampaignName()#" cfsqltype="varchar" /> and
				CampaignSource = <cfqueryparam value="#arguments.campaignBean.getCampaignSource()#" cfsqltype="varchar" /> and
				AdMedium = <cfqueryparam value="#arguments.campaignBean.getAdMedium()#" cfsqltype="varchar" /> and
				AdContent = <cfqueryparam value="#arguments.campaignBean.getAdContent()#" cfsqltype="varchar" /> and
				LandingPageContentID = <cfqueryparam value="#arguments.campaignBean.getLandingPageContentID()#" cfsqltype="varchar" /> and
				QueryString = <cfqueryparam value="#arguments.campaignBean.getLandingPageContentID()#" cfsqltype="varchar" />
		</cfquery>
		
		<cfif not rs.recordcount>
			<cfquery name="rs" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
				INSERT INTO tslatcampaign (
					CampaignName,
					CampaignSource,
					AdMedium,
					AdContent,
					LandingPageContentID,
					QueryString
				) VALUES (
					<cfqueryparam value="#arguments.campaignBean.getCampaignName()#" cfsqltype="varchar" />,
					<cfqueryparam value="#arguments.campaignBean.getCampaignSource()#" cfsqltype="varchar" />,
					<cfqueryparam value="#arguments.campaignBean.getAdMedium()#" cfsqltype="varchar" />,
					<cfqueryparam value="#arguments.campaignBean.getAdContent()#" cfsqltype="varchar" />,
					<cfqueryparam value="#arguments.campaignBean.getLandingPageContentID()#" cfsqltype="varchar" />,
					<cfqueryparam value="#arguments.campaignBean.getQueryString()#" cfsqltype="varchar" />
				)
			</cfquery>
		</cfif>
		
	</cffunction>
	
</cfcomponent>
