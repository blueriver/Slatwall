component displayname="Order Item" entityname="SlatwallOrderItem" table="SlatwallOrderItem" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="orderItemID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="price" ormtype="float";
	property name="quantity" ormtype="float";
	property name="taxAmount" ormtype="float";
	
	// Related Object Properties
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	property name="profile" cfc="Profile" fieldtype="many-to-one" fkcolumn="profileID";
	property name="orderShipment" cfc="OrderShipment" fieldtype="many-to-one" fkcolumn="orderShipmentID";
	property name="orderItemStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="orderItemStatusTypeID";
	
	public string function getStatus(){
		return getOrderItemStatusType().getType();
	}
	
	public string function getStatusCode() {
		return getOrderItemStatusType().getSystemCode();
	}
	
}