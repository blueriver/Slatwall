component displayname="History Sku" entityname="SlatwallHistorySku" table="SlatwallHistorySku" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historySkuID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="historyDateTime" type="date";
	property name="price" type="numeric";
	property name="listPrice" type="string";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
}