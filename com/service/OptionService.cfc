component extends="slatwall.com.service.BaseService" accessors="true" {
	
	public any function init(required any entityName, required any dao) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		
		return this;
	}
	
	public any function getSmartList(required struct rc){
		
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=getEntityName());
		
		smartList.addKeywordProperty(rawProperty="optionCode", weight=9);
		smartList.addKeywordProperty(rawProperty="optionName", weight=3);
		smartList.addKeywordProperty(rawProperty="optionGroup_optionGroupName", weight="4");
		smartList.addKeywordProperty(rawProperty="optionDescription", weight=1);
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());	
	}
	
}