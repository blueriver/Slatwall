<cfparam name="rc.productTypes" type="query" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.createproducttype" type="list">
</ul>
<table class="stripe" id="productTypes">
    <tr>
        <th class="varWidth">#rc.$.Slatwall.rbKey("entity.product.producttype")#</th>
		<th>&nbsp;</th>
	</tr>
	<cfif rc.productTypes.recordCount gt 0>
<cfloop query="rc.productTypes">
    <cfset local.thisNest = rc.productTypes.treedepth eq 0 ? "neston" : "nest" & rc.productTypes.treedepth & "on" />
    <tr>
        <td class="varWidth">
            <ul class="#local.thisNest#">
                <li class="Category">#rc.productTypes.productTypeName#</li>
			</ul>     
        </td>
		<td class="administration">
		  <ul class="four">
		  	  <cfset local.deleteDisabled = (rc.productTypes.isAssigned gt 0) or (rc.productTypes.childCount gt 0) />
		      <cf_ActionCaller action="admin:product.editproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="edit" type="list">
			  <cf_ActionCaller action="admin:product.detailproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="viewDetails" type="list">
              <cf_ActionCaller action="admin:product.createproducttype" querystring="parentProductTypeID=#rc.productTypes.productTypeID#" class="add" type="list">
			  <cf_ActionCaller action="admin:product.deleteproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="delete" type="list" disabled="#local.deleteDisabled#" confirmrequired="true">
		  </ul>
		</td>
    </tr>
</cfloop>
    <cfelse>
	   <tr>
	       <td colspan="3">#rc.$.Slatwall.rbKey("admin.product.noproducttypesdefined")#</td>
	   </tr>
    </cfif>
</table>
</cfoutput>