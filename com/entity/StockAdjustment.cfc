component displayname="Stock Adjustment" entityname="SlatwallStockAdjustment" table="SlatwallStockAdjustment" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="stockAdjustmentID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="adjustmentDateTime" ormtype="date";
	
	// Related Object Properties
	property name="adjustmentType" cfc="Type" fieldtype="many-to-one" fkcolumn="adjustmentTypeID";
	property name="purchaseOrder" cfc="PurchaseOrder" fieldtype="many-to-one" fkcolumn="purchaseOrderID";
	property name="stockAdjustmentItems" singularname="stockAdjustmentItem" type="Array" cfc="StockAdjustmentItem" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" cascade="all" inverse="true";
	
}