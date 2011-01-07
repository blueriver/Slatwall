component displayname="Base Service" persistent="false" accessors="true" output="false" hint="This is a base service that all services will extend" {

	property name="entityName" type="string";
	property name="DAO" type="any";
	
	public any function init(required any entityName, required any dao) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		
		return this;
	}
	
	public any function getByID(required string ID) {
		return getDAO().read(ID=arguments.ID, entityName=getEntityName());
	}
	
	public any function getByFilename(required string filename) {
		return getDAO().readByFilename(filename=arguments.filename, entityName=getEntityName());
	}
	
	public any function getNewEntity() {
		var entity = entityNew(getEntityName());
		entity.init(argumentcollection=arguments);
		return entity;
	}
	
	public any function list() {
		return getDAO().list(entityName=getEntityName());
	}
	
	public array function getOptionList(required string idProperty, required string nameProperty) {
		var entityList = list();
		var optionsArray = arrayNew(1);
		for(var i=1; i <= arrayLen(entityList); i++) {
			var option = structNew();
			option.id = evaluate("entityList[i].get#arguments.idProperty#()");
			option.name = evaluate("entityList[i].get#arguments.nameProperty#()");
			arrayAppend(optionsArray, option);
		}
		return optionsArray;
	}
	
	public any function getSmartList(required struct rc){
		var smartList = createObject("component","slatwall.com.utility.SmartList").init(rc=arguments.rc, entityName=getEntityName());
		
		return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());
	}
	
	public void function delete(required any entity){
		getDAO().delete(entity=arguments.entity);
	}
	
	public any function save(required any entity) {
		return validateSave(entity=arguments.entity);
	}
	
	public any function validateSave(required any entity) {
		var validator = new Slatwall.com.utility.Validator();
		
		validator.validateObject(entity=arguments.entity);
		
		if(!arguments.entity.hasErrors()) {
			arguments.entity = getDAO().save(entity=arguments.entity);
		}
		
		return arguments.entity;
	}
	
}