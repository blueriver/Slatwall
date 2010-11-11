<cfoutput>
<div class="svocontentproducts">
	<cfloop array="#RC.ContentProductSmartList.getEntityArray()#" index="Local.Product">
		<h3 class="productname">#Local.Product.getProductName()#</h3>
	
	</cfloop>
</div>
</cfoutput>