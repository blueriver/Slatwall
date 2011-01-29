component displayname="Profile Template" entityname="SlatwallProfileTemplate" table="SlatwallProfileTemplate" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	property name="profileTemplateID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="profileTemplateName" type="string";
	property name="profileTemplateDescription" type="string";
	
}