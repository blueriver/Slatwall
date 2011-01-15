<cfoutput>
	<div class="svofrontendcontentproductlist">
		<cfloop array="#rc.ProductSmartList.getEntityArray()#" index="Local.Product">
			<div class="product">
				<a href="#Local.Product.getProductURL()#">
				<img src="#Local.Product.getDefaultImagePath()#" title="#Local.Product.getTitle()#" />
				<h3 class="productName">#Local.Product.getTitle()#</h3>
				<span class="livePrice">#Local.Product.getLivePrice()#</span>
				</a>
			</div>
		</cfloop>
	</div>
</cfoutput>