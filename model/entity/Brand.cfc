/*

    Slatwall - An Open Source eCommerce Platform
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
component displayname="Brand" entityname="SlatwallBrand" table="SlatwallBrand" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="brandID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hint="As Brands Get Old, They would be marked as Not Active";
	property name="publishedFlag" ormtype="boolean";
	property name="urlTitle" ormtype="string" unique="true" hint="This is the name that is used in the URL string";
	property name="brandName" ormtype="string" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" ormtype="string" formatType="url" hint="This is the Website of the brand";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Slatwall.model.entity.Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Slatwall.model.entity.Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="Slatwall.model.entity.AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="brandID" cascade="all-delete-orphan" inverse="true";
	property name="products" singularname="product" cfc="Slatwall.model.entity.Product" type="array" fieldtype="one-to-many" fkcolumn="brandID" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" singularname="promotionReward" cfc="Slatwall.model.entity.PromotionReward" fieldtype="many-to-many" linktable="SlatwallPromotionRewardBrand" fkcolumn="brandID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="Slatwall.model.entity.PromotionReward" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedBrand" fkcolumn="brandID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="Slatwall.model.entity.PromotionQualifier" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierBrand" fkcolumn="brandID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="Slatwall.model.entity.PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionQualifierExcludedBrand" fkcolumn="brandID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="vendors" singularname="vendor" cfc="Slatwall.model.entity.Vendor" fieldtype="many-to-many" linktable="SlatwallVendorBrand" fkcolumn="brandID" inversejoincolumn="vendorID" inverse="true";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setBrand( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeBrand( this );    
	}
	
	// Products (one-to-many)
	public void function addProduct(required Product Product) {
	   arguments.Product.setBrand(this);
	}
	
	public void function removeProduct(required Product Product) {
	   arguments.Product.removeBrand(this);
	}
	
	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addBrand(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeBrand(this);
	}
	
	// Promotion Reward Exclusions (many-to-many - inverse)    
	public void function addPromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedBrand( this );    
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.removeExcludedBrand( this );    
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addBrand( this );
	}
	
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeBrand( this );
	}
	
	// Promotion Qualifier Exclusions (many-to-many - inverse)    
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedBrand( this );    
	}    
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.removeExcludedBrand( this );    
	}
	
	// Vendors (many-to-many - inverse)    
	public void function addVendor(required any vendor) {    
		arguments.vendor.addBrand( this );    
	}    
	public void function removeVendor(required any vendor) {    
		arguments.vendor.removeBrand( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
