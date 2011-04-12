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
component displayname="Option" entityname="SlatwallOption" table="SlatwallOption" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="optionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" validateRequired ormtype="string";
	property name="optionName" validateRequired ormtype="string";
	property name="optionImage" ormtype="string";
	property name="optionDescription" ormtype="string" length="4000";
	property name="sortOrder" ormtype="integer";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="optionID" inversejoincolumn="skuID" inverse="true" lazy="extra" cascade="save-update"; 
	
	// Calculated Properties
	property name="assignedFlag" type="boolean" formula="SELECT count(*) from SlatwallSkuOption so WHERE so.OptionID=optionID";

	// Non-persistent Properties
	property name="imageDirectory" type="string" hint="Base directory for option images" persistent="false";

    public Option function init(){
		// set default collections for association management methods
		if(isNull(variables.skus)) {
			variables.skus = [];
		}
	    
		setImageDirectory("#$.siteConfig().getAssetPath()#/images/Slatwall/meta/");
		return Super.init();
    }
    
    public boolean function hasSkus() {
    	if(arrayLen(getSkus()) gt 0) {
    		return true;
    	} else {
    		return false;
    	}
    }

    /******* Association management methods for bidirectional relationships **************/
    
    // OptionGroup (many-to-one)
    
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
    
    // Sku (many-to-many) delegates both sides of the relationship to the other side
    
    public void function addSku(required Sku Sku) {
       arguments.Sku.addOption(this);
    }
    
    public void function removeSku(required Sku Sku) {
       arguments.Sku.removeOption(this);
    }
    
    /************   END Association Management Methods   *******************/
	
	// Image Management methods
	
	public string function displayImage(numeric width=0, numeric height=0) {
		var imageDisplay = "";
		if(this.hasImage()) {
			var fileService = getService("FileService");
			imageDisplay = fileService.displayImage(imagePath=getImagePath(), width=arguments.width, height=arguments.height, alt=getOptionName());
		}
		return imageDisplay;
	}
	
	public boolean function hasImage() {
		return len(getOptionImage());
	}
	
    public string function getImagePath() {
        return getImageDirectory() & getOptionImage();
    }
}
