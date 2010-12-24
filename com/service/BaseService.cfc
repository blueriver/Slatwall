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
	
	public void function delete(required any entity){
		getDAO.delete(entity=arguments.entity);
	}
	
	public any function save(required any entity) {
		return getDAO().save(entity=arguments.entity);
	}
}