<cfoutput>
	<div class="svoproductedit">
		<form name="ProductEdit" action="?action=product.update" method="post">
		<input type="hidden" name="ProductID" value="#rc.Product.getProductID()#" />
		#rc.Product.getPropertyDisplay('Active', true)#
		#rc.Product.getPropertyDisplay('ProductName', true)#
		#rc.Product.getPropertyDisplay('Filename', true)#
		#rc.Product.getPropertyDisplay('ProductCode', true)#
		#rc.Product.getPropertyDisplay('ProductYear', true)#
		#rc.Product.getPropertyDisplay('ProductDescription', true)#
		#rc.Product.getPropertyDisplay('ManufactureDiscontinued', true)#
		#rc.Product.getPropertyDisplay('ShowOnWebRetail', true)#
		#rc.Product.getPropertyDisplay('ShowOnWebWholesale', true)#
		#rc.Product.getPropertyDisplay('NonInventoryItem', true)#
		#rc.Product.getPropertyDisplay('CallToOrder', true)#
		#rc.Product.getPropertyDisplay('AllowShipping', true)#
		#rc.Product.getPropertyDisplay('AllowPreorder', true)#
		#rc.Product.getPropertyDisplay('AllowDropship', true)#
		#rc.Product.getPropertyDisplay('ShippingWeight', true)#
		#rc.Product.getPropertyDisplay('PublishedWeight', true)#
		<button type="submit">Save</button>
		</form>
	</div>
</cfoutput>