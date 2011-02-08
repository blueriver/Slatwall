component extends="BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="ProductTypeDAO" type="any";
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	
	public any function init(required any entityName, required any dao, required any skuDAO, required any productTypeDAO, required any contentManager, required any settingsManager) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setSkuDAO(arguments.skuDAO);
		setProductTypeDAO(arguments.productTypeDAO);
		setContentManager(arguments.contentManager);
		setSettingsManager(arguments.settingsManager);
		
		return this;
	}
	
	public any function getSmartList(required struct rc){
		
		var smartList = new slatwall.com.utility.SmartList(rc=arguments.rc, entityName=getEntityName());
		
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
	   if(len(arguments.ID))
	   	   var productType = getProductTypeDAO().read(arguments.ID,"SlatwallProductType");
	   else if(!len(arguments.ID))
           var productType = getNewProductType();
       return productType;  
	}
	
	public any function getNewProductType() {
		var productType = entityNew("SlatwallProductType");
	    productType.init(argumentcollection=arguments);   
        return productType;
	}
	
	public any function listProductTypes() {
       return getProductTypeDAO().list("SlatwallProductType");
    }
	
	public any function getProductTypeTree() {
	   return getProductTypeDAO().getProductTypeTree();
	}
	
	public any function saveProductType(required any productType) {
	   return getProductTypeDAO().save(arguments.productType);
	}
	
	public void function deleteProductType(required any productType) {
	   if(isObject(arguments.productType))
	       getProductTypeDAO().delete(arguments.productType);
	   else if(isSimpleValue(arguments.productType)) {
	       local.productType = getProductType(arguments.productType);
		   getProductTypeDAO().delete(local.productType);
	   }
	}
	
}