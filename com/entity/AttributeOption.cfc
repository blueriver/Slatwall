component displayname="Attribute Option" entityname="SlatwallAttributeOption" table="SlatwallAttributeOption" persistent="true" accessors="true" output="false" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="attributeOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeOptionValue" ormtype="string";
	
	// Related Object Properties
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";	
}