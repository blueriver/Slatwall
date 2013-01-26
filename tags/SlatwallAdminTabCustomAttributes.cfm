<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.object" type="string" default="" />
	
	<cfset attributes.text = "" />
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>