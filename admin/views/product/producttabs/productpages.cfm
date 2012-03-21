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

<!---<cfoutput>
	<cfif rc.edit>
		<input type="hidden" name="productContentIDPaths" value="" />
		<cfif rc.productPages.recordCount() gt 0>
			<table id="productPages" class="listing-grid stripe">
				<tr>
					<th></th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
				</tr>
				<cfloop condition="rc.productPages.hasNext()">
					<cfset local.thisProductPage = rc.productPages.next() />
					<tr>
						<td>
							<input type="checkbox"<cfif local.thisProductPage.getValue("excludeFromAssignment")> disabled="true"</cfif> id="#local.thisProductPage.getContentID()#" name="productContentIDPaths" value="#listChangeDelims(local.thisProductPage.getPath(),' ')#"<cfif listFind(rc.product.getContentIDs(),local.thisProductPage.getContentID())> checked="checked"</cfif> /> 
						</td>
						<cfset local.thisNest = local.thisProductPage.getTreeDepth() eq 0 ? "neston" : "nest" & local.thisProductPage.getTreeDepth() & "on" />
						<td class="varWidth">
							<ul class="#local.thisNest#">
				                <li class="Category"><label for="#local.thisProductPage.getContentID()#">#local.thisProductPage.getTitle()#</label></li>
							</ul> 
						</td>
					</tr>	
				</cfloop>
			</table>
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("admin.product.noproductpagesdefined")#</em></p>
		</cfif>
	<cfelse>
		<cfif arrayLen(rc.product.getProductContent())>
			<table id="ProductPages" class="listing-grid stripe">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.product.productPages.pagePath")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.product.productPages.preview")#</th>
				</tr>
				<cfloop condition="rc.productPages.hasNext()">
					<cfset local.thisProductPage = rc.productPages.next() />
					<cfif listFind(rc.product.getContentIDs(),local.thisProductPage.getContentID())>
						<tr>
							<td class="varWidth">#listChangeDelims(local.thisProductPage.getTitle()," &raquo; ")#</td>
							<td>#listChangeDelims(local.thisProductPage.getMenuTitlePath()," &raquo; ")#</td>
							<td class="administration">
								<ul class="one">
									<li class="preview"><a href="#local.thisProductPage.getURL()#" target="_blank">Preview</a></li>
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</table>
		<cfelse>
			<em>#rc.$.Slatwall.rbKey("admin.product.productPages.noProductPagesAssigned")#</em>
		</cfif>
	</cfif>	
</cfoutput>--->