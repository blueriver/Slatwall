component displayname="Base Service" persistent="false" accessors="true" output="false" hint="This is a base service that all services will extend" {

	property name="entityName" type="string";
	property name="DAO" type="any";
	property name="Validator" table="Slatwall.com.utility.Validator";
	property name="fileService" type="any";
	
	public any function init() {
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
		if(!isDefined("arguments.entityName")) {
			arguments.entityName = getEntityName();
		}
		return getDAO().list(argumentCollection=arguments);
	}
	
	public any function getSmartList(required struct rc, string entityName){
		if(isDefined("arguments.entityName")) {
			return getDAO().getSmartList(rc=arguments.rc, entityName=arguments.entityName);
		} else {
			return getDAO().getSmartList(rc=arguments.rc, entityName=getEntityName());
		}
	}
	
	public boolean function delete(required any entity){
		var deleted = false;
		if(!arguments.entity.hasErrors()) {
			getDAO().delete(entity=arguments.entity);
			deleted = true;
		} else {
			transactionRollback();
		}
		return deleted;
	}
	
	public any function save(required any entity, struct data) {
		if(structKeyExists(arguments,"data")){
			arguments.entity.populate(arguments.data);
		}
        getValidator().validateObject(entity=arguments.entity);
		
		if(!arguments.entity.hasErrors()) {
			arguments.entity = getDAO().save(entity=arguments.entity);
		} else {
			transactionRollback();
			//trace( text="rolled back save within base service");
		}
		return arguments.entity;
	}	

}