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
<cfparam name="rc.productSmartList" type="any" />
<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>
<div class="svoadminmaindefault">
	<div class="products dashboardSection">
		<h3>Recently Updated Products</h3>
		<table id="orderList" class="stripe">
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.brand")#</th>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.product.productName")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.modifiedDateTime")#</th>
			</tr>	
			<cfloop array="#rc.productSmartList.getPageRecords()#" index="local.Product">
				<tr>
					<td><a href="#buildURL(action='admin:brand.detail', querystring='brandID=#local.Product.getBrand().getBrandID()#')#">#local.Product.getBrand().getBrandName()#</a></td>
					<td class="varWidth"><a href="#buildURL(action='admin:product.detail', querystring='productID=#local.Product.getProductID()#')#">#local.Product.getProductName()#</a></td>
					<td>#DateFormat(local.product.getProductType().getModifiedDateTime(), "MM/DD/YYYY")# - #TimeFormat(local.product.getProductType().getModifiedDateTime(), "HH:MM:SS")#</td>
				</tr>
			</cfloop>
		</table>
		<cf_actionCaller action="admin:product.list" />
	</div>
	<div class="orders dashboardSection">
		<h3>New Orders</h3>
		<table id="orderList" class="stripe">
			<tr>
				<th>#rc.$.Slatwall.rbKey("entity.order.orderNumber")#</th>
				<th class="varWidth">#rc.$.Slatwall.rbKey("entity.account.fullname")#</th>
				<th>#rc.$.Slatwall.rbKey("entity.createdDateTime")#</th>
			</tr>	
			<cfloop array="#rc.orderSmartList.getPageRecords()#" index="local.order">
				<tr>
					<td>#local.order.getOrderNumber()#</td>
					<cfif !isNull(local.order.getAccount())>
						<td class="varWidth">#local.order.getAccount().getFullName()#</td>
					<cfelse>
						<td class="varWidth"></td>
					</cfif>
					<td>#DateFormat(local.product.getProductType().getCreatedDateTime(), "MM/DD/YYYY")# - #TimeFormat(local.product.getProductType().getCreatedDateTime(), "HH:MM:SS")#</td>
				</tr>
			</cfloop>
		</table>
		<cf_actionCaller action="admin:order.list" />
	</div>
	<div class="started dashboardSection">
		<h3>Getting Started</h3>
		<p>Welcome to the Slatwall administation panel.  From here you can manage every aspect of your Online Store, and much more.</p>
		<p>The first thing you'll want to do is farmiliarize yourself with the toolbar below.  It will provide access to every aspect of your administation panel.  In addition by clicking the "Website" link you can be taken directly to the front-end of your website where the toolbar will remain</p>
		<p>Just as a quick tip, you can quickly access the toolbars Main Menu quickly by presing "ctrl + M" go ahead and try it right now.  Once the menu has opend you can close it by hitting the "esc" key</p>
	</div>
</div>
</cfoutput>