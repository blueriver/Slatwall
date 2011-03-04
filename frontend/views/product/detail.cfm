<cfparam name="rc.product" type="any" />

<cfoutput>
	<div class="svofrontendproductdetail">
		<div class="image">
			Image Here
		</div>
		<cf_PropertyDisplay object="#rc.Product#" property="productCode">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear">
		<div class="description">#rc.product.getProductDescription()#</div>
		<form action="#buildURL(action='frontend:product.addtocart')#" method="post">
			<button type="submit">Add To Cart</button>
		</form>
	</div>
</cfoutput>