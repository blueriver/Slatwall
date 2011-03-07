<cfparam name="rc.options" type="any" />
<cfparam name="rc.optionGroups" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:option.createoptiongroup" type="list">
	<cfif rc.listby EQ "optiongroups">
		<cf_ActionCaller action="admin:option.list" text="#rc.$.Slatwall.rbKey('admin.option.listbyoptions')#" querystring="listby=options" type="list">
	<cfelseif rc.listby EQ "options">
		<cf_ActionCaller action="admin:option.list" text="#rc.$.Slatwall.rbKey('admin.option.listbyoptiongroups')#" querystring="listby=optiongroups" type="list">
	</cfif>
</ul>

<cfif arrayLen(rc.optionGroups) GT 0>

	<cfif rc.listby eq "options">
	<form name="filterOptions" method="get">
		 #rc.$.Slatwall.rbKey("admin.option.optiongroupfilter")#:
		<input type="hidden" name="action" value="admin:option.list" />
		<input type="hidden" name="listby" value="options" />
		<select name="F_optiongroup_optiongroupname">
			<option value="">#rc.$.Slatwall.rbKey('admin.option.showall')#</option>
		<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
			<option value="#local.thisOptionGroup.getOptionGroupName()#"<cfif structKeyExists(rc,"F_optiongroup_optiongroupname") and rc.F_optiongroup_optiongroupname eq local.thisOptionGroup.getOptionGroupName()> selected="selected"</cfif>>#local.thisOptionGroup.getOptionGroupName()#</option>
		</cfloop>
		</select>
		<cf_ActionCaller action="admin:option.list" type="submit" text="#rc.$.Slatwall.rbKey('admin.option.show')#">
	</form>
	#view("option/inc/optiontable")#
	<cfelse>
	#view("option/inc/optiongrouptable")#
	</cfif>

<cfelse>
	<p>#rc.$.Slatwall.rbKey("admin.option.nooptiongroupsdefined")#</p>
</cfif>

</cfoutput>