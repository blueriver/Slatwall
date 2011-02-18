<cfoutput>
<div class="svoadminbrandlist">
	<table id="ProductBrands" class="listtable stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.brand.brandName")#</th>
			<th>#rc.$.Slatwall.Slatwall.rbKey("entity.brand.brandWebsite")#</th>
			<th>&nbsp;</th>
		</tr>
		<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
		<cfset local.rowcounter = 1 />
		<cfloop array="#rc.BrandSmartList.getPageRecords()#" index="Local.Brand">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<td class="varWidth"><a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td><a href="#Local.Brand.getBrandWebsite()#" target="_blank">#local.Brand.getBrandWebsite()#</a></td>
				<td class="administration">
		          <ul class="three">
		              <li class="edit">
		                  <a href="#buildURL(action='admin:brand.edit', queryString='BrandID=#local.Brand.getBrandID()#')#" title="Edit">#rc.$.Slatwall.rbKey("admin.edit")#</a>
		              </li>
		              <li class="viewDetails">
		                 <a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#" title="View">#rc.$.Slatwall.rbKey("admin.viewdetail")#</a>
		              </li>
		              <li class="delete">
		                 <a href="#buildURL(action='admin:brand.delete', queryString='BrandID=#local.Brand.getBrandID()#')#" title="Delete">#rc.$.Slatwall.rbKey("admin.delete")#</a>
		              </li>
		          </ul>     						
				</td>
			</tr>
			<cfset local.rowcounter++ />
		</cfloop>
	</table>
</div>
</cfoutput>