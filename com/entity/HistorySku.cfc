component displayname="History Sku" entityname="SlatwallHistorySku" table="SlatwallHistorySku" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historySkuID" type="string" fieldtype="id" generator="guid";
	property name="historyDateTime" type="date";
	property name="price" type="";
	property name="listPrice" type="string";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
}