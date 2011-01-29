component displayname="Profile Template Attribute" entityname="SlatwallProfileTemplateAttribute" table="SlatwallProfileTemplateAttribute" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="profileTemplateAttributeID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	
	// Related Object Properties
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";
	property name="profileTemplate" cfc="ProfileTemplate" fieldtype="many-to-one" fkcolumn="profileTemplateID";
	
}