component displayname="Purchase Order Item" entityname="SlatwallPurchaseOrderItem" table="SlatwallPurchaseOrderItem" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="purchaseOrderItemID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantityOrdered" ormtype="integer" persistent="true";
	property name="quantityReceived" ormtype="integer" persistent="true";
	property name="estimatedArrivalDateTime" ormtype="date" persistent="true";
	
	// Related Object Properties
	property name="purchaseOrder" cfc="PurchaseOrder" fieldtype="many-to-one" fkcolumn="purchaseOrderID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
}