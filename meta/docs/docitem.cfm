<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.itemID" type="string" default="" />
	<cfparam name="attributes.itemName" type="string" default="" />
	
	<cfassociate basetag="cf_docsection" datacollection="items">
</cfif>