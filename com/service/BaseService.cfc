component displayname="Base Service" persistent="false" accessors="true" output="false" hint="This is a base service that all services will extend" {

	property name="entityName" type="string";
	property name="DAO" type="any";
	property name="Validator" table="Slatwall.com.utility.Validator";
	property name="fileService" type="any";
	
	public any function init(required string entityName, required any dao, required any validator, any fileService) {
		setEntityName(arguments.entityName);
		setDAO(arguments.DAO);
		setValidator(arguments.validator);
		if(structKeyExists(arguments,"fileService")) {
			setfileService(arguments.fileService);
		}
		
		return this;
	}
	
	public any function getByID(required string ID, string entityName) {
		if(isDefined("arguments.entityName")) {
			return getDAO().read(ID=arguments.ID, entityName=arguments.entityName);
		} else {
			return getDAO().read(ID=arguments.ID, entityName=getEntityName());
		}
	}
	
	public any function getByFilename(required string filename, string entityName) {
		if(isDefined("arguments.entityName")) {
			return getDAO().readByFilename(filename=arguments.filename, entityName=arguments.entityName);
		} else {
			return getDAO().readByFilename(filename=arguments.filename, entityName=getEntityName());	
		}
	}
	
	public any function getNewEntity(string entityName) {
		if(isDefined("arguments.entityName")) {
			var entity = entityNew(arguments.entityName);
			structDelete(arguments, "entityName");
		} else {
			var entity = entityNew(getEntityName());
		}
		entity.init(argumentcollection=arguments);
		return entity;
	}
	
	public any function list(string entityName) {
		if(isDefined("arguments.entityName")) {
			return getDAO().list(entityName=arguments.entityName);
		} else {
			return getDAO().list(entityName=getEntityName());
		}
	}
	
	public any function getSmartList(required struct rc, string entityName){
		if(isDefined("arguments.entityName")) {
			var smartList = createObject("component","Slatwall.com.utility.SmartList").init(rc=arguments.rc, entityName=arguments.entityName);
			return getDAO().fillSmartList(smartList=smartList, entityName=arguments.entityName);
		} else {
			var smartList = createObject("component","Slatwall.com.utility.SmartList").init(rc=arguments.rc, entityName=getEntityName());
			return getDAO().fillSmartList(smartList=smartList, entityName=getEntityName());
		}
	}
	
	public void function delete(required any entity){
		getDAO().delete(entity=arguments.entity);
	}
	
	public any function save(required any entity) {;
        getValidator().validateObject(entity=arguments.entity);
		
		if(!arguments.entity.hasErrors()) {
			arguments.entity = getDAO().save(entity=arguments.entity);
		}
		
		return arguments.entity;
	}
	
}