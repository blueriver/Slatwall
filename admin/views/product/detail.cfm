<cfset local.Product = rc.Product />

<cfoutput>
	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#local.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		#rc.Product.getPropertyDisplay('Active')#
		#rc.Product.getPropertyDisplay('ProductName')#
		#rc.Product.getPropertyDisplay('ProductCode')#
		#rc.Product.getPropertyDisplay('ProductYear')#
		#rc.Product.getPropertyDisplay('ShippingWeight')#
		#rc.Product.getPropertyDisplay('PublishedWeight')#
	</div>
	
	<div class="ItemDetailBar">
		#rc.Product.getPropertyDisplay('AllowPreorder')#
		#rc.Product.getPropertyDisplay('AllowDropship')#
		#rc.Product.getPropertyDisplay('NonInventoryItem')#
		#rc.Product.getPropertyDisplay('CallToOrder')#
		#rc.Product.getPropertyDisplay('AllowShipping')#
	</div>
</cfoutput>