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
component displayname="Product Type" entityname="SlatwallProductType" table="SlatwallProductType" persistent="true" extends="BaseEntity" {
			
	// Persistent Properties
	property name="productTypeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="productTypeName" ormtype="string";
	property name="productTypeDescription" ormtype="string" length="2000";
	
	// Persistent Properties - Inheritence Settings
	property name="allowShippingFlag" ormtype="boolean";
	property name="allowPreorderFlag" ormtype="boolean";
	property name="allowBackorderFlag" ormtype="boolean";
	property name="allowDropshipFlag" ormtype="boolean";
	property name="callToOrderFlag" ormtype="boolean";
	property name="displayTemplate" ormtype="string";
	property name="quantityHeldBack" ormtype="integer";
	property name="quantityMinimum" ormtype="integer";
	property name="quantityMaximum" ormtype="integer";
	property name="quantityOrderMinimum" ormtype="integer";
	property name="quantityOrderMaximum" ormtype="integer";
	property name="shippingWeight" ormtype="integer";
	property name="trackInventoryFlag" ormtype="boolean";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Related Object Properties (Many-To-One)
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	
	// Related Object Properties (One-To-Many)
	property name="childProductTypes" singularname="childProductType" cfc="ProductType" fieldtype="one-to-many" inverse="true" fkcolumn="parentProductTypeID" cascade="all";
	property name="products" singularname="product" cfc="Product" fieldtype="one-to-many" inverse="true" fkcolumn="productTypeID" lazy="extra" cascade="all";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="ProductTypeAttributeSetAssignment" fieldtype="one-to-many" fkcolumn="productTypeID" cascade="all-delete-orphan";
	
	// Related Object Properties (Many-To-Many)
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductProductType" fkcolumn="productTypeID" inversejoincolumn="promotionRewardID" cascade="all" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="many-to-many" linktable="SlatwallPriceGroupRateProductType" fkcolumn="productTypeID" inversejoincolumn="priceGroupRateID" cascade="all" inverse="true";

	public ProductType function init(){
	   // set default collections for association management methods
	   if(isNull(variables.Products)){
	       variables.Products = [];
	   }
	   if(isNull(variables.attributeSetAssignments)){
	   		variables.attributeSetAssignments = [];
	   }
	   if(isNull(variables.promotionRewards)) {
	       variables.promotionRewards = [];
	   }
	   
	   return Super.init();
	}
	
	public any function getProductTypeTree() {
		return getService("ProductService").getProductTypeTree();
	}
	
	public any function getParentProductTypeOptions() {
		if(!structKeyExists(variables, "parentProductTypeOptions")) {
			variables.parentProductTypeOptions=[];
			
			// Add a null value to the options for none.
			arrayAppend(variables.parentProductTypeOptions, {value="", name=rbKey('define.none')});
			
			// Get product type tree query
			var ptt = getProductTypeTree();
			
			// Loop over all records in product type tree
			for(var i=1; i<=ptt.recordCount; i++) {
				
				// This logic makes it so that it can't be child of itself or any of its children
				if(!listFindNoCase(ptt.idpath[i], this.getProductTypeID())) {
					var option = {};
					option.value = ptt.productTypeID[i];
					option.name = replace(ptt.productTypeNamePath[i], ",", "&nbsp;&raquo;&nbsp;", "all");
					arrayAppend(variables.parentProductTypeOptions, option);
				}
			}
		}
		
		return variables.parentProductTypeOptions;
	}

	public array function getInheritedAttributeSetAssignments(){
		// Todo get by all the parent productTypeIDs
		var attributeSetAssignments = getService("AttributeService").getAttributeSetAssignmentSmartList().getRecords();
		if(!arrayLen(attributeSetAssignments)){
			attributeSetAssignments = [];
		}
		return attributeSetAssignments;
	}
	
	public void function setProducts(required array Products) {
		// first, clear existing collection
		variables.Products = [];
		for( var product in arguments.Products ) {
			addProduct(product);
		}
	}
	
    public any function getAppliedPriceGroupRateByPriceGroup( required any priceGroup) {
		return getService("priceGroupService").getRateForProductTypeBasedOnPriceGroup(product=this, priceGroup=arguments.priceGroup);
	}
    
    // START: Setting Methods
    public boolean function getSetting(required string settingName) {
        if(structKeyExists(variables, arguments.settingName)) {
            return variables[arguments.settingName];
        }
		
		return getInheritedSetting( arguments.settingName );
    }

    public boolean function getInheritedSetting( required string settingName ) {
    	if(!isNull(getParentProductType())) {
    		return getParentProductType().getSetting( arguments.settingName );
    	}
    	
    	return setting("product_#arguments.settingName#");
    }
    
    public any function getWhereSettingDefined( required string settingName ) {
    	if(structKeyExists(variables,arguments.settingName)) {
    		return {type="Product Type", name=getProductTypeName(), id=getProductTypeID()};
    	} else if (!isNull(getParentProductType())) {
    		return getParentProductType().getWhereSettingDefined( arguments.settingName );
    	}
    	
    	return {type="Global"};
    }
    // END: Setting Methods
    
    // ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Parent Product Type (many-to-one)
	public void function setParentProductType(required any parentProductType) {
		variables.parentProductType = arguments.parentProductType;
		if(isNew() or !arguments.parentProductType.hasChildProductType( this )) {
			arrayAppend(arguments.parentProductType.getChildProductTypes(), this);
		}
	}
	public void function removeParentProductType(any parentProductType) {
		if(!structKeyExists(arguments, "parentProductType")) {
			arguments.parentProductType = variables.parentProductType;
		}
		var index = arrayFind(arguments.parentProductType.getChildProductTypes(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getChildProductTypes(), index);
		}
		structDelete(variables, "parentProductType");
	}
	
	// Child Product Types (one-to-many)
	public void function addchildProductType(required any ChildProductType) {
		arguments.ChildProductType.setParentProductType( this );
	}
	public void function removechildProductType(required any ChildProductType) {
		arguments.ChildProductType.removeParentProductType( this );
	}
	
	// Products (one-to-many)
	public void function addProduct(required any product) {
		arguments.product.setProductType( this );
	}
	public void function removeProduct(required any product) {
		arguments.product.removeProductType( this );
	}
	
	// Attribute Set Assignments (one-to-many)
	public void function addAttributeSetAssignment(required any attributeSetAssignment) {
		arguments.attributeSetAssignment.setProductType( this );
	}
	public void function removeAttributeSetAssignment(required any attributeSetAssignment) {
		arguments.attributeSetAssignment.removeProductType( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("skuCacheService").updateFromProductType( this );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromProductType( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
