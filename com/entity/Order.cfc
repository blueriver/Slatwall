component displayname="Order" entityname="SlatwallOrder" table="SlatwallOrder" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderID" type="string" fieldtype="id" generator="guid";
	property name="orderOpenDate" type="date";
	property name="orderCloseDate" type="date";
	
	// Related Object Properties
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="statusType" cfc="Type" fieldtype="many-to-one" fkcolumn="statusTypeID";
	property name="billingAddress" cfc="Address" fieldtype="many-to-one" fkcolumn="billingAddressID";
	
	
	public string function getStatus() {
		return getStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getStatusType().getSystemCode();
	}
}