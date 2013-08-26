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
component displayname="LoyaltyRedemption" entityname="SlatwallLoyaltyRedemption" table="SwLoyaltyRedemption" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyRedemptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="RedemptionPointType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="RedemptionType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="autoRedemptionType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="amountType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="amount" ormType="integer";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="globalFlag" ormtype="boolean" default="1";
	property name="nextRedemptionDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="loyalty" cfc="Loyalty" fieldtype="many-to-one" fkcolumn="loyaltyID";
	property name="balanceTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="balanceTermID";
	property name="autoRedemptionTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="autoRedemptionTermID";
	
	// Related Object Properties (one-to-many)
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="loyaltyRedemptionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionBrand" fkcolumn="loyaltyRedemptionID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionSku" fkcolumn="loyaltyRedemptionID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionProduct" fkcolumn="loyaltyRedemptionID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionProductType" fkcolumn="loyaltyRedemptionID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclBrand" fkcolumn="loyaltyRedemptionID" inversejoincolumn="brandID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclSku" fkcolumn="loyaltyRedemptionID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclProduct" fkcolumn="loyaltyRedemptionID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclProductType" fkcolumn="loyaltyRedemptionID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public string function getSimpleRepresentation() {
		return "#rbKey('entity.loyaltyRedemption')#";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getRedemptionPointTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyRedemption.redemptionPointType.lifeTimePoints'), value="lifeTimePoints"},
			{name=rbKey('entity.loyaltyRedemption.redemptionPointType.pointBalance'), value="pointBalance"},
			{name=rbKey('entity.loyaltyRedemption.redemptionPointType.termBalance'), value="termBalance"}
		];
	}
	
	public array function getRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyRedemption.redemptionType.productPurchase'), value="productPurchase"},
			{name=rbKey('entity.loyaltyRedemption.redemptionType.cashCouponCreation'), value="cashCouponCreation"},
			{name=rbKey('entity.loyaltyRedemption.redemptionType.priceGroupAssignment'), value="priceGroupAssignment"}
		];
	}
	
	public array function getAutoRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyRedemption.autoRedemptionType.accountPlacesOrder'), value="accountPlacesOrder"},
			{name=rbKey('entity.loyaltyRedemption.autoRedemptionType.term'), value="term"}
		];
	}
	
	public array function getAmountTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyRedemption.amountType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyRedemption.amountType.pointPerDollar'), value="pointPerDollar"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// AccountLoyaltyTransaction (one-to-many)
	public void function addAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {
		arguments.accountLoyaltyTransaction.setLoyaltyRedemption( this );
	}
	public void function removeAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {
		arguments.accountLoyaltyTransaction.removeLoyaltyRedemption( this );
	}
	
	
	// loyalty Program (many-to-one)
	public void function setLoyalty(required any loyalty) {
		variables.loyalty = arguments.loyalty;
		if(isNew() or !arguments.loyalty.hasLoyaltyRedemption( this )) {
			arrayAppend(arguments.loyalty.getLoyaltyRedemptions(), this);
		}
	}
	public void function removeLoyalty(any loyalty) {
		if(!structKeyExists(arguments, "loyalty")) {
			arguments.loyalty = variables.loyalty;
		}
		var index = arrayFind(arguments.loyalty.getLoyaltyRedemptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.loyalty.getLoyaltyRedemptions(), index);
		}
		structDelete(variables, "loyalty");
	}
	
	// Balance Term (many-to-one)
	public void function setBalanceTerm(required any balanceTerm) {
		variables.balanceTerm = arguments.balanceTerm;
		if(isNew() or !arguments.balanceTerm.hasLoyaltyBalanceTerm( this )) {
			arrayAppend(arguments.balanceTerm.getLoyaltyBalanceTerms(), this);
		}
	}
	public void function removeBalanceTerm(any balanceTerm) {
		if(!structKeyExists(arguments, "balanceTerm")) {
			arguments.balanceTerm = variables.balanceTerm;
		}
		var index = arrayFind(arguments.balanceTerm.getLoyaltyBalanceTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.balanceTerm.getLoyaltyBalanceTerms(), index);
		}
		structDelete(variables, "balanceTerm");
	}	

	// Auto Redemption Term (many-to-one)         
 	public void function setAutoRedemptionTerm(required any autoRedemptionTerm) {         
 		variables.autoRedemptionTerm = arguments.autoRedemptionTerm;         
 		if(isNew() or !arguments.autoRedemptionTerm.hasLoyaltyAutoRedemptionTerm( this )) {         
 			arrayAppend(arguments.autoRedemptionTerm.getLoyaltyAutoRedemptionTerms(), this);         
 		}         
 	}         
 	public void function removeAutoRedemptionTerm(any autoRedemptionTerm) {         
 		if(!structKeyExists(arguments, "autoRedemptionTerm")) {         
 			arguments.autoRedemptionTerm = variables.autoRedemptionTerm;         
 		}         
 		var index = arrayFind(arguments.autoRedemptionTerm.getLoyaltyAutoRedemptionTerms(), this);         
 		if(index > 0) {         
 			arrayDeleteAt(arguments.autoRedemptionTerm.getLoyaltyAutoRedemptionTerms(), index);         
 		}         
 		structDelete(variables, "autoRedemptionTerm");         
 	}

	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasLoyaltyRedemption( this )) {
			arrayAppend(arguments.brand.getLoyaltyRedemptions(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getLoyaltyRedemptions(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}
		if(isNew() or !arguments.sku.hasLoyaltyRedemption( this )) {
			arrayAppend(arguments.sku.getLoyaltyRedemptions(), this);
		}   
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getLoyaltyRedemptions(), thatIndex);
		}   
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyRedemption( this )) {
			arrayAppend(arguments.product.getLoyaltyRedemptions(), this);
		} 
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.products.getLoyaltyRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.products.getLoyaltyRedemptions(), thatIndex);
		} 
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyRedemption( this )) {
			arrayAppend(arguments.productType.getLoyaltyRedemptions(), this);
		} 
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getLoyaltyRedemptions(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}
		if(isNew() or !arguments.brand.hasLoyaltyRedemptionExclusion( this )) {    
			arrayAppend(arguments.brand.getLoyaltyRedemptionExclusions(), this);    
		}  
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getLoyaltyRedemptionExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasLoyaltyRedemptionExclusion( this )) {    
			arrayAppend(arguments.sku.getLoyaltyRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getLoyaltyRedemptionExclusions(), thatIndex);    
		}  
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyRedemptionExclusion( this )) {    
			arrayAppend(arguments.product.getLoyaltyRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getLoyaltyRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.product.getLoyaltyRedemptionExclusions(), thatIndex);    
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyRedemptionExclusion( this )) {    
			arrayAppend(arguments.productType.getLoyaltyRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getLoyaltyRedemptionExclusions(), thatIndex);    
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
