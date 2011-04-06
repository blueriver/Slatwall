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
component displayname="Product Type" entityname="SlatwallProductType" table="SlatwallProductType" persistent="true" extends="slatwall.com.entity.baseEntity" {
			
	// Persistant Properties
	property name="productTypeID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="productTypeName" ormtype="string" validateRequired displayname="Product Type" default="";
    property name="manufactureDiscontinued" ormtype="boolean" persistent=true displayname="Manufacture Discounted" hint="This property can determine if a product can still be ordered by a vendor or not";
    property name="showOnWeb" ormtype="boolean" displayname="Show On Web Retail" hint="Should this product be sold on the web retail Site";
    property name="showOnWebWholesale" ormtype="boolean" persistent=true displayname="Show On Web Wholesale" hint="Should this product be sold on the web wholesale Site";
    property name="trackInventory" ormtype="boolean" displayname="Non-Inventory Item";
    property name="callToOrder" ormtype="boolean" displayname="Call To Order";
    property name="allowShipping" ormtype="boolean" displayname="Allow Shipping";
    property name="allowPreorder" ormtype="boolean" displayname="Allow Pre-Orders" hint="";
    property name="allowBackorder" ormtype="boolean" displayname="Allow Backorders";
    property name="allowDropship" ormtype="boolean" displayname="Allow Dropship";
	
	// Related Object Properties
	property name="parentProductType" cfc="ProductType" fieldtype="many-to-one" fkcolumn="parentProductTypeID";
	property name="subProductTypes" cfc="ProductType" singularname="SubProductType" fieldtype="one-to-many" inverse="true" fkcolumn="parentProductTypeID" cascade="all";
	property name="Products" cfc="Product" singularname="Product" fieldtype="one-to-many" inverse="true" fkcolumn="productTypeID" lazy="extra" cascade="all";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="AttributeSetAssignment" fieldtype="one-to-many" fkcolumn="baseItemID" cascade="all";
	
	// Calculated Properties
	property name="isAssigned" type="boolean" formula="SELECT count(sp.productID) from SlatwallProduct sp INNER JOIN SlatwallProductType spt on sp.productTypeID = spt.productTypeID where sp.productTypeID=productTypeID";
	
	public ProductType function init(){
	   // set default collections for association management methods
	   if(isNull(variables.Products))
	       variables.Products = [];
	   return Super.init();
	}
	
	public boolean function hasProducts() {
		if(arrayLen(this.getProducts()) gt 0) {
			return true;
		} else {
			return false;
		}
	} 
	
	public boolean function hasSubProductTypes() {
		if(isNull(variables.subProductTypes) || arrayLen(this.getSubProductTypes()) == 0) {
			return false;
		} else {
			return true;
		}
	}
	
	public boolean function isCustomSettings() {
		var isCustom = false;
		var props = getMetaData(this).properties;
		for(var i=1; i<=arrayLen(props);i++) {
			local.thisProp = props[i];
			if( structKeyExists(local.thisProp,"ormType") && local.thisProp.ormType == "boolean" && structKeyExists(variables,local.thisProp.name) ) {
				isCustom = true;
				break;
			}
		}
		return isCustom;
	} 
	
	public any function getProductTypeTree() {
		return getService("ProductService").getProductTypeTree();
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
	
    /************   END Association Management Methods   *******************/
}
