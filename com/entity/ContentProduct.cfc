component displayname="Content Product" entityname="SlatwallContentProduct" table="SlatwallContentProduct" persistent=true output=false accessors=true extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="contentProductID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentID" type="string" persistent="true" hint="Mura Content ID";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="ProductID";
		
}