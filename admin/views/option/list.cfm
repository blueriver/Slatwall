<cfoutput>

<cfif arrayLen(rc.options) GT 0>
#view("option/inc/optiontable")#
<cfelse>
<p>#rc.rbFactory.getKeyValue(session.rb,"option.nooptionsdefined")#</p>
	<cfif arrayLen(rc.optionGroups) gt 0>
	<form name="addOptionToGroup" method="get">
		
		 #rc.rbFactory.getKeyValue(session.rb,"option.addoptiontogroup")#:
		<input type="hidden" name="action" value="admin:option.optionform" />
		<select name="optiongroupid">
		<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
			<option name="optiongroupid" value="#local.thisOptionGroup.getOptionGroupID()#">#local.thisOptionGroup.getOptionGroupName()#</option>
		</cfloop>
		</select>
		<input type="submit" value="Add" />
	</form>
	</cfif>
</cfif>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:option.optiongroupform')#">#rc.rbFactory.getKeyValue(session.rb,"option.addoptiongroup")#</a></li>
</ul>

</cfoutput>