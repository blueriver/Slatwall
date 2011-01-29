component displayname="Purchase Order" entityname="SlatwallPurchaseOrder" table="SlatwallPurchaseOrder" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="purchaseOrderID" fieldtype="id" generator="guid";
	property name="purchaseOrderCode" type="string" persistent="true";
	property name="estimatedArrivalDateTime" type="date" persistent="true";
	property name="createdDateTime" type="date" persistent="true";
	property name="lastUpdatedDateTime" type="date" persistent="true";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="purchaseOrderItem" type="array" cfc="PurchaseOrderItem" filedtype="one-to-many" fkcolumn="purchaseOrderID";
}