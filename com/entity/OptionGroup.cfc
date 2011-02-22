component displayname="Option Group" entityname="SlatwallOptionGroup" table="SlatwallOptionGroup" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionGroupID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionGroupName" validateRequired DisplayName="Option Group Name" ormtype="string";
	property name="optionGroupImage" ormtype="string";
	property name="optionGroupDescription" ormtype="string";
	
	// Related Object Properties
	property name="options" singularname="option" type="array" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID" inverse="true" cascade="all-delete-orphan" ;

    public OptionGroup function init(){
       // set default collections for association management methods
       if(isNull(variables.Options))
           variables.Options = [];
       return Super.init();
    }
    
    // Association management methods for bidirectional relationships (delegates both sides to Option.cfc)
    public void function addOption(required Option Option) {
       arguments.Option.setOptionGroup(this);
    }
    
    public void function removeOption(required Option Option) {
       arguments.Option.removeOptionGroup(this);
    }
	
	
	// Image Management methods
	
	public void function setImage() {
		// TODO: implement method -- update entity and delegate to service the image file upload and placement
		return true;
	} 
	
	public void function removeImage() {
		// TODO: implement method -- update entity and delegate to service the image file deletion
		return true;
	} 
	
	public boolean function hasImage() {
		return len(getOptionGroupImage());
	}
	
    public string function getImagePath() {
        return getClassName() & "/" & getOptionGroupImage();
    }  
}