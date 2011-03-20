component extends="BaseController" output=false accessors=true {

	// fw1 Auto-Injected Service Properties
	property name="productService" type="Slatwall.com.service.ProductService";
	property name="brandService" type="Slatwall.com.service.BrandService";
	property name="skuService" type="Slatwall.com.service.SkuService";
	
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
    }
	
	public void function detail(required struct rc) {
		param name="rc.edit" default="false";
		// we could be redirected here from a failed form submission, so check rc for product object first
		if(structKeyExists(rc,"product") && isObject(rc.product)) {
			// merge it with the new session and transfer over the error bean
            var errors = rc.product.getErrorBean();
            rc.product = entityMerge(rc.product);
            rc.product.setErrorBean(errors);
		} else {
			rc.product = getProductService().getByID(rc.productID);
		}
		if(!isNull(rc.product)) {
			if(len(rc.product.getProductName())) {
				rc.itemTitle &= ": #rc.product.getProductName()#";
			}
			if(rc.edit) {
				rc.productPages = getProductService().getContentFeed().set({ siteID=session.siteID,sortBy="title",sortDirection="asc" }).getIterator();
			}
		} else {
			getFW().redirect("admin:product.list");
		}
	}
	
	public void function edit(required struct rc) {
		rc.edit = true;
		detail(rc);
		getFW().setView("admin:product.detail");
	}

	
	public void function list(required struct rc) {
		rc.productSmartList = getProductService().getSmartList(arguments.rc);
	}
	
	public void function save(required struct rc) {
		var isNew = 0;
		
		if(len(rc.productID)) {
			rc.product = getProductService().getByID(rc.productID);
		} else {
			rc.product = getProductService().getNewEntity();	
		}
		
		if(rc.product.isNew()) {
			isNew = 1;
		}
		
		// set up options struct for generating skus if this is a new product
		if(isNew) {
			rc.optionsStruct = getService("formUtilities").buildFormCollections(rc);
		}

		// Attempt to Save Product
		rc.product = getProductService().save( rc.product,rc );
		
		// Redirect & Error Handle
		if(!rc.product.hasErrors()) {
			getProductService().setProductTypeTree();
			// add product details if this is a new product
			if(isNew) {
			     getFW().redirect(action="admin:product.edit",queryString="productID=#rc.product.getProductID()#");
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
		getProductService().setProductTypeTree();
		getFW().redirect(action="admin:product.list");
	}
	
	
	//   Product Type actions      
		
	public void function createProductType(required struct rc) {
	   rc.productType = getProductService().getNewEntity("SlatwallProductType");
	   // put type tree into the rc for parent dropdown
	   rc.productTypeTree = getProductService().getProductTypeTree();
	   getFW().setView("admin:product.editproducttype");
	}
		
	public void function editProductType(required struct rc) {
		// we could be redirected here from a failed form submission, so check rc for productType object first
	   	if(structKeyExists(rc,"productType") && isObject(rc.productType)) {
	   		if(!rc.productType.isNew()) {
				// merge it with the new session and transfer over the error bean
	            var errors = rc.productType.getErrorBean();
	            rc.productType = entityMerge(rc.productType);
	            rc.productType.setErrorBean(errors);
	        }
	   	} else {	
	   		rc.productType = getProductService().getByID(rc.productTypeID,"SlatwallProductType");
		}
	   	if(!isNull(rc.productType)) {
	       	rc.productTypeTree = getProductService().getProductTypeTree();
		   	rc.itemTitle &= ": " & rc.productType.getProductTypeName();
	   	} else {
           	getFW().redirect("product.listproducttypes");
		}
	}
	
	public void function listProductTypes(required struct rc) {
       rc.productTypes = getProductService().getProductTypeTree();
	}

	
	public void function saveProductType(required struct rc) {
		if(len(rc.productTypeID)) {
			rc.productType = getProductService().getByID(rc.productTypeID,"SlatwallProductType");
		} else {
			rc.productType = getProductService().getNewEntity("SlatwallProductType");	
		}
		
		rc.productType = getProductService().saveProductType(rc.productType,rc);
		
		if(!rc.productType.hasErrors()) {
			getProductService().setProductTypeTree();
			rc.message = "admin.product.saveproducttype_success";
		  	getFW().redirect(action="admin:product.listproducttypes",preserve="message");
		} else {
		  getFW().redirect(action="admin:product.editproducttype", preserve="productType");
        }
	}
	
	public void function deleteProductType(required struct rc) {
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
