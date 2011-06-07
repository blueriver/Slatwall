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
	<div class="svofrontendcheckoutitems">
		<h3 id="checkoutItemsTitle" class="titleBlick">Order Items</h3>
		<div id="checkoutItemsContent" class="contentBlock orderItems">
			<cfloop array="#$.slatwall.cart().getOrderItems()#" index="local.orderItem">
				<dl class="orderItem">
					<dt class="image">#local.orderItem.getSku().getImage(size="small")#</dt>
					<dt class="title"><a href="#local.orderItem.getSku().getProduct().getProductURL()#" title="#local.orderItem.getSku().getProduct().getTitle()#">#local.orderItem.getSku().getProduct().getTitle()#</a></dt>
					<dd class="options">#local.orderItem.getSku().displayOptions()#</dd>
					<dd class="price">#DollarFormat(local.orderItem.getPrice())#</dd>
					<dd class="quantity">#NumberFormat(local.orderItem.getQuantity(),"0")#</dd>
					<dd class="extended">#DollarFormat(local.orderItem.getExtendedPrice())#</dd>
				</dl>
			</cfloop>
			<dl class="totals">
				<dt class="subtotal">Subtotal</dt>
				<dd class="subtotal">#DollarFormat($.slatwall.cart().getSubtotal())#</dd>
				<dt class="delivery">Delivery</dt>
				<dd class="delivery">#DollarFormat($.slatwall.cart().getFulfillmentTotal())#</dd>
				<dt class="tax">Tax</dt>
				<dd class="tax">#DollarFormat($.slatwall.cart().getTaxTotal())#</dd>
				<dt class="total">Total</dt>
				<dd class="total">#DollarFormat($.slatwall.cart().getTotal())#</dd>
			</dl>
		</div>
	</div>
</cfoutput>