component extends="BaseController" accessors="true" output="false" {
	
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	
	public void function toolbar(required struct rc) {
		request.generateSES = false;
		request.layout = false;
	}
	
	public void function toolbarsearch(required struct rc) {
		if(isDefined("rc.toolbarKeyword") && len(rc.toolbarKeyword) >= 2) {
			rc.keyword = rc.toolbarKeyword;
			rc.p_show = 5; 
			rc.productSmartList = getProductService().getSmartList(arguments.rc);
			rc.brandSmartList = getBrandService().getSmartList(arguments.rc);
		}
	}
	
}