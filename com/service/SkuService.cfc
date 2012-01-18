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
	property name="productService" type="any";
	
	public any function getSkuSmartList(string productID, struct data={}){
		arguments.entityName = "SlatwallSku";
		var smartList = getDAO().getSmartList(argumentCollection=arguments);
		
		if( structKeyExists(arguments,"productID") ) {
			smartList.addFilter(propertyIdentifier="product_productID", value=arguments.productID);
		}
		
		return smartList;
	}
	
	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price ) {
		// check to see if any options were selected
		if(!structIsEmpty(arguments.optionsStruct)) {
			var options = arguments.optionsStruct;
			var comboList = getOptionCombinations(options);
			createSkusFromOptions(comboList,arguments.product,arguments.price);
		} else {  // no options were selected so create a default sku
			var thisSku = this.newSku();
			thisSku.setProduct(arguments.product);
			thisSku.setPrice(arguments.price);
			thisSku.setSkuCode(arguments.product.getProductCode() & "-0000");
			arguments.product.setDefaultSku(thisSku);
		}
		return true;
	}

	/**
	/* @hint takes a list of optionID combinations and generates skus
	*/
	public void function createSkusFromOptions (required string comboList, required any product, required price) {
		for(  i=1; i<=listLen(arguments.comboList,";");i++ ) {
			//every option combination represents 1 Sku, so we create it
			var thisCombo = listGetAt(arguments.comboList,i,";");
			var thisSku = createSkuFromStruct({options=thisCombo,price=arguments.price},arguments.product);
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
		var comboCode = "";
		// loop through optionID's within the option combination and set them into the sku
		for( j=1;j<=listLen(arguments.data.options);j++ ) {
			var thisOptionID = listGetAt(arguments.data.options,j);
			var thisOption = this.getOption(thisOptionID);
			thisSku.addOption(thisOption);
			thisSku.setImageFile(thisSku.generateImageFileName());
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
		var imageSaved = getService("utilityFileService").saveImage(uploadResult=arguments.imageUploadResult,filePath=imagePath,allowedExtensions="jpg,jpeg,png,gif");
		if(imageSaved) {
			return true;
		} else {
			return false;
		}	
	}
	
	public array function getSortedProductSkus(required any product) {
		var skus = arguments.product.getSkus();
		if(arrayLen(skus) lt 2) {
			return skus;
		}
		
		var sortedSkuIDQuery = getDAO().getSortedProductSkusID(arguments.product.getProductID());
		var sortedArray = arrayNew(1);
		var sortedArrayReturn = arrayNew(1);
		
		for(var i=1; i<=sortedSkuIDQuery.recordCount; i++) {
			arrayAppend(sortedArray, sortedSkuIDQuery.skuID[i]);
		}
		
		arrayResize(sortedArrayReturn, arrayLen(sortedArray));
		
		for(var i=1; i<=arrayLen(skus); i++) {
			var skuID = skus[i].getSkuID();
			var index = arrayFind(sortedArray, skuID);
			sortedArrayReturn[index] = skus[i];
		}
		
		return sortedArrayReturn;
	}
	
	public any function searchSkusByProductType(string term,string productTypeID) {
		return getDAO().searchSkusByProductType(argumentCollection=arguments);
	}	
	
	/**
	/* @hint Updates the prices of all of the SKUs in a product 
	**/
	public void function updateAllSKUPricesForProduct(productId, price){
		var skus = getProductService().getProduct(arguments.productId).getSKUs();
		for(var i=1; i LTE ArrayLen(skus); i++)
			skus[i].setPrice(price);
	}

	/**
	/* @hint Updates the wight of all of the SKUs in a product 
	**/
	public void function updateAllSKUWeightsForProduct(productId, weight){
		var skus = getProductService().getProduct(arguments.productId).getSKUs();
		for(var i=1; i LTE ArrayLen(skus); i++)
			skus[i].setShippingWeight(weight);
	}

}
