component displayname="Profile Template" entityname="SlatwallProfileTemplate" table="SlatwallProfileTemplate" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	property name="profileTemplateID" type="string" fieldtype="id" generator="guid";
	property name="profileTemplateName" type="string";
	property name="profileTemplateDescription" type="string";
	
}