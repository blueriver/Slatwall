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
		var orderParams['vendorOrderID'] = rc.vendorOrderID;
		var orderParams.orderBy = "createdDateTime|DESC";
		rc.vendorOrderItemSmartList = getVendorOrderService().getVendorOrderItemSmartList(data=orderParams);
			
		// Get Deliveries
		var orderParams['vendorOrderID'] = rc.vendorOrderID;
		var orderParams.orderBy = "createdDateTime|DESC";
		rc.vendorOrderDeliverySmartList = getVendorOrderService().getVendorOrderDeliverySmartList(data=orderParams);

		// Get Vendor's Products
		/*var orderParams['vendorOrderID'] = rc.vendorOrderID;
		var orderParams.orderBy = "createdDateTime|DESC";
		rc.vendorOrderDeliverySmartList = getVendorOrderService().getVendorOrderDeliverySmartList(data=orderParams);*/
		rc.vendorProducts = getVendorService().getProductsForVendor(rc.vendorOrder.getVendor().getVendorId());
		

		
  	  				
	  /* rc.vendorOrder = getVendorOrderService().getVendorOrder(rc.vendorOrderID);
	   //rc.shippingServices = getService("settingService").getShippingServices();
	   if(!isNull(rc.vendorOrder) and !rc.vendorOrder.isNew()) {
	       rc.itemTitle &= ": Vendor Order No. " & rc.vendorOrder.getVendorOrderNumber();
	   } else {
	       getFW().redirect("admin:vendorOrder.listVendorOrders");
	   }*/
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
		
		//dumpScreen(rc);

		// this does an RC -> Entity population, and flags the entities to be saved.
		getVendorOrderService().saveVendorOrder(rc.vendorOrder, rc);

		if(!rc.vendorOrder.hasErrors()) {
			// If added or edited a Price Group Rate
			if(rc.VendorOrder.isNew()) {
				rc.message=rbKey("admin.vendorOrder.savevendorOrder_nowaddorderitems");
				getFW().redirect(action="admin:vendorOrder.editVendorOrder", querystring="vendorOrderID=#rc.vendorOrder.getVendorOrderID()#", preserve="message");	
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
	
	
	
	
	
	
	
	/****** Order Fulfillments *****/
	
	/*public void function listOrderFulfillments(required struct rc) {
		param name="rc['F:order_orderstatustype_systemcode']" default="ostNew,ostProcessing";
		rc.fulfillmentSmartList = getVendorOrderService().getVendorOrderFulfillmentSmartList(data=arguments.rc);
	}
	
	public void function detailOrderFulfillment(required struct rc) {
		rc.vendorOrderFulfillment = getVendorOrderService().getVendorOrderFulfillment(rc.vendorOrderfulfillmentID);
		if(isNull(rc.vendorOrderFulfillment)) {
			getFW().redirect(action="admin:vendorOrder.listVendorOrdersOrderFulfillments");
		}
	}
	
	public void function processOrderFulfillment(required struct rc) {
		
		rc.vendorOrderFulfillment = getVendorOrderService().getVendorOrderFulfillment(rc.vendorOrderFulfillmentID);
		
		if(rc.vendorOrderFulfillment.isProcessable()) {
			var orderDeliveryItemsStruct = rc.vendorOrderItems;
			// call service to process fulfillment. Returns an orderDelivery
			var orderDelivery = getVendorOrderService().processOrderFulfillment(rc.vendorOrderfulfillment,orderDeliveryItemsStruct);
			if(!orderDelivery.hasErrors()) {
				
				getFW().redirect(action="admin:print", queryString="returnAction=admin:vendorOrder.listVendorOrders&printAction=packingSlip&orderDeliveryShippingID=#orderDelivery.getVendorOrderDeliveryID()#");
				
				// rc.message = rc.$.slatwall.rbKey("admin.order.processorderfulfillment_success");
				// getFW().redirect(action="admin:vendorOrder.listVendorOrdersorderfulfillments", preserve="message");
			} else {
				rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailOrderFulfillment");
				rc.message = orderDelivery.getError("orderDeliveryItems")[1];
				rc.messagetype = "warning";
				getFW().setView("admin:vendorOrder.detailOrderFulfillment");
			}
		} else {
			rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailOrderFulfillment");
			rc.message = rc.$.slatwall.rbKey("admin.order.processOrderFulfillment.notProcessable");
			rc.messagetype = "error";
			getFW().setView("admin:vendorOrder.detailOrderFulfillment");			
		}
	}*/

}
