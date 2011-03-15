<cfparam name="rc.productContentSmartList" type="any" />
<cfoutput>
	<div class="svofrontendlistcontentproducts">
		<cfloop array="#rc.productContentSmartList.getPageRecords()#" index="local.product">
			<a href="#local.product.getProductURL()#">
			<dl>
				<dt class="image">#local.product.getImage("s")#</dt>
				<dt class="title">#local.product.getTitle()#</dt>
				<dd class="price">#DollarFormat(local.product.getLivePrice())#</dd>
			</dl>
			</a>
		</cfloop>
	</div>
</cfoutput>