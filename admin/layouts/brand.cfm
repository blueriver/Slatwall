<cfoutput>
<ul id="navTask">
    <cfif rc.action NEQ "admin:brand.list">
    <cf_ActionLink action="admin:brand.list" listitem="true">
	</cfif>
	<cfif rc.action NEQ "admin:brand.edit">
    <cf_ActionLink action="admin:brand.add" listitem="true">
	</cfif>
</ul>
#body#
</cfoutput>