<cfoutput>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$w.rbKey("entity.optiongroup.optiongroupname")#</th>
		<th>#rc.$w.rbKey("entity.optiongroup.options")#</th>
		<th>&nbsp;</th>
	</tr>
	<cfset local.rowCount = 0 />
<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
<cfset local.rowCount++ />
	<tr<cfif local.rowCount mod 2 eq 1> class="alt"</cfif>>
		<td class="varWidth">#local.thisOptionGroup.getOptionGroupName()#</td>
		<td>#arrayLen(local.thisOptionGroup.getOptions())#</td>
		<td class="administration">
		  <ul class="three">
		      <cf_ActionLink action="admin:option.editoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" liclass="edit" listitem="true">
              <cf_ActionLink action="admin:option.optiongroupdetail" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" liclass="viewDetails" listitem="true">
			  <cf_ActionLink action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" liclass="delete" listitem="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>