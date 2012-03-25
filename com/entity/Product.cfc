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
component displayname="Product" entityname="SlatwallProduct" table="SlatwallProduct" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="productID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hint="As Products Get Old, They would be marked as Not Active";
	property name="urlTitle" ormtype="string" hint="This is the name that is used in the URL string";
	property name="productName" ormtype="string" notNull="true" hint="Primary Notation for the Product to be Called By";
	property name="productCode" ormtype="string" unique="true" hint="Product Code, Typically used for Manufacturer Coded";
	property name="productDescription" ormtype="string" length="4000" hint="HTML Formated description of the Product";
	property name="manufactureDiscontinuedFlag" default="false"	ormtype="boolean" hint="This property can determine if a product can still be ordered by a vendor or not";
	property name="publishedFlag" ormtype="boolean" default="false" hint="Should this product be sold on the web retail Site";
	property name="sortOrder" ormtype="integer";
	
	// Persistent Properties - Inheritence Settings
	property name="allowBackorderFlag" ormtype="boolean";
	property name="allowDropshipFlag" ormtype="boolean";
	property name="allowPreorderFlag" ormtype="boolean";
	property name="allowShippingFlag" ormtype="boolean";
	property name="callToOrderFlag" ormtype="boolean";
	property name="productDisplayTemplate" ormtype="string";
	property name="quantityHeldBack" ormtype="integer";
	property name="quantityMinimum" ormtype="integer";
	property name="quantityMaximum" ormtype="integer";
	property name="quantityOrderMinimum" ormtype="integer";
	property name="quantityOrderMaximum" ormtype="integer";
	property name="shippingWeight" ormtype="integer";
	property name="shippingWeightUnitCode" ormtype="string";
	property name="trackInventoryFlag" ormtype="boolean";
	
	// Related Object Properties (One-To-One)
	property name="productCache" fieldType="one-to-one" cfc="ProductCache" cascade="delete";
		
	// Related Object Properties (many-to-one)
	property name="brand" cfc="Brand" fieldtype="many-to-one" fkcolumn="brandID";
	property name="productType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="productTypeID";
	property name="defaultSku" cfc="Sku" fieldtype="many-to-one" fkcolumn="defaultSkuID" cascade="delete";
	
	// Related Object Properties (one-to-many)
	property name="skus" type="array" cfc="Sku" singularname="Sku" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productImages" type="array" cfc="ProductImage" singularname="ProductImage" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="ProductAttributeValue" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="ProductAttributeSetAssignment" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	property name="productReviews" singlularname="productReview" cfc="ProductReview" fieldtype="one-to-many" fkcolumn="productID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	property name="pages" cfc="Content" fieldtype="many-to-many" linktable="SlatwallProductPage" fkcolumn="productID" inversejoincolumn="contentID";
	property name="categories" singularname="category" cfc="Category" fieldtype="many-to-many" linktable="SlatwallProductCategory" fkcolumn="productID" inversejoincolumn="categoryID";
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProduct" fkcolumn="productID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifierProduct" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierProductProduct" fkcolumn="productID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="PromotionRewardExclusion" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExclusionProduct" fkcolumn="productID" inversejoincolumn="promotionRewardExclusionID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="PromotionQualifierExclusion" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExclusionProduct" fkcolumn="productID" inversejoincolumn="promotionQualifierExclusionID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateProduct" fkcolumn="productID" inversejoincolumn="priceGroupRateID" inverse="true";
	property name="eligibleFulfillmentMethods" singularname="eligibleFulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SlatwallProductEligibleFulfillmentMethod" fkcolumn="productID" inversejoincolumn="fulfillmentMethodID"; 
	property name="relatedProducts" singularname="relatedProduct" cfc="Product" type="array" fieldtype="many-to-many" linktable="SlatwallRelatedProduct" fkcolumn="productID" inversejoincolumn="relatedProductID";

	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="attributeValuesByAttributeIDStruct" type="struct" persistent="false";
	property name="attributeValuesByAttributeCodeStruct" type="struct" persistent="false";
	property name="brandName" type="string" persistent="false";
	property name="productDisplayTemplateOptions" type="array" persistent="false";
	property name="salePriceDetailsForSkus" type="struct" persistent="false";
	property name="shippingWeightUnitCodeOptions" type="array" persistent="false";
	property name="title" type="string" persistent="false";
	
	// Non-Persistent Properties - Delegated to default sku
	property name="price" type="numeric" formatType="currency" persistent="false";
	property name="listPrice" type="numeric" formatType="currency" persistent="false";
	property name="livePrice" type="numeric" formatType="currency" persistent="false";
	property name="salePrice" type="numeric" formatType="currency" persistent="false";
	
	public Product function init(){
	   // set default collections for association management methods
	   if(isNull(variables.activeFlag)) {
	       variables.activeFlag = 1;
	   }
	   if(isNull(variables.pages)) {
	       variables.pages = [];
	   }
	   if(isNull(variables.categories)) {
	       variables.categories = [];
	   }
	   if(isNull(variables.Skus)) {
	       variables.Skus = [];
	   }
	   if(isNull(variables.attributeValues)) {
	       variables.attributeValues = [];
	   }	   
	   if(isNull(variables.attributeSetAssignments)) {
	       variables.attributeSetAssignments = [];
	   }
	   if(isNull(variables.promotionRewards)) {
	       variables.promotionRewards = [];
	   }
	   if(isNull(variables.relatedProducts)) {
	       variables.relatedProducts = [];
	   }
	   if(isNull(variables.productReviews)) {
	       variables.productReviews = [];
	   }
	   if(isNull(variables.productImages)) {
	       variables.productImages = [];
	   }
	   if(isNull(variables.eligibleFulfillmentMethods)) {
	       variables.eligibleFulfillmentMethods = [];
	   }
	   return Super.init();
	}
	
    public any function getProductTypeOptions() {
		if(!structKeyExists(variables, "productTypeOptions")) {
			var productTypeTree = getProductTypeTree();
			var productTypeOptions = [];
			
			for(var i=1; i <= productTypeTree.recordCount; i++) {
				// only get the leaf nodes of the tree (those with no children)
				if( productTypeTree.childCount[i] == 0 ) {
					arrayAppend(productTypeOptions, {value=productTypeTree.productTypeID[i], name=listChangeDelims(productTypeTree.productTypeNamePath[i], " &raquo; ")});
				}
			}
			
			variables.productTypeOptions = productTypeOptions;
			arrayPrepend(variables.productTypeOptions, {value="", name=rbKey('define.select')});
		}
		return variables.productTypeOptions;
	}
    
    public any function getProductTypeTree() {
        return getService("ProductService").getProductTypeTree();
    }
    
    public array function getSkus(boolean sorted=false, boolean fetchOptions=false) {
        if(!arguments.sorted && !arguments.fetchOptions) {
        	return variables.skus;
        }
        return getService("skuService").getProductSkus(product=this, sorted=arguments.sorted, fetchOptions=arguments.fetchOptions);
    }
	
	public any function getSkuByID(required string skuID) {
		var skus = getSkus();
		for(var i = 1; i <= arrayLen(skus); i++) {
			if(skus[i].getSkuID() == arguments.skuID) {
				return skus[i];
			}
		}
	}
	
	public any function getTemplateOptions() {
		if(!isDefined("variables.templateOptions")){
			variables.templateOptions = getService("ProductService").getProductTemplates();
		}
		return variables.templateOptions;
	}
	
	public any function getImages() {
		return variables.productImages;
	}
	
	public struct function getSkuSalePriceDetails( required any skuID ) {
		if(structKeyExists(getSalePriceDetailsForSkus(), arguments.skuID)) {
			return getSalePriceDetailsForSkus()[ arguments.skuID ];
		}
		return {};
	}
	
	// Non-Persistent Helpers
	
	public string function getPageIDs() { 
		var pageIDs = "";
		for( var i=1; i<= arrayLen(getPages()); i++ ) {
			pageIDs = listAppend(pageIDs,getPages()[i].getPageID());
		}
		return pageIDs;
	}
	
	public string function getCategoryIDs() { 
		var categoryIDs = "";
		for( var i=1; i<= arrayLen(getCategories()); i++ ) {
			categoryIDs = listAppend(categoryIDs,getCategories()[i].getCategoryID());	
		}
		return categoryIDs;
	}
	
	public string function getProductURL() {
		return $.createHREF(filename="#setting('product_urlKey')#/#getURLTitle()#");
	}
	
	public string function getListingProductURL(string filename=$.content('filename')) {
		return $.createHREF(filename="#arguments.filename#/#setting('product_urlKey')#/#getURLTitle()#");
	}
	
	public string function getTemplate() {
		if(!structKeyExists(variables, "template") || variables.template == "") {
			return setting('product_defaultTemplate');
		} else {
			return variables.template;
		}
	}
	
	public string function getAlternateImageDirectory() {
    	return "#$.siteConfig().getAssetPath()#/assets/Image/Slatwall/product/";	
    }
    
    public numeric function getProductRating() {
    	var totalRatingPoints = 0;
    	var averageRating = 0;
    	
    	if(arrayLen(getProductReviews())) {
	    	for(var i=1; i<=arrayLen(getProductReviews()); i++) {
	    		var totalRatingPoints += getProductReviews()[1].getRating();
	    	}
	    	averageRating = totalRatingPoints / arrayLen(getProductReviews());
    	}
    	
    	return averageRating;
    }
	
	
	// Product Type (many-to-one)
	
	public void function setProductType(required ProductType ProductType) {
	   variables.productType = arguments.ProductType;
	   if(isNew() or !arguments.ProductType.hasProduct(this)) {
	       arrayAppend(arguments.ProductType.getProducts(),this);
	   }
	}
	
	public void function removeProductType(required ProductType ProductType) {
       var index = arrayFind(arguments.ProductType.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.ProductType.getProducts(),index);
       }    
       structDelete(variables,"productType");
    }
    
    // Brand (many-to-one)
	
	public void function setBrand(required Brand Brand) {
	   variables.Brand = arguments.Brand;
	   if(isNew() or !arguments.Brand.hasProduct(this)) {
	       arrayAppend(arguments.Brand.getProducts(),this);
	   }
	}
	
	public void function removeBrand(required Brand Brand) {
       var index = arrayFind(arguments.Brand.getProducts(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.Brand.getProducts(),index);
       }    
       structDelete(variables,"Brand");
    }
	
	
	// Skus (one-to-many)
	
	public void function setSkus(required array skus) {
		// first, clear existing collection
		variables.skus = [];
		for( var i=1; i<= arraylen(arguments.Skus); i++ ) {
			var thisSku = arguments.skus[i];
			if(isObject(thisSku) && thisSku.getClassName() == "SlatwallSku") {
				addSku(thisSku);
			}
		}
	}
	
	public void function addSku(required any sku) {
	   arguments.sku.setProduct(this);
	}
	
	public void function removeSku(required any sku) {
	   arguments.sku.removeProduct(this);
	}
	
	// attributeValues (one-to-many)
	public void function addAttribtueValue(required any attributeValue) {
	   arguments.attributeValue.setProduct(this);
	}
	
	public void function removeAttributeValue(required any attributeValue) {
	   arguments.attributeValue.removeProduct(this);
	}
	
	// productReviews (one-to-many)
	public void function addProductReview(required any productReview) {
	   arguments.productReview.setProduct(this);
	}
	
	public void function removeProductReview(required any productReview) {
	   arguments.productReview.removeProduct(this);
	}
	
	// promotionRewards (many-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addProduct(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeProduct(this);
	}
	
	// promotionQualifiers (many-to-many)
	public void function addPromotionQualifier(required any promotionQualifier) {
	   arguments.promotionQualifier.addProduct(this);
	}
	
	public void function removePromotionQualifier(required any promotionQualifier) {
	   arguments.promotionQualifier.removeProduct(this);
	}
	
	// promotionRewardExclusions (many-to-many)
	public void function addPromotionRewardExclusion(required any promotionRewardExclusion) {
	   arguments.promotionRewardExclusion.addProduct(this);
	}
	
	public void function removePromotionRewardExclusion(required any promotionRewardExclusion) {
	   arguments.promotionRewardExclusion.removeProduct(this);
	}
	
	// promotionQualifierExclusions (many-to-many)
	public void function addPromotionQualifierExclusion(required any promotionQualifierExclusion) {
	   arguments.promotionQualifierExclusion.addProduct(this);
	}
	
	public void function removePromotionQualifierExclusion(required any promotionQualifierExclusion) {
	   arguments.promotionQualifierExclusion.removeProduct(this);
	}
	
	// product images (one-to-many)
	public void function addProductImage(required any productImage) {
	   arguments.productImage.setProduct(this);
	}
	
	public void function removeProductImage(required any productImage) {
	   arguments.productImage.removeProduct(this);
	}
	
	/************   END Association Management Methods   *******************/

	public struct function getOptionGroupsStruct() {
		if( !structKeyExists(variables, "optionGroupsStruct") ) {
			variables.optionGroupsStruct = {};
			for(var optionGroup in getOptionGroups()){
				variables.optionGroupsStruct[optionGroup.getOptionGroupID()] = optionGroup;
			}
		}
		return variables.optionGroupsStruct;
	}
	
	public array function getOptionGroups() {
		if( !structKeyExists(variables, "optionGroups") ) {
			variables.optionGroups = [];
			var smartList = getService("OptionService").getOptionGroupSmartList();
			smartList.addFilter("options_skus_product_productID",this.getProductID());
			smartList.addOrder("sortOrder|ASC");
			variables.optionGroups = smartList.getRecords();
		}
		return variables.optionGroups;
	}
	
	public numeric function getOptionGroupCount() {
		return arrayLen(getOptionGroups());
	}
	
	// Start: Functions that delegate to the default sku
    public string function getImageDirectory() {
    	return getDefaultSku().getImageDirectory();	
    }
    
	public string function getImage(string size, numeric width, numeric height, string class, string alt, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		return getDefaultSku().getImage(argumentCollection = arguments);
	}
	
	public string function getImagePath() {
		return getDefaultSku().getImagePath();
	}
	
	public string function getResizedImagePath(string size, numeric width, numeric height, string resizeMethod="scale", string cropLocation="",numeric cropXStart=0, numeric cropYStart=0,numeric scaleWidth=0,numeric scaleHeight=0) {
		return getDefaultSku().getResizedImagePath(argumentCollection = arguments);
	}
	
	public array function getImageGalleryArray(array resizeSizes=[{size='s'},{size='m'},{size='l'}]) {
		var imageGalleryArray = [];
		var filenames = "";
		
		// Add all skus's default images
		for(var i=1; i<=arrayLen(getSkus()); i++) {
			if( !listFind(filenames, getSkus()[i].getImageFile()) ) {
				filenames = listAppend(filenames, getSkus()[i].getImageFile());
				var thisImage = {};
				thisImage.originalFilename = getSkus()[i].getImageFile();
				thisImage.originalPath = getSkus()[i].getImagePath();
				thisImage.type = "skuDefaultImage";
				thisImage.productID = getProductID();
				thisImage.name = getTitle();
				thisImage.description = getProductDescription();
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getSkus()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		// Add all alternate image paths
		for(var i=1; i<=arrayLen(getImages()); i++) {
			if( !listFind(filenames, getImages()[i].getImageID()) ) {
				filenames = listAppend(filenames, getImages()[i].getImageID());
				var thisImage = {};
				thisImage.originalFilename = getImages()[i].getImageID() & "." & getImages()[i].getImageExtension();
				thisImage.originalPath = getImages()[i].getImagePath();
				thisImage.type = "productAlternateImage";
				thisImage.skuID = "";
				thisImage.productID = getProductID();
				thisImage.name = "";
				if(!isNull(getImages()[i].getImageName())) {
					thisImage.name = getImages()[i].getImageName();
				}
				thisImage.description = "";
				if(!isNull(getImages()[i].getImageDescription())) {
					thisImage.name = getImages()[i].getImageDescription();
				}
				thisImage.resizedImagePaths = [];
				for(var s=1; s<=arrayLen(arguments.resizeSizes); s++) {
					arrayAppend(thisImage.resizedImagePaths, getImages()[i].getResizedImagePath(argumentCollection = arguments.resizeSizes[s]));
				}
				arrayAppend(imageGalleryArray, thisImage);
			}
		}
		
		return imageGalleryArray;
	}
	
	//get merchandisetype 
	public any function getBaseProductType() {
		return getProductType().getBaseProductType();
	}
	
	//get eligibleFulfillmentMethods
	public array function getEligibleFulfillmentMethods() {
		if(!arrayLen(getEligibleFulfillmentMethods())) {
			return getProductType().getEligibleFulfillmentMethods();
		}
		return variables.eligibleFulfillmentMethods;
	}
	
	public array function getOptionsByOptionGroup(required string optionGroupID) {
		var smartList = getService("optionService").getOptionSmartList();
		smartList.addFilter("optionGroup_optionGroupID",arguments.optionGroupID);
		smartList.addFilter("skus_product_productID",this.getProductID());
		smartList.addOrder("sortOrder|ASC");
		return smartList.getRecords();
	}

	public any function getSkuBySelectedOptions(string selectedOptions="") {
		if(len(arguments.selectedOptions) > 0) {
			var skus = getSkusBySelectedOptions(selectedOptions=arguments.selectedOptions);
			if(arrayLen(skus) == 1) {
				return skus[1];
			} else if (arrayLen(skus) > 1) {
				throw("More than one sku is returned when the selected options are: #arguments.selectedOptions#");
			} else if (arrayLen(skus) < 1) {
				throw("No Skus are found for these selected options: #arguments.selectedOptions#");
			}
		} else if (arrayLen(getSkus()) == 1) {
			return getSkus()[1];
		} else {
			throw("You must submit a comma seperated list of selectOptions to find an indvidual sku in this product");
		}
	}
	
	public any function getSkusBySelectedOptions(string selectedOptions="") {
		return getService("productService").getProductSkusBySelectedOptions(arguments.selectedOptions,this.getProductID());
	}
	
	// get all the assigned attribute sets
	public array function getAttributeSets(array attributeSetTypeCode){
		var attributeSets = [];
		// get all the parent product types
		if(!isNull(getProductType())){
			return getService("ProductService").getAttributeSets(arguments.attributeSetTypeCode,listToArray(getProductType().getProductTypeIDPath()));
		} else {
			return attributeSets;
		}
	}
	
	//get attribute value
	public any function getAttributeValueOld(required string attribute, returnEntity=false){
		var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallProductAttributeValue");
		
		smartList.addFilter("product_productID",getProductID(),1);
		smartList.addFilter("attribute_attributeID",attribute,1);
		
		smartList.addFilter("product_productID",getProductID(),2);
		smartList.addFilter("attribute_attributeCode",attribute,2);
		
		var attributeValue = smartList.getRecords();
		
		if(arrayLen(attributeValue)){
			if(returnEntity) {
				return attributeValue[1];	
			} else {
				return attributeValue[1].getAttributeValue();
			}
		}else{
			if(returnEntity) {
				return getService("ProductService").newProductAttributeValue();	
			} else {
				return "";
			}
		}
	}
	
	//get attribute value2
	
	public any function getAttributeValue(required string attribute, returnEntity=false){
		
		if(len(arguments.attribute) eq 32) {
			if( structKeyExists(getAttributeValuesByAttributeIDStruct(), arguments.attribute) ) {
				if(arguments.returnEntity) {
					return getAttributeValuesByAttributeIDStruct()[arguments.attribute];
				}
				return getAttributeValuesByAttributeIDStruct()[arguments.attribute].getAttributeValue();
			}
		}
		
		if( structKeyExists(getAttributeValuesByAttributeCodeStruct(), arguments.attribute) ) {
			if(arguments.returnEntity) {
				return getAttributeValuesByAttributeCodeStruct()[ arguments.attribute ];
			}
			
			return getAttributeValuesByAttributeCodeStruct()[ arguments.attribute ].getAttributeValue();
		}
				
		if(arguments.returnEntity) {
			return getService("ProductService").newProductAttributeValue();	
		}
		
		return "";
	}
	
	public struct function getCrumbData(required string path, required string siteID, required array baseCrumbArray) {
		var productFilename = replace(arguments.path, "/#arguments.siteID#/", "", "all");
		productFilename = left(productFilename, len(productFilename)-1);
		
		var productCrumbData = {
			contentHistID = "",
			contentID = "",
			filename = productFilename,
			inheritobjects = "Cascade",
			menuTitle = getTitle(),
			metaDesc = "",
			metaKeywords = "",
			parentArray = arguments.baseCrumbArray[1].parentArray,
			parentID = "",
			restricted = 0,
			retrictgroups = "",
			siteid = arguments.siteID,
			sortby = "orderno",
			sortdirection = "asc",
			target = "_self",
			targetPrams = "",
			template = "",
			type = "Page"
		};
		
		return productCrumbData;
	}
	
	public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup ) {
		return getService("priceGroupService").getRateForProductBasedOnPriceGroup(product=this, priceGroup=arguments.priceGroup);
	}
	
	// Start: Quantity Methods
	
	public numeric function getQuantity(required string quantityType, string skuID, string locationID) {
		if(structKeyExists(arguments, "skuID")) {
			return getService("skuService").getSku(arguments.skuID).invokeMethod("getQuantity", arguments);
		}
		if(!structKeyExists(variables, quantityType)) {
			if(listFindNoCase("QOH,QOSH,QNDOO,QNDORVO,QNDOSA,QNRORO,QNROVO,QNROSA", arguments.quantityType)) {
				variables[quantityType] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {productID=getProductID(), productRemoteID=getRemoteID()});	
			} else if(listFindNoCase("QC,QE,QNC,QATS,QIATS", arguments.quantityType)) {
				variables[quantityType] = getService("inventoryService").invokeMethod("get#arguments.quantityType#", {entity=this});
			} else {
				throw("The quantity type you passed in '#arguments.quantityType#' is not a valid quantity type.  Valid quantity types are: QOH, QOSH, QNDOO, QNDORVO, QNDOSA, QNRORO, QNROVO, QNROSA, QC, QE, QNC, QATS, QIATS");
			}
		}
		return variables[quantityType];
	}
	
	// END: Quantity Methods
	
	// Start: Setting Methods
	
	// Generic setting accessor
	public any function getSetting( required string settingName ) {
		if(structKeyExists(variables,arguments.settingName)) {
			return variables[arguments.settingName];
		}
		
		return getInheritedSetting( arguments.settingName );
	}
	
	// Get the setting inherited
	public any function getInheritedSetting( required string settingName ) {
		if(!isNull(getProductType())) {
			return getProductType().getSetting(arguments.settingName);
		}
		
		// so a CF error won't be thrown during validtion if the product type wasn't selected
		return setting("product_" & arguments.settingName);
	}
	
	// Get source of setting
	public any function getWhereSettingDefined( required string settingName ) {
		if(structKeyExists(variables,arguments.settingName)) {
			return {type="Product"};
		} else if(!isNull(getProductType())) {
			return getProductType().getWhereSettingDefined( arguments.settingName );
		}

		// so a CF error won't be thrown during validtion if the product type wasn't selected
		return {type="Global"};
	}
	
	// END: Setting Methods
	
	// ============ START: Non-Persistent Property Methods =================
	
	public struct function getAttributeValuesByAttributeIDStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeIDStruct")) {
			variables.attributeValuesByAttributeIDStruct = {};
			for(var i=1; i<=arrayLen(getAttributeValues()); i++){
				variables.attributeValuesByAttributeIDStruct[ getAttributeValues()[i].getAttribute().getAttributeID() ] = getAttributeValues()[i];
			}
		}
		
		return variables.attributeValuesByAttributeIDStruct;
	}
	
	public struct function getAttributeValuesByAttributeCodeStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeCodeStruct")) {
			variables.attributeValuesByAttributeCodeStruct = {};
			for(var i=1; i<=arrayLen(getAttributeValues()); i++){
				variables.attributeValuesByAttributeCodeStruct[ getAttributeValues()[i].getAttribute().getAttributeCode() ] = getAttributeValues()[i];
			}
		}
		
		return variables.attributeValuesByAttributeCodeStruct;
	}
	
	public struct function getSalePriceDetailsForSkus() {
		if(!structKeyExists(variables, "salePriceDetailsForSkus")) {
			variables.salePriceDetailsForSkus = getService("promotionService").getSalePriceDetailsForProductSkus(productID=getProductID());
		}
		return variables.salePriceDetailsForSkus;
	}
	
	public any function getProductDisplayTemplateOptions() {
		if(!structKeyExists(variables, "productDisplayTemplateOptions")) {
			variables.productDisplayTemplateOptions = getService("productService").getProductTemplates(siteID=$.event('siteid'));
			arrayPrepend(variables.productDisplayTemplateOptions, {value="", name="#rbKey('setting.inherit')# ( #getInheritedSetting('productDisplayTemplate')# )"});
		}
		
		return variables.productDisplayTemplateOptions;
	}
	
	public any function getShippingWeightUnitCodeOptions() {
		if(!structKeyExists(variables, "shippingWeightUnitCodeOptions")) {
			variables.shippingWeightUnitCodeOptions = getService("settingService").getMeaurementUnitOptions(measurementType="weight");
			arrayPrepend(variables.shippingWeightUnitCodeOptions, {value="", name="#rbKey('setting.inherit')# ( #getInheritedSetting('shippingWeightUnitCode')# )"});
		}
		return variables.shippingWeightUnitCodeOptions; 
	}

	public string function getBrandName() {
		if(!structKeyExists(variables, "brandName")) {
			variables.brandName = "";
			if( structKeyExists(variables, "brand") ) {
				return getBrand().getBrandName();
			}
		}
		return variables.brandName;
	}
	
	public string function getTitle() {
		if(!structKeyExists(variables, "title")) {
			variables.title = getService("utilityService").replaceStringTemplate(template=setting('product_titleString'), object=this);
		}
		return variables.title;
	}
	
	
	public numeric function getPrice() {
		if(!structKeyExists(variables, "price")) {
			variables.price = 0;
			if( structKeyExists(variables,"defaultSku") ) {
				variables.price = getDefaultSku().getPrice();
			}
		}
		return variables.price;
	}
	
	public numeric function getListPrice() {
		if(!structKeyExists(variables, "listPrice")) {
			variables.listPrice = 0;
			if( structKeyExists(variables,"defaultSku") ) {
				variables.listPrice = getDefaultSku().getListPrice();
			}	
		}
		return variables.listPrice;
	}
	
	public numeric function getLivePrice() {
		if(!structKeyExists(variables, "livePrice")) {
			variables.livePrice = 0;
			if( structKeyExists(variables,"defaultSku") ) {
				variables.livePrice = getDefaultSku().getLivePrice();
			}
		}
		return variables.livePrice;
	}
	
	public numeric function getSalePrice() {
		if(!structKeyExists(variables, "salePrice")) {
			variables.salePrice = 0;
			if( structKeyExists(variables,"defaultSku") ) {
				variables.salePrice = getDefaultSku().getSalePrice();
			}
		}
		return variables.salePrice;
	}
	
	
	public any function getSalePriceDiscountType() {
		if(!structKeyExists(variables, "salePriceDiscountType")) {
			variables.salePriceDiscountType = "none";
			if( structKeyExists(variables, "defaultSku") ) {
				variables.salePriceDiscountType = getDefaultSku().getSalePriceDiscountType();
			}
		}
		return variables.salePriceDiscountType;
	}
	
	public date function getSalePriceExpirationDateTime() {
		if(!structKeyExists(variables, "salePriceExpirationDateTime")) {
			variables.salePriceExpirationDateTime = now();
			if( structKeyExists(variables,"defaultSku") ) {
				variables.salePriceExpirationDateTime = getDefaultSku().getSalePricExpirationDateTime();
			}
		}
		return variables.salePriceExpirationDateTime;
	}

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "productName";
	}
	
	public boolean function isDeletable() {
		var pot = getService("productService").getProductIsOnTransaction(product=this);
		if(!pot) {
			return super.isDeletable();
		}
		return false;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function postInsert() {
		super.postInsert();
		getService("skuCacheService").updateFromProduct( this );
	}
	
	public void function postUpdate() {
		super.postUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromProduct( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}