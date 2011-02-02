component displayname="Content Product" entityname="SlatwallContentProduct" table="SlatwallContentProduct" persistent=true output=false accessors=true extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="contentProductID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentID" ormtype="string" persistent="true" hint="Mura Content ID";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="ProductID";
		
}