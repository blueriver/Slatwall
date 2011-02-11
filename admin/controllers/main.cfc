component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	
	public void function before(required struct rc) {
		rc.sectionTitle="Slatwall";
	}
	
	public void function dashboard(required struct rc) {
		rc.itemTitle = "Dashboard";
	}
}