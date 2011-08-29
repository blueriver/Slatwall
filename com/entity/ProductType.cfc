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
	property name="productTypeName" ormtype="string" validateRequired="true";
    property name="productTypeDescription" ormtype="string" length="2000";
    property name="trackInventoryFlag" ormtype="boolean";
    property name="callToOrderFlag" ormtype="boolean";
    property name="allowShippingFlag" ormtype="boolean";
    property name="allowPreorderFlag" ormtype="boolean";
    property name="allowBackorderFlag" ormtype="boolean";
    property name="allowDropshipFlag" ormtype="boolean";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	property name="subProductTypes" cfc="ProductType" singularname="SubProductType" fieldtype="one-to-many" inverse="true" fkcolumn="parentProductTypeID" cascade="all";
	property name="products" singularname="Product" cfc="Product" fieldtype="one-to-many" inverse="true" fkcolumn="productTypeID" lazy="extra" cascade="all";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="ProductTypeAttributeSetAssignment" fieldtype="one-to-many" fkcolumn="productTypeID" cascade="all" ;
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionRewardProduct" fieldtype="one-to-many" fkcolumn="productTypeID" cascade="all-delete-orphan" inverse="true";
	
	// Calculated Properties
	property name="assignedFlag" type="boolean" formula="SELECT count(sp.productID) from SlatwallProduct sp INNER JOIN SlatwallProductType spt on sp.productTypeID = spt.productTypeID where sp.productTypeID=productTypeID";
	
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

	
    // @hint use this to implement get{setting}Options() calls for PropertyDisplay tags for settings
	public function onMissingMethod(missingMethodName, missingMethodArguments) {
		// first look to see if the method name follows the get{SettingName}Options naming convention and that {setting} is a valid property
		if( left(arguments.missingMethodName,3) == "get" 
		    && right(arguments.missingMethodName,7) == "options"
		    && listFindNoCase( getPropertyList(),mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-10) ) ) {
		    	var settingName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-10);
		    	return getSettingOptions(settingName);
		    }
	}
	
	private array function getSettingOptions(required string settingName) {
		var settingOptions = [
		  {id="1", name=rbKey("sitemanager.yes")},
		  {id="0", name=rbKey("sitemanager.no")}
		];
		return settingOptions;
	}
	
	public array function getInheritedAttributeSetAssignments(){
		//Todo get by all the parent productTypeIDs
		var attributeSetAssignments = getService("AttributeService").getAttributeSetAssignmentSmartList().getRecords();
		if(!arrayLen(attributeSetAssignments)){
			attributeSetAssignments = [];
		}
		return attributeSetAssignments;
	}
	
    /******* Association management methods for bidirectional relationships **************/
	
	// Products (one-to-many)
	
	public void function setProducts(required array Products) {
		// first, clear existing collection
		variables.Products = [];
		for( var i=1; i<= arraylen(arguments.Products); i++ ) {
			var thisProduct = arguments.Products[i];
			if(isObject(thisProduct) && thisProduct.getClassName() == "SlatwallProduct") {
				addProduct(thisProduct);
			}
		}
	}
	
	public void function addProduct(required Product Product) {
	   arguments.Product.setProductType(this);
	}
	
	public void function removeProduct(required Product Product) {
	   arguments.Product.removeProductType(this);
	}
	
	// attributeValues (one-to-many))
	public void function addAttributeSetAssignment(required any attributeSetAssignment) {
	   arguments.attributeSetAssignment.setProductType(this);
	}
	
	public void function removeAttributeSetAssignment(required any attributeSetAssignment) {
		arguments.attributeSetAssignment.removeProductType(this);
		
		//Todo: not sure why the remove method is not deleting the child entity.  This line makes sure that the record is actually deleted.
		getService("AttributeService").delete(attributeSetAssignment);
	}
	
	// promotionRewards (one-to-many))
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.setProductType(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeProductType(this);
	}
	
    /************   END Association Management Methods   *******************/
    
    public void function removeParentProductType() {
    	if(structKeyExists(variables,"parentProductType")) {
    		structDelete(variables,"parentProductType");
    	}
    }
    
    public boolean function getSetting(required string settingName) {
        if(structKeyExists(variables,arguments.settingName)) {
            return variables[arguments.settingName];
        } else {
            return getInheritedSetting( arguments.settingName );
        }
    }

    public boolean function getInheritedSetting( required string settingName ) {
    	if( this.hasParentProductType() ) {
	        var settingValue = getService("ProductService").getProductTypeSetting( getParentProductType().getProductTypeID(),arguments.settingName );
	    } else {
	    	var settingValue = "";
	    }
        if(len(settingValue) > 0) {
            return settingValue;
        } else {
        	// if setting hasn't been defined at the product type level, return the global setting
            return setting("product_#arguments.settingName#");
        }
    }
    
    public any function getWhereSettingDefined( required string settingName ) {
    	if(structKeyExists(variables,arguments.settingName)) {
    		return {type="Product Type", name=getProductTypeName(),id=getProductTypeID()};
    	} else {
    		return getService("ProductService").getWhereSettingDefined( getProductTypeID(),arguments.settingName );
    	}
    }
    
    public void function populate(required any data){
    	// remove the ones not selected, loop in reverse to prevent shifting of array items
    	var attributeSetAssignmentCount = arrayLen(getAttributeSetAssignments());
    	for(var i = attributeSetAssignmentCount; i > 0; i--){
    		var attributeSetAssignment = getAttributeSetAssignments()[i];
    		if(structKeyExists(data,"attributeSetIDs") && listFindNoCase(data.attributeSetIDs,attributeSetAssignment.getAttributeSet().getAttributeSetID()) == 0){
    			removeAttributeSetAssignment(attributeSetAssignment);
    		}
    	}
    	// Add new ones
    	if(structKeyExists(data,"attributeSetIDs")){
    		var attributeSetIDArray = listToArray(data.attributeSetIDs);
    		for(var attributeSetID in attributeSetIDArray){
    			var dataStruct = {"F:attributeSet_attributeSetID"=attributeSetID,"F:productType_productTypeID"=getProductTypeID()};
    			var attributeSetAssignmentArray = new Slatwall.org.entitySmartList.SmartList(entityName="SlatwallProductTypeAttributeSetAssignment",data=dataStruct).getRecords();
    			if(!arrayLen(attributeSetAssignmentArray)){
	    			var attributeSetAssignment = getService("AttributeService").newProductTypeAttributeSetAssignment();
	    			var attributeSet = getService("AttributeService").getAttributeSet(attributeSetID);
	    			attributeSetAssignment.setProductType(this);
	    			attributeSetAssignment.setAttributeSet(attributeSet);
	    			addAttributeSetAssignment(attributeSetAssignment);
    			}
    		}
    	}
    	super.populate(argumentCollection=arguments);
    }
}
