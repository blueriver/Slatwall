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
component displayname="Sku" entityname="SlatwallSku" table="SlatwallSku" persistent=true accessors=true output=false extends="BaseEntity" {
	
	// Persistent Properties
	property name="skuID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="skuCode" ormtype="string" unique="true" length="50";
	property name="listPrice" ormtype="big_decimal" formatType="currency" default="0";
	property name="price" ormtype="big_decimal" formatType="currency" default="0";
	property name="shippingWeight" ormtype="big_decimal" formatType="weight" dbdefault="0" default="0" hint="This Weight is used to calculate shipping charges";
	property name="imageFile" ormtype="string" length="50";

	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (One-To-One)
	property name="skuCache" fieldType="one-to-one" cfc="SkuCache";
	
	// Related Object Properties (Many-to-One)
	property name="product" fieldtype="many-to-one" fkcolumn="productID" cfc="Product";
	
	// Related Object Properties (One-to-Many)
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="skuID" cfc="Stock" inverse="true" cascade="all";
	property name="alternateSkuCodes" singularname="alternateSkuCode" fieldtype="one-to-many" fkcolumn="skuID" cfc="AlternateSkuCode" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (Many-to-Many)
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="skuID" inversejoincolumn="optionID" cascade="save-update"; 
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductSku" fkcolumn="skuID" inversejoincolumn="promotionRewardID" cascade="all" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateSku" fkcolumn="skuID" inversejoincolumn="priceGroupRateID" cascade="all" inverse="true";
	
	// Non-Persistent Properties
	property name="livePrice" formatType="currency" persistent="false" hint="this property should calculate after term sale";
	
	// Non-Persistent Quantity Properties For On Hand & Inventory in Motion (Deligated to the DAO)
	property name="qoh" type="numeric" persistent="false" hint="Quantity On Hand";
	property name="qosh" type="numeric" persistent="false" hint="Quantity On Stock Hold";
	property name="qndoo" type="numeric" persistent="false" hint="Quantity Not Delivered On Order";
	property name="qndorvo" type="numeric" persistent="false" hint="Quantity Not Delivered On Return Vendor Order";
	property name="qndosa" type="numeric" persistent="false" hint="Quantity Not Delivered On Stock Adjustment";
	property name="qnroro" type="numeric" persistent="false" hint="Quantity Not Received On Return Order";
	property name="qnrovo" type="numeric" persistent="false" hint="Quantity Not Received On Vendor Order";
	property name="qnrosa" type="numeric" persistent="false" hint="Quantity Not Received On Stock Adjustment";
	
	// Non-Persistent Quantity Properties For Reporting (Deligated to DAO)
	property name="qr" type="numeric" persistent="false" hint="Quantity Received";
	property name="qs" type="numeric" persistent="false" hint="Quantity Sold";
	
	// Non-Persistent Quantity Properties For Logic & Display Based on On Hand & Inventory in Motion values (Could be calculated here, but delegated to the Service, for Consitency of Product / Sku / Stock)
	property name="qc" type="numeric" persistent="false" hint="Quantity Commited";
	property name="qe" type="numeric" persistent="false" hint="Quantity Expected";
	property name="qnc" type="numeric" persistent="false" hint="Quantity Not Commited";
	property name="qats" type="numeric" persistent="false" hint="Quantity Available To Sell";
	property name="qiats" type="numeric" persistent="false" hint="Quantity Immediately Available To Sell";
	
	// Non-Persistent Quantity Properties For Settings (Because these can be defined in multiple locations it is delectaed to the Service)
	property name="qmin" type="numeric" persistent="false" hint="Quantity Minimum";
	property name="qmax" type="numeric" persistent="false" hint="Quantity Maximum";
	property name="qhb" type="numeric" persistent="false" hint="Quantity Held Back";
	property name="qomin" type="numeric" persistent="false" hint="Quantity Order Minimum";
	property name="qomax" type="numeric" persistent="false" hint="Quantity Order Maximum";
	property name="qvomin" type="numeric" persistent="false" hint="Quantity Vendor Order Minimum";
	property name="qvomax" type="numeric" persistent="false" hint="Quantity Vendor Order Maximum";
	
	
	public Sku function init() {
       // set default collections for association management methods
       if(isNull(variables.Options)) {
       	    variables.options=[];
       }
 	   if(isNull(variables.promotionRewards)) {
	       variables.promotionRewards = [];
	   }
      
       return super.init();
    }
    
    public boolean function isNotDefaultSku() {
    	if(getProduct().getDefaultSku().getSkuID() != getSkuID()) {
    		return true;
    	}
    	return false;
    }
    
    public string function displayOptions(delimiter=" ") {
    	var options = getOptions(sorted=true);
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(options);i++) {
    		var thisOption = options[i];
    		dspOptions = listAppend(dspOptions,thisOption.getOptionName(),arguments.delimiter);
    	}
		return dspOptions;
    }
    
    // override generated setter to get options sorted by optiongroup sortorder
    public array function getOptions(boolean sorted = false) {
    	if(!sorted) {
    		return variables.options;
    	} else {
	    	if(!structKeyExists(variables,"sortedOptions")) {
		    	var options = ORMExecuteQuery(
		    		"select opt from SlatwallOption opt
		    		join opt.skus s
		    		where s.skuID = :skuID
		    		order by opt.optionGroup.sortOrder",
		    		{skuID = this.getSkuID()}
		    	);
		    	variables.sortedOptions = options;
	    	}
	    	return variables.sortedOptions;
	    }
    }

	/******* Association management methods for bidirectional relationships **************/
	
	// Product (many-to-one)
	
	public void function setProduct(required any Product) {
	   variables.product = arguments.product;
	   if(isNew() or !arguments.product.hasSku(this)) {
	       arrayAppend(arguments.product.getSkus(),this);
	   }
	}
	
	public void function removeProduct(any Product) {
	   if(!structKeyExists(arguments,"Product")) {
	   		arguments.Product = variables.product;
	   }
       var index = arrayFind(arguments.Product.getSkus(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Product.getSkus(),index);
       }    
       structDelete(variables,"Product");
    }
    
    // Option (many-to-many)
    public void function addOption(required any Option) {
        if(!hasOption(arguments.option)) {
        	// first add option to this Sku
        	arrayAppend(this.getOptions(),arguments.option);
        	// add this Sku to the option
        	arrayAppend(arguments.Option.getSkus(),this);
        }	
    }
    
    public void function removeOption(required any Option) {
       // first remove the option from this Sku
       if(hasOption(arguments.option)) {
	       var index = arrayFind(this.getOptions(),arguments.option);
	       if(index>0) {
	           arrayDeleteAt(this.getOptions(),index);
	       }
	      // then remove this Sku from the Option
	       var index = arrayFind(arguments.Option.getSkus(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Option.getSkus(),index);
	       }
	   }
    }
    
	// promotionRewards (many-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addSku(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeSku(this);
	}
	
    /************   END Association Management Methods   *******************/
    
    public string function getImageDirectory() {
    	return "#$.siteConfig().getAssetPath()#/assets/Image/Slatwall/product/default/";	
    }
    
    public string function getImagePath() {
    	return this.getImageDirectory() & this.getImageFile();
    }
    
    public string function getImage(string size, numeric width=0, numeric height=0, string alt="", string class="", string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		// Get the expected Image Path
		var path=getImagePath();
		
		// If no image Exists use the defult missing image 
		if(!fileExists(expandPath(path))) {
			path = setting('product_missingimagepath');
		}
		
		// If there were sizes specified, get the resized image path
		if(structKeyExists(arguments, "size") || arguments.width != 0 || arguments.height != 0) {
			path = getResizedImagePath(argumentcollection=arguments);	
		}
		
		// Setup Alt & Class for the image
		if(arguments.alt == "") {
			arguments.alt = "#getProduct().getTitle()#";
		}
		if(arguments.class == "") {
			arguments.class = "skuImage";	
		}
		
		// Try to read and return the image, otherwise don't specify the height and width
		try {
			var img = imageRead(expandPath(path));
			return '<img src="#path#" width="#imageGetWidth(img)#" height="#imageGetHeight(img)#" alt="#arguments.alt#" class="#arguments.class#" />';	
		} catch(any e) {
			return '<img src="#path#" alt="#arguments.alt#" class="#arguments.class#" />';
		}
	}
	
	public string function getResizedImagePath(string size, numeric width=0, numeric height=0, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		if(structKeyExists(arguments, "size")) {
			arguments.size = lcase(arguments.size);
			if(arguments.size eq "l" || arguments.size eq "large") {
				arguments.size = "large";
			} else if (arguments.size eq "m" || arguments.size eq "medium") {
				arguments.size = "medium";
			} else {
				arguments.size = "small";
			}
			arguments.width = setting("product_imagewidth#arguments.size#");
			arguments.height = setting("product_imageheight#arguments.size#");
		}
		arguments.imagePath=getImagePath();
		return getService("utilityFileService").getResizedImagePath(argumentCollection=arguments);
	}
	
	public boolean function imageExists() {
		if( fileExists(expandPath(getImagePath())) ) {
			return true;
		} else {
			return false;
		}
	}
	
	public any function getOptionsByGroupIDStruct() {
		if(!structKeyExists(variables, "OptionsByGroupIDStruct")) {
			variables.OptionsByGroupIDStruct = structNew();
			var options = getOptions();
			for(var i=1; i<=arrayLen(options); i++) {
				if( !structKeyExists(variables.OptionsByGroupIDStruct, options[i].getOptionGroup().getOptionGroupID())){
					variables.OptionsByGroupIDStruct[options[i].getOptionGroup().getOptionGroupID()] = options[i];
				}
			}
		}
		return variables.OptionsByGroupIDStruct;
	}
	
	public any function getOptionByOptionGroupID(required string optionGroupID) {
		var optionsStruct = getOptionsByGroupIDStruct();
		return optionsStruct[arguments.optionGroupID];
	}
	
	// This will give the price based on User logged in, current term sales, volume discounts, ect.
	public numeric function getLivePrice() {
		var prices = [getPrice()];
		
		arrayAppend(prices, getBestPriceByLivePromotions());
		arrayAppend(prices, getPriceByCurrentAccount());
		
		arraySort(prices, "numeric", "asc");
		
		return prices[1];
	}
	
	public numeric function getBestPriceByLivePromotions() {
		//return getService("promotionService").calculateBestSkuPriceBasedOnLivePromotions(sku=this);
		return getPrice();
	}
	
	public numeric function getPriceByPromotion( required any promotion) {
		return getService("promotionService").calculateSkuPriceBasedOnPromotion(sku=this, promotion=arguments.promotion);
	}
	
	public numeric function getPriceByCurrentAccount() {
		return getService("priceGroupService").calculateSkuPriceBasedOnCurrentAccount(sku=this);
	}
	
	public numeric function getPriceByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").calculateSkuPriceBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}
	
	public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").getRateForSkuBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}
	
	// @hint this method validates that this skus has a unique option combination that no other sku has
	public any function hasUniqueOptions() {
		var optionsList = "";
		
		for(var i=1; i<=arrayLen(getOptions()); i++){
			optionsList = listAppend(optionsList, getOptions()[i].getOptionID());
		}
		
		var skus = getProduct().getSkusBySelectedOptions(selectedOptions=optionsList);
		if(!arrayLen(skus) || (arrayLen(skus) == 1 && skus[1].getSkuID() == getSkuID() )) {
			return true;
		}
		
		return false;
	}
	
	// @hint this method validates that this skus has a unique option combination that no other sku has
	public any function hasOneOptionPerOptionGroup() {
		var optionGroupList = "";
		
		for(var i=1; i<=arrayLen(getOptions()); i++){
			if(listFind(optionGroupList, getOptions()[i].getOptionGroup().getOptionGroupID())) {
				return false;
			} else {
				optionGroupList = listAppend(optionGroupList, getOptions()[i].getOptionGroup().getOptionGroupID());	
			}
		}
		
		return true;
	}
	
	//@hint Generates the image path based upon product code, and image options for this sku
	public string function generateImageFileName() {
		var optionString = "";
		for(var option in getOptions()){
			if(option.getOptionGroup().getImageGroupFlag()){
				optionString &= "-#option.getOptionCode()#";
			}
		}
		return "#getProduct().getProductCode()##optionString#.#setting('product_imageextension')#";
	}
	
	//@hint this method generated sku code based on assigned options
	public any function generateSkuCode () {
		var newSkuCode = getProduct().getProductCode();
		for(var option in getOptions() ) {
			newSkuCode = listAppend(newSkuCode,option.getOptionCode(),"-");
		}
		return newSkuCode;
	}

    
	// ============ START: Non-Persistent Property Methods =================
	
	// Non-Persistent Quantity Properties For On Hand & Inventory in Motion (Deligated to the DAO)
	public numeric function getQOH(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQOH();
		}
		if(!structKeyExists(variables, "qoh")) {
			variables.qoh = getService("inventoryService").getQOH(skuID=getSkuID());
		}
		return variables.qoh;
	}
	public numeric function getQOSH(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQOSH();
		}
		if(!structKeyExists(variables, "qosh")) {
			variables.qosh = getService("inventoryService").getQOSH(skuID=getSkuID());
		}
		return variables.qosh;
	}
	public numeric function getQNDOO(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNDOO();
		}
		if(!structKeyExists(variables, "qndoo")) {
			variables.qndoo = getService("inventoryService").getQNDOO(skuID=getSkuID());
		}
		return variables.qndoo;
	}
	public numeric function getQNDORVO(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNDORVO();
		}
		if(!structKeyExists(variables, "qndorvo")) {
			variables.qndorvo = getService("inventoryService").getQNDORVO(skuID=getSkuID());
		}
		return variables.qoh;
	}
	public numeric function getQNDOSA(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNDOSA();
		}
		if(!structKeyExists(variables, "qndosa")) {
			variables.qndosa = getService("inventoryService").getQNDOSA(skuID=getSkuID());
		}
		return variables.qndosa;
	}
	public numeric function getQNRORO(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNRORO();
		}
		if(!structKeyExists(variables, "qnroro")) {
			variables.qnroro = getService("inventoryService").getQNRORO(skuID=getSkuID());
		}
		return variables.qnroro;
	}
	public numeric function getQNROVO(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNROVO();
		}
		if(!structKeyExists(variables, "qnrovo")) {
			variables.qnrovo = getService("inventoryService").getQNROVO(skuID=getSkuID());
		}
		return variables.qnrovo;
	}
	public numeric function getQNROSA(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNROSA();
		}
		if(!structKeyExists(variables, "qnrosa")) {
			variables.qnrosa = getService("inventoryService").getQNROSA(skuID=getSkuID());
		}
		return variables.qnrosa;
	}
	
	// Non-Persistent Quantity Properties For Reporting (Deligated to DAO)
	public numeric function getQR(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQR();
		}
		if(!structKeyExists(variables, "qr")) {
			variables.qr = getService("inventoryService").getQR(skuID=getSkuID());
		}
		return variables.qr;
	}
	public numeric function getQS(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQS();
		}
		if(!structKeyExists(variables, "qs")) {
			variables.qs = getService("inventoryService").getQS(skuID=getSkuID());
		}
		return variables.qs;
	}
	
	// Non-Persistent Quantity Properties For Logic & Display Based on On Hand & Inventory in Motion values (Could be calculated here, but delegated to the Service, for Consitency of Product / Sku / Stock)
	public numeric function getQC(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQC();
		}
		if(!structKeyExists(variables, "qc")) {
			variables.qc = getService("inventoryService").getQC(entity=this);
		}
		return variables.qc;
	}
	public numeric function getQE(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQE();
		}
		if(!structKeyExists(variables, "qe")) {
			variables.qe = getService("inventoryService").getQE(entity=this);
		}
		return variables.qe;
	}
	public numeric function getQNC(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQNC();
		}
		if(!structKeyExists(variables, "qnc")) {
			variables.qnc = getService("inventoryService").getQNC(entity=this);
		}
		return variables.qnc;
	}
	public numeric function getQATS(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQATS();
		}
		if(!structKeyExists(variables, "qats")) {
			variables.qats = getService("inventoryService").getQATS(entity=this);
		}
		return variables.qats;
	}
	public numeric function getQIATS(string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(getSkuID(), arguments.locationID).getQIATS();
		}
		if(!structKeyExists(variables, "qiats")) {
			variables.qiats = getService("inventoryService").getQIATS(entity=this);
		}
		return variables.qiats;
	}
	
	// TODO: These methods are just here so that the calculation stuff will work.  The actuall settings need to be setup
	public numeric function getQMIN() {
		return 0;
	}
	public numeric function getQMAX() {
		return 0;
	}
	public numeric function getQHB() {
		return 0;
	}
	public numeric function getQOMIN() {
		return 0;
	}
	public numeric function getQOMAX() {
		return 0;
	}
	public numeric function getQVOMIN() {
		return 0;
	}
	public numeric function getQVOMAX() {
		return 0;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Alternate Sku Codes (one-to-many)
	public void function addAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.setSku( this );
	}
	public void function removeAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.removeSku( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
    	return "skuCode";
    }
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// Override the preInsert method to set sku code and Image name
    public void function preInsert() {
    	if(isNull(getSkuCode()) || getSkuCode() == "") {
    		setSkuCode(generateSkuCode());
    	}
    	if(isNull(getImageFile()) || getImageFile() == "") {
    		setImageFile(generateImageFileName());
    	}
		super.preInsert();
    }
    
	// ===================  END:  ORM Event Hooks  =========================
}
