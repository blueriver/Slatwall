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
<cfoutput>
	<cfif isDefined("rc.toolbarKeyword") and len(rc.toolbarKeyword) gte 2>
		<div class="svocommontoolbarsearch">
			<ul class="SearchMenu">
				<li class="MenuTop">&nbsp;</li>
				
				<cfif arrayLen(rc.productSmartList.getEntityArray())>
					<li class="SearchHeader top"><a href="#buildURL(action='product.list',querystring='Keyword=#rc.toolbarKeyword#')#">Products (#rc.productSmartList.getTotalEntities()#)</a></li>
					<cfloop array="#rc.productSmartList.getEntityArray()#" index="local.Product">
						<li class="SearchResult"><a href="#buildURL(action='product.detail',querystring='ProductID=#local.Product.getProductID()#')#">#local.Product.getProductName()#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				
				<cfif arrayLen(rc.brandSmartList.getEntityArray())>
					<li class="SearchHeader top"><a href="#buildURL(action='brand.list',querystring='Keyword=#rc.toolbarKeyword#')#">Brands (#rc.brandSmartList.getTotalEntities()#)</a></li>
					<cfloop array="#rc.brandSmartList.getEntityArray()#" index="local.Brand">
						<li class="SearchResult"><a href="#buildURL(action='brand.detail',querystring='BrandID=#local.Brand.getBrandID()#')#">#local.Brand.getBrandName()#</a></li>
					</cfloop>
					<li class="Spacer">&nbsp;</li>
				</cfif>
				<cfif not arrayLen(rc.productSmartList.getEntityArray()) and not arrayLen(rc.brandSmartList.getEntityArray())>
					<li class="MenuBottom">Nothing Found Matching Your Search</li>
				<cfelse>
					<li class="MenuBottom">&nbsp;</li>
				</cfif>
			</ul>
		</div>
	<cfelse>
		<div class="svoadminutilitytoolbarsearch" style="display:none;"></div>
	</cfif>
</cfoutput>
