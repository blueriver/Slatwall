<cfparam name="rc.brands" type="any" />

<cfoutput>
<div class="svoadminbrandlist">
<cfif arrayLen(rc.brands) gt 0>
	<table id="ProductBrands" class="stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.brand.brandName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.brand.brandWebsite")#</th>
			<th>&nbsp;</th>
		</tr>
		<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
		<cfloop array="#rc.brands#" index="Local.Brand">
			<tr>
				<td class="varWidth"><a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td><a href="#Local.Brand.getBrandWebsite()#" target="_blank">#local.Brand.getBrandWebsite()#</a></td>
				<td class="administration">
		          <ul class="two">
                      <cf_ActionCaller action="admin:brand.edit" querystring="brandID=#local.brand.getBrandID()#" class="edit" type="list">            
					 <!--- <cf_ActionCaller action="admin:brand.detail" querystring="brandID=#local.brand.getBrandID()#" class="viewDetails" type="list">--->
					  <cf_ActionCaller action="admin:brand.delete" querystring="brandID=#local.brand.getBrandID()#" class="delete" type="list" disabled="#local.brand.getIsAssigned()#" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
<cfelse>
#rc.$.Slatwall.rbKey("admin.brand.nobrandsdefined")#
</cfif>
</div>
</cfoutput>