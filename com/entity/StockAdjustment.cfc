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
component displayname="Stock Adjustment" entityname="SlatwallStockAdjustment" table="SlatwallStockAdjustment" persistent="true" accessors="true" output="false" extends="BaseEntity" {

	// Persistent Properties
	property name="stockAdjustmentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="fromLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="fromLocationID";
	property name="toLocation" cfc="Location" fieldtype="many-to-one" fkcolumn="toLocationID";
	property name="stockAdjustmentType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentTypeID";
	property name="stockAdjustmentStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="stockAdjustmentStatusTypeID";
	
	// Related Object Properties (one-to-many)
	property name="stockAdjustmentItems" singularname="stockAdjustmentItem" cfc="StockAdjustmentItem" fieldtype="one-to-many" fkcolumn="stockAdjustmentID" inverse="true" cascade="all-delete-orphan";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public any function init() {
		if(isNull(variables.stockAdjustmentItems)) {
			variables.stockAdjustmentItems = [];
		}
		
		// Set the default status type
		if(isNull(variables.stockAdjustmentStatusType)) {
			variables.stockAdjustmentStatusType = getService("typeService").getTypeBySystemCode('sastNew');
		}
		return super.init();
	}
	
	// This method first finds the Stock with the provided sku and location, then searches in the VendorOrder's Items list for an item with that stock. If either are not found, it returns a blank VendorOrderItem
	public any function getStockAdjustmentItemForSkuAndLocation(required any skuID, required any locationID) {
		var sku = getService("SkuService").getSku(arguments.skuID);
		var location = getService("LocationService").getLocation(arguments.locationID);
		var stock = getService("StockService").getStockBySkuAndLocation(sku, location);
		
		for(var i=1; i<=arrayLen(getStockAdjustmentItems()); i++) {
			if(getStockAdjustmentItems()[i].getFromStock().getStockId() EQ stock.getStockId()) {
				return vendorOrderItems[i];
			}
		}
		
		// Otherwise, if stock was null (could not find one with that sku and location) or no VendorOrderItem was found with the located stock, return a new VendorOrderItem
		return getService("VendorOrderService").newVendorOrderItem();
	}
	
	// For use with Adjustment Items interface, get one location that we will use for stock lookup. 
	public any function getOneLocation() {
		if(getStockAdjustmentType().getSystemCode() == "satLocationTransfer" || getStockAdjustmentType().getSystemCode() == "satManualIn") {
			return getToLocation();
		} else {
			return getFromLocation();
		}
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Stock Adjustment Items (one-to-many)
	public void function addStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.setStockAdjustment( this );
	}
	
	public void function removeStockAdjustmentItem(required any stockAdjustmentItem) {
	   arguments.stockAdjustmentItem.removeStockAdjustment( this );
	}
	
	/************   END Association Management Methods   *******************/
	
	// ============ START: Non-Persistent Property Methods =================
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}