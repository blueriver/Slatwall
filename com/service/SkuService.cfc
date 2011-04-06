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


	public any function delete(required any sku) {
		if(arrayLen(arguments.sku.getProduct().getSkus()) == 1) {
			getValidator().setError(entity=arguments.sku,errorname="delete",rule="oneSku");
		}
		var deleted = Super.delete(arguments.sku);
		return deleted;
	}

	/**
	/* @hint sets up initial skus when products are created
	*/
	public boolean function createSkus(required any product, required struct optionsStruct, required price, required listprice) {
		var skuCodeIndex = 1000;
		
		// check to see if any options were selected
		if(len(arguments.optionsStruct.formCollectionsList)) {
			// get list of option group names
			var options = arguments.optionsStruct.options;
			var optionGroupList = structKeyList(options);
			
			// first get list of options from first option group
			var comboList = options[listFirst(optionGroupList)];
			
			// parse options struct to build list of possible option combinations
			for( var optionGroup in options ) {
				if(optionGroup != listFirst(optionGroupList)) {
					var tempList = "";
					for(var i=1;i<=listLen(comboList);i++) {
						local.thisCombo = listGetAt(comboList,i);
						local.newCombo = "";
						for(var j=1; j<=listLen(options[optionGroup]);j++) {
							newCombo = listAppend(newCombo,thisCombo & " " & listGetAt(options[optionGroup],j));
						}
						tempList = listAppend(tempList,newCombo);
					}
					comboList = tempList;
				}
			}
			for(  i=1; i<=listLen(comboList);i++ ) {
				//every option combination represents 1 Sku, so we create it
				var thisCombo = listGetAt(comboList,i);
				var thisSku = getNewEntity();
				thisSku.setProduct(arguments.product);
				thisSku.setPrice(arguments.price);
				thisSku.setListPrice(arguments.listprice);
				thisSku.setSkuCode(arguments.product.getProductCode() & "_" & skuCodeIndex);
				if(i==1) { 			// set the first sku as the default one
					thisSku.setIsDefault(true);
				}
				// loop through optionID's within the option combination and set them into the sku
				for( j=1;j<=listLen(thisCombo," ");j++ ) {
					var thisOptionID = listGetAt(thisCombo,j," ");
					thisSku.addOption(getByID(thisOptionID,"SlatwallOption"));
				}
				skuCodeIndex++;
			}
		} else {  // no options were selected so create a default sku
			var thisSku = getNewEntity();
			thisSku.setProduct(arguments.product);
			thisSku.setPrice(arguments.price);
			thisSku.setListPrice(arguments.listprice);
			thisSku.setSkuCode(arguments.product.getProductCode() & "_" & skuCodeIndex);
			thisSku.setIsDefault(true);
		}
		return true;
	}

    /**
    /* @hint bulk update of skus from product edit page
    */	
	public any function updateSkus(required any product,required any skuStruct) {
		for(local.thisID in arguments.skuStruct) {
			local.thisSku = getByID(local.thisID);
			// set the new sku Code if one was entered
			if(len(trim(arguments.skuStruct[local.thisID].skuCode)) > 0) {
				local.thisSku.setSkuCode(arguments.skuStruct[local.thisID].skuCode);
			}
			// set new sku prices if they were numeric
			if(isNumeric(arguments.skuStruct[local.thisID].price)) {
				local.thisSku.setPrice(arguments.skuStruct[local.thisID].price);
			}
            if(isNumeric(arguments.skuStruct[local.thisID].listPrice)) {
                local.thisSku.setListPrice(arguments.skuStruct[local.thisID].listPrice);
            }
		}
		return true;
	}
	

}
