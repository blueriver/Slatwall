component displayname="Payment Method" entityname="SlatwallPaymentMethod" table="SlatwallPaymentMethod" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="paymentMethodID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="paymentMethodName" ormtype="string";
	property name="providerGateway" ormtype="string";

}