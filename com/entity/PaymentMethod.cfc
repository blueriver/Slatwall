component displayname="Payment Method" entityname="SlatwallPaymentMethod" table="SlatwallPaymentMethod" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="paymentMethodID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="paymentMethodName" type="string";
	property name="providerGateway" type="string";

}