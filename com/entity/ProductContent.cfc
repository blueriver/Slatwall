component displayname="Product Content" entityname="SlatwallProductContent" table="SlatwallProductContent" persistent=true output=false accessors=true extends="slatwall.com.entity.baseEntity" {
	
	// Persistent Properties
	property name="productContentID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentID" ormtype="string" length="35";  
	
	// Related Object Properties
	//property name="content" cfc="Content" fieldtype="many-to-one" hint="Mura Content ID" fkcolumn="contentID";
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="ProductID";
		
}