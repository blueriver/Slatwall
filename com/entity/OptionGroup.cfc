component displayname="Option Group" entityname="SlatwallOptionGroup" table="SlatwallOptionGroup" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionGroupID" type="numeric" ormtype="integer" fieldtype="id" generator="identity" unsavedvalue="0" default="0";
	property name="optionGroupName" type="string";
	property name="optionGroupImage" type="string";
	property name="optionGroupDescription" type="string";
	
	// Related Object Properties
	property name="options" type="array" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID";

}