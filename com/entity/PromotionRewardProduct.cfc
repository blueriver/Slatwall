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
component displayname="Promotion Reward Product" entityname="SlatwallPromotionRewardProduct" table="SlatwallPromotionReward" persistent="true" extends="PromotionReward" discriminatorValue="product" {
	
	// Persistent Properties
	property name="promotionRewardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="itemRewardQuantity" ormType="integer";
	property name="itemPercentageOff" ormType="big_decimal";
	property name="itemAmountOff" ormType="big_decimal";
	property name="itemAmount" ormType="big_decimal";
	
	// Related Entities
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID";
	
	// Non-persistent entities
	property name="itemDiscountType" persistent="false";
	
	public any function init() {

		if(isNull(variables.brands)) {
			variables.brands = [];
		}
		if(isNull(variables.options)) {
			variables.options = [];
		}
		if(isNull(variables.skus)) {
			variables.skus = [];
		}
		if(isNull(variables.products)) {
			variables.products = [];
		}	   
		if(isNull(variables.productTypes)) {
			variables.productTypes = [];
		}

		return super.init();
	}
	
	public string function getRewardType() {
		return "product";
	}
		
	/******* Association management methods for bidirectional relationships **************/

	// brand (many-to-many)
	
	public void function addBrand(required any Brand) {
		if(arguments.Brand.isNew() || !hasBrand(arguments.Brand)) {
			// first add brand to this reward
			arrayAppend(this.getBrands(),arguments.Brand);
			//add this reward to the brand
			arrayAppend(arguments.Brand.getPromotionRewards(),this);
		}
	}
    
    public void function removeBrand(required any Brand) {
       // first remove the brand from this reward
       if(this.hasBrand(arguments.Brand)) {
	       var index = arrayFind(this.getBrands(),arguments.Brand);
	       if(index>0) {
	           arrayDeleteAt(this.getBrands(),index);
	       }
	      // then remove this reward from the brand
	       var index = arrayFind(arguments.Brand.getPromotionRewards(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Brand.getPromotionRewards(),index);
	       }
	   }
    }	

	// options (many-to-many)
	
	public void function addOption(required any Option) {
		if(arguments.Option.isNew() || !hasOption(arguments.Option)) {
			// first add option to this reward
			arrayAppend(this.getOptions(),arguments.Option);
			//add this reward to the option
			arrayAppend(arguments.Option.getPromotionRewards(),this);
		}
	}
    
    public void function removeOption(required any Option) {
       // first remove the option from this reward
       if(this.hasOption(arguments.Option)) {
	       var index = arrayFind(this.getOptions(),arguments.Option);
	       if(index>0) {
	           arrayDeleteAt(this.getOptions(),index);
	       }
	      // then remove this reward from the option
	       var index = arrayFind(arguments.Option.getPromotionRewards(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.Option.getPromotionRewards(),index);
	       }
	   }
    }

	// sku (many-to-many)
	
	public void function addSku(required any Sku) {
		if(arguments.Sku.isNew() || !hasSku(arguments.Sku)) {
			// first add sku to this reward
			arrayAppend(this.getSkus(),arguments.Sku);
			//add this reward to the sku
			arrayAppend(arguments.sku.getPromotionRewards(),this);
		}
	}
    
    public void function removeSku(required any sku) {
       // first remove the sku from this reward
       if(this.hasSku(arguments.sku)) {
	       var index = arrayFind(this.getSkus(),arguments.sku);
	       if(index>0) {
	           arrayDeleteAt(this.getSkus(),index);
	       }
	      // then remove this reward from the sku
	       var index = arrayFind(arguments.sku.getPromotionRewards(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.sku.getPromotionRewards(),index);
	       }
	   }
    }
    
	// product (many-to-many)
	
	public void function addProduct(required any product) {
		if(arguments.product.isNew() || !hasProduct(arguments.product)) {
			// first add product to this reward
			arrayAppend(this.getProducts(),arguments.product);
			//add this reward to the product
			arrayAppend(arguments.product.getPromotionRewards(),this);
		}
	}
    
    public void function removeProduct(required any product) {
       // first remove the product from this reward
       if(this.hasProduct(arguments.product)) {
	       var index = arrayFind(this.getProducts(),arguments.product);
	       if(index>0) {
	           arrayDeleteAt(this.getProducts(),index);
	       }
	      // then remove this reward from the product
	       var index = arrayFind(arguments.product.getPromotionRewards(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.product.getPromotionRewards(),index);
	       }
	   }
    }
    
	// productType (many-to-many)
	
	public void function addProductType(required any ProductType) {
		if(arguments.ProductType.isNew() || !hasProductType(arguments.ProductType)) {
			// first add productType to this reward
			arrayAppend(this.getProductTypes(),arguments.ProductType);
			//add this reward to the productType
			arrayAppend(arguments.ProductType.getPromotionRewards(),this);
		}
	}
    
    public void function removeProductType(required any ProductType) {
       // first remove the productType from this reward
       if(this.hasProductType(arguments.ProductType)) {
	       var index = arrayFind(this.getProductTypes(),arguments.ProductType);
	       if(index>0) {
	           arrayDeleteAt(this.getProductTypes(),index);
	       }
	      // then remove this reward from the productType
	       var index = arrayFind(arguments.ProductType.getPromotionRewards(),this);
	       if(index > 0) {
	           arrayDeleteAt(arguments.ProductType.getPromotionRewards(),index);
	       }
	   }
    }
    
    /************   END Association Management Methods   *******************/

	public any function getBrandOptions() {
		if(!structKeyExists(variables, "brandOptions")) {
			var smartList = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallBrand");
			smartList.addSelect(propertyIdentifier="brandName", alias="name");
			smartList.addSelect(propertyIdentifier="brandID", alias="value"); 
			smartList.addOrder("brandName|ASC");
			variables.brandOptions = smartList.getRecords();
		}
		return variables.brandOptions;
	}
	
	public string function displayBrandNames() {
		var brandNames = "";
		for( var i=1; i<=arrayLen(this.getBrands());i++ ) {
			brandNames = listAppend(brandNames, " " & this.getBrands()[i].getBrandName());
		}
		return brandNames;
	}
	
	public string function displayOptionNames() {
		var optionNames = "";
		for( var i=1; i<=arrayLen(this.getOptions());i++ ) {
			optionNames = listAppend(optionNames, " " & this.getOptions()[i].getOptionName());
		}
		return optionNames;
	}
	
	public string function displayProductTypeNames() {
		var productTypeNames = "";
		for( var i=1; i<=arrayLen(this.getProductTypes());i++ ) {
			productTypeNames = listAppend(productTypeNames, " " & this.getProductTypes()[i].getProductTypeName());
		}
		return productTypeNames;
	}

	public string function displayProductNames() {
		var productNames = "";
		for( var i=1; i<=arrayLen(this.getProducts());i++ ) {
			productNames = listAppend(productNames, " " & this.getProducts()[i].getProductName());
		}
		return productNames;
	}
	
	public string function displaySkuCodes() {
		var skuCodes = "";
		for( var i=1; i<=arrayLen(this.getSkus());i++ ) {
			skuCodes = listAppend(skuCodes, " " & this.getSkus()[i].getSkuCode());
		}
		return skuCodes;
	}

	public string function getProductTypeIDs() {
		var productTypeIDs = "";
		for( var i=1; i<=arrayLen(this.getProductTypes());i++ ) {
			productTypeIDs = listAppend(productTypeIDs,this.getProductTypes()[i].getProductTypeID());
		}
		return productTypeIDs;
	}
	
	public string function getProductIDs() {
		var productIDs = "";
		for( var i=1; i<=arrayLen(this.getProducts());i++ ) {
			productIDs = listAppend(productIDs,this.getProducts()[i].getProductID());
		}
		return productIDs;
	}
	
	public string function getSkuIDs() {
		var skuIDs = "";
		for( var i=1; i<=arrayLen(this.getSkus());i++ ) {
			skuIDs = listAppend(skuIDs,this.getSkus()[i].getSkuID());
		}
		return skuIDs;
	}
	
	public array function getItemDiscountTypeOptions() {
		return [
			{name=rbKey("admin.promotion.promotionRewardShipping.discountType.percentageOff"), value="percentageOff"},
			{name=rbKey("admin.promotion.promotionRewardShipping.discountType.amountOff"), value="amountOff"},
			{name=rbKey("admin.promotion.promotionRewardShipping.discountType.amount"), value="amount"}
		];
	}
	
	public string function getItemDiscountType() {
		if(isNull(variables.itemDiscountType)) {
			if(!isNull(getItemPercentageOff()) && isNull(getItemAmountOff()) && isNull(getItemAmount())) {
				variables.itemDiscountType = "percentageOff";
			} else if (!isNull(getItemAmountOff()) && isNull(getItemPercentageOff()) && isNull(getItemAmount())) {
				variables.itemDiscountType = "amountOff";
			} else if (!isNull(getItemAmount()) && isNull(getItemPercentageOff()) && isNull( getItemAmountOff())) {
				variables.itemDiscountType = "amount";
			} else {
				variables.itemDiscountType = "percentageOff";
			}
		}
		return variables.itemDiscountType;
	}
	
	public boolean function hasValidItemPercentageOffValue() {
		if(getItemDiscountType() == "percentageOff" && ( isNull(getItemPercentageOff()) || !isNumeric(getItemPercentageOff()) || getItemPercentageOff() > 100 || getItemPercentageOff() < 0 ) ) {
			return false;
		}
		return true;
	}
	
	public boolean function hasValidItemAmountOffValue() {
		if(getItemDiscountType() == "amountOff" && ( isNull(getItemAmountOff()) || !isNumeric(getItemAmountOff()) ) ) {
			return false;
		}
		return true;
	}
	
	public boolean function hasValidItemAmountValue() {
		if(getItemDiscountType() == "amount" && ( isNull(getItemAmount()) || !isNumeric(getItemAmount()) ) ) {
			return false;
		}
		return true;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("skuCacheService").updateFromPromotionRewardProduct( this );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromPromotionRewardProduct( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}