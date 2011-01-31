component displayname="Profile Template" entityname="SlatwallProfileTemplate" table="SlatwallProfileTemplate" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="profileTemplateID" type="string" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="profileTemplateName" type="string";
	property name="profileTemplateDescription" type="string";
	
}