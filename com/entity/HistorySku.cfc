component displayname="History Sku" entityname="SlatwallHistorySku" table="SlatwallHistorySku" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historySkuID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="historyDateTime" ormtype="date";
	property name="price" ormtype="float";
	property name="listPrice" ormtype="float";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
}