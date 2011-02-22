<cfparam name="rc.options" type="any" />
<cfparam name="rc.optiongroups" type="any" />

<cfoutput>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.option.optionname")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.optiongroup")#</th>
		<th>&nbsp;</th>
	</tr>
	<cfset local.rowCount = 0 />
<cfloop array="#rc.options.getPageRecords()#" index="local.thisOption">
<cfset local.rowCount++ />
	<tr<cfif local.rowCount mod 2 eq 1> class="alt"</cfif>>
		<td class="varWidth">#local.thisOption.getOptionName()#</td>
		<td>#local.thisOption.getOptionGroup().getOptionGroupName()#</td>
		<td class="administration">
		  <ul class="three">
              <cf_ActionCaller action="admin:option.edit" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#&optionID=#local.thisOption.getOptionID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:option.optiongroupdetail" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#" class="viewDetails" type="list">
              <cf_ActionCaller action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#" class="delete" type="list">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>