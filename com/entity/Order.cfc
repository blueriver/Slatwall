component displayname="Order" entityname="SlatwallOrder" table="SlatwallOrder" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="orderOpenDate" ormtype="date";
	property name="orderCloseDate" ormtype="date";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="orderStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusTypeID";
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID";
	property name="orderShipments" singularname="orderShipment" cfc="OrderShipment" fieldtype="one-to-many" fkcolumn="orderID" inverse="true" cascade="all";
	
	public string function getStatus() {
		return getOrderStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderStatusType().getSystemCode();
	}
}