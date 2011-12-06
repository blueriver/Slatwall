<div id="updateAllSKUPricesDialog" class="ui-helper-hidden">
	<h1>Update Product Price</h1>
	<form id="updateAllSKUPricesForm" action="#buildURL('admin:product.updateSKUPrices')#" method="post">
		<input type="hidden" name="priceGroupId">	<!--- This ID will either be 0 (the base column) or one of the price group IDs --->
		Amount: <input type="text" name="amount">
	</form>
</div>