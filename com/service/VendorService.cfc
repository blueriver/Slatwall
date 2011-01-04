component extends="slatwall.com.service.BaseService" {
	
	public any function getSmartList(required struct rc){
		var smartList = new slatwall.com.utility.SmartList(entityName=getEntityName(), rc=arguments.rc);
		smartList.addKeywordColumn("VendorName", 1);
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());	
	}
}