component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {
	
	public boolean function delete(required any Brand){
		if( arguments.Brand.hasProducts() ) {
			getValidator().setError(entity=arguments.Brand,errorName="delete",rule="assignedToProducts");
		}
		return Super.delete(arguments.Brand);
	}

}