<cfparam name="rc.options" type="any" />
<cfparam name="rc.optiongroups" type="any" />

<cfoutput>
<cfif arrayLen(rc.options.getPageRecords()) GT 0>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$.Slatwall.rbKey("entity.option.optionname")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.optioncode")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.optiongroup")#</th>
		<th>#rc.$.Slatwall.rbKey("entity.option.sortorder")#</th>
		<th>&nbsp;</th>
	</tr>
<cfloop array="#rc.options.getPageRecords()#" index="local.thisOption">
	<tr>
		<td class="varWidth">#local.thisOption.getOptionName()#</td>
		<td>#local.thisOption.getOptionCode()#</td>
		<td>#local.thisOption.getOptionGroup().getOptionGroupName()#</td>
		<td>#local.thisOption.getSortOrder()#</td>
		<td class="administration">
		  <ul class="two">
              <cf_ActionCaller action="admin:option.edit" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#&optionID=#local.thisOption.getOptionID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:option.delete" querystring="optionid=#local.thisOption.getOptionID()#" class="delete" type="list" disabled="#local.thisOption.getIsAssigned()#" confirmrequired="true">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
<cfelse>
<p>#rc.$.Slatwall.rbKey("admin.option.nooptionsdefined")#</p>
</cfif>
</cfoutput>