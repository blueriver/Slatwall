component displayname="Content Product" entityname="SlatwallContentProduct" table="SlatwallContentProduct" persistent=true output=false accessors=true extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="contentProductID" fieldtype="id" generator="increment";
	property name="contentID" type="string" persistent="true" hint="Mura Content ID";
	
	// Related Object Properties
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="ProductID";
		
}