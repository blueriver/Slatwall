component extends="slatwall.com.dao.BaseDAO" {

	public any function getSmartList(required struct rc, required string entityName){
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName);
	
		smartList.addKeywordProperty(rawProperty="brandName", weight=1);
	
		return smartList;
	}
			
}