<cfparam name="rc.optiongroups" type="any" />

<cfoutput>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.optiongroup.optiongroupname")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.optiongroup.options")#</th>
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
		      <cf_ActionCaller action="admin:option.create" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:option.detailoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="viewDetails" type="list">
			  <cf_ActionCaller action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="delete" type="list" confirmrequired="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>