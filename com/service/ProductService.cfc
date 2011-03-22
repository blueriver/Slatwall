component extends="BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="SkuService" type="any";  
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	property name="feedManager" type="any";
	property name="ProductTypeTree" type="any";
	
	public any function init(required any productTypeDAO) {
		//TODO: look at changing it to property injection through coldspring
		setproductTypeDAO(arguments.productTypeDAO);
		setProductTypeTree();
		
		return this;
	}
		
	public any function getProductTemplates() {
		return getSettingsManager().getSite(session.siteid).getTemplates();
	}
	
	public any function getContentFeed() {
		return getFeedManager().getBean();
	}

	/**
	/* @hint associates this product with Mura content objects
	*/
	public void function assignProductContent(required any product,required string contentID) {
		var productContentArray = [];
		getDAO().clearProductContent(arguments.product);
		for(var i=1;i<=listLen(arguments.contentID);i++) {
			local.thisContentID = listGetAt(arguments.contentID,i);
			local.thisProductContent = entityNew("SlatwallProductContent",{contentID=local.thisContentID});
			arrayAppend(productContentArray,local.thisProductContent);
		}
		arguments.product.setProductContent(productContentArray);
	}
	
	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice) {
		return getSkuService().createSkus(argumentCollection=arguments);
	}
	
	public any function populate(required any productEntity,required struct data) {
		arguments.productEntity.populate(arguments.data);
		return arguments.productEntity;
	}
	
	public any function save(required any Product,required struct data) {
		// populate bean from values in the data Struct
		arguments.Product.populate(arguments.data);
		
		// if filename wasn't set in bean, default it to the product's name.
		if(arguments.Product.getFileName() == "") {
			arguments.Product.setFileName(getFileService().filterFileName(arguments.Product.getProductName()));
		}
		
		// set up sku(s) if this is a new product
		if(arguments.Product.isNew()) {
			createSkus(arguments.Product,arguments.data.optionsStruct,arguments.data.price,arguments.data.listPrice);
		}
		
		// set Default sku
		if( structKeyExists(arguments.data,"defaultSku") && len(arguments.data.defaultSku) ) {
			var dSku = arguments.Product.getSkuByID(arguments.data.defaultSku);
			if(!dSku.getIsDefault()) {
				dSku.setIsDefault(true);
			}
		}
		
		// set up associations between product and content
		assignProductContent(arguments.Product,arguments.data.contentID);
		
		arguments.Product = Super.save(arguments.Product);
		
		if(arguments.Product.hasErrors()) {
			transactionRollback();
			trace( text="rolled back save within product service");
		}
		
		return arguments.Product;
	}
	
	public any function getProductContentSmartList(required struct rc, required string contentID) {
		return getDAO().getProductContentSmartList(rc=arguments.rc, entityName=getEntityName(), contentID=arguments.contentID);
	}
	
	//   Product Type Methods
	
    public void function setProductTypeTree() {
        variables.productTypeTree = getProductTypeDAO().getProductTypeTree();
    }
	
	public any function saveProductType(required any productType, required struct data) {
		
		arguments.productType.populate(data=arguments.data);
		
		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
	   var entity = Super.save(arguments.productType);
	   return entity;
	}
	
	public boolean function deleteProductType(required any productType) {
		var deleted = false;
		if( !arguments.productType.hasProducts() && !arguments.productType.hasSubProductTypes() ) {
			Super.delete(arguments.productType);
			deleted = true;
		} else {
			transactionRollback();
			getValidator().setError(entity=arguments.productType,errorName="delete",rule="assignedToProducts");
		}
		return deleted;
	}
	
	/**
	* @hint recursively looks through the cached product type tree query to the the first non-empty value in the type lineage, or returns empty string if it wasn't set
	*/
	public any function getProductTypeSetting( required string productType,required string setting ) {
		var ptTree = getProductTypeTree();
		// use q of q to get the setting, looking up the lineage of the product type tree if an empty string is encountered
		var qoq = new Query();
		qoq.setAttributes(ptTable = ptTree);
		qoq.setSQL("select #arguments.setting#, path from ptTable where lower(productTypeName) = :ptype");
		qoq.addParam(name="ptype", value=lcase(arguments.productType), cfsqlType="cf_sql_varchar");
		var qGetSetting = qoq.execute(dbtype="query").getResult();
		if(qGetSetting.recordCount == 1) {
			local.theValue = evaluate("qGetSetting.#arguments.setting#");
			if(local.theValue != "") {
				return local.theValue;
			} else if(local.theValue == "" && lcase(qGetSetting.path) != lcase(arguments.productType)) {
				// gets the next product type up in the lineage and calls this function recursively
				local.parentProductType = listGetAt(qGetSetting.path,listLen(qGetSetting.path)-1);
				return getProductTypeSetting( productType=local.parentProductType,setting=arguments.setting );
			} else {
				return "";
			}
		}
		else return "";
	}
	
}