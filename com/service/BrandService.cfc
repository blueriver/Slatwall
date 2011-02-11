component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	public any function getSmartList(required struct rc){
		var smartList = new slatwall.com.utility.SmartList(rc=arguments.rc, entityName=getEntityName());
		
		smartList.addKeywordProperty(rawProperty="brandName", weight=1);
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());	
	}

}