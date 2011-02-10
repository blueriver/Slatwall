<cfparam name="rc.productTypes" type="query" />
<cfoutput>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:product.producttypeform')#">#rc.rbFactory.getKeyValue(session.rb,"product.producttype.addnewproducttype")#</a></li>
</ul>
<table class="stripe" id="productTypes" width="400">
    <tr>
        <th class="varWidth">#rc.rbFactory.getKeyValue(session.rb,"product.producttype")#</th>
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
		          <a href="#buildURL(action='admin:product.productTypeForm', queryString='productTypeID=#rc.productTypes.productTypeID#')#" title="Edit">Edit</a>
			  </li>
              <li class="add">
                 <a href="#buildURL(action='admin:product.productTypeForm', queryString='parentTypeID=#rc.productTypes.productTypeID#')#" title="Add Subtype">Add Subtype</a>
              </li>
			  <li class="delete">
			     <a href="#buildURL(action='admin:product.deleteProductType', queryString='productTypeID=#rc.productTypes.productTypeID#')#" title="Delete">Delete</a>
			  </li>
		  </ul>
		</td>
    </tr>
</cfloop>
    <cfelse>
	   <tr>
	       <td colspan="3">#rc.rbFactory.getKeyValue(session.rb,"product.producttype.noproducttypes")#</td>
	   </tr>
    </cfif>
</table>
</cfoutput>