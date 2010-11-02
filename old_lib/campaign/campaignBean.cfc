<cfcomponent output="false" name="campaignBean" extends="slat.lib.coreBean" hint="">

	<cfset variables.instance.CampaignID = 0 />
	<cfset variables.instance.CampaignName = "" />
	<cfset variables.instance.CampaignSource = "" />
	<cfset variables.instance.AdMedium = "" />
	<cfset variables.instance.AdContent = "" />
	<cfset variables.instance.LandingPageContentID = "" />
	<cfset variables.instance.MarketingFriendlyURL = "" />
	
	<cffunction name="getCampaignID" returntype="numeric" access="public" output="false" hint="">
    	<cfreturn variables.instance.CampaignID />
    </cffunction>
    <cffunction name="setCampaignID" access="public" output="false" hint="">
    	<cfargument name="CampaignID" type="numeric" required="true" />
    	<cfset variables.instance.CampaignID = trim(arguments.CampaignID) />
    </cffunction>    
	
	<cffunction name="getCampaignName" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CampaignName />
    </cffunction>
    <cffunction name="setCampaignName" access="public" output="false" hint="">
    	<cfargument name="CampaignName" type="string" required="true" />
    	<cfset variables.instance.CampaignName = trim(arguments.CampaignName) />
    </cffunction>
	
	<cffunction name="getCampaignSource" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.CampaignSource />
    </cffunction>
    <cffunction name="setCampaignSource" access="public" output="false" hint="">
    	<cfargument name="CampaignSource" type="string" required="true" />
    	<cfset variables.instance.CampaignSource = trim(arguments.CampaignSource) />
    </cffunction>
	
	<cffunction name="getAdMedium" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AdMedium />
    </cffunction>
    <cffunction name="setAdMedium" access="public" output="false" hint="">
    	<cfargument name="AdMedium" type="string" required="true" />
    	<cfset variables.instance.AdMedium = trim(arguments.AdMedium) />
    </cffunction>
	
	<cffunction name="getAdContent" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.AdContent />
    </cffunction>
    <cffunction name="setAdContent" access="public" output="false" hint="">
    	<cfargument name="AdContent" type="string" required="true" />
    	<cfset variables.instance.AdContent = trim(arguments.AdContent) />
    </cffunction>
	
	<cffunction name="getLandingPageContentID" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.LandingPageContentID />
    </cffunction>
    <cffunction name="setLandingPageContentID" access="public" output="false" hint="">
    	<cfargument name="LandingPageContentID" type="string" required="true" />
    	<cfset variables.instance.LandingPageContentID = trim(arguments.LandingPageContentID) />
    </cffunction>
	
	<cffunction name="getQueryString" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.QueryString />
    </cffunction>
    <cffunction name="setQueryString" access="public" output="false" hint="">
    	<cfargument name="QueryString" type="string" required="true" />
    	<cfset variables.instance.QueryString = trim(arguments.QueryString) />
    </cffunction>
	
	<cffunction name="getMarketingFriendlyURL" returntype="string" access="public" output="false" hint="">
    	<cfreturn variables.instance.MarketingFriendlyURL />
    </cffunction>
    <cffunction name="setMarketingFriendlyURL" access="public" output="false" hint="">
    	<cfargument name="MarketingFriendlyURL" type="string" required="true" />
    	<cfset variables.instance.MarketingFriendlyURL = trim(arguments.MarketingFriendlyURL) />
    </cffunction>
	
	<cffunction name="getLink" returntype="String" access="public" output="false" hint="">
		<cfset var contentBean = application.contentManager.read(ContentID = getLandingPageContentID(), SiteID=session.siteid) />
		<cfset var Link = "http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(session.siteid,contentBean.getfilename())#?" />
		<cfif len(getQueryString())>
			<cfset Link = "#Link##getQueryString()#&" />
		</cfif>
		<cfset Link = "#Link#utm_source=#getCampaignSource()#&utm_medium=#getAdMedium()#&utm_content=#getAdContent()#&utm_campaign=#getCampaignName()#" />
		
		<cfreturn Link />
	</cffunction>
    
    <cffunction name="Save" returntype="void" access="public">
		<cfreturn application.slat.campaignManager.save(this) />
	</cffunction>
	
</cfcomponent>
