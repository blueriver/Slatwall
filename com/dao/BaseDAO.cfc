component output="false" {
	
	public any function init() {
		return this;
	}
	
	public any function read(required string ID, required string entityName) {
		return entityLoad(arguments.entityName, arguments.ID, true);
	}
	
	public any function readByFilename(required string filename, required string entityName){
		return ormExecuteQuery(" from #arguments.entityName# where filename = :filename", {filename=arguments.filename}, true);
	}
	
	public array function list(required string entityName,struct filterCriteria=structNew(),string sortOrder="") {
		if(!structIsEmpty(arguments.filterCriteria) and !len("arguments.sortOrder")) {
			return entityLoad(arguments.entityName);
		} else {
			return entityLoad(arguments.entityName,arguments.filterCriteria,arguments.sortOrder);
		}	
	}
	
	public any function getSmartList(required struct rc, required string entityName){
		var smartList = new Slatwall.com.utility.SmartList(rc=arguments.rc, entityName=arguments.entityName);
	
		return smartList;
	}
	
	public void function delete(required any entity) {
		EntityDelete(arguments.entity);
	}
	
	public any function save(required any entity) {
		EntitySave(arguments.entity);
		//writeDump("THIS WORKED");
		return arguments.entity;
	}
}