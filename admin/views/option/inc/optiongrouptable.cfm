<cfoutput>
<table class="stripe" id="Options">
	<tr>
		<th class="varWidth">#rc.$w.rbKey("option.optiongroupname")#</th>
		<th>#rc.$w.rbKey("option.options")#</th>
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
		      <li class="edit">
		          <a href="#buildURL(action='admin:option.optiongroupform', queryString='optiongroupid=#local.thisOptionGroup.getOptionGroupID()#')#" title="Edit">Edit</a>
			  </li>
              <li class="viewDetails">
                 <a href="#buildURL(action='admin:option.optiongroupdetail', queryString='optiongroupid=#local.thisOptionGroup.getOptionGroupID()#')#" title="View">Add Subtype</a>
              </li>
			  <li class="delete">
			     <a href="#buildURL(action='admin:option.deleteoptiongroup', queryString='optiongroupid=#local.thisOptionGroup.getOptionGroupID()#')#" title="Delete">Delete</a>
			  </li>
		  </ul>		
		
		</td>
	</tr>
</cfloop>
</table>
</cfoutput>