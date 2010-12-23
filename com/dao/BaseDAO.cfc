component output="false" {
	
	public any function init() {
		return this;
	}
	
	public any function read(required string ID, required string entityName) {
		return entityLoad(arguments.entityName, arguments.ID, true);
	}
	
	public any function readByFilename(required string filename, required string entityName){
		var HQL = " from #arguments.entityName# where filename = '#arguments.Filename#'";
		return ormExecuteQuery(HQL, true);
	}
	
	public array function list(required string entityName) {
		return entityLoad(arguments.entityName);
	}
	
	public any function fillSmartList(required any smartList, required any entityName) {
		var EntityRecords = arrayNew(1);
		var HQL = " from #arguments.entityName# a#arguments.entityName# #arguments.smartList.getHQLWhere()#";
		
		EntityRecords = ormExecuteQuery(HQL);
		arguments.smartList.setEntityRecords(EntityRecords);
		
		return arguments.smartList;
	}
	
	public void function delete(required any target) {
		EntityDelete(arguments.target);
	}
	
	public any function save(required any entity) {
		EntitySave(arguments.entity);
		
		return arguments.entity;
	}
	
	// @hint This is a helper function that is used by extended integration DAO's to convert SQL queries to an Array of that object by using the Set method in the BaseEntity
	private array function queryToEntityArray(required query resultsQuery, required string entityName) {
		
		var entityArray = arrayNew(1);
		for(var i=1; i <= arguments.resultsQuery; i++) {
			var entity = EntityNew(arguments.entityName);
			entity.set(arguments.resultsQuery[i]);
			arrayAppend(entityArray, entity);
		}
		
		return entityArray;
	}
}