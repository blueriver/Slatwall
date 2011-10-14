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
<cfparam name="rc.productTypes" type="query" />

<cfoutput>
<ul id="navTask">
    <cf_SlatwallActionCaller action="admin:product.createproducttype" type="list">
</ul>
<table class="mura-table-grid" id="productTypes">
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
			  <!--- if this is currently a leaf node in the product type tree, its products will be reassigned to any child types that are added, so indicate whether
			  	to show modal dialog to alert the user --->
			  <cfset local.productsReassigned = not rc.productTypes.childCount />
		      <cf_SlatwallActionCaller action="admin:product.editproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="edit" type="list">
			  <cf_SlatwallActionCaller action="admin:product.detailproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="viewDetails" type="list">
              <cf_SlatwallActionCaller action="admin:product.createproducttype" querystring="parentProductTypeID=#rc.productTypes.productTypeID#" confirmRequired="#local.productsReassigned#" class="add" type="list">
			  <cf_SlatwallActionCaller action="admin:product.deleteproducttype" querystring="producttypeID=#rc.productTypes.productTypeID#" class="delete" type="list" disabled="#local.deleteDisabled#" disabledText="#rc.$.Slatwall.rbKey('entity.producttype.delete_validateisassigned')#" confirmrequired="true">
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
