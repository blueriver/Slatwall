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
component entityname="SlatwallPhysical" table="SlatwallPhysical" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="PhysicalService" hb_permission="this" {
	
	// Persistent Properties
	property name="physicalID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (many-to-one)
	property name="physicalStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="physicalStatusTypeID";
	
	// Related Object Properties (one-to-many)
	property name="physicalCounts" singularname="physicalCount" cfc="PhysicalCount" type="array" fieldtype="one-to-many" fkcolumn="physicalID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="locations" singularname="location" cfc="Location" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalLocation" fkcolumn="physicalID" inversejoincolumn="locationID";
	property name="productTypes" singularname="productType" cfc="ProductType" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalProductType" fkcolumn="physicalID" inversejoincolumn="productTypeID";
	property name="products" singularname="product" cfc="Product" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalProduct" fkcolumn="physicalID" inversejoincolumn="productID";
	property name="brands" singularname="brand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalBrand" fkcolumn="physicalID" inversejoincolumn="BrandID";
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SlatwallPhysicalSku" fkcolumn="physicalID" inversejoincolumn="skuID";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="physicalStatusTypeSystemCode" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getPhysicalStatusTypeSystemCode() {
		return getPhysicalStatusType().getSystemCode();
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Physical Counts (one-to-many)    
	public void function addPhysicalCount(required any physicalCount) {    
		arguments.physicalCount.setPhysical( this );    
	}    
	public void function removePhysicalCount(required any physicalCount) {    
		arguments.physicalCount.removePhysical( this );    
	}
	
	// Locations (many-to-many - owner)
	public void function addLocation(required any location) {
		if(arguments.location.isNew() or !hasLocation(arguments.location)) {
			arrayAppend(variables.locations, arguments.location);
		}
		if(isNew() or !arguments.location.hasPhysical( this )) {
			arrayAppend(arguments.location.getPhysicals(), this);
		}
	}
	public void function removeLocation(required any location) {
		var thisIndex = arrayFind(variables.locations, arguments.location);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.locations, thisIndex);
		}
		var thatIndex = arrayFind(arguments.location.getPhysicals(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.location.getPhysicals(), thatIndex);
		}
	}
	
	// Product (many-to-many - owner)    
	public void function addProduct(required any product) {    
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {    
			arrayAppend(variables.product, arguments.product);    
		}    
		if(isNew() or !arguments.product.hasPhysical( this )) {    
			arrayAppend(arguments.product.getPhysicals(), this);    
		}    
	}    
	public void function removeProduct(required any product) {    
		var thisIndex = arrayFind(variables.product, arguments.product);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.product, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.product.getPhysicals(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.product.getPhysicals(), thatIndex);    
		}    
	}
	
	// Brands (many-to-many - owner)    
	public void function addBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {    
			arrayAppend(variables.brand, arguments.brand);    
		}    
		if(isNew() or !arguments.brand.hasPhysical( this )) {    
			arrayAppend(arguments.brand.getPhysicals(), this);    
		}    
	}    
	public void function removeBrand(required any brand) {    
		var thisIndex = arrayFind(variables.brand, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.brand, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.brand.getPhysicals(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getPhysicals(), thatIndex);    
		}    
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.sku, arguments.sku);    
		}    
		if(isNew() or !arguments.sku.hasPhysical( this )) {    
			arrayAppend(arguments.sku.getPhysicals(), this);    
		}    
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.sku, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.sku, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.sku.getPhysicals(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getPhysicals(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "createdDateTime";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}