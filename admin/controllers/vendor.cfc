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
	
	
	property name="addressService";
	property name="locationService" type="any";
	property name="productService" type="any";
	property name="settingService" type="any";
	property name="skuService" type="any";
	property name="stockService" type="any";
	property name="vendorService";
	property name="vendorOrderService" type="any";
	
	
	public void function default(required struct rc) {
		getFW().redirect(action="admin:vendor.listvendor");
	}
	
	public void function createVendorAddress(required struct rc) {
		editVendorAddress(rc);
	}
	
	public void function editVendorAddress(required struct rc) {
		param name="rc.vendorID" default="";
		param name="rc.vendorAddressID" default="";
		
    	rc.vendor = getVendorService().getVendor(rc.vendorID, true);
    	rc.vendorAddress = getVendorService().getVendorAddress(rc.vendorAddressID, true);
    	
       	// If vendorAddress is new then it won't contain an "Address" (vendorAddress is only a relational entity), so create a new one.
    	if(rc.vendorAddress.isNew()) {
    		rc.vendorAddress.setAddress(getAddressService().newAddress());	
    	}
    	rc.edit = true;
    	getFW().setView("admin:vendor.detailVendorAddress");
	}
	
	/*
	public void function listVendors(required struct rc) {
        param name="rc.orderBy" default="vendorId|ASC";
        
        rc.vendorSmartList = getVendorService().getVendorSmartList(data=arguments.rc);  
    }
	
	
	
	public void function initVendor(required struct rc) {
		param name="rc.vendorID" default="";
		param name="rc.vendorAddressID" default="";
		
		// These both will return blank objects if the rc fields are empty (no IDs).
    	rc.vendor = getVendorService().getVendor(rc.vendorID, true);
    	rc.vendorAddress = getVendorService().getVendorAddress(rc.vendorAddressID, true);
    	
    	// If vendorAddress is new then it won't contain an "Address" (vendorAddress is only a relational entity), so create a new one.
    	if(rc.vendorAddress.isNew()) {
    		rc.vendorAddress.setAddress(getAddressService().newAddress());	
    	}
    	
		rc.vendorOrderSmartList = rc.vendor.getVendorOrdersSmartList();
		rc.vendorOrderSmartList.addOrder("createdDateTime|DESC");
	}
	
	public void function detailVendor(required struct rc) {
		param name="rc.vendorID" default="";
    	param name="rc.edit" default="false";
    		
    	initVendor(rc);
    	
    	if(rc.vendor.isNew()) {
    		getFW().redirect(action="admin:vendor.listvendors");
    	}
	}
	
	public void function createVendor(required struct rc) {
		initVendor(rc);
		
		rc.edit = true; 
    	getFW().setView("admin:vendor.detailvendor");  
	}
	
	// Display edit interface
	public void function editVendor(required struct rc) {
		param name="rc.vendorID" default="";
    	param name="rc.vendorAddressID" default="";

		initVendor(rc);

    	rc.edit = true; 
    	getFW().setView("admin:vendor.detailvendor");  
	}
	
	public void function saveVendor(required struct rc) {
		param name="rc.vendorID" default="";
		param name="rc.vendorAddressID" default="";
		
		initVendor(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		rc.vendor = getVendorService().saveVendor(rc.vendor, rc);	

		if(!rc.vendor.hasErrors()) {
			// If added or edited a Price Group Rate
			if(rc.vendor.isNew()) {
				rc.message=rbKey("admin.vendor.saveVendor_success");
				//getFW().redirect(action="admin:vendor.editVendor", querystring="Vendorid=#rc.Vendor.getVendorID()#", preserve="message");
				getFW().redirect(action="admin:vendor.listvendors", preserve="message");	
			} else {
				rc.message=rc.message=rbKey("admin.vendor.saveVendor_success");
				
				// If any of the sub properties (such as address or email) has changed during this edit, then stay on the details page, otherwise, list.
				if(NOT findNoCase(rc.ignoreProperties, "vendorAddresses"))
					getFW().redirect(action="admin:vendor.editVendor", querystring="vendorID=#rc.Vendor.getVendorID()#", preserve="message");
				else
					getFW().redirect(action="admin:vendor.listVendors", preserve="message");
			}	
		} 
		else { 	
			rc.vendorAddress = getVendorService().newVendorAddress();
    		rc.vendorAddress.setAddress(getAddressService().newAddress());	

			// If one of the sub properties had the error, then find out which one and populate it
			if(rc.Vendor.hasError("VendorAddresses")) {
				for(var i=1; i<=arrayLen(rc.Vendor.getVendorAddresses()); i++) {
					if(rc.Vendor.getVendorAddresses()[i].getAddress().hasErrors()) {
						rc.VendorAddress = rc.Vendor.getVendorAddresses()[i];
						break;
					}
				}
			}

			rc.edit = true;
			rc.itemTitle = rc.Vendor.isNew() ? rc.$.Slatwall.rbKey("admin.Vendor.createVendor") : rc.$.Slatwall.rbKey("admin.Vendor.editVendor") & ": #rc.Vendor.getVendorName()#";
			getFW().setView(action="admin:vendor.detailvendor");
		}	
		
	}
	
	public void function deleteVendor(required struct rc) {
		param name="rc.vendorID";
		var vendor = getVendorService().getVendor(rc.vendorID);
		var deleteOK = getVendorService().deleteVendor(vendor);
	
		if( deleteOK ) {
			rc.message = rbKey("admin.vendor.delete_success");
		} else {
			rc.message = rbKey("admin.vendor.delete_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:vendor.listvendors", preserve="message,messageType");
	}
	
	public void function deletevendoraddress(required struct rc) {
		param name="rc.vendorAddressID";
		var vendorAddress = getVendorService().getVendorAddress(rc.vendorAddressID);
		var deleteOK = getVendorService().deleteVendorAddress(vendorAddress);
		
		if( deleteOK ) {
			rc.message = rbKey("admin.vendor.deleteVendorAddress_success");
		} else {
			rc.message = rbKey("admin.vendor.deleteVendorAddress_error");
			rc.messageType="error";
		}
		
		getFW().redirect(action="admin:vendor.detailvendor", querystring="vendorId=#vendorAddress.getVendor().getVendorId()#", preserve="message,messageType");
	}
	

	public void function listVendor(required struct rc) {
		param name="rc.keyword" default="";
		
		rc.vendorSmartList = getVendorService().getVendorSmartList(data=arguments.rc);
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
    
    public void function initVendorOrder(required struct rc) {
    	param name="rc.vendorOrderID" default="";
	
		rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderId, true);
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
		
		rc.edit = false;
		getFW().setView("admin:vendororder.detailvendororder"); 
	}
	
	public void function createVendorOrder(required struct rc) {
		initVendorOrder(rc);
		rc.edit = true;
		getFW().setView("admin:vendororder.detailvendororder");  
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
			getFW().setView(action="admin:vendororder.detailvendororder");
		}	
	}
	
	
	// Handlers for the "Add product to vendor order" dialog
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
				var skuID = lcase(mid(key, res.pos[2], res.len[2]));
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
				var skuID = lcase(mid(key, res.pos[2], res.len[2]));
				var locationID= lcase(mid(key, res.pos[3], res.len[3]));
				var quantity = val(rc[key]);
				if(len(skuID) && len(locationID)) {
					// We've found one of the inputs. See if a VendorOrderItem already exists with this sku and location. If so, then update it. Otherwise, we will have to create one, and possibly even the stock!
					var vendorOrderItem = vendorOrder.getVendorOrderItemForSkuAndLocation(skuID, locationID);
					
					if(vendorOrderItem.isNew()) {
						// Only proceed if we have a positive value
						if(quantity > 0) {
							// The vendorOrderItem is new. See if we already have a stock for that sku and location and use if it so, otherwise, creat a new stock
							var stock = getStockService().getStockBySkuAndLocation(getSkuService().getSku(skuID), getLocationService().getLocation(locationID));
							
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
							getVendorOrderService().deleteVendorOrderItem(vendorOrderItem);	
						}	
					}
				}
			}	
		}	
			
		rc.message=rbKey("admin.vendorOrder.savevendorOrderItems_success");
		getFW().redirect(action="admin:vendorOrder.detailVendorOrder", querystring="vendorOrderID=#vendorOrder.getVendorOrderID()#", preserve="message");
	}
	*/
}
