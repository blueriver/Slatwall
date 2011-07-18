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
component extends="Slatwall.com.service.BaseService" persistent="false" accessors="true" output="false" {

	property name="optionService" type="any";

	public any function getSkuSmartList(string productID, struct data={}){
		arguments.entityName = "SlatwallSku";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		if( structKeyExists(arguments,"productID") ) {
			smartList.addFilter(propertyIdentifier="product_productID", value=arguments.productID);
		}
		
		return smartList;
	}
	
	public any function delete(required any sku) {
		if(arrayLen(arguments.sku.getProduct().getSkus()) == 1) {
			getValidationService().setError(entity=arguments.sku,errorname="delete",rule="oneSku");
		}
		
		if(arguments.sku.getSkuID() == arguments.sku.getProduct().getDefaultSku().getSkuID()) {
			getValidationService().setError(entity=arguments.sku,errorname="delete",rule="isDefault");	
		}
		
		if(arguments.sku.getOrderedFlag() == true) {
			getValidationService().setError(entity=arguments.sku,errorname="delete",rule="Ordered");	
		}
		if(!arguments.sku.hasErrors()) {
			arguments.sku.removeProduct();
		}
		var deleted = Super.delete(arguments.sku);
		return deleted;
	}

	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice, required shippingWeight) {
		// check to see if any options were selected
		if(len(arguments.optionsStruct.formCollectionsList)) {
			var options = arguments.optionsStruct.options;
			var comboList = getOptionCombinations(options);
			createSkusFromOptions(comboList,arguments.product,arguments.price,arguments.listprice,arguments.shippingWeight);
		} else {  // no options were selected so create a default sku
			var thisSku = this.newSku();
			thisSku.setProduct(arguments.product);
			thisSku.setPrice(arguments.price);
			thisSku.setListPrice(arguments.listprice);
			thisSku.setShippingWeight(arguments.shippingWeight);
			thisSku.setSkuCode(arguments.product.getProductCode() & "-0000");
			thisSku.setImageFile(generateImageFileName(thisSku));
			arguments.product.setDefaultSku(thisSku);
		}
		return true;
	}

	/**
	/* @hint takes a list of optionID combinations and generates skus
	*/
	public void function createSkusFromOptions (required string comboList, required any product, required price, required listPrice, required shippingWeight) {
		for(  i=1; i<=listLen(arguments.comboList,";");i++ ) {
			//every option combination represents 1 Sku, so we create it
			var thisCombo = listGetAt(arguments.comboList,i,";");
			var thisSku = createSkuFromStruct({options=thisCombo,price=arguments.price,listPrice=arguments.listPrice,shippingWeight=arguments.shippingWeight},arguments.product);
			// set the first sku as the default one
			if(i==1) {
				arguments.product.setDefaultSku(thisSku);
			}
		}
	}

	public any function createSkuFromStruct (required struct data, required any product) {
		var thisSku = this.newSku();
		thisSku.setProduct(arguments.product);
		thisSku.setPrice(arguments.data.price);
		thisSku.setListPrice(arguments.data.listprice);
		thisSku.setShippingWeight(arguments.data.shippingWeight);
		var comboCode = "";
		// loop through optionID's within the option combination and set them into the sku
		for( j=1;j<=listLen(arguments.data.options);j++ ) {
			var thisOptionID = listGetAt(arguments.data.options,j);
			var thisOption = this.getOption(thisOptionID);
			thisSku.addOption(thisOption);
			thisSku.setImageFile(generateImageFileName(thisSku));
			// generate code from options to be used in Sku Code
			comboCode = listAppend(comboCode,thisOption.getOptionCode(),"-");
		}
		if( structKeyExists(arguments.data,"skuCode") && len(arguments.data.skuCode) ) {
			thisSku.setSkuCode(arguments.data.skuCode);
		} else {
			thisSku.setSkuCode( listPrepend(comboCode,arguments.product.getProductCode(),"-") );
		}
		return thisSku;
	}

    /**
    /* @hint bulk update of skus from product edit page
    */	
	public any function updateSkus(required any product,required array skus) {
		// keep track of sku codes so that we can flag any duplicates
		var skuCodeList = "";
		for(var i=1;i<=arrayLen(arguments.skus);i++) {
			local.skuStruct = arguments.skus[i];
			if( len(local.skuStruct.skuID) > 0 ) {
				local.thisSku = this.getSku(local.skuStruct.skuID);
				// set the new sku Code if one was entered
				if(len(trim(local.skuStruct.skuCode)) > 0) {
					local.thisSku.setSkuCode(local.skuStruct.skuCode);
				}
				// set new sku prices if they were numeric
				if(isNumeric(local.skuStruct.price)) {
					local.thisSku.setPrice(local.skuStruct.price);
				}
	            if(isNumeric(local.skuStruct.listPrice)) {
	                local.thisSku.setListPrice(local.skuStruct.listPrice);
	            }
	          	if(isNumeric(local.skuStruct.shippingWeight)) {
	                local.thisSku.setShippingWeight(local.skuStruct.shippingWeight);
	            }
	            local.thisSku.setImageFile(generateImageFileName(local.thisSku));
	         } else {
	         	// this is a new sku added from product.edit form (no skuID yet)
	         	local.thisSku = createSkuFromStruct( local.skuStruct, arguments.product );
	         }
	         validateSkuCode( local.thisSku, skuCodeList );
	         skuCodeList = listAppend(skuCodeList, local.thisSku.getSkuCode());
		}
		return true;
	}
	
	
	public any function validateSkuCode( required any sku, string skuCodeList ) {
		var isDuplicate = false;
		// first check if there was a duplicate among the Skus that are being created with this one
		if(structKeyExists(arguments,"skuCodeList")) {
			isDuplicate = listFindNoCase( arguments.skuCodeList, arguments.sku.getSkuCode() );
		}
		// then check the database (only if a duplicate wasn't already found)
		if( isDuplicate == false ) {
			isDuplicate = getDAO().isDuplicateProperty("skuCode", arguments.sku);
		}
		var skuCodeError = getValidationService().validateValue(rule="assertFalse",objectValue=isDuplicate,objectName="skuCode",message=rbKey("entity.sku.skuCode_validateUnique"));
		if( !structIsEmpty(skuCodeError) ) {
			arguments.sku.addError(argumentCollection=skuCodeError);
			getService("requestCacheService").setValue("ormHasErrors", true);
		}
	}
	
	
	/**
	/* @hint takes a struct of optionGroup (keys are option group sort orders) and lists of optionID's (values) and returns a list of all possible optionID combinations 
	/* (combinations are semicolon-delimited and option id's within each combination are comma-delimited )
	*/
	public string function getOptionCombinations (required struct options) {
		// use struct keys to make sure options are ordered by sort order of option group
		var optionsKeyArray = structKeyArray(options);
		arraySort(optionsKeyArray,"numeric");
		// pick the first group and create the array for cartesian output
		var optionComboArray = listToArray(options[optionsKeyArray[1]]); 
		// loop for second to last group
		for(var i = 2; i <= arrayLen(optionsKeyArray); i++){
			var optionComboArrayLen = arrayLen(optionComboArray);
			var optionTempArray = [];
			// loop through each item in the group
			for(var j = 1; j <= optionComboArrayLen; j++){
				var thisOptionArray = listToArray(options[optionsKeyArray[i]]);
				var currentOptionList = optionComboArray[j];
				// loop through each item in the group
				for(var optionID in thisOptionArray){
					// new combination by appending to the existing values
					var thisCombo = listAppend(currentOptionList,optionID);
					arrayAppend(optionComboArray,thisCombo);
				}
				// store old value to be discarded
				arrayAppend(optionTempArray,currentOptionList);
			}
			// discard old values because now we have new combination
			for(var item in optionTempArray){
				arrayDelete(optionComboArray,item);
			}
		}
		return arrayToList(optionComboArray,";");
	}
	
	public any function processImageUpload(required any Sku, required struct imageUploadResult) {
		var imagePath = arguments.Sku.getImagePath();
		var imageSaved = getFileService().saveImage(uploadResult=arguments.imageUploadResult,filePath=imagePath,allowedExtensions="jpg,jpeg,png,gif");
		if(imageSaved) {
			return true;
		} else {
			return false;
		}	
	}
	
	private string function generateImageFileName( required any sku ) {
		// Generates the image path based upon product code, and image options for this sku
		var options = arguments.sku.getOptions();
		var optionString = "";
		for(var i=1; i<=arrayLen(options); i++){
			if(options[i].getOptionGroup().getImageGroupFlag()){
				optionString &= "-#options[i].getOptionCode()#";
			}
		}
		return "#arguments.Sku.getProduct().getProductCode()##optionString#.#setting('product_imageextension')#";
	}
	
	public array function getSortedProductSkus(required any product) {
		return getDAO().getSortedProductSkus(arguments.product);
	}

}
