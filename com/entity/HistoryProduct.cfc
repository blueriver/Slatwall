component displayname="History Product" entityname="SlatwallHistoryProduct" table="SlatwallHistoryProduct" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="historyProductID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="historyDateTime" ormtype="date";
	property name="productName" ormtype="string";
	property name="productDescription" ormtype="long";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	
}