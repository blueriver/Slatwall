component displayname="Sku Alternate" entityname="SlatwallSkuAlternate" table="SlatwallSkuAlternate" persistent=true accessors=true output=false extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="skuAlternateID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="skuValue" ormtype="string";
	
	// Related Object Properties
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="skuType" cfc="Type" fieldtype="many-to-one" fkcolumn="skuTypeID";
	
}