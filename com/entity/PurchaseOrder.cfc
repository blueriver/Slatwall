component displayname="Purchase Order" entityname="SlatwallPurchaseOrder" table="SlatwallPurchaseOrder" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="purchaseOrderID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="purchaseOrderCode" type="string" persistent="true";
	property name="estimatedArrivalDateTime" type="date" persistent="true";
	property name="createdDateTime" type="date" persistent="true";
	property name="lastUpdatedDateTime" type="date" persistent="true";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="purchaseOrderItem"  cfc="PurchaseOrderItem" filedtype="one-to-many" fkcolumn="purchaseOrderID";
}