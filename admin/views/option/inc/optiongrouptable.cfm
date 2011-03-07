<cfparam name="rc.optiongroups" type="any" />

<cfoutput>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.optiongroup.optiongroupname")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.optiongroup.options")#</th>
		<th>&nbsp;</th>
	</tr>
<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
	<tr>
		<td class="varWidth">#local.thisOptionGroup.getOptionGroupName()#</td>
		<td>#local.thisOptionGroup.getOptionsCount()#</td>
		<td class="administration">
		  <ul class="three">
		  	  <cfif local.thisOptionGroup.getOptionsCount() gt 0><cfset local.deleteDisabled=true><cfelse><cfset local.deleteDisabled=false></cfif>
		      <cf_ActionCaller action="admin:option.create" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:option.detailoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="viewDetails" type="list">
			  <cf_ActionCaller action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="delete" type="list" disabled="#local.deleteDisabled#" confirmrequired="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>