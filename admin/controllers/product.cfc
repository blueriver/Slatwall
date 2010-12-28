component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";

	public void function before(required struct rc) {
		param name="rc.productID" default="";
		
		rc.product = getProductService().getByID(ID=rc.productID);
		if(!isDefined("rc.product")) {
			rc.product = getProductService().getNewEntity();
		}
	}
	
	public void function list(required struct rc) {
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function update(required struct rc) {
	
		rc.product = variables.fw.populate(cfc=rc.product, keys=rc.product.getUpdateKeys(), trim=true);
		
		//Set Filename for product if it isn't already defined.
		if(rc.product.getFilename EQ "") {
			rc.product.setFilename(rc.product.getProductName());
		}
		
		//Simplify filename
		rc.product.setFilename(LCASE(REReplace(Replace(rc.product.getFilename()," ","-","all"),"[^A-Z|\-]","","all")));
		
		//Save Product
		rc.product = getProductService().save(entity=rc.product);
		variables.fw.redirect(action="admin:product.detail", queryString="productID=#rc.product.getProductID()#");
		
	}
	
	public void function edit(required struct rc) {
		rc.productTemplatesQuery = getProductService().getProductTemplates();
	}
	
	public void function delete(required struct rc) {
		getProductService().delete(entity=rc.product);
		variables.fw.redirect(action="admin:product.list");
	}
		
}