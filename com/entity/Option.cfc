component displayname="Option" entityname="SlatwallOption" table="SlatwallOption" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionID" type="string" fieldtype="id" generator="guid";
	property name="optionCode" type="string";
	property name="optionName" type="string";
	property name="optionImage" type="string";
	property name="optionDescription" type="string";
	property name="sortOrder" type="numeric";
	
	// Related Object Properties
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";

}