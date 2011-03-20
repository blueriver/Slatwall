component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	public any function save( required any Brand, required struct data ) {
		arguments.Brand.populate(arguments.data);
		return Super.save(arguments.Brand);
	}
	
	public boolean function delete(required any Brand){
		var deleted = false;
		if( !arguments.Brand.hasProducts() ) {
			getDAO().delete(entity=arguments.Brand);
			deleted = true;
		} else {
			transactionRollback();
			getValidator().setError(entity=arguments.Brand,errorName="delete",rule="assignedToProducts");
		}
		return deleted;
	}

}