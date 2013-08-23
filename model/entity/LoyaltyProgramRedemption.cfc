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
component displayname="LoyaltyProgramRedemption" entityname="SlatwallLoyaltyProgramRedemption" table="SlatwallLoyaltyProgramRedemption" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyProgramRedemptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="RedemptionPointType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="RedemptionType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="autoRedemptionType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="amountType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="amount" ormType="integer";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="globalFlag" ormtype="boolean" default="1";
	property name="nextRedemptionDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="loyaltyProgram" cfc="LoyaltyProgram" fieldtype="many-to-one" fkcolumn="loyaltyProgramID";
	property name="balanceTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="balanceTermID";
	property name="autoRedemptionTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="autoRedemptionTermID";
	
	// Related Object Properties (one-to-many)
	property name="accountLoyaltyProgramTransactions" singularname="accountLoyaltyProgramTransaction" cfc="AccountLoyaltyProgramTransaction" type="array" fieldtype="one-to-many" fkcolumn="loyaltyProgramRedemptionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwProgramRedemptionBrand" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwProgramRedemptionSku" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionProduct" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionProductType" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionExclBrand" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="brandID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionExclSku" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionExclProduct" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyProgramRedemptionExclProductType" fkcolumn="loyaltyProgramRedemptionID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public string function getSimpleRepresentation() {
		return "#rbKey('entity.loyaltyProgramRedemption')#";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getRedemptionPointTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionPointType.lifeTimePoints'), value="lifeTimePoints"},
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionPointType.pointBalance'), value="pointBalance"},
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionPointType.termBalance'), value="termBalance"}
		];
	}
	
	public array function getRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionType.productPurchase'), value="productPurchase"},
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionType.cashCouponCreation'), value="cashCouponCreation"},
			{name=rbKey('entity.loyaltyProgramRedemption.redemptionType.priceGroupAssignment'), value="priceGroupAssignment"}
		];
	}
	
	public array function getAutoRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramRedemption.autoRedemptionType.accountPlacesOrder'), value="accountPlacesOrder"},
			{name=rbKey('entity.loyaltyProgramRedemption.autoRedemptionType.term'), value="term"}
		];
	}
	
	public array function getAmountTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramRedemption.amountType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyProgramRedemption.amountType.pointPerDollar'), value="pointPerDollar"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// AccountLoyaltyProgramTransaction (one-to-many)
	public void function addAccountLoyaltyProgramTransaction(required any accountLoyaltyProgramTransaction) {
		arguments.accountLoyaltyProgramTransaction.setLoyaltyProgramRedemption( this );
	}
	public void function removeAccountLoyaltyProgramTransaction(required any accountLoyaltyProgramTransaction) {
		arguments.accountLoyaltyProgramTransaction.removeLoyaltyProgramRedemption( this );
	}
	
	
	// loyalty Program (many-to-one)
	public void function setLoyaltyProgram(required any loyaltyProgram) {
		variables.loyaltyProgram = arguments.loyaltyProgram;
		if(isNew() or !arguments.loyaltyProgram.hasLoyaltyProgramRedemption( this )) {
			arrayAppend(arguments.loyaltyProgram.getLoyaltyProgramRedemptions(), this);
		}
	}
	public void function removeLoyaltyProgram(any loyaltyProgram) {
		if(!structKeyExists(arguments, "loyaltyProgram")) {
			arguments.loyaltyProgram = variables.loyaltyProgram;
		}
		var index = arrayFind(arguments.loyaltyProgram.getLoyaltyProgramRedemptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.loyaltyProgram.getLoyaltyProgramRedemptions(), index);
		}
		structDelete(variables, "loyaltyProgram");
	}
	
	// Balance Term (many-to-one)
	public void function setBalanceTerm(required any balanceTerm) {
		variables.balanceTerm = arguments.balanceTerm;
		if(isNew() or !arguments.balanceTerm.hasLoyaltyProgramBalanceTerm( this )) {
			arrayAppend(arguments.balanceTerm.getLoyaltyProgramBalanceTerms(), this);
		}
	}
	public void function removeBalanceTerm(any balanceTerm) {
		if(!structKeyExists(arguments, "balanceTerm")) {
			arguments.balanceTerm = variables.balanceTerm;
		}
		var index = arrayFind(arguments.balanceTerm.getLoyaltyProgramBalanceTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.balanceTerm.getLoyaltyProgramBalanceTerms(), index);
		}
		structDelete(variables, "balanceTerm");
	}	

	// Auto Redemption Term (many-to-one)         
 	public void function setAutoRedemptionTerm(required any autoRedemptionTerm) {         
 		variables.autoRedemptionTerm = arguments.autoRedemptionTerm;         
 		if(isNew() or !arguments.autoRedemptionTerm.hasLoyaltyProgramAutoRedemptionTerm( this )) {         
 			arrayAppend(arguments.autoRedemptionTerm.getLoyaltyProgramAutoRedemptionTerms(), this);         
 		}         
 	}         
 	public void function removeAutoRedemptionTerm(any autoRedemptionTerm) {         
 		if(!structKeyExists(arguments, "autoRedemptionTerm")) {         
 			arguments.autoRedemptionTerm = variables.autoRedemptionTerm;         
 		}         
 		var index = arrayFind(arguments.autoRedemptionTerm.getLoyaltyProgramAutoRedemptionTerms(), this);         
 		if(index > 0) {         
 			arrayDeleteAt(arguments.autoRedemptionTerm.getLoyaltyProgramAutoRedemptionTerms(), index);         
 		}         
 		structDelete(variables, "autoRedemptionTerm");         
 	}

	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasLoyaltyProgramRedemption( this )) {
			arrayAppend(arguments.brand.getLoyaltyProgramRedemptions(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyProgramRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getLoyaltyProgramRedemptions(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}
		if(isNew() or !arguments.sku.hasLoyaltyProgramRedemption( this )) {
			arrayAppend(arguments.sku.getLoyaltyProgramRedemptions(), this);
		}   
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyProgramRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getLoyaltyProgramRedemptions(), thatIndex);
		}   
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyProgramRedemption( this )) {
			arrayAppend(arguments.product.getLoyaltyProgramRedemptions(), this);
		} 
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.products.getLoyaltyProgramRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.products.getLoyaltyProgramRedemptions(), thatIndex);
		} 
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyProgramRedemption( this )) {
			arrayAppend(arguments.productType.getLoyaltyProgramRedemptions(), this);
		} 
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyProgramRedemption(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getLoyaltyProgramRedemptions(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}
		if(isNew() or !arguments.brand.hasLoyaltyProgramRedemptionExclusion( this )) {    
			arrayAppend(arguments.brand.getLoyaltyProgramRedemptionExclusions(), this);    
		}  
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyProgramRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getLoyaltyProgramRedemptionExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasLoyaltyProgramRedemptionExclusion( this )) {    
			arrayAppend(arguments.sku.getLoyaltyProgramRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyProgramRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getLoyaltyProgramRedemptionExclusions(), thatIndex);    
		}  
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyProgramRedemptionExclusion( this )) {    
			arrayAppend(arguments.product.getLoyaltyProgramRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getLoyaltyProgramRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.product.getLoyaltyProgramRedemptionExclusions(), thatIndex);    
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyProgramRedemptionExclusion( this )) {    
			arrayAppend(arguments.productType.getLoyaltyProgramRedemptionExclusions(), this);    
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyProgramRedemptionExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getLoyaltyProgramRedemptionExclusions(), thatIndex);    
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
