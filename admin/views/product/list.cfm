<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.$" type="any" />
<cfparam name="rc.productSmartList" type="any" />

<cfoutput>
<ul id="navTask">
    <cf_ActionCaller action="admin:product.create" type="list">
</ul>

<div class="svoadminproductlist">
<cfif rc.productSmartList.getTotalRecords()>
	<form method="post">
		<input name="Keyword" value="#rc.Keyword#" /> <button type="submit">Search</button>
	</form>

	<table id="ProductList" class="stripe">
		<tr>
			<!---<th>Search Score</th>--->
			<th>#rc.$.Slatwall.rbKey("entity.brand")#</th>
			<th class="varWidth">#rc.$.Slatwall.rbKey("entity.product.productName")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.productYear_title")#</th>
			<!---<th>Product Code</th>--->
			<th>#rc.$.Slatwall.rbKey("entity.product.qoh")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qoo")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qc")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qia")#</th>
			<th>#rc.$.Slatwall.rbKey("entity.product.qea")#</th>
			<th>&nbsp</th>
		</tr>
	<!--- since we are looping through an array, not a recordset, I'll use a counter do the alternate row table formatting --->		
		<cfloop array="#rc.ProductSmartList.getPageRecords()#" index="Local.Product">
			<tr>
				<!---<td>#Local.Product.getSearchScore()#</td>--->
				<td>#Local.Product.getBrandName()#</td>
				<td class="varWidth">#Local.Product.getProductName()#</td>
				<td>#Local.Product.getProductYear()#</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td class="administration">
					<cfset local.productID = Local.Product.getProductID() />
		          <ul class="four">
                      <cf_ActionCaller action="admin:product.edit" querystring="productID=#local.productID#" class="edit" type="list">            
					  <cf_ActionCaller action="admin:product.detail" querystring="productID=#local.productID#" class="viewDetails" type="list">
					  <li class="preview"><a href="#local.product.getProductURL()#">Preview Product</a></li>
					  <cf_ActionCaller action="admin:product.delete" querystring="productID=#local.productID#" class="delete" type="list" disabled="false" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
		</cfloop>
	</table>
<cfelse>
	<em>#rc.$.Slatwall.rbKey("admin.product.noProductsDefined")#</em>
</cfif>
</div>
</cfoutput>

