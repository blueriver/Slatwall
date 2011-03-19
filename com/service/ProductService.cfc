component extends="BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="SkuService" type="any";  
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	property name="feedManager" type="any";
	property name="ProductTypeTree" type="any";
	
	public any function init(required any entityName, required any dao, required any validator, required any fileService, required any skuDAO, required any productTypeDAO, required any skuService, required any contentManager, required any feedManager, required any settingsManager) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setValidator(arguments.validator);
		setfileService(arguments.fileService);
		setSkuDAO(arguments.skuDAO);
		setProductTypeDAO(arguments.productTypeDAO);
		setSkuService(arguments.skuService);
		setContentManager(arguments.contentManager);
		setFeedManager(arguments.feedManager);
		setSettingsManager(arguments.settingsManager);
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
		for(var i=1;i<=listLen(arguments.contentID);i++) {
			var thisContentID = listGetAt(arguments.contentID,i);
			var thisProductContent = entityNew("SlatwallProductContent",{contentID=thisContentID});
			arrayAppend(productContentArray,thisProductContent);
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
	
	public any function save(required any productEntity,required struct data) {
		// populate bean from values in the data Struct
		arguments.productEntity.populate(arguments.data);
		
		// if filename wasn't set in bean, default it to the product's name.
		if(arguments.productEntity.getFileName() == "") {
			arguments.productEntity.setFileName(getFileService().filterFileName(arguments.productEntity.getProductName()));
		}
		
		// set up sku(s) if this is a new product
		if(arguments.productEntity.isNew()) {
			createSkus(arguments.productEntity,arguments.data.optionsStruct,arguments.data.price,arguments.data.listPrice);
		}
		
		// set Default sku
		if( structKeyExists(arguments.data,"defaultSku") && len(arguments.data.defaultSku) ) {
			var dSku = arguments.productEntity.getSkuByID(arguments.data.defaultSku);
			if(!dSku.getIsDefault()) {
				dSku.setIsDefault(true);
			}
		}
		
		// set up associations between product and content
		if(len(arguments.data.contentID)) {
			assignProductContent(arguments.productEntity,arguments.data.contentID);
		}
		
		arguments.productEntity = Super.save(arguments.productEntity);
		
		if(arguments.productEntity.hasErrors()) {
			transactionRollback();
			trace( text="rolled back save within product service");
		}
		
		return arguments.productEntity;
	}
	
	public any function getProductContentSmartList(required struct rc, required string contentID) {
		return getDAO().getProductContentSmartList(rc=arguments.rc, entityName=getEntityName(), contentID=arguments.contentID);
	}
	
	//   Product Type Methods
	
    public void function setProductTypeTree() {
        variables.productTypeTree = getProductTypeDAO().getProductTypeTree();
    }
	
	public any function saveProductType(required any productType) {
		// if this type has a parent, inherit all products that were assigned to that parent
		if(!isNull(arguments.productType.getParentProductType()) and arrayLen(arguments.productType.getParentProductType().getProducts())) {
			arguments.productType.setProducts(arguments.productType.getParentProductType().getProducts());
		}
	   var entity = Super.save(arguments.productType);
	   return entity;
	}
	
	public void function deleteProductType(required any productType) {
	   if(isObject(arguments.productType)) {
	       delete(arguments.productType);
		} else if(isSimpleValue(arguments.productType)) {
		   delete(getByID(arguments.productType,"SlatwallProductType"));
	   }
	}
	
}