<cfoutput>
<form name="filterOptions" method="get">
	 #rc.$w.rbKey("admin.option.showoptiongroup")#:
	<input type="hidden" name="action" value="admin:option.list" />
	<input type="hidden" name="listby" value="options" />
	<select name="F_optiongroup_optiongroupname">
		<option value="">#rc.$w.rbKey('admin.option.showall')#</option>
	<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
		<option value="#local.thisOptionGroup.getOptionGroupName()#">#local.thisOptionGroup.getOptionGroupName()#</option>
	</cfloop>
	</select>
	<input type="submit" value="#rc.$w.rbKey('admin.option.show')#" />
</form>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$w.rbKey("entity.option.optionname")#</th>
		<th>#rc.$w.rbKey("entity.option.optiongroup")#</th>
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
              <cf_ActionCaller action="admin:option.editoptiongroup" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#" class="edit" type="list">
              <cf_ActionCaller action="admin:option.optiongroupdetail" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#" class="viewDetails" type="list">
              <cf_ActionCaller action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#" class="delete" type="list">
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>