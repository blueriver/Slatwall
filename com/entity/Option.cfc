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
component displayname="Option" entityname="SlatwallOption" table="SlatwallOption" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="optionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" ormtype="string";
	property name="optionName" ormtype="string";
	property name="optionImage" ormtype="string";
	property name="optionDescription" ormtype="string" length="4000";
	property name="sortOrder" ormtype="integer";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="optionID" inversejoincolumn="skuID" inverse="true" cascade="save-update"; 

	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" cascade="all" inverse="true";
	
	public Option function init(){
		// set default collections for association management methods
		if(isNull(variables.skus)) {
			variables.skus = [];
		}
		
		return Super.init();
    }
    
    public string function getImageDirectory() {
    	return "#$.siteConfig().getAssetPath()#/assets/Image/Slatwall/meta/";
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
    
	// promotionRewards (many-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addOption(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeOption(this);
	}
    
    /************   END Association Management Methods   *******************/
	
	// Image Management methods
	
	public string function getImage(numeric width=0, numeric height=0, string alt="", string class="") {
		if( this.hasImage() ) {
			
			// If there were sizes specified, get the resized image path
			if(arguments.width != 0 || arguments.height != 0) {
				path = getResizedImagePath(argumentcollection=arguments);	
			} else {
				path = getImagePath();
			}
			
			// Read the Image
			var img = imageRead(expandPath(path));
			
			// Setup Alt & Class for the image
			if(arguments.alt == "" and len(getOptionName())) {
				arguments.alt = "#getOptionName()#";
			}
			if(arguments.class == "") {
				arguments.class = "optionImage";	
			}
			return '<img src="#path#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';
		}
	}
	
	public string function getResizedImagePath(numeric width=0, numeric height=0) {
		return getService("utilityFileService").getResizedImagePath(imagePath=getImagePath(), width=arguments.width, height=arguments.height);
	}
	
	public boolean function hasImage() {
		return len(getOptionImage());
	}
	
    public string function getImagePath() {
        return getImageDirectory() & getOptionImage();
    }
}
