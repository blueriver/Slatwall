component displayname="Profile Template" entityname="SlatwallProfileTemplate" table="SlatwallProfileTemplate" persistent="true" extends="slatwall.com.entity.baseEntity" {
	
	// Persistant Properties
	property name="profileTemplateID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="profileTemplateName" ormtype="string";
	property name="profileTemplateDescription" ormtype="string";
	
}