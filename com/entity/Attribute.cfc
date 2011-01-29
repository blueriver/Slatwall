component displayname="Attribute" entityname="SlatwallAttribute" table="SlatwallAttribute" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="attributeID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="attributeName" type="string";
	property name="attributeHint" type="string";
	
	// Related Object Properties
	property name="attributeType" cfc="Type" fieldtyp="many-to-one" fkcolumn="attributeTypeID" hint="This is used to define how the UI for the attribute looks example: text, radio, wysiwyg, checkbox";
	property name="attributeClassType" cfc="Type" fieldtype="many-to-one" fkcolumn="attributeClassTypeID"  hint="This is used to define if this attribute is applied to a profile, account, product, ext";
	property name="attrinuteOptions" cfc="AttributeOption" fieldtype="one-to-many" fkcolumn="attributeID";
	
}