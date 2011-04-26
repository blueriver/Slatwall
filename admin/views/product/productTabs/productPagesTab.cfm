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
	<cfif rc.edit>
		<input type="hidden" name="contentID" value="" />
		<cfif rc.productPages.getRecordCount() gt 0>
			<table id="ProductPagesSelect" class="stripe">
				<tr>
					<th></th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
				</tr>
				<cfloop condition="rc.productPages.hasNext()">
					<tr>
						<cfset local.thisProductPage = rc.productPages.next() />
						<td>
							<input type="checkbox" id="productPage#local.thisProductPage.getContentID()#" name="contentID" value="#local.thisProductPage.getContentID()#"<cfif listFind(rc.product.getContentIDs(),local.thisProductPage.getContentID())> checked="checked"</cfif> /> 
						</td>
						<td class="varWidth">
							<label for="productPage#local.thisProductPage.getContentID()#">#local.thisProductPage.getTitle()#</label>
						</td>
					</tr>	
				</cfloop>
			</table>
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("admin.product.noproductpagesdefined")#</em></p>
		</cfif>
	<cfelse>
		<cfif arrayLen(rc.product.getProductContent())>
			<table id="ProductPages" class="stripe">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productPages.pageTitle")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.product.productPages.preview")#</th>
				</tr>
				<cfloop array="#rc.product.getProductContent()#" index="local.thisProductContent">
					<cfset local.thisContentBean = rc.$.getBean("content").loadBy(contentID=local.thisProductContent.getContentID()) />
					<tr>
						<td class="varWidth">#local.thisContentBean.getTitle()#</td>
						<td class="administration">
							<ul class="one">
								<li class="preview"><a href="#local.thisContentBean.getURL()#" target="_blank">Preview</a></li>
							</ul>
						</td>
					</tr>
				</cfloop>
			</table>
		<cfelse>
			<em>#rc.$.Slatwall.rbKey("admin.product.productPages.noProductPagesAssigned")#</em>
		</cfif>
	</cfif>	
</cfoutput>