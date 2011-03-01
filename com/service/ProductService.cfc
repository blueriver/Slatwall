component extends="BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	property name="feedManager" type="any";
	property name="ProductTypeTree" type="any";
	
	public any function init(required any entityName, required any dao, required any validator, required any fileService, required any skuDAO, required any productTypeDAO, required any contentManager, required any feedManager, required any settingsManager) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setValidator(arguments.validator);
		setfileService(arguments.fileService);
		setSkuDAO(arguments.skuDAO);
		setProductTypeDAO(arguments.productTypeDAO);
		setContentManager(arguments.contentManager);
		setFeedManager(arguments.feedManager);
		setSettingsManager(arguments.settingsManager);
		setProductTypeTree();
		
		return this;
	}
	
	public any function getSmartList(required struct rc){
		
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=getEntityName());
		
		smartList.addKeywordProperty(rawProperty="productCode", weight=9);
		smartList.addKeywordProperty(rawProperty="productName", weight=3);
		smartList.addKeywordProperty(rawProperty="productYear", weight=6);
		smartList.addKeywordProperty(rawProperty="productDescription", weight=1);
		smartList.addKeywordProperty(rawProperty="brand_brandName", weight=3);
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());	
	}
	
	public any function getProductTemplates() {
		return getSettingsManager().getSite(session.siteid).getTemplates();
	}
	
	public any function getContentFeed() {
		return getFeedManager().getBean();
	}

	/**
	/* @hint associates this product with categories (Mura Content objects)
	*/
	public void function assignCategories(required any product,required string categoryID) {
		var categoryArray = [];
		for(var i=1;i<=listLen(arguments.categoryID);i++) {
			var thisCategoryID = listGetAt(arguments.categoryID,i);
			var thisCategory = entityLoadByPK("Category",thisCategoryID);
			if(!arguments.product.hasCategory(thisCategory)) {
				arrayAppend(categoryArray,thisCategory);
			}
		}
		product.setCategories(categoryArray);
	}
	
	public any function save(required any entity) {
		// if filename wasn't set, in bean, default it to the product's name.
		if(arguments.entity.getFileName() == "") {
			arguments.entity.setFileName(getFileService().filterFileName(arguments.entity.getProductName()));
		}
		return Super.save(arguments.entity);
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
	   var entity = save(arguments.productType);
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