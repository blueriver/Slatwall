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

Notes: Test.

*/
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="stockService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	
	public void function default(required struct rc) {
		getFW().redirect("admin:stockadjustment.listStockAdjustments");
	}
	
	public void function listStockAdjustments(required struct rc) {
        param name="rc.orderBy" default="stockAdjustmentId|ASC";
        
        rc.stockAdjustmentSmartList = getStockService().getStockAdjustmentSmartList(data=arguments.rc);  
    }
    
    /*
    	Generic to all Stock Receiver types
    */
    public void function initStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	param name="rc.stockAdjustmentType" default="";
    	
    	if(len(rc.StockAdjustmentID)) {
    		rc.stockAdjustment = getStockService().getStockAdjustment(rc.stockAdjustmentID, true);
    	} else {
    		if(rc.stockAdjustmentType == "vendorOrder") {
    			rc.stockAdjustment = getStockService().newStockAdjustmentVendorOrder();
    		} else if(rc.stockAdjustmentType == "order") {
    			rc.stockAdjustment = getStockService().newStockAdjustmentOrder();
    		} else {
    			throw("Unknown StockAdjustment type: #rc.stockAdjustmentType#");
    		}
    	}
    	
    	// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.setPageRecordsShow(9999999);
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");
	}
    
    /*public void function detailStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	
    	initStockAdjustment(rc);
    	
    	if(isNull(rc.stockAdjustment)) {
    		getFW().redirect(action="admin:stockAdjustment.listStockAdjustments");
    	}
    	
    	// Proceed to the type-specific detail
    	if(rc.stockAdjustment.getReceiverType() == "vendorOrder") {
    		detailStockAdjustmentVendorOrder(rc);
    	} else if(rc.stockAdjustment.getReceiverType() == "order") {
    		detailStockAdjustmentOrder(rc);
    	} else {
    		throw("Unrecognized StockAdjustment type: #rc.stockAdjustment.getReceiverType()#");
    	}
    	
    	rc.edit = false;
		rc.itemTitle = rc.StockAdjustment.isNew() ? rc.$.Slatwall.rbKey("admin.stockreceiver.createStockAdjustment") : rc.$.Slatwall.rbKey("admin.stockreceiver.editStockAdjustment") & rc.$.Slatwall.rbKey("admin.stockreceiver.typeName_#rc.stockreceiver.getReceiverType()#");
		getFW().setView(action="admin:stockAdjustment.detailStockAdjustment");  	
    }*/
    
    /*
    	Vendor Order related.
    */
    /* public void function detailStockAdjustmentVendorOrder(required struct rc) {
		param name="rc.vendorOrderID";
    	
    	rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);	
    }*/

    public void function createStockAdjustment(required struct rc) {
    	//param name="rc.vendorOrderId" default="";
    	rc.stockAdjustmentType = "vendorOrder";
    	initStockAdjustment(rc);
    	
    	// Populate Vendor Order specific data
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
		
		if(isNull(rc.vendorOrder)) {
			getFW().redirect(action="admin:vendorOrder.detailOrderReceivers", queryString="VendorOrderID=#rc.VendorOrder.getVendorOrderID()#");
		}
	
		// Get Items
		//rc.vendorOrderItemSmartList = getVendorOrderService().getVendorOrderItemSmartList();
		//rc.vendorOrderItemSmartList.setPageRecordsShow(9999999);
		//rc.vendorOrderItemSmartList.addFilter("vendorOrder.vendorOrderID", rc.vendorOrderID);

    	rc.backAction = "admin:vendorOrder.detailVendorOrder";
    	rc.backQueryString = "vendorOrderID=#rc.vendorOrderId#";
    	rc.action = "admin:stockAdjustment.saveStockAdjustmentVendorOrder";
    	
    	rc.edit = true;
		rc.itemTitle = rc.StockAdjustment.isNew() ? rc.$.Slatwall.rbKey("admin.stockreceiver.createStockAdjustment") : rc.$.Slatwall.rbKey("admin.stockreceiver.editStockAdjustment") & rc.$.Slatwall.rbKey("admin.stockreceiver.typeName_#rc.stockreceiver.getReceiverType()#");
		getFW().setView(action="admin:stockAdjustment.detailStockAdjustment");
	}
    
   /* public void function editStockAdjustment(required struct rc) {
    	param name="rc.stockAdjustmentID" default="";
    	param name="rc.stockAdjustmentRateID" default="";
    	
    	rc.stockAdjustment = getStockService().getStockAdjustment(rc.stockAdjustmentID, true);
    	rc.stockAdjustmentRate = getStockService().getStockAdjustmentRate(rc.stockAdjustmentRateId, true);
    	
    	rc.edit = true; 
    	getFW().setView("admin:stockreceiver.detailStockAdjustment");  
	}*/
	
	public void function saveStockAdjustmentVendorOrder(required struct rc) {
		rc.stockAdjustmentType = "vendorOrder";
		var vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderId);
		
		// Call the generic save method.
		saveStockAdjustment(rc);
		
		// Since this is a vendor order reciever, also add the vendororder
		rc.StockAdjustment.setVendorOrder(vendorOrder);

		rc.message=rbKey("admin.vendorOrder.saveStockAdjustmentVendorOrder_success");
		getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderId=#rc.vendorOrderId#", preserve="message");
	} 
	

	// Only to be called from the type-specific save methods
	public void function saveStockAdjustment(required struct rc) {
		initStockAdjustment(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		var wasNew = rc.stockAdjustment.isNew();

		// Quantities provided by fields named like: quantity_skuid(4028b8813414708a01341514ad67001e). Loop over rc and find these fields. 
		for (var key IN rc) {
			var res = REFindNoCase("quantity_skuid\((.+)\)", key, 1, true);

			//logSlatwall("Found: #key#");

			if(ArrayLen(res.pos) == 2) {
				var skuID = mid(key, res.pos[2], res.len[2]);
				var quantity = val(rc[key]);
				var stock = getStockService().getStockBySkuAndLocation(getSkuService().getSku(skuID), getLocationService().getLocation(rc.receiveForLocationID));
				
				//logSlatwall("Found: #key# - #skuID# - #quantity#");
				
				if(len(skuID) && isNumeric(quantity)) {
					// Take the sku, location (selected), and quantity, and build a StockRecieverItem
					var stockAdjustmentItem = getStockService().newStockAdjustmentItem();
					stockAdjustmentItem.setStockAdjustment(rc.stockAdjustment);		
					stockAdjustmentItem.setQuantity(quantity);
					stockAdjustmentItem.setStock(stock);
				}
			}
		}
		
		// Populate with box count & packing slip, validate, and save
		rc.stockAdjustment = getStockService().saveStockAdjustment(rc.stockAdjustment, rc);
	}
}
