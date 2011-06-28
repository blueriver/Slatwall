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
<cfparam name="order" type="any" />

<cfoutput>
	<html>
		<body>
			<dl>
				<dt>Order Number</dt>
				<dd>#order.getOrderNumber()#</dd>
				<dt>Date Placed</dt>
				<dd>#DateFormat(order.getOrderOpenDateTime(), "DD/MM/YYYY")# - #TimeFormat(order.getOrderOpenDateTime(), "short")#</dd>
				<dt>Customer</dt>
				<dd>#order.getAccount().getFirstName()# #order.getAccount().getLastName()#</dd>
				<dt>Items</dt>
				<dd>
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<th>Product Name</th>
							<th>Details</th>
							<th>Price</th>
							<th>Quantity</th>
							<th>Total Price</th>
						</tr>
						<cfloop array="#order.getOrderItems()#" index="orderItem">
							<tr>
								<td>#orderItem.getSku().getProduct().getTitle()#</td>
								<td>#orderItem.getSku().displayOptions()#</td>
								<td>#DollarFormat(orderItem.getPrice())#</td>
								<td>#NumberFormat(orderItem.getQuantity(), "0")#</td>
								<td>#DollarFormat(orderItem.getExtendedPrice())#</td>
							</tr>
						</cfloop>
					</table>
				</dd>
				<dt>Subtotal</dt>
				<dd>#DollarFormat(order.getSubtotal())#</dd>
				<dt>Delivery Charges</dt>
				<dd>#DollarFormat(order.getFulfillmentTotal())#</dd>
				<dt>Tax</dt>
				<dd>#DollarFormat(order.getTaxTotal())#</dd>
				<dt>Total</dt>
				<dd>#DollarFormat(order.getTotal())#</dd>
			</dl>
		</body>
	</html>
</cfoutput>