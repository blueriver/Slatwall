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
	property name="itemRewardQuantity" ormType="integer" validateNumeric="true";
	property name="itemPercentageOff" ormType="big_decimal" validateNumeric="true";
	property name="itemAmountOff" ormType="big_decimal" validateNumeric="true";
	property name="itemAmount" ormType="big_decimal" validateNumeric="true";
	
	// Related Entities
	property name="brands" singularname="brand" cfc="Brands" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID" cascade="save-update";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID" cascade="save-update";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID" cascade="save-update";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID" cascade="save-update";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID" cascade="save-update";
		
	/******* Association management methods for bidirectional relationships **************/
	
	// sku (many-to-one)
	
	public void function setSku(required Sku sku) {
		variables.sku = arguments.sku;
		if(!arguments.sku.hasPromotionReward(this)) {
			arrayAppend(arguments.sku.getPromotionRewards(),this);
		}
	}
	
	public void function removeSku(Sku sku) {
	   if(!structKeyExists(arguments,"sku")) {
	   		arguments.sku = variables.sku;
	   }
       var index = arrayFind(arguments.sku.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.sku.getPromotionRewards(), index);
       }
       structDelete(variables,"sku");
    }
    
	// product (many-to-one)
	
	public void function setProduct(required Product product) {
		variables.product = arguments.product;
		if(!arguments.product.hasPromotionReward(this)) {
			arrayAppend(arguments.product.getPromotionRewards(),this);
		}
	}
	
	public void function removeProduct(Product product) {
	   if(!structKeyExists(arguments,"product")) {
	   		arguments.product = variables.product;
	   }
       var index = arrayFind(arguments.product.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.product.getPromotionRewards(), index);
       }
       structDelete(variables,"product");
    }
    
	// productType (many-to-one)
	
	public void function setProductType(required ProductType productType) {
		variables.productType = arguments.productType;
		if(!arguments.productType.hasPromotionReward(this)) {
			arrayAppend(arguments.productType.getPromotionRewards(),this);
		}
	}
	
	public void function removeProductType(ProductType productType) {
	   if(!structKeyExists(arguments,"productType")) {
	   		arguments.productType = variables.productType;
	   }
       var index = arrayFind(arguments.productType.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.productType.getPromotionRewards(), index);
       }
       structDelete(variables,"productType");
    }
    
    /************   END Association Management Methods   *******************/

}