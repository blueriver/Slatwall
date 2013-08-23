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
component displayname="LoyaltyProgramAccruement" entityname="SlatwallLoyaltyProgramAccruement" table="SwLoyaltyProgramAccruement" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyProgramAccruementID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="startDateTime" ormtype="timestamp";
	property name="endDateTime" ormtype="timestamp";
	property name="accruementType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="pointType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="pointQuantity" ormType="integer";
	property name="activeFlag" ormtype="boolean" default="1";
	
	// Related Object Properties (many-to-one)
	property name="loyaltyProgram" cfc="LoyaltyProgram" fieldtype="many-to-one" fkcolumn="loyaltyProgramID";
	property name="expirationTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="expirationTermID";
	
	// Related Object Properties (one-to-many)
	property name="accountLoyaltyProgramTransactions" singularname="accountLoyaltyProgramTransaction" cfc="AccountLoyaltyProgramTransaction" type="array" fieldtype="one-to-many" fkcolumn="loyaltyProgramAccruementID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementBrand" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementSku" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementProduct" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementProductType" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementExclBrand" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="brandID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementExclSku" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementExclProduct" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyProgramAccruementExclProductType" fkcolumn="loyaltyProgramAccruementID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public string function getSimpleRepresentation() {
		return "#rbKey('entity.loyaltyProgramAccruement')#";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramAccruement.accruementType.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.loyaltyProgramAccruement.accruementType.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.loyaltyProgramAccruement.accruementType.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.loyaltyProgramAccruement.accruementType.enrollment'), value="enrollment"}
		];
	}
	
	public array function getPointTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyProgramAccruement.pointType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyProgramAccruement.pointType.pointPerDollar'), value="pointPerDollar"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account Loyalty Program Transaction (one-to-many)
	public void function addAccountLoyaltyProgramTransaction(required any accountLoyaltyProgramTransaction) {
		arguments.accountLoyaltyProgramTransaction.setLoyaltyProgramAccruement( this );
	}
	public void function removeAccountLoyaltyProgramTransaction(required any accountLoyaltyProgramTransaction) {
		arguments.accountLoyaltyProgramTransaction.removeLoyaltyProgramAccruement( this );
	}
	
	
	// loyalty Program (many-to-one)
	public void function setLoyaltyProgram(required any loyaltyProgram) {
		variables.loyaltyProgram = arguments.loyaltyProgram;
		if(isNew() or !arguments.loyaltyProgram.hasLoyaltyProgramAccruement( this )) {
			arrayAppend(arguments.loyaltyProgram.getLoyaltyProgramAccruements(), this);
		}
	}
	public void function removeLoyaltyProgram(any loyaltyProgram) {
		if(!structKeyExists(arguments, "loyaltyProgram")) {
			arguments.loyaltyProgram = variables.loyaltyProgram;
		}
		var index = arrayFind(arguments.loyaltyProgram.getLoyaltyProgramAccruements(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.loyaltyProgram.getLoyaltyProgramAccruements(), index);
		}
		structDelete(variables, "loyaltyProgram");
	}
	
	// Expiration Term (many-to-one)
	public void function setExpirationTerm(required any expirationTerm) {
		variables.expirationTerm = arguments.expirationTerm;
		if(isNew() or !arguments.expirationTerm.hasLoyaltyProgramAccruementExpirationTerm( this )) {
			arrayAppend(arguments.expirationTerm.getLoyaltyProgramAccruementExpirationTerms(), this);
		}
	}
	public void function removeExpirationTerm(any Expirationterm) {
		if(!structKeyExists(arguments, "expirationTerm")) {
			arguments.expirationTerm = variables.expirationTerm;
		}
		var index = arrayFind(arguments.expirationTerm.getLoyaltyProgramAccruementExpirationTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.expirationTerm.getLoyaltyProgramAccruementExpirationTerms(), index);
		}
		structDelete(variables, "expirationTerm");
	}
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasLoyaltyProgramAccruement( this )) {
			arrayAppend(arguments.brand.getLoyaltyProgramAccruements(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyProgramAccruement(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getLoyaltyProgramAccruements(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}
		if(isNew() or !arguments.sku.hasLoyaltyProgramAccruement( this )) {
			arrayAppend(arguments.sku.getLoyaltyProgramAccruements(), this);
		}   
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyProgramAccruement(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getLoyaltyProgramAccruements(), thatIndex);
		}   
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyProgramAccruement( this )) {
			arrayAppend(arguments.product.getLoyaltyProgramAccruements(), this);
		} 
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.products.getLoyaltyProgramAccruement(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.products.getLoyaltyProgramAccruements(), thatIndex);
		} 
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyProgramAccruement( this )) {
			arrayAppend(arguments.productType.getLoyaltyProgramAccruements(), this);
		} 
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyProgramAccruement(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getLoyaltyProgramAccruements(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}
		if(isNew() or !arguments.brand.hasLoyaltyProgramAccruementExclusion( this )) {    
			arrayAppend(arguments.brand.getLoyaltyProgramAccruementExclusions(), this);    
		}  
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyProgramAccruementExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getLoyaltyProgramAccruementExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasLoyaltyProgramAccruementExclusion( this )) {    
			arrayAppend(arguments.sku.getLoyaltyProgramAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyProgramAccruementExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getLoyaltyProgramAccruementExclusions(), thatIndex);    
		}  
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyProgramAccruementExclusion( this )) {    
			arrayAppend(arguments.product.getLoyaltyProgramAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getLoyaltyProgramAccruementExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.product.getLoyaltyProgramAccruementExclusions(), thatIndex);    
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyProgramAccruementExclusion( this )) {    
			arrayAppend(arguments.productType.getLoyaltyProgramAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyProgramAccruementExclusion(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getLoyaltyProgramAccruementExclusions(), thatIndex);    
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
