<cfoutput>
<ul id="navTask">
    <cfif rc.action NEQ "admin:brand.list">
    <cf_ActionCaller action="admin:brand.list" type="list">
	</cfif>
	<cfif rc.action NEQ "admin:brand.edit">
    <cf_ActionCaller action="admin:brand.add" type="list">
	</cfif>
</ul>
#body#
</cfoutput>