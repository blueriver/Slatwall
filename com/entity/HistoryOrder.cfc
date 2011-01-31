component displayname="History Sku" entityname="SlatwallHistoryOrder" table="SlatwallHistoryOrder" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historyOrderID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="historyDateTime" type="date";
	
	// Related Object Properties
	property name="order" cfc="Sku" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderStatus" cfc="Type" fieldtype="many-to-one" fkcolumn="orderStatusID";
	
}