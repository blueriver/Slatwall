component {

	public any function getTestMerchandiseProduct() {
		var product = entityNew("SlatwallProduct");
		productData = {
			productName = "Test Product",
			price = 100,
			productCode = "TESTPRODUCTXXX",
			productType = {
				productTypeID = "444df2f7ea9c87e60051f3cd87b435a1"
			}
		};
		
		request.slatwallScope.getService("productService").saveProduct(product, productData);
		
		ormFlush();
		
		return product;
	}
	
	public void function destroyTestMerchandiseProduct( required any product ) {
		arguments.product.setDefaultSku( javaCast("null", "") );
		
		entityDelete(arguments.product);
		
		ormFlush();
	}
	
}