<cfparam name="rc.BrandSmartList" type="any" />

<cfoutput>
<div class="svoadminbrandlist">
<cfif rc.BrandSmartList.getTotalEntities() gt 0>
	<table id="ProductBrands" class="listtable stripe">
		<tr>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.brand.brandName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.brand.brandWebsite")#</th>
			<th>&nbsp;</th>
		</tr>
		<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->
		<cfset local.rowcounter = 1 />
		<cfloop array="#rc.BrandSmartList.getPageRecords()#" index="Local.Brand">
			<tr<cfif local.rowcounter mod 2 eq 1> class="alt"</cfif>>
				<td class="varWidth"><a href="#buildURL(action='admin:brand.detail', queryString='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></td>
				<td><a href="#Local.Brand.getBrandWebsite()#" target="_blank">#local.Brand.getBrandWebsite()#</a></td>
				<td class="administration">
		          <ul class="two">
                      <cf_ActionCaller action="admin:brand.edit" querystring="brandID=#local.brand.getBrandID()#" class="edit" type="list">            
					 <!--- <cf_ActionCaller action="admin:brand.detail" querystring="brandID=#local.brand.getBrandID()#" class="viewDetails" type="list">--->
					  <cf_ActionCaller action="admin:brand.delete" querystring="brandID=#local.brand.getBrandID()#" class="delete" type="list" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
			<cfset local.rowcounter++ />
		</cfloop>
	</table>
<cfelse>
#rc.$.Slatwall.rbKey("admin.brand.nobrandsdefined")#
</cfif>
</div>
Records: #rc.BrandSmartList.getTotalEntities()#
</cfoutput>