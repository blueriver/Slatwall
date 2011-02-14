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

    // Association management methods for bidirectional relationships
    public void function setOptionGroup(required OptionGroup OptionGroup) {
       variables.OptionGroup = arguments.OptionGroup;
       if(isNew() or !arguments.OptionGroup.hasOption(this)) {
           arrayAppend(arguments.OptionGroup.getOptions(),this);
       }
    }

    public void function removeOptionGroup(required OptionGroup OptionGroup) {
       var index = arrayFind(arguments.OptionGroup.getOptions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.OptionGroup.getOptions(),index);
       }
       
       structDelete(variables,"OptionGroup");
    }
	
	public boolean function hasImage() {
		return len(getOptionImage());
	}
	
	public string function getImagePath() {
        return getClassName() & "/" & getOptionImage();
    }  
}