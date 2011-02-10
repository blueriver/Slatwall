component extends="slatwall.com.service.BaseService" accessors="true" {
	
	property name="OptionGroupDAO" type="any";
	
	public any function init(required any entityName, required any dao, required any OptionGroupDAO) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setOptionGroupDAO(arguments.OptionGroupDAO);
		
		return this;
	}

	
	
	//   Option Group Methods
	
	public any function getOptionGroup(ID="") {
	   if(len(arguments.ID))
	   	   var OptionGroup = getOptionGroupDAO().read(arguments.ID,"SlatwallOptionGroup");
	   else if(!len(arguments.ID) or !isDefined("OptionGroup"))
           var OptionGroup = getNewEntity("SlatwallOptionGroup");
		return OptionGroup;
	}
	
	public any function listOptionGroups() {
       return list("SlatwallOptionGroup");
    }

	public any function saveOptionGroup(required any OptionGroup) {
	   return save(arguments.OptionGroup);
	}
	
	public void function deleteOptionGroup(required any OptionGroup) {
	   if(isObject(arguments.OptionGroup))
	       delete(arguments.OptionGroup);
	   else if(isSimpleValue(arguments.OptionGroup)) {
	       local.OptionGroup = getOptionGroup(arguments.OptionGroup);
		   delete(local.OptionGroup);
	   }
	}
	
}