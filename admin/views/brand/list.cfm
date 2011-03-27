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
					  <cf_ActionCaller action="admin:brand.delete" querystring="brandID=#local.brand.getBrandID()#" class="delete" type="list" disabled="#local.brand.getIsAssigned()#" disabledText="#rc.$.Slatwall.rbKey('entity.brand.delete_validateisassigned')#" confirmrequired="true">
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
