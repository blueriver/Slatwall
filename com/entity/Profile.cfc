component displayname="Profile" entityname="SlatwallProfile" table="SlatwallProfile" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="profileID" type="string" fieldtype="id" generator="guid";
	property name="profileName" type="string";
	
	// Related Object Properties
	property name="profileTemplate" cfc="ProfileTemplate" fieldtype="many-to-one" fkcolumn="profileTemplateID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	
}