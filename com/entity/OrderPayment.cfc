component displayname="Order Payment" entityname="SlatwallOrderPayment" table="SlatwallOrderPayment" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderPaymentID" type="string" fieldtype="id" generator="guid";
	property name="amount" type="numeric";
	property name="amountAuthorized" type="numeric";
	property name="amountCharged" type="numeric";
	property name="amountSettled" type="numeric";
	property name="amountVerified" type="numeric";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="paymentMethod" cfc="PaymentMethod" fieldtype="many-to-one" fkcolumn="paymentMethodID";
	
}