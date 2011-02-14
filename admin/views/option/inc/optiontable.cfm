<cfoutput>
<form name="filterOptions" method="get">
	 #rc.$w.rbKey("option.showoptiongroup")#:
	<input type="hidden" name="action" value="admin:option.list" />
	<input type="hidden" name="listby" value="options" />
	<select name="F_optiongroup_optiongroupname">
		<option value="">#rc.$w.rbKey('option.showall')#</option>
	<cfloop array="#rc.optionGroups#" index="local.thisOptionGroup">
		<option value="#local.thisOptionGroup.getOptionGroupName()#">#local.thisOptionGroup.getOptionGroupName()#</option>
	</cfloop>
	</select>
	<input type="submit" value="#rc.$w.rbKey('option.show')#" />
</form>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$w.rbKey("option.optionname")#</th>
		<th>#rc.$w.rbKey("option.optiongroup")#</th>
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
		      <li class="edit">
		          <a href="#buildURL(action='admin:option.optiongroupform', queryString='optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#')#" title="Edit">Edit</a>
			  </li>
              <li class="viewDetails">
                 <a href="#buildURL(action='admin:option.optiongroupdetail', queryString='optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#')#" title="View">Add Subtype</a>
              </li>
			  <li class="delete">
			     <a href="#buildURL(action='admin:option.deleteoptiongroup', queryString='optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#')#" title="Delete">Delete</a>
			  </li>
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>