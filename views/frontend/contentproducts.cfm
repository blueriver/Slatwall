<cfoutput>
<div class="svocontentproducts">
	<cfloop array="#RC.ContentProductSmartList.getEntityArray()#" index="Local.Product">
		<div class="product">
			<a href="#Local.Product.getProductURL()#">
			<h3 class="productname">#Local.Product.getProductName()#</h3>
			</a>
		</div>
	</cfloop>
</div>
</cfoutput>