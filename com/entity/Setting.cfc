component displayname="Setting" entityname="SlatwallSetting" table="SlatwallSetting" persistent="true" accessors="true" output="false" extends="Slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="settingID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="settingName" ormtype="string" persistent="true";
	property name="settingValue" ormtype="string" persistent="true";
	
}