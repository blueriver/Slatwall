<cfset local.Product = rc.Product />

<cfoutput>
	<!--- <div class="ItemDetailImage"><img src="http://www.nytro.com/prodimages/#local.Product.getDefaultImageID()#-DEFAULT-s.jpg"></div> --->
	<div class="ItemDetailMain">
		<cf_PropertyDisplay object="#rc.Product#" property="Active">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductName">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductCode">
		<cf_PropertyDisplay object="#rc.Product#" property="ProductYear">
		<cf_PropertyDisplay object="#rc.Product#" property="ShippingWeight">
		<cf_PropertyDisplay object="#rc.Product#" property="PublishedWeight">
	</div>
	
	<div class="ItemDetailBar">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowPreorder">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowDropship">
		<cf_PropertyDisplay object="#rc.Product#" property="NonInventoryItem">
		<cf_PropertyDisplay object="#rc.Product#" property="CallToOrder">
		<cf_PropertyDisplay object="#rc.Product#" property="AllowShipping">
	</div>
</cfoutput>