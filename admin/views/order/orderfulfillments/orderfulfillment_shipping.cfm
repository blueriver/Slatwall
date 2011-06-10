<cfoutput>
	<table class="stripe">
		<tr>
			<th>#$.slatwall.rbKey("entity.sku.skucode")#</th>
			<th class="varWidth">#$.slatwall.rbKey("entity.product.brand")# - #$.slatwall.rbKey("entity.product.productname")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.price")#</th>
			<th>#$.slatwall.rbKey("entity.orderitem.quantity")#</th>
			<th>#$.slatwall.rbKey("admin.order.detail.quantityshipped")#</th>
			<th>#$.slatwall.rbKey("admin.order.detail.priceextended")#</th>
		</tr>
			
		<cfloop array="#local.thisOrderFulfillment.getOrderFulfillmentItems()#" index="local.orderItem">
			<tr>
				<td>#local.orderItem.getSku().getSkuCode()#</td>
				<td class="varWidth">#local.orderItem.getSku().getProduct().getBrand().getBrandName()# #local.orderItem.getSku().getProduct().getProductName()#</td>
				<td>#dollarFormat(local.orderItem.getPrice())#</td>
				<td>#local.orderItem.getQuantity()#</td>
				<td></td>
				<td>#dollarFormat(local.orderItem.getPrice() * local.orderItem.getQuantity())#</td>
			</tr>
		</cfloop>
	</table>	
</cfoutput>