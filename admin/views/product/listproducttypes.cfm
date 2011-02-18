<cfparam name="rc.productTypes" type="query" />
<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.addproducttype" type="list">
</ul>
<table class="stripe" id="productTypes" width="400">
    <tr>
        <th class="varWidth">#rc.$.Slatwall.rbKey("entity.product.producttype")#</th>
		<th>&nbsp;</th>
	</tr>
	<cfif rc.productTypes.recordCount gt 0>
<cfloop query="rc.productTypes">
    <cfset local.thisNest = rc.productTypes.treedepth eq 0 ? "neston" : "nest" & rc.productTypes.treedepth & "on" />
    <tr<cfif rc.productTypes.currentRow mod 2 eq 1> class="alt"</cfif>>
        <td class="varWidth">
            <ul class="#local.thisNest#">
                <li class="Category">#rc.productTypes.productType#</li>
			</ul>     
        </td>
		<td class="administration">
		  <ul class="three">
		      <li class="edit">
		          <cf_ActionCaller action="admin:product.editproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" type="list">
			  </li>
              <li class="add">
                 <cf_ActionCaller action="admin:product.addproducttype" querystring="parentProductTypeID=#rc.productTypes.productTypeID#" type="list">
              </li>
			  <li class="delete">
			     <cf_ActionCaller action="admin:product.deleteproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" type="list">
			  </li>
		  </ul>
		</td>
    </tr>
</cfloop>
    <cfelse>
	   <tr>
	       <td colspan="3">#rc.$.Slatwall.rbKey("product.producttype.noproducttypes")#</td>
	   </tr>
    </cfif>
</table>
</cfoutput>