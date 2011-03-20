component displayname="Option Group" entityname="SlatwallOptionGroup" table="SlatwallOptionGroup" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {

	// Persistant Properties
	property name="optionGroupID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionGroupName" validateRequired DisplayName="Option Group Name" ormtype="string";
	property name="optionGroupImage" ormtype="string";
	property name="optionGroupDescription" ormtype="string";
	property name="isImageGroup" ormtype="boolean";
	
	// Related Object Properties
	property name="options" singularname="option" type="array" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID" inverse="true" cascade="all-delete-orphan" lazy="extra" ;

	// Non-persistent Properties
	property name="imageDirectory" type="string" hint="Base directory for optionGroup images" persistent="false";
	
    public OptionGroup function init(){
       // set default collections for association management methods
	   this.setImageDirectory("#$.siteConfig().getAssetPath()#/images/Slatwall/meta/");
       if(isNull(variables.Options))
           variables.Options = [];
       return Super.init();
    }
	
	public array function getOptions(sortby, sortType="text", direction="asc") {
		if(!structKeyExists(arguments,"sortby")) {
			return variables.Options;
		} else {
			return sortObjectArray(variables.Options,arguments.sortby,arguments.sortType,arguments.direction);
		}
	}
    
   /******* Association management methods for bidirectional relationships **************/
    
    // Option (one-to-many)
    
    public void function addOption(required Option Option) {
       arguments.Option.setOptionGroup(this);
    }
    
    public void function removeOption(required Option Option) {
       arguments.Option.removeOptionGroup(this);
    }

    /************   END Association Management Methods   *******************/
	
	public boolean function hasOptions() {
		if(this.getOptionsCount() gt 0) {
			return true;
		} else {
			return false;
		}
	}
	
	public numeric function getOptionsCount() {
		return arrayLen(this.getOptions());
	}
	
	
	// Image Management methods
	public string function displayImage(string width="", string height="") {
		var imageDisplay = "";
		if(this.hasImage()) {
			var fileService = getService("FileService");
			imageDisplay = fileService.displayImage(imagePath=getImagePath(), width=arguments.width, height=arguments.height, alt=getOptionGroupName());
		}
		return imageDisplay;
	}
	
	public boolean function hasImage() {
		return len(getOptionGroupImage());
	}
	
    public string function getImagePath() {
        return getImageDirectory() & getOptionGroupImage();
    }  
}