component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	public any function save( required any Brand, required struct data ) {
		arguments.Brand.populate(arguments.data);
		return Super.save(arguments.Brand);
	}

}