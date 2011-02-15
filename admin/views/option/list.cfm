<cfoutput>
<ul id="navTask">
    <cf_ActionLink action="admin:option.addoptiongroup" listitem="true">
	<cfif rc.listby EQ "optiongroups">
	<li><a href="#buildURL(action='admin:option.list',querystring='listby=options')#">#rc.$w.rbKey('admin.option.listbyoptions')#</a></li>
<!---	<cf_ActionLink action="admin:option.list" text="#rc.$w.rbKey('admin.option.listybyoptions')#" querystring="listby=options" listitem="true">--->
	<cfelseif rc.listby EQ "options">
	<li><a href="#buildURL(action='admin:option.list',querystring='listby=optiongroups')#">#rc.$w.rbKey('admin.option.listbyoptiongroups')#</a></li>
<!---	<cf_ActionLink action="admin:option.list" text="#rc.$w.rbKey('admin.option.listybyoptiongroups')#" querystring="listby=optiongroups" listitem="true">--->
	</cfif>
</ul>
<cfif arrayLen(rc.options.getPageRecords()) GT 0>

<cfif rc.listby eq "options">
#view("option/inc/optiontable")#
<cfelse>
#view("option/inc/optiongrouptable")#
</cfif>
<cfelse>
<p>#rc.$w.rbKey("admin.option.nooptionsdefined")#</p>
</cfif>

</cfoutput>