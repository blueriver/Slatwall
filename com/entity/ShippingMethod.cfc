component displayname="Shipping Method" entityname="SlatwallShippingMethod" table="SlatwallShippingMethod" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="shippingMethodID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="shippingMethodName" type="string";
	property name="shippingProviderGateway" type="string";
	property name="shippingProviderMethod" type="string";
	
	// Related Object Properties
	property name="shippingMethodType" cfc="Type" fieldtype="many-to-one" fkcolumn="shippingMethodTypeID";
	
	public string function getMethodType() {
		return getShippingMethodType().getType();
	}

}