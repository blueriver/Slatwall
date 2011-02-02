component displayname="Order Payment" entityname="SlatwallOrderPayment" table="SlatwallOrderPayment" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderPaymentID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="float";
	property name="amountAuthorized" ormtype="float";
	property name="amountCharged" ormtype="float";
	property name="amountSettled" ormtype="float";
	property name="amountVerified" ormtype="float";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID";
	
}