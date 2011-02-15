component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";

	public void function before(required struct rc) {
		param name="rc.productID" default="";
		
		rc.product = getProductService().getByID(ID=rc.productID);
		
		if(isNull(rc.product)) {
			rc.product = getProductService().getNewEntity();
		}
	}
	
	public void function list(required struct rc) {
		param name="rc.keyword" default="";
		
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function detail(required struct rc) {
		if(len(rc.product.getProductName())) {
			rc.itemTitle &= ": #rc.product.getProductName()#";
		}
		
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function create(required struct rc) {
		rc.edit = true;
		rc.productTypes = getProductService().getProductTypeTree();
		variables.fw.setView("admin:product.detail");
	}
	
	public void function edit(required struct rc) {
		if(len(rc.product.getProductName())) {
			rc.itemTitle &= ": #rc.product.getProductName()#";
		}
		
		rc.edit = true;
		
		variables.fw.setView("admin:product.detail");
	}
	
	public void function update(required struct rc) {
		param name="rc.brand_brandID" default="";
		rc.product = variables.fw.populate(cfc=rc.product, keys=rc.product.getUpdateKeys(), trim=true);
		rc.product.setBrand(getBrandService().getByID(ID=rc.Brand_BrandID));
		// TODO: validate that this product type is a leaf node of tree
		rc.product.setProductType(getProductService().getProductType(ID=rc.productType_productTypeID));
		//Set Filename for product if it isn't already defined.
		if(trim(rc.product.getFilename()) EQ "") {
			rc.product.setFilename(rc.product.getProductName());
		}
		
		//Simplify filename
		rc.product.setFilename(LCASE(Replace(rc.product.getFilename()," ","-","all")));
		
		//Save Product
		rc.product = getProductService().save(entity=rc.product);
		
		if(!rc.product.hasErrors()) {
			variables.fw.redirect(action="admin:product.detail", queryString="productID=#rc.product.getProductID()#");
		} else {
			variables.fw.setView("admin:product.edit");
		}
	}
	
	public void function delete(required struct rc) {
		getProductService().delete(entity=rc.product);
		variables.fw.redirect(action="admin:product.list");
	}
	
	public void function types(required struct rc) {
       rc.productTypes = getProductService().getProductTypeTree();
	}
	
	public void function producttypeform(required struct rc) {
	   param name="rc.productTypeID" default="";
	   if(len(rc.productTypeID)) {
           rc.action=rc.$w.rbKey('product.producttype.edit');
		   rc.productType = getProductService().getproductType(rc.productTypeID);
		   if(!rc.productType.hasParentProductType())
		      rc.parentProductTypeID=0;
		   else
		      rc.parentProductTypeID=rc.productType.getParentProductType().getProductTypeID();	   
	   }
	   else {
	       rc.action=rc.$w.rbKey('product.producttype.add');
		   rc.productType = getProductService().getProductType();
		   rc.parentProductTypeID=0;
	   }
	   rc.itemTitle = rc.action & " #rc.$w.rbKey('product.producttype')#";
	   // Put product type tree in rc for parent type drop-down selector
	   rc.productTypes = getProductService().getProductTypeTree();
	}
	
	
	public void function processProductTypeForm(required struct rc) {
        var productType = getProductService().getProductType();
		productType = variables.fw.populate(cfc=productType, keys=productType.getUpdateKeys(), trim=true);
		
		// set parent product type, if specified
		if(len(trim(rc.parentProductType_productTypeID)))
		  productType.setParentProductType(getProductService().getProductType(ID=rc.parentProductType_productTypeID));
	
		productType = getProductService().saveProductType(productType);
		if(!productType.hasErrors()) {
		  // cache the updated product type tree
		  getProductService().setProductTypeTree();
		  variables.fw.redirect(action="admin:product.types",queryString="saved=true");
		} else {
		  variables.fw.redirect(action="admin:product.productTypeForm", queryString="productTypeID=#productType.getProductTypeID()#");
        }
	}
	
	public void function deleteProductType(required struct rc) {
	   getProductService().deleteProductType(rc.productTypeID);
	   // cache the updated product type tree
       getPluginConfig().getApplication().setValue("ProductTypeTree",getProductService().getProductTypeTree());
	   variables.fw.redirect(action="admin:product.types",queryString="deleted=#rc.productTypeID#");
	}
		
}
