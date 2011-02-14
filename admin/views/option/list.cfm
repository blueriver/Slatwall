<cfoutput>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:option.optiongroupform')#">#rc.$w.rbKey("option.addoptiongroup")#</a></li>
	<cfif rc.listby EQ "optiongroups">
	<li><a href="#buildURL(action='admin:option.list', querystring='listby=options')#">#rc.$w.rbKey("option.listbyoptions")#</a></li>
	<cfelseif rc.listby EQ "options">
	<li><a href="#buildURL(action='admin:option.list', querystring='listby=optiongroups')#">#rc.$w.rbKey("option.listbyoptiongroups")#</a></li>
	</cfif>
</ul>
<cfif arrayLen(rc.options.getPageRecords()) GT 0>
<!---<form name="addOptionToGroup" method="get">
	
	 #rc.$w.rbKey("option.addoptiontogroup")#:
	<input type="hidden" name="action" value="admin:option.optionform" />
	<select name="optiongroupid">
	<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
		<option name="optiongroupid" value="#local.thisOptionGroup.getOptionGroupID()#">#local.thisOptionGroup.getOptionGroupName()#</option>
	</cfloop>
	</select>
	<input type="submit" value="Add" />
</form>--->
<cfif rc.listby eq "options">
#view("option/inc/optiontable")#
<cfelse>
#view("option/inc/optiongrouptable")#
</cfif>
<cfelse>
<p>#rc.$w.rbKey("option.nooptionsdefined")#</p>
</cfif>

</cfoutput>