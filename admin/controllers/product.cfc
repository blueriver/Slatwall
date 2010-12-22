component extends="BaseController" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="any";

	public void function before(required struct rc) {
		param name="rc.productID" default="";
		
		rc.product = variables.productService.getByID(ID=rc.productID);
		if(!isDefined("rc.product")) {
			rc.product = variables.productService.getNewEntity();
		}
	}
	
	public void function list(required struct rc) {
		rc.productSmartList = variables.productService.getSmartList(arguments.rc);
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
		rc.product = varibales.productService.save(entity=rc.product);
		variables.fw.redirect(action="product.detail", queryString="productID=#rc.product.getProductID()#");
		
	}
	
	public void function edit(required struct rc) {
		rc.productTemplatesQuery = variables.productService.getProductTemplates();
	}
		
}