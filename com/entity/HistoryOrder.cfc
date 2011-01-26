component displayname="History Sku" entityname="SlatwallHistorySku" table="SlatwallHistorySku" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historyOrderID" type="string" fieldtype="id" generator="guid";
	property name="historyDateTime" type="date";
	
	// Related Object Properties
	property name="order" cfc="Sku" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderStatus" cfc="OrderStatus" fieldtype="many-to-one" fkcolumn="orderStatusID";
	
}