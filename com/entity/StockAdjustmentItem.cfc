component displayname="Stock Adjustment Item" entityname="SlatwallStockAdjustmentItem" table="SlatwallStockAdjustmentItem" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="stockAdjustmentItemID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="adjustmentQuantity" type="numeric";
	property name="newQuantity" type="numeric";
	
	// Related Object Properties
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	
}