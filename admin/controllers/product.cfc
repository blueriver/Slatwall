component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	
	public void function before(required struct rc) {
		param name="rc.productID" default="";
		param name="rc.keyword" default="";
		param name="rc.edit" default="false";
	}
	
	public void function dashboard(required struct rc) {
		getFW().redirect(action="admin:product.list");
	}

    public void function create(required struct rc) {
		if(!structKeyExists(rc,"product") or !isObject(rc.product) or !rc.product.isNew()) {
			rc.product = getProductService().getNewEntity();
		}
		rc.productTypes = getProductService().getProductTypeTree();
		rc.optionGroups = getProductService().list(entityName="SlatwallOptionGroup",sortby="OptionGroupName");
		//rc.categories = rc.$.getBean("feed").set({ siteID=session.siteID,sortBy="title",sortDirection="asc" }).getIterator();
    }
	
	public void function detail(required struct rc) {
		// we could be redirected here from a failed form submission, so check rc for product object first
		if(!structKeyExists(rc,"product") or !isObject(rc.product)) {
			rc.product = getProductService().getByID(rc.productID);
		}
		if(!isNull(rc.product)) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
			//rc.productSmartList = getProductService().getSmartList(arguments.rc);
		} else {
			getFW().redirect("admin:product.list");
		}
		rc.productPages = getProductService().getContentFeed().set({ siteID=session.siteID,sortBy="title",sortDirection="asc" }).getIterator();
	}
	
	public void function edit(required struct rc) {
		detail(rc);
		rc.edit = true;
		getFW().setView("admin:product.detail");
	}
	
	public void function list(required struct rc) {
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function save(required struct rc) {
		var isNew = 0;
		
		rc.product = getProductService().getByID(rc.productID);
		if(isNull(rc.product)) {
			rc.product = getProductService().getNewEntity();	
		}
		
		if(rc.product.isNew()) {
			isNew = 1;
		}
		
		// populate product with form data
		rc.product = getFW().populate(cfc=rc.product, keys=rc.product.getUpdateKeys(), trim=true, acceptEmptyValues=false);
		
		// set brand into the bean
		if(len(rc.brand_brandID)) {
			rc.product.setBrand(getBrandService().getByID(rc.brand_brandID));
		}
		// set product type into the bean
		if(len(rc.productType_productTypeID)) {
			rc.product.setProductType(getProductService().getByID(rc.productType_productTypeID,"SlatwallProductType"));
		}
		
		// set content IDs
		if(!structKeyExists(rc,"contentID")) {
			rc.contentID = "";
		}

		// Attempt to Save Product
		rc.product = getProductService().save(product=rc.product,contentID=rc.contentID);
		
		// Redirect & Error Handle
		if(!rc.product.hasErrors()) {
			// set up sku(s) if this is a new product
			if(isNew) {
				rc.optionsStruct = getService("formUtilities").buildFormCollections(rc);
				getProductService().createSkus(rc.product,rc.optionsStruct,rc.price,rc.listPrice);
				getFW().redirect(action="admin:product.edit",preserve="product");
			} else {
				getFW().redirect(action="admin:product.list");
			}
		} else {
			if(isNew) {
				getFW().redirect(action="admin:product.create",preserve="product");
			} else {
				getFW().redirect(action="admin:product.edit",preserve="product");
			}
		}
	}
	
	public void function delete(required struct rc) {
		var product = getProductService().getByID(rc.productID);
		getProductService().delete(product);
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
			getProductService().setProductTypeTree();
			rc.message = "admin.product.deleteproducttype_success";		
		} else {
			rc.message="admin.product.deleteproducttype_disabled";
			rc.messagetype="warning";
		}
		getFW().redirect(action="admin:product.listproducttypes",preserve="message,messagetype");
	}
		
}
