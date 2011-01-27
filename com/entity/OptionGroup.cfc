component displayname="Option Group" entityname="SlatwallOptionGroup" table="SlatwallOptionGroup" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionGroupID" type="string" fieldtype="id" generator="guid";
	property name="optionGroupName" type="string";
	property name="optionGroupImage" type="string";
	property name="optionGroupDescription" type="string";
	
	// Related Object Properties
	property name="options" type="array" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID";

}