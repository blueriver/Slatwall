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
component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="vendorOrderService" type="any";
	property name="vendorService" type="any";
	property name="productService" type="any";
	property name="locationService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="settingService" type="any";
	
	public void function before(required struct rc) {
		param name="rc.vendorOrderID" default="";
		param name="rc.keyword" default="";
	}
	
	public void function default(required struct rc) {
		getFW().redirect("admin:vendorOrder.listVendorOrders");
	}
	
    public void function listVendorOrders(required struct rc) {
		param name="rc.vendorOrderby" default="createdDateTime|DESC";
		param name="rc.vendorOrderDateStart" default="";
		param name="rc.vendorOrderDateEnd" default="";
		
		// show advanced search fields if they have been filled
		if(len(trim(rc.vendorOrderDateStart)) > 0 || len(trim(rc.vendorOrderDateEnd)) > 0) {
			rc.showAdvancedSearch = 1;
		}
		rc.vendorOrderSmartList = getVendorOrderService().searchVendorOrders(data=arguments.rc);
    }    
	
	public void function detailVendorOrder(required struct rc) {
		param name="rc.vendorOrderID" default="";
    	param name="rc.edit" default="false";
    		
    	initVendorOrder(rc);
    	
    	// Redirect the user back to list if the Vendor Order was found to be new (possibly bad or blank ID).
    	if(!rc.vendorOrder.isNew()) {
	       rc.itemTitle &= ": Vendor Order No. " & rc.vendorOrder.getVendorOrderNumber();
		} else {
    		getFW().redirect(action="admin:vendororder.listVendorOrders");
    	}
    	
    	// Get Items
		rc.vendorOrderItemSmartList = getVendorOrderService().getVendorOrderItemSmartList();
		rc.vendorOrderItemSmartList.addFilter("vendorOrder.vendorOrderID", rc.vendorOrderID);
			
		// Get Receivers
		rc.stockReceiverVendorOrderSmartList = getStockService().getStockReceiverVendorOrderSmartList();
		rc.stockReceiverVendorOrderSmartList.addFilter("vendorOrder.vendorOrderID", rc.vendorOrderID);
		
		// Get Vendor's Products
		rc.vendorProductSmartList = getProductService().getProductSmartList();
		rc.vendorProductSmartList.setPageRecordsShow(9999999);
		rc.vendorProductSmartList.addFilter("brand.vendors.vendorID", rc.VendorOrder.getVendor().getVendorID());
	}
	
	public void function initVendorOrder(required struct rc) {
    	param name="rc.vendorOrderID" default="";
	
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderId, true);
	}
	
	/*public void function editVendorOrder(required struct rc) {
    	param name="rc.vendorOrderID" default="";
    	
    	initVendorOrder(rc);
    	rc.edit = true; 
    	getFW().setView("admin:vendorOrder.detailVendorOrder");  
	}*/

	public void function createVendorOrder(required struct rc) {
		initVendorOrder(rc);
		rc.edit = true;
	
		getFW().setView("admin:vendorOrder.detailVendorOrder");  
	}
	
	public void function saveVendorOrder(required struct rc) {
		initVendorOrder(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		var wasNew = rc.VendorOrder.isNew();
		getVendorOrderService().saveVendorOrder(rc.vendorOrder, rc);

		if(!rc.vendorOrder.hasErrors()) {
			// If added or edited a Price Group Rate
			if(wasNew) { 
				rc.message=rbKey("admin.vendorOrder.savevendorOrder_nowaddorderitems");
				getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderID=#rc.vendorOrder.getVendorOrderID()#", preserve="message");	
			} else {
				rc.message=rc.message=rbKey("admin.vendorOrder.savevendorOrder_success");
				getFW().redirect(action="admin:vendorOrder.listVendorOrders", querystring="", preserve="message");
			}
			
		} 
		else { 			
			rc.edit = true;
			rc.itemTitle = rc.VendorOrder.isNew() ? rc.$.Slatwall.rbKey("admin.vendorOrder.createVendorOrder") : rc.$.Slatwall.rbKey("admin.vendorOrder.editVendorOrder") & ": #rc.vendorOrder.getVendorOrderName()#";
			getFW().setView(action="admin:vendorOrder.detailVendorOrder");
		}	
	}
	
	/*
		Handlers for the "Add product to vendor order" dialog
	*/
	public void function editVendorOrderItems(required struct rc) {
    	param name="rc.vendorOrderID" default="";
    	param name="rc.productID" default="";
    	param name="rc.inDialog" default="false";

    	initVendorOrder(rc);
    	rc.product = getProductService().getProduct(rc.productId);
    	
    	// Get Location
		//var orderParams['vendorOrderID'] = rc.vendorOrderID;
		//var orderParams.orderBy = "createdDateTime|DESC";
		rc.locationSmartList = getLocationService().getLocationSmartList();
		
    	rc.edit = true; 
    	rc.itemTitle = rbKey("admin.vendororder.editvendororderproductassignment");
    	rc.itemTitle = ReplaceNoCase(rc.itemTitle, "{1}", rc.product.getProductName());
    	getFW().setView("admin:vendorOrder.editvendororderitems");  
	}
	
	// Called from vendor order items / sku assignment dialog
	public void function saveVendorOrderItems(required struct rc) {
		param name="rc.vendorOrderID";
		var vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
		var skuCosts = {};
	
		// Sku costs are provided by fields named like: cost_skuid(4028b8813414708a01341514ad67001e). Loop over rc and find these fields. Build an associative array keyed on sku, containing the cost. This will be used to populate the cost into each vendorOrderItem in the next loop.
		for (var key IN rc) {
			//key = "qty_skuid(4028b8813414708a01341514ad67001e)_locationid(4028e6893463040e0134672d027900ba)";
			var res = REFindNoCase("cost_skuid\((.+)\)", key, 1, true);

			if(ArrayLen(res.pos) == 2) {
				var skuID = mid(key, res.pos[2], res.len[2]);
				var cost = val(rc[key]);
				if(len(skuID)) {
					skuCosts[skuID] = cost;
				}
			}
		}
	
		// Sku / location quantities are provided by fields named like: qty_skuid(4028b8813414708a01341514ad67001e)_locationid(4028e6893463040e0134672d027900ba). Loop over rc and find these fields
		for (var key IN rc) {
			var res = REFindNoCase("qty_skuid\((.+)\)_locationid\((.+)\)", key, 1, true);

			if(ArrayLen(res.pos) == 3) {
				var skuID = mid(key, res.pos[2], res.len[2]);
				var locationID= mid(key, res.pos[3], res.len[3]);
				var quantity = val(rc[key]);
				if(len(skuID) && len(locationID)) {
					// We've found one of the inputs. See if a VendorOrderItem already exists with this sku and location. If so, then update it. Otherwise, we will have to create one, and possibly even the stock!
					var vendorOrderItem = vendorOrder.getVendorOrderItemForSkuAndLocation(skuID, locationID);
					
					if(vendorOrderItem.isNew()) {
						// Only proceed if we have a positive value
						if(quantity > 0) {
							// The vendorOrderItem is new. See if we already have a stock for that sku and location and use if it so, otherwise, creat a new stock
							var stock = getVendorOrderService().getStockForSkuAndLocation(skuID, locationID);
							
							if(isNull(stock)) {
								stock = getVendorOrderService().getStock(0, true);
								stock.setSku(getSkuService().getSku(skuID));
								stock.setLocation(getLocationService().getLocation(locationID));
								getVendorOrderService().saveStock(stock);
							} 

							vendorOrderItem.setStock(stock);
							vendorOrderItem.setVendorOrder(vendorOrder);
							vendorOrderItem.setQuantity(quantity);
							vendorOrderItem.setCost(skuCosts[skuID]);
							getVendorOrderService().saveVendorOrderItem(vendorOrderItem);
						}	
						
					} else {
						// vendorOrderItem existed. If qty is positive number, simply update the quantity. If 0, delete VendorOrderItem
						if(quantity > 0) {
							vendorOrderItem.setQuantity(quantity);
							vendorOrderItem.setCost(skuCosts[skuID]);
						} else {
							vendorOrder.removeVendorOrderItem(vendorOrderItem);
							getVendorOrderService().deleteVendorOrderItem(vendorOrderItem);		// TODO!!!!!!!!!! Make sure this does not delete the stock!
						}	
					}
				}
			}	
		}	
			
		rc.message=rbKey("admin.vendorOrder.savevendorOrderItems_success");
		getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderID=#vendorOrder.getVendorOrderID()#", preserve="message");
	}
	
	
	
	/*public void function cancelorder(required struct rc) {
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
		var response = getVendorOrderService().cancelOrder(rc.vendorOrder);
		if( !response.hasErrors() ) {
			rc.message = rc.$.slatwall.rbKey("admin.order.cancelorder_success");
		} else {
			rc.message = response.getError("cancel");
			rc.messageType = "error";
		}
		rc.itemTitle &= ": Order No. " & rc.vendorOrder.getVendorOrderNumber();
		getFW().setView(action="admin:vendorOrder.detail");
	}*/
	
	
	
	
	
	
	
	/* 
		Vendor Order Receivers 
	*/
	
		
	/*public void function listVendorOrderReceivers(required struct rc) {
		param name="rc['F:order_orderstatustype_systemcode']" default="ostNew,ostProcessing";
		rc.fulfillmentSmartList = getVendorOrderService().getVendorOrderReceiverSmartList(data=arguments.rc);
	}*/
	
/*
	public void function detailVendorOrderReceiver(required struct rc) {
		param name="rc.vendorOrderReceiverID" default="";
		
		rc.vendorOrderReceiver = getVendorOrderService().getVendorOrderReceiver(rc.vendorOrderReceiverId, true);

		if(isNull(rc.vendorOrderReceiver)) {
			getFW().redirect(action="admin:vendorOrder.listVendorOrderReceivers");
		}
		
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.VendorOrderReceiver.getVendorOrder().getVendorOrderId());
		
		rc.edit = false;
		getFW().setView("admin:vendorOrder.detailvendororderreceiver");  
	}
	
	public void function createVendorOrderReceiver(required struct rc){
		param name="rc.vendorOrderID" default="";
		
		rc.vendorOrderReceiver = getVendorOrderService().getVendorOrderReceiver(0, true);
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
		
		if(isNull(rc.vendorOrder)) {
			getFW().redirect(action="admin:vendorOrder.listVendorOrderReceivers");
		}
	
		// Get Items
		rc.vendorOrderItemSmartList = getVendorOrderService().getVendorOrderItemSmartList();
		rc.vendorOrderItemSmartList.setPageRecordsShow(9999999);
		rc.vendorOrderItemSmartList.addFilter("vendorOrder.vendorOrderID", rc.vendorOrderID);
		
		// Set up the locations smart list to return an array that is compatible with the cf_slatwallformfield output tag
		rc.locationSmartList = getLocationService().getLocationSmartList();
		rc.locationSmartList.setPageRecordsShow(9999999);
		rc.locationSmartList.addSelect(propertyIdentifier="locationName", alias="name");
		rc.locationSmartList.addSelect(propertyIdentifier="locationId", alias="value");

		rc.edit = true;
		getFW().setView("admin:vendorOrder.createvendororderreceiver");  
	}
	
	// Currently we only support adding new Vendor Order Receivers. Not editing.
	public void function saveVendorOrderReceiver(required struct rc){
		param name="rc.vendorOrderID";
		param name="rc.receiveForLocationId";
		
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderId);
		rc.vendorOrderReceiver = getVendorOrderService().getVendorOrderReceiver(0, true);
		rc.vendorOrderReceiver.setVendorOrder(rc.vendorOrder);
		rc.vendorOrderReceiver.setBoxCount(rc.boxCount);
		
		// We need to do some combining of Receiver Items, so we'll store them in a stockID keyed struct
		var vendorOrderReceiverItemsByStockId = {};
		
		// Sku / location quantities are provided by fields named like: qty_skuid(4028b8813414708a01341514ad67001e)_locationid(4028e6893463040e0134672d027900ba). Loop over rc and find these fields
		for (var key IN rc) {
			var res = REFindNoCase("cost_stockid\((.+)\)", key, 1, true);

			if(ArrayLen(res.pos) == 2) {
				var stockID = mid(key, res.pos[2], res.len[2]);
				var cost = val(rc[key]);
				
				if(len(stockID)) {
					// Pull the quantity
					var quantity = rc["quantity_stockid(#stockID#)"];
					
					if(isNumeric(quantity) && isNumeric(cost)) {
						var stock = getVendorOrderService().getStock(stockID);
						var vendorOrderReceiverItem = getVendorOrderService().getVendorOrderReceiverItem(0, true);
						//vendorOrderReceiverItem.setVendorOrderReceiver(rc.vendorOrderReceiver);
						vendorOrderReceiverItem.setQuantity(quantity);
						vendorOrderReceiverItem.setCost(cost);
						
						// If the "receiveForLocationID" passed in (the drop down) matches this stock's location, then use that. Otherwise, find the stock to the corresponding location
						stock = getVendorOrderService().getStockForSkuAndLocation(stock.getSku().getSkuID(), rc.receiveForLocationId);
						vendorOrderReceiverItem.setStock(stock);
						
						// Search the stockID keyed struc for this stock. The only way that we would find the item already present is if the user is trying to receive the same SKU from multiple locations.
						if(StructKeyExists(vendorOrderReceiverItemsByStockId, stock.getStockId())) {
							vendorOrderReceiverItemsByStockId[stock.getStockId()].setQuantity(vendorOrderReceiverItemsByStockId[stock.getStockId()].getQuantity() + quantity);
						} else {
							// Otherwise it did not exist, so tie the item to the receiver, and a it to the struct.
							vendorOrderReceiverItem.setVendorOrderReceiver(rc.vendorOrderReceiver);
							vendorOrderReceiverItemsByStockId[stock.getStockId()] = vendorOrderReceiverItem;
						}
					}
				}
			}
		}
		
		// Loop over the Items struct and finally assign them to the Receiever.
		for (var key IN vendorOrderReceiverItemsByStockId) {
			vendorOrderReceiverItemsByStockId[key].setVendorOrderReceiver(rc.vendorOrderReceiver);
		}
		
		getVendorOrderService().saveVendorOrderReceiver(rc.vendorOrderReceiver);
			
		rc.message=rbKey("admin.vendorOrder.savevendorOrderReceiver_success");
		getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderID=#rc.vendorOrder.getVendorOrderID()#", preserve="message");
	}
	
	*/
	
	/*public void function processVendorOrderReceiver(required struct rc) {
		
		rc.vendorOrderReceiver = getVendorOrderService().getVendorOrderReceiver(rc.vendorOrderReceiverID);
		
		if(rc.vendorOrderReceiver.isProcessable()) {
			var orderDeliveryItemsStruct = rc.vendorOrderItems;
			// call service to process fulfillment. Returns an orderDelivery
			var orderDelivery = getVendorOrderService().processVendorOrderReceiver(rc.vendorOrderReceiver,orderDeliveryItemsStruct);
			if(!orderDelivery.hasErrors()) {
				
				getFW().redirect(action="admin:print", queryString="returnAction=admin:vendorOrder.listVendorOrders&printAction=packingSlip&orderDeliveryShippingID=#orderDelivery.getVendorOrderDeliveryID()#");
				
				// rc.message = rc.$.slatwall.rbKey("admin.order.processvendorOrderReceiver_success");
				// getFW().redirect(action="admin:vendorOrder.listVendorOrderReceivers", preserve="message");
			} else {
				rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailVendorOrderReceiver");
				rc.message = orderDelivery.getError("orderDeliveryItems")[1];
				rc.messagetype = "warning";
				getFW().setView("admin:vendorOrder.detailVendorOrderReceiver");
			}
		} else {
			rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailVendorOrderReceiver");
			rc.message = rc.$.slatwall.rbKey("admin.order.processVendorOrderReceiver.notProcessable");
			rc.messagetype = "error";
			getFW().setView("admin:vendorOrder.detailVendorOrderReceiver");			
		}
	}*/

}
