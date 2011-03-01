component extends="BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	property name="ProductTypeTree" type="any";
	
	public any function init(required any entityName, required any dao, required any validator, required any skuDAO, required any productTypeDAO, required any contentManager, required any settingsManager) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setValidator(arguments.validator);
		setSkuDAO(arguments.skuDAO);
		setProductTypeDAO(arguments.productTypeDAO);
		setContentManager(arguments.contentManager);
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
	
	
	//   Product Type Methods
	
	public any function getProductType(ID="") {
		return getByID(arguments.ID,"SlatwallProductType");
	}
	
	public any function getNewProductType() {
		return getNewEntity("SlatwallProductType");
	}
	
	public any function listProductTypes() {
       return list("SlatwallProductType");
    }
	
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
		   delete(getProductType(arguments.productType));
	   }
	   setProductTypeTree();
	}
	
}