component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required string options, required price, required listprice) {

		return true;
	}

}