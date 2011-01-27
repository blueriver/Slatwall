component displayname="Payment Method" entityname="SlatwallPaymentMethod" table="SlatwallPaymentMethod" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="paymentMethodID" type="string" fieldtype="id" generator="guid";
	property name="paymentMethodName" type="string";
	property name="providerGateway" type="string";

}