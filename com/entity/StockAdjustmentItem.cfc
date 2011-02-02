component displayname="Stock Adjustment Item" entityname="SlatwallStockAdjustmentItem" table="SlatwallStockAdjustmentItem" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="stockAdjustmentItemID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="adjustmentQuantity" ormtype="integer";
	property name="newQuantity" ormtype="integer";
	
	// Related Object Properties
	property name="stockAdjustment" cfc="StockAdjustment" fieldtype="many-to-one" fkcolumn="stockAdjustmentID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	
}