component persistent="false" accessors="true" output="false" extends="BaseController" {

	property name="productService" type="any";
	
	public void function productlist(required struct rc) {
		rc.ProductSmartList = getProductService().getSmartList(rc=arguments.rc);	
	}
	
}