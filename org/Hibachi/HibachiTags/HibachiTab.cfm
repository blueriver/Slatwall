<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.view" type="string" />
	<cfparam name="attributes.tabid" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="" />
	<cfparam name="attributes.params" type="struct" default="#structNew()#" />
	<cfparam name="attributes.count" type="string" default="0" />
	
	<cfif not len(attributes.tabid)>
		<cfset attributes.tabid = "tab" & listLast(attributes.view, '/') />
	</cfif>
	
	<cfif not len(attributes.text)>
		<cfset attributes.text = attributes.hibachiScope.rbKey( replace( replace(attributes.view, '/', '.', 'all') ,':','.','all' ) ) />
	</cfif>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>