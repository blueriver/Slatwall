<cfparam name="rc.product" type="any" />

<cfoutput>
	<div class="svofrontendproductdetail">
		<div class="description">#rc.product.getProductDescription()#</div>
	</div>
</cfoutput>