/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Option Group" entityname="SlatwallOptionGroup" table="SlatwallOptionGroup" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {

	// Persistant Properties
	property name="optionGroupID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionGroupName" validateRequired DisplayName="Option Group Name" ormtype="string";
	property name="optionGroupImage" ormtype="string";
	property name="optionGroupDescription" ormtype="string";
	property name="isImageGroup" ormtype="boolean";
	
	// Related Object Properties
	property name="options" singularname="option" type="array" cfc="Option" fieldtype="one-to-many" fkcolumn="optionGroupID" inverse="true" lazy="extra" cascade="delete";

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
