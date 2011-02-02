component extends="slatwall.com.service.BaseService" accessors="true" {
	
	property name="skuDAO" type="any";
	property name="contentManager" type="any";
	property name="settingsManager" type="any";
	
	public any function init(required any entityName, required any dao, required any skuDAO, required any productTypeDAO, required any contentManager, required any settingsManager) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setSkuDAO(arguments.skuDAO);
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
	
}