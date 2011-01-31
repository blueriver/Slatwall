component displayname="Profile Template Attribute" entityname="SlatwallProfileTemplateAttribute" table="SlatwallProfileTemplateAttribute" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="profileTemplateAttributeID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";
	property name="profileTemplate" cfc="ProfileTemplate" fieldtype="many-to-one" fkcolumn="profileTemplateID";
	
}