<cfset local.Order = application.slatwall.orderManager.read(OrderID=rc.OrderID) />
<cfset local.OrderItemsIterator = local.Order.getOrderItemIterator() />
<cfoutput>
<div class="svoorderdetail">
	<div class="TCLeftTThird">
	<div class="ItemDetailMain">
		<dl>
			<dt>Order Number</dt>
			<dd>#local.Order.getOrderID()#</dd>
		</dl>
		<dl>
			<dt>Warehouse</dt>
			<dd>#local.Order.getWarehouseID()#</dd>
		</dl>
		<dl>
			<dt>Date Placed</dt>
			<dd>#local.Order.getDatePlaced()#</dd>
		</dl>
		<dl>
			<dt>Customer</dt>
			<dd><a href="#buildURL(action='customer.detail', querystring='CustomerID=#local.Order.getCustomerID()#')#">#local.Order.getCustomerName()#</a></dd>
		</dl>
		<dl>
			<dt>Order Type</dt>
			<dd>#local.Order.getOrderType()#</dd>
		</dl>
		<dl>
			<dt>Order Status</dt>
			<dd>#local.Order.getOrderStatus()#</dd>
		</dl>
		<dl>
			<dt>Shipping Method</dt>
			<dd>#local.Order.getOrderStatus()#</dd>
		</dl>
	</div>
	<div class="ItemDetailSecond">
		#Replace(local.Order.getNotes(), "#Chr(10)#", "<br />", "all")#
	</div>
	<br class="clear" />
	<div class="ItemDetailBar">
		<dl>
			<dt>Total Savings</dt>
			<dd>#local.Order.getTotalSavings()#</dd>
		</dl>
		<dl>
			<dt>Total Shipping</dt>
			<dd>#local.Order.getTotalShipping()#</dd>
		</dl>
		<dl>
			<dt>Total Tax</dt>
			<dd>#local.Order.getTotalTax()#</dd>
		</dl>
		<dl class="wide">
			<dt>Total Charged</dt>
			<dd>#local.Order.getTotalCharged()#</dd>
		</dl>
		<dl class="wide">
			<dt>Total Authorized</dt>
			<dd>#local.Order.getTotalAuthorized()#</dd>
		</dl>
		<dl class="wide">
			<dt>Order Total</dt>
			<dd>#local.Order.getOrderTotal()#</dd>
		</dl>
	</div>
	<h3 class="tableheader">Order Items</h3>
	<table class="listtable">
		<tr>
			<th>Sku Code</th>
			<th>Brand</th>
			<th>Year</th>
			<th>Description</th>
			<th>Attributes</th>
			<th>QO</th>
			<th>QS</th>
			<th>Ship Est.</th>
			<th>QIA</th>
			<th>QOO</th>
			<th>QC</th>
			<th>QOH</th>
			<th>Next Est.</th>
		</tr>
		<cfloop condition="#local.OrderItemsIterator.hasNext()#">
			<cfset local.OrderItem = local.OrderItemsIterator.Next() />
			<tr>
				<td>#local.OrderItem.getSkuCode()#</td>
				<td>#local.OrderItem.getProduct().getBrandName()#</td>
				<td>#local.OrderItem.getProduct().getProductYear()#</td>
				<td><a href="#BuildURL(action='product.detail', querystring='ProductID=#local.OrderItem.getProduct().getProductID()#')#">#local.OrderItem.getProduct().getProductName()#</a></td>
				<td>#local.OrderItem.getAttributesString()#</td>
				<td>#local.OrderItem.getOrderQuantity()#</td>
				<td>#local.OrderItem.getOrderQuantityShipped()#</td>
				<td>#local.OrderItem.getExpectedShipDate()#</td>
				<td>#local.OrderItem.getQIA()#</td>
				<td>#local.OrderItem.getQOO()#</td>
				<td>#local.OrderItem.getQC()#</td>
				<td>#local.OrderItem.getQOH()#</td>
				<td>#local.OrderItem.getNextArrivalDate()#</td>
			</tr>
		</cfloop>
	</table>
	</div>
</div>
</cfoutput>
<!---
				<cfif ReceiptDetail.ordercat eq "AMAZON ORDERS" or ReceiptDetail.machine_id eq "9906">
					Amazon
				<cfelseif ReceiptDetail.ordercat eq "RRS ORDERS">
					Road Runner Sports
				<cfelseif ReceiptDetail.machine_id eq "9907">
					Web
				<cfelseif ReceiptDetail.machine_id eq "9916" or ReceiptDetail.machine_id eq "9905">
					Mail Order
				<cfelseif ReceiptDetail.receipt_type eq "1">
					Service
				<cfelse>
					In Store
				</cfif>
				
				<cfif ReceiptDetail.current_state_id eq 1>
					NEW
				<cfelseif ReceiptDetail.current_state_id eq 3>
					RTP
				<cfelseif ReceiptDetail.current_state_id eq 7>
					PP
				<cfelseif ReceiptDetail.current_state_id eq 2>
					BO
				<cfelseif ReceiptDetail.current_state_id eq 6>
					HOLD
				</cfif>
--->