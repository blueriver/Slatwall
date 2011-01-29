component displayname="History Product" entityname="SlatwallHistoryProduct" table="SlatwallHistoryProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historyProductID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="historyDateTime" type="date";
	property name="productName" type="string";
	property name="productDescription" type="string";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
}