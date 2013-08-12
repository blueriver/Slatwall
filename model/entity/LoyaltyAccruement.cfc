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
component displayname="LoyaltyAccruement" entityname="SlatwallLoyaltyAccruement" table="SlatwallLoyaltyAccruement" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyAccruementID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="startDateTime" ormtype="timestamp";
	property name="endDateTime" ormtype="timestamp";
	property name="accruementType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="pointType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="point" ormType="integer";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="globalFlag" ormtype="boolean" default="1";
	
	// Related Object Properties (many-to-one)
	property name="loyaltyProgram" cfc="LoyaltyProgram" fieldtype="many-to-one" fkcolumn="loyaltyProgramID";
	property name="expirationTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="expirationTermID";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementBrand" fkcolumn="loyaltyAccruementID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementSku" fkcolumn="loyaltyAccruementID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementProduct" fkcolumn="loyaltyAccruementID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementProductType" fkcolumn="loyaltyAccruementID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementExcludedBrand" fkcolumn="loyaltyAccruementID" inversejoincolumn="brandID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementExcludedSku" fkcolumn="loyaltyAccruementID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementExcludedProduct" fkcolumn="loyaltyAccruementID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallLoyaltyAccruementExcludedProductType" fkcolumn="loyaltyAccruementID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties


	public string function getSimpleRepresentation() {
		return "#rbKey('entity.loyaltyAccruement')#";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyAccruement.accruementType.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.enrollment'), value="enrollment"}
		];
	}
	
	public array function getPointTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyAccruement.pointType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyAccruement.pointType.pointPerDollar'), value="pointPerDollar"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}   
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}   
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
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
