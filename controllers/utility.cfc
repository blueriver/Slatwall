<cfcomponent output="false">

	<cffunction name="toolbar" output="false">
		<cfset request.generateSES = false />
		<cfset request.layout = false />
	</cffunction>

	<cffunction name="campaignlink" output="false">
		<cfif isDefined('rc.SaveCampaign')>
			<cfif rc.SaveCampaign eq 1>
				<cfset rc.CampaignName = Replace(rc.CampaignName," ","","all") />
				<cfset rc.CampaignSource = Replace(rc.CampaignSource," ","","all") />
				<cfset rc.AdMedium = Replace(rc.AdMedium," ","","all") />
				<cfset rc.AdContent = Replace(rc.AdContent," ","","all") />
				
				<cfset rc.Campaign = application.slat.CampaignManager.getBean() />
				<cfset rc.Campaign.setCampaignName(rc.CampaignName) />
				<cfset rc.Campaign.setCampaignSource(rc.CampaignSource) />
				<cfset rc.Campaign.setAdMedium(rc.AdMedium) />
				<cfset rc.Campaign.setAdContent(rc.AdContent) />
				<cfset rc.Campaign.setLandingPageContentID(rc.LandingPageContentID) />
				<cfset rc.Campaign.setQueryString(rc.QueryString) />
				<cfset rc.Campaign.save() />
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>