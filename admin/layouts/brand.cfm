<cfoutput>
<ul id="navTask">
    <cfif request.action EQ "admin:brand.detail">
    <cf_ActionCaller action="admin:brand.edit" querystring="brandID=#rc.brand.getbrandID()#" type="list">
    </cfif>
	<cfif request.action EQ "admin:brand.list">
    <cf_ActionCaller action="admin:brand.create" type="list">
	</cfif>
    <cfif request.action NEQ "admin:brand.list">
    <cf_ActionCaller action="admin:brand.list" type="list">
    </cfif>
</ul>
#body#
</cfoutput>