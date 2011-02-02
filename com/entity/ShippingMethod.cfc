component displayname="Shipping Method" entityname="SlatwallShippingMethod" table="SlatwallShippingMethod" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingMethodID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingMethodName" ormtype="string";
	property name="shippingProviderGateway" ormtype="string";
	property name="shippingProviderMethod" ormtype="string";
	
	// Related Object Properties
	property name="shippingMethodType" cfc="Type" fieldtype="many-to-one" fkcolumn="shippingMethodTypeID";
	
	public string function getMethodType() {
		return getShippingMethodType().getType();
	}

}