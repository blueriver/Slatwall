component extends="slatwall.com.dao.BaseDAO" {

	public any function getSmartList(required struct rc, required string entityName){
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName);
		
		smartList.addKeywordProperty(rawProperty="optionCode", weight=9);
		smartList.addKeywordProperty(rawProperty="optionName", weight=3);
		smartList.addKeywordProperty(rawProperty="optionGroup_optionGroupName", weight="4");
		smartList.addKeywordProperty(rawProperty="optionDescription", weight=1);
		
		return smartList;
	}
}