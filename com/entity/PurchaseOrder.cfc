component displayname="Purchase Order" entityname="SlatwallPurchaseOrder" table="SlatwallPurchaseOrder" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="purchaseOrderID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="purchaseOrderCode" ormtype="string" persistent="true";
	property name="estimatedArrivalDateTime" ormtype="date" persistent="true";
	property name="createdDateTime" ormtype="date" persistent="true";
	property name="lastUpdatedDateTime" ormtype="date" persistent="true";
	
	// Related Object Properties
	property name="vendor" cfc="Vendor" fieldtype="many-to-one" fkcolumn="vendorID";
	property name="purchaseOrderItem" singularname="purchaseOrderItem" cfc="PurchaseOrderItem" filedtype="one-to-many" fkcolumn="purchaseOrderID" inverse="true" cascade="all";
}