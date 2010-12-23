component extends="slat.com.service.BaseService" {
	
	public slat.com.entity.SmartList function getSmartList(required struct rc){
		var smartList = createObject("component","slat.com.entity.SmartList").init(entityName=getEntityName(), rc=arguments.rc);
		smartList.addKeywordColumn("VendorName", 1);
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());	
	}
}