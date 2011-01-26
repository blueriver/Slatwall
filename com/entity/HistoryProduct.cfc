component displayname="History Product" entityname="SlatwallHistoryProduct" table="SlatwallHistoryProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historyProductID" type="string" fieldtype="id" generator="guid";
	property name="historyDateTime" type="date";
	property name="productName" type="string";
	property name="productDescription" type="string";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
}