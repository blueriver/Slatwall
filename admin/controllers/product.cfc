component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";

	public void function dashboard(required struct rc) {
		getFW().redirect("product.list");
	}

    public void function create(required struct rc) {
		rc.product = getProductService().getNewEntity();
		rc.productTypes = getProductService().getProductTypeTree();
		rc.optionGroups = getProductService().list(entityName="SlatwallOptionGroup",sortby="OptionGroupName");
    }
	
	public void function detail(required struct rc) {
		rc.product = getProductService().getByID(rc.productID);
		if(!isNull(rc.product)) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
			rc.productSmartList = getProductService().getSmartList(arguments.rc);
		} else {
			getFW().redirect("admin:product.list");
		}
	}
	
	public void function edit(required struct rc) {
	// we could be redirected here from a failed form submission, so check rc for product object first
		if(!structKeyExists(rc,"product") or !isObject(rc.product)) {
			rc.product = getProductService().getByID(rc.productID);
		}
		if(!isNull(rc.product)) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
			rc.edit = true;
			getFW().setView("admin:product.detail");
		} else {
			getFW().redirect("admin:product.list");
		}
	}
	
	public void function list(required struct rc) {
		param name="rc.keyword" default="";	
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function save(required struct rc) {
		param name="rc.brand_brandID" default="";
		rc.product = getFW().populate(cfc=rc.product, keys=rc.product.getUpdateKeys(), trim=true);
		rc.product = getFW().populate(cfc=product, keys=product.getUpdateKeys(), trim=true);
		if(structKeyExists(rc,"brand_brandID") && len(rc.brand_brandID)) {
			rc.product.setBrand(getProductService().getByID(rc.brand_brandID,"SlatwallBrand"));
		} 
		if(structKeyExists(rc,"productType_productTypeID") && len(rc.productType_productTypeID)) {
			rc.product.setProductType(getProductService().getByID(rc.productType_productTypeID,"SlatwallProductType"));
		}
		//Set Filename for product if it isn't already defined.
		if(trim(rc.product.getFilename()) EQ "") {
			rc.product.setFilename(rc.product.getProductName());
		}
		
		//Simplify filename
		rc.product.setFilename(LCASE(Replace(rc.product.getFilename()," ","-","all")));
		
		//Save Product
		rc.product = getProductService().save(entity=rc.product);
		
		if(!rc.product.hasErrors()) {
			getFW().redirect(action="admin:product.detail", queryString="productID=#rc.product.getProductID()#");
		} else {
			getFW().setView("admin:product.edit");
		}
	}
	
	public void function delete(required struct rc) {
		getProductService().delete(entity=rc.product);
		getFW().redirect(action="admin:product.list");
	}
	
	
	//   Product Type actions      
		
	public void function createproducttype(required struct rc) {
	   rc.productType = getProductService().getNewEntity("SlatwallProductType");
	   // put type tree into the rc for parent dropdown
	   rc.productTypeTree = getProductService().getProductTypeTree();
	   getFW().setView("admin:product.editproducttype");
	}
		
	public void function editproducttype(required struct rc) {
	   	if(!structKeyExists(rc,"productType") or !isObject(rc.productType)) {
	   		rc.productType = getProductService().getByID(rc.productTypeID,"SlatwallProductType");
		}
	   	if(!isNull(rc.productType)) {
	       	rc.productTypeTree = getProductService().getProductTypeTree();
		   	rc.itemTitle &= ": " & rc.productType.getProductType();
	   	} else {
           	getFW().redirect("product.listproducttypes");
		}
	}
	
	public void function listproducttypes(required struct rc) {
       rc.productTypes = getProductService().getProductTypeTree();
	}

	
	public void function saveproducttype(required struct rc) {
        var productType = getProductService().getNewEntity("SlatwallProductType");
		rc.productType = getFW().populate(cfc=productType, keys=productType.getUpdateKeys(), trim=true);
		
		// set parent product type, if specified
		if(len(trim(rc.parentProductType_productTypeID))) {
			rc.productType.setParentProductType(getProductService().getByID(rc.parentProductType_productTypeID,"SlatwallProductType"));
		}
		rc.productType = getProductService().saveProductType(rc.productType);
		if(!rc.productType.hasErrors()) {
			getProductService().setProductTypeTree();
			rc.message = "admin.product.saveproducttype_success";
		  	getFW().redirect(action="admin:product.listproducttypes",preserve="message");
		} else {
		  getFW().redirect(action="admin:product.editproducttype", preserve="productType");
        }
	}
	
	public void function deleteproducttype(required struct rc) {
		var productType = getProductService().getByID(rc.productTypeID,"SlatwallProductType");
		if(!productType.getIsAssigned() and !arrayLen(productType.getSubProductTypes())) {
			getProductService().deleteProductType(rc.productTypeID);
			rc.message = "admin.product.deleteproducttype_success";		
		} else {
			rc.message="admin.product.deleteproducttype_disabled";
			rc.messagetype="warning";
		}
		getFW().redirect(action="admin:product.listproducttypes",preserve="message,messagetype");
	}
		
}
