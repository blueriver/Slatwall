component implements="CFIDE.orm.IEventHandler" {

	public void function preInsert(any entity){
		var timestamp = now();
		if(structKeyExists(arguments.entity,"setDateCreated")){
			arguments.entity.setDateCreated(timestamp);
		}
		if(structKeyExists(arguments.entity,"setDateModified")){
			arguments.entity.setDateModified(timestamp);
		}
		var administratorExists = !IsNull(session.admin.appsession.getAdministrator);
		if(administratorExists && structKeyExists(arguments.entity,"setCreatedByAdministratorID") && IsNull(arguments.entity.getCreatedByAdministratorID())){
			arguments.entity.setCreatedByAdministratorID(session.admin.appsession.getAdministrator().getAdministratorID());
		}
		if(administratorExists && structKeyExists(arguments.entity,"setModifiedByAdministratorID") && IsNull(arguments.entity.getModifiedByAdministratorID())){
			arguments.entity.setModifiedByAdministratorID(session.admin.appsession.getAdministrator().getAdministratorID());
		}
		
		if(structKeyExists(arguments.entity,"setSortOrder") && IsNull(arguments.entity.getSortOrder())){
			var hql = "SELECT COALESCE(MAX(sortOrder),0)+1 FROM " & arguments.entity.getEntityName() ;
			var newSortOrder = ORMExecuteQuery(hql,true);
			arguments.entity.setSortOrder(newSortOrder);
		}

	}
	
	public void function preUpdate(any entity, Struct oldData){
		if(arguments.entity.getUpdateAuditFlag()){
			var timestamp = now();
			if(structKeyExists(arguments.entity,"setDateModified")){
				arguments.entity.setDateModified(timestamp);
			}
			var administratorExists = !IsNull(session.admin.appsession.getAdministrator);
			
			if(administratorExists && structKeyExists(arguments.entity,"setModifiedByAdministratorID")){
				arguments.entity.setModifiedByAdministratorID(session.admin.appsession.getAdministrator().getAdministratorID());
			}
		}
	}
	
	public void function preDelete(any entity){

	}
	
	public void function preLoad(any entity){

	}
	
	public void function postInsert(any entity){

	}
	
	public void function postUpdate(any entity){

	}
	
	public void function postDelete(any entity){

	}
	
	public void function postLoad(any entity){

	}
}