component displayname="Option" entityname="SlatwallOption" table="SlatwallOption" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" ormtype="string";
	property name="optionName" ormtype="string";
	property name="optionImage" ormtype="string";
	property name="optionDescription" ormtype="string";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";

}