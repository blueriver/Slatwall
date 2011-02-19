<cfoutput>
<ul id="navTask">
    <cfif rc.action EQ "admin:brand.detail">
    <cf_ActionCaller action="admin:brand.edit" querystring="brandID=#rc.brand.getbrandID()#" type="list">
    </cfif>
	<cfif rc.action EQ "admin:brand.list">
    <cf_ActionCaller action="admin:brand.add" type="list">
	</cfif>
    <cfif rc.action NEQ "admin:brand.list">
    <cf_ActionCaller action="admin:brand.list" type="list">
    </cfif>
</ul>
#body#
</cfoutput>