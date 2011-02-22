<cfparam name="rc.optionGroup" type="any" />

<ul id="navTask">
    <cf_ActionCaller action="admin:option.list" type="list">
	<cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupID=#rc.optiongroup.getoptiongroupid()#" type="list">
</ul>

<cfoutput>
<a class="button" id="addOption" href="##">#rc.$.Slatwall.rbKey('admin.option.addoption')#</a>
<cfif arrayLen(rc.optionGroup.getOptions()) gt 0>

<cfelse>
	<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsingroup")#</em></p>
</cfif>

</cfoutput>