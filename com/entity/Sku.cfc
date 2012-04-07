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
	property name="activeFlag" ormtype="boolean" default="1";
	property name="skuCode" ormtype="string" unique="true" length="50";
	property name="listPrice" ormtype="big_decimal" formatType="currency" default="0";
	property name="price" ormtype="big_decimal" formatType="currency" default="0";
	property name="renewalPrice" ormtype="big_decimal" formatType="currency" default="0";
	property name="imageFile" ormtype="string" length="50";
	
	// Related Object Properties (many-to-one)
	property name="product" fieldtype="many-to-one" fkcolumn="productID" cfc="Product";
	property name="subscriptionTerm" cfc="SubscriptionTerm" fieldtype="many-to-one" fkcolumn="subscriptionTermID";
	
	// Related Object Properties (one-to-many)
	property name="stocks" singularname="stock" fieldtype="one-to-many" fkcolumn="skuID" cfc="Stock" inverse="true" cascade="all";
	property name="alternateSkuCodes" singularname="alternateSkuCode" fieldtype="one-to-many" fkcolumn="skuID" cfc="AlternateSkuCode" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many - owner)
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallSkuOption" fkcolumn="skuID" inversejoincolumn="optionID"; 
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifierProduct" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierProductSku" fkcolumn="skuID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="accessContents" singularname="accessContent" cfc="Content" type="array" fieldtype="many-to-many" linktable="SlatwallSkuAccessContent" fkcolumn="skuID" inversejoincolumn="contentID"; 
	property name="subscriptionBenefits" singularname="subscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SlatwallSkuSubscriptionBenefit" fkcolumn="skuID" inversejoincolumn="subscriptionBenefitID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductSku" fkcolumn="skuID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateSku" fkcolumn="skuID" inversejoincolumn="priceGroupRateID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="optionsDisplay" persistent="false";
	property name="currentAccountPrice" type="numeric" formatType="currency" persistent="false";
	property name="livePrice" type="numeric" formatType="currency" persistent="false";
	property name="salePriceDetails" type="struct" persistent="false";
	property name="salePrice" type="numeric" formatType="currency" persistent="false";
	property name="salePriceDiscountType" type="string" persistent="false";
	property name="salePriceDiscountAmount" type="string" persistent="false";
	property name="salePriceExpirationDateTime" type="date" formatType="datetime" persistent="false";
	property name="defaultFlag" type="boolean" persistent="false";
	
	public Sku function init() {
       // set default collections for association management methods
       if(isNull(variables.Options)) {
       	    variables.options=[];
       }
 	   if(isNull(variables.promotionRewards)) {
	       variables.promotionRewards = [];
	   }
 	   if(isNull(variables.promotionQualifiers)) {
	       variables.promotionQualifiers = [];
	   }
	   if(isNull(variables.priceGroupRates)) {
	   	   variables.priceGroupRates = [];
	   }
 	   if(isNull(variables.accessContents)) {
	       variables.accessContents = [];
	   }
 	   if(isNull(variables.subscriptionBenefits)) {
	       variables.subscriptionBenefits = [];
	   }
 	   if(isNull(variables.eligibleFulfillmentMethods)) {
	       variables.eligibleFulfillmentMethods = [];
	   }

       return super.init();
    }
    
    public boolean function getDefaultFlag() {
    	if(getProduct().getDefaultSku().getSkuID() == getSkuID()) {
    		return true;
    	}
    	return false; 
    }
    
    // used by validate this
    public boolean function isNotDefaultSku() {
		return !getDefaultFlag();
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
		return "#getProduct().getProductCode()##optionString#.#setting('globalImageExtension')#";
	}
	
	//@hint this method generated sku code based on assigned options
	public any function generateSkuCode () {
		var newSkuCode = getProduct().getProductCode();
		if(arrayLen(getOptions())) {
			for(var option in getOptions() ) {
				newSkuCode = listAppend(newSkuCode,option.getOptionCode(),"-");
			}
		} else {
			// if no options then generate code based on count
			newSkuCode = newSkuCode & "-" & arrayLen(getProduct().getSkus());
		}
		return newSkuCode;
	}
    
    public string function getOptionsDisplay(delimiter=" ") {
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(getOptions());i++) {
    		dspOptions = listAppend(dspOptions, getOptions()[i].getOptionName(), arguments.delimiter);
    	}
		return dspOptions;
    }
    
    public string function displayOptions(delimiter=" ") {
    	var dspOptions = "";
    	for(var i=1;i<=arrayLen(getOptions());i++) {
    		dspOptions = listAppend(dspOptions, getOptions()[i].getOptionName(), arguments.delimiter);
    	}
		return dspOptions;
    }
    
    // Start: Option Helper Methods
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
    
    // END: Option Helper Methods
    
    // START: Image Methods
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
			path = setting('globalMissingImagePath');
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
			arguments.width = setting("productImage#arguments.size#Width");
			arguments.height = setting("productImage#arguments.size#Height");
		}
		arguments.imagePath=getImagePath();
		return getService("imageService").getResizedImagePath(argumentCollection=arguments);
	}
	
	public boolean function imageExists() {
		if( fileExists(expandPath(getImagePath())) ) {
			return true;
		} else {
			return false;
		}
	}
	
	// END: Image Methods
	
	//get BaseProductType 
	public any function getBaseProductType() {
		return this.getProduct().getBaseProductType();
	}
	
	// START: Price Methods
	public numeric function getPriceByPromotion( required any promotion) {
		return getService("promotionService").calculateSkuPriceBasedOnPromotion(sku=this, promotion=arguments.promotion);
	}
	
	public numeric function getPriceByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").calculateSkuPriceBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}
	
	public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").getRateForSkuBasedOnPriceGroup(sku=this, priceGroup=arguments.priceGroup);
	}
	// END: Price Methods
	
	// Start: Quantity Helper Methods
	public numeric function getQuantity(required string quantityType, string locationID) {
		if(structKeyExists(arguments, "locationID")) {
			return getService("stockService").getStockBySkuAndLocation(this, getService("locationService").getLocation(arguments.locationID)).invokeMethod("getQuantity", {quantityType=arguments.quantityType});
		}
		if(!structKeyExists(variables, quantityType)) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA", arguments.quantityType)) {
				variables[quantityType] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {skuID=getSkuID(), skuRemoteID=getRemoteID()});	
			} else if(listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType)) {
				variables[quantityType] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[quantityType];
	}
	// END: Quantity Helper Methods
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getCurrentAccountPrice() {
		if(!structKeyExists(variables, "currentAccountPrice")) {
			variables.currentAccountPrice = getService("priceGroupService").calculateSkuPriceBasedOnCurrentAccount(sku=this);
		}
		return variables.currentAccountPrice;
	}
	
	public any function getLivePrice() {
		if(!structKeyExists(variables, "livePrice")) {
			// Create a prices array, and add the 
			var prices = [getPrice()];
			
			// Add the current account price, and sale price
			arrayAppend(prices, getSalePrice());
			arrayAppend(prices, getCurrentAccountPrice());
			
			// Sort by best price
			arraySort(prices, "numeric", "asc");
			
			// set that in the variables scope
			variables.livePrice = prices[1];
		}
		return variables.livePrice;
	}
	
	public any function getSalePriceDetails() {
		if(!structKeyExists(variables, "salePriceDetails")) {
			variables.salePriceDetails = getProduct().getSkuSalePriceDetails( getSkuID() );
		}
		return variables.salePriceDetails;
	}
	
	public any function getSalePrice() {
		if(structKeyExists(getSalePriceDetails(), "salePrice")) {
			return getSalePriceDetails()[ "salePrice"];
		}
		return getPrice();
	}
	
	public any function getSalePriceDiscountType() {
		if(structKeyExists(getSalePriceDetails(), "salePriceDiscountType")) {
			return getSalePriceDetails()[ "salePriceDiscountType"];
		}
		return "";
	}
	
	public any function getSalePriceExpirationDateTime() {
		if(structKeyExists(getSalePriceDetails(), "salePriceExpirationDateTime")) {
			return getSalePriceDetails()[ "salePriceExpirationDateTime"];
		}
		return "";
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasSku( this )) {
			arrayAppend(arguments.product.getSkus(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getSkus(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getSkus(), index);
		}
		structDelete(variables, "product");
	}
	
	// Stocks (one-to-many)
	public void function addStock(required any stock) {
		arguments.stock.setSku( this );
	}
	public void function removeStock(required any stock) {
		arguments.stock.removeSku( this );
	}
	
	// Alternate Sku Codes (one-to-many)
	public void function addAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.setSku( this );
	}
	public void function removeAlternateSkuCode(required any alternateSkuCode) {
		arguments.alternateSkuCode.removeSku( this );
	}

	// Promotion Rewards (one-to-many)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addSku( this );
	}
	
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeSku( this );
	}

	// Promotion Qualifiers (one-to-many)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addSku( this );
	}
	
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeSku( this );
	}
	
	// Access Contents (many-to-many - owner)    
	public void function addAccessContent(required any accessContent) {    
		if(isNew() or !hasAccessContent(arguments.accessContent)) {    
			arrayAppend(variables.accessContents, arguments.accessContent);    
		}    
		if(arguments.accessContent.isNew() or !arguments.accessContent.hasSku( this )) {    
			arrayAppend(arguments.accessContent.getSkus(), this);    
		}    
	}    
	public void function removeAccessContent(required any accessContent) {    
		var thisIndex = arrayFind(variables.accessContents, arguments.accessContent);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.accessContents, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.accessContent.getSkus(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.accessContent.getSkus(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
    	return "skuCode";
    }
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert() {
    	// Set sku code and Image name if they are null or blank
    	if(isNull(getSkuCode()) || getSkuCode() == "") {
    		setSkuCode(generateSkuCode());
    	}
    	if(isNull(getImageFile()) || getImageFile() == "") {
    		setImageFile(generateImageFileName());
    	}
		super.preInsert();
		getService("productCacheService").updateFromProduct( this );
    }
    
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		getService("productCacheService").updateFromProduct( this );
	}
    
	// ===================  END:  ORM Event Hooks  =========================
}
