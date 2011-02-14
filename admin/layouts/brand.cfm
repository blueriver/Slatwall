<cfoutput>
<ul id="navTask">
    <cfif rc.action NEQ "admin:brand.list">
    <li><a href="#buildURL(action='admin:brand.list')#">#rc.$w.rbKey("brand.brandlist")#</a></li>
	</cfif>
	<cfif rc.action NEQ "admin:brand.edit">
    <li><a href="#buildURL(action='admin:brand.edit')#">#rc.$w.rbKey("brand.addbrand")#</a></li>
	</cfif>
</ul>
#body#
</cfoutput>