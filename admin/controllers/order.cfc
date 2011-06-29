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
	property name="orderService" type="any";
	property name="paymentService" type="any";
	
	public void function before(required struct rc) {
		param name="rc.orderID" default="";
		param name="rc.keyword" default="";
	}
	
	public void function dashboard(required struct rc) {
		getFW().redirect("admin:order.list");
	}

    public void function list(required struct rc) {
		param name="rc.orderby" default="orderOpenDateTime|DESC";
		param name="rc['F:orderstatustype_systemcode']" default="ostNew,ostProcessing";
		param name="rc.orderDateStart" default="";
		param name="rc.orderDateEnd" default="";
		if(structKeyExists(rc,"isSearch")) {
			processOrderSearch(arguments.rc);
		}
		rc.orderStatusOptions = getOrderService().getOrderStatusOptions();
		rc.orderSmartList = getOrderService().getOrderSmartList(data=arguments.rc);
    }    
    
	private void function processOrderSearch(required struct rc) {
		// if someone tries to filter for carts using URL, override the filter
		if(rc['F:orderstatustype_systemcode'] == "ostNotPlaced") {
			rc["F:orderstatustype_systemcode"] = "ostNew,ostProcessing";
		}
		// show advanced search fields if they have been filled
		if(len(trim(rc.orderDateStart)) > 0 || len(trim(rc.orderDateEnd)) > 0 || (len(rc['F:orderstatustype_systemcode']) && rc['F:orderstatustype_systemcode'] != "ostNew,ostProcessing" )) {
			rc.showAdvancedSearch = 1;
		}
		// date range (start or end) have been submitted 
		if(len(trim(rc.orderDateStart)) > 0 || len(trim(rc.orderDateEnd)) > 0) {
			var dateStart = rc.orderDateStart;
			var dateEnd = rc.orderDateEnd;
			// if either the start or end date is blank, default them to a long time ago or now(), respectively
 			if(len(trim(rc.orderDateStart)) == 0) {
 				dateStart = createDateTime(30,1,1,0,0,0);
 			} else if(len(trim(rc.orderDateEnd)) == 0) {
 				dateEnd = now();
 			}
 			// make sure we have valid datetimes
 			if(isDate(dateStart) && isDate(dateEnd)) {
 				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make sure we get all orders on the last day of the range (only if it was entered)
				if(len(trim(rc.orderDateEnd)) > 0) {
					dateEnd = dateAdd('s',85399,dateEnd);	
				}
				rc['R:orderOpenDateTime'] = "#dateStart#,#dateEnd#";
 			} else {
 				rc.message = #rc.$.slatwall.rbKey("admin.order.search.invaliddates")#;
 				rc.messagetype = "warning";
 			}
		}
			
	}
	
	public void function detail(required struct rc) {
	   rc.order = getOrderService().getOrder(rc.orderID);
	   rc.shippingServices = getService("settingService").getShippingServices();
	   if(!isNull(rc.order) and !rc.order.isNew()) {
	       rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
	   } else {
	       getFW().redirect("admin:order.list");
	   }
	}
	
	public void function applyOrderActions(required struct rc) {
		for( var i=1; i<=listLen(rc.orderActions); i++ ) {
			local.thisOrderID = listFirst(listGetAt(rc.orderActions,i),"_");
			local.thisOrderActionTypeID = listLast(listGetAt(rc.orderActions,i),"_");
			var applied = getOrderService().applyOrderAction(local.thisOrderID,local.thisOrderActionTypeID);
		}
		if( applied ) {
			rc.message = rc.$.slatwall.rbKey("admin.order.applyOrderActions_success");
			getFW().redirect(action="admin:order.list", preserve="message");
		}
	}
	
	public void function cancelorder(required struct rc) {
		rc.order = getOrderService().getOrder(rc.orderID);
		var response = getOrderService().cancelOrder(rc.order);
		if( !response.hasErrors() ) {
			rc.message = rc.$.slatwall.rbKey("admin.order.cancelorder_success");
		} else {
			rc.message = response.getError("cancel");
			rc.messageType = "error";
		}
		rc.itemTitle &= ": Order No. " & rc.order.getOrderNumber();
		getFW().setView(action="admin:order.detail");
	}
	
	public void function chargeOrderPayment(required struct rc) {
		var orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		if(!isNull(orderPayment)) {
			var chargeOK = getPaymentService().processPayment(orderPayment,"chargePreAuthorization",orderPayment.getAmount());
			if(chargeOK) {
				rc.message = rc.$.slatwall.rbKey("admin.order.chargeOrderPayment_success");
				getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message");
			} else {
				rc.errorBean = orderPayment.getErrorBean();
				rc.messagetype = "error";
				rc.message = rc.$.slatwall.rbKey("admin.order.chargeOrderPayment_error");
				getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype,errorBean");
			}
		} else {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");
		}
	}
	
	public void function refundOrderPayment(required struct rc) {
		rc.orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		if(isNull(rc.orderPayment)) {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");		
		}
	}
	
	public void function processOrderPaymentRefund(required struct rc) {
		var orderPayment = getOrderService().getOrderPayment(rc.orderPaymentID);
		var refundOK = false;
		if(!isNull(orderPayment)) {
			// make sure that the refund amount entered is within the limits
			if(isNumeric(rc.refundAmount) && rc.refundAmount > 0 && rc.refundAmount <= orderPayment.getAmountCharged()) {
				refundOK = getPaymentService().processPayment(orderPayment,"credit",rc.refundAmount);
				if(refundOK) {
					rc.message = rc.$.slatwall.rbKey("admin.order.refundOrderPayment_success");
					getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message");
				} else {
					rc.errorBean = orderPayment.getErrorBean();
					rc.messagetype = "error";
					rc.message = rc.$.slatwall.rbKey("admin.order.refundOrderPayment_error");
					getFW().redirect(action="admin:order.detail", queryString="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype,errorBean");
				}	
			} else {
				rc.message = rc.$.slatwall.rbKey("admin.order.refundorderpayment_invalidAmount");
				rc.message = replaceNoCase(rc.message,"{amountCharged}",dollarFormat(orderPayment.getAmountCharged()),"one");
				rc.messageType = "error";
				getFW().redirect(action="admin:order.detail",querystring="orderID=#orderPayment.getOrder().getOrderID()#",preserve="message,messagetype");
			}
		} else {
			rc.message = rc.$.slatwall.rbKey("admin.order.orderpayment_notexists");
			rc.messageType = "error";
			getFW().redirect(action="admin:order.list",preserve="message,messagetype");				
		}
	}
	
	/****** Order Fulfillments *****/
	
	public void function listOrderFulfillments(required struct rc) {
		param name="rc['F:order_orderstatustype_systemcode']" default="ostNew,ostProcessing";
		rc.fulfillmentSmartList = getOrderService().getOrderFulfillmentSmartList(data=arguments.rc);
	}
	
	public void function detailOrderFulfillment(required struct rc) {
		rc.orderFulfillment = getOrderService().getOrderFulfillment(rc.orderfulfillmentID);
		if(isNull(rc.orderFulfillment)) {
			getFW().redirect(action="admin:order.listOrderFulfillments");
		}
	}
	
	public void function processOrderFulfillment(required struct rc) {
		rc.orderFulfillment = getOrderService().getOrderFulfillment(rc.orderFulfillmentID);	
		var orderDeliveryItemsStruct = getService("formUtilities").buildFormCollections(rc)['orderItems'];
		// call service to process fulfillment. Returns an orderDelivery
		var orderDelivery = getOrderService().processOrderFulfillment(rc.orderfulfillment,orderDeliveryItemsStruct);
		if(!orderDelivery.hasErrors()) {
			rc.message = rc.$.slatwall.rbKey("admin.order.processorderfulfillment_success");
			getFW().redirect(action="admin:order.listorderfulfillments", preserve="message");
		} else {
			rc.itemTitle = rc.$.slatwall.rbKey("admin.order.detailOrderFulfillment");
			rc.message = orderDelivery.getErrorBean().getError("orderDeliveryItems");
			rc.messagetype = "warning";
			getFW().setView("admin:order.detailOrderFulfillment");
		}
	}

}
