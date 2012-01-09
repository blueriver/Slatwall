<!---

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

--->
<cfcomponent extends="BaseDAO">
	
	<cfscript>
		/* 
			Quantity on hand. Physically at any location
		*/
		public numeric function getQOH(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(inventory.quantityIn), 0 ), coalesce( sum(inventory.quantityOut), 0 ) FROM SlatwallInventory inventory WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "inventory.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "inventory.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "inventory.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results[1] - results[2];
		}
		
		/* 
			Quantity on stock hold. Quantity on hold based on business requirement. Could be used to hold inventory for centain amount of time when user
			adds item to cart. Another use is when the item is reserved/held for a customer in store.
		*/
		public numeric function getQOSH(string stockID, string skuID, string productID) {
			// TODO: Setup Sales Hold
			return 0;
		}
		
		/* 
			Quantity not delivered on order
		*/
		public numeric function getQNDOO(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(orderItem.quantity), 0 ) FROM SlatwallOrderItem orderItem 
						WHERE orderItem.order.orderStatusType.systemCode != 'ostNotPlaced'
						AND orderItem.orderItemStatusType.systemCode != 'oistFulfilled' 
						 ";
			
			if(structKeyExists(arguments, "stockID")) {
				// TODO: stock is unknown at this point. This option should be removed.
				throw("Stock unknown at this point");
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "AND orderItem.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "AND orderItem.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity not delivered on return vendor order
		*/
		public numeric function getQNDORVO(string stockID, string skuID, string productID) {
			return 0;
		}
		
		/* 
			Quantity not delivered on stock adjustment
		*/
		public numeric function getQNDOSA(string stockID, string skuID, string productID) {

			var results = getQOUTOSA(argumentcollection=arguments) - getQOSAD(argumentcollection=arguments);
			
			return results;
		}
		
		/* 
			Quantity not received on return order
		*/
		public numeric function getQNRORO(string stockID, string skuID, string productID) {
			
			var results = getQORO(argumentcollection=arguments) - getQOROR(argumentcollection=arguments);
			
			return results;
		}
		
		/* 
			Quantity not received on vendor order
		*/
		public numeric function getQNROVO(string stockID, string skuID, string productID) {
			
			var results = getQOVO(argumentcollection=arguments) - getQOVOR(argumentcollection=arguments);
			
			return results;
		}
		
		/* 
			Quantity not received on stock adjustment
		*/
		public numeric function getQNROSA(string stockID, string skuID, string productID) {

			var results = getQINOSA(argumentcollection=arguments) - getQOSAR(argumentcollection=arguments);
			
			return results;
		}
		
		/* 
			Quantity received
		*/
		public numeric function getQR(string stockID, string skuID, string productID) {
			return 0;
		}
		
		/* 
			Quantity sold
		*/
		public numeric function getQS(string stockID, string skuID, string productID) {
			return 0;
		}
		
		/******************************************************************************/
		/* helper methods */
		/******************************************************************************/
		
		/* 
			Quantity on return order
		*/
		public numeric function getQORO(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(orderReturnItem.quantity), 0 ) FROM SlatwallOrderReturn orderReturn JOIN orderReturn.orderReturnItems orderReturnItem JOIN orderReturnItem.sku sku JOIN sku.stocks stock WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "orderReturnItem.sku.skuID = ?";
				hql &= "AND stock.locationID = orderReturn.returnLocation";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "orderReturnItem.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "orderReturnItem.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on return order receiver
		*/
		public numeric function getQOROR(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockReceiverItem.quantity), 0 ) FROM SlatwallStockReceiverOrder stockReceiverOrder JOIN stockReceiverOrder.stockReceiverItems stockReceiverItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockReceiverItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockReceiverItem.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockReceiverItem.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on vendor order
		*/
		public numeric function getQOVO(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(vendorOrderItem.quantity), 0 ) FROM SlatwallVendorOrderItem vendorOrderItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "vendorOrderItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "vendorOrderItem.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "vendorOrderItem.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on vendor order receiver
		*/
		public numeric function getQOVOR(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockReceiverItem.quantity), 0 ) FROM SlatwallStockReceiverVendorOrder stockReceiverVendorOrder JOIN stockReceiverVendorOrder.stockReceiverItems stockReceiverItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockReceiverItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockReceiverItem.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockReceiverItem.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on stock adjustment
		*/
		public numeric function getQOSA(string stockID, string skuID, string productID) {
			
			var results = getQINOSA(argumentcollection=arguments) - getQOUTOSA(argumentcollection=arguments);
			
			return results;
		}
		
		/* 
			Quantity IN on stock adjustment
		*/
		public numeric function getQINOSA(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockAdjustmentItem.quantity), 0 ) FROM SlatwallStockAdjustmentItem stockAdjustmentItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockAdjustmentItem.toStock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockAdjustmentItem.toStock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockAdjustmentItem.toStock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity OUT on stock adjustment
		*/
		public numeric function getQOUTOSA(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockAdjustmentItem.quantity), 0 ) FROM SlatwallStockAdjustmentItem stockAdjustmentItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockAdjustmentItem.fromStock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockAdjustmentItem.fromStock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockAdjustmentItem.fromStock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on stock adjustment receiver
		*/
		public numeric function getQOSAR(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockReceiverItem.quantity), 0 ) FROM SlatwallStockReceiverStockAdjustment stockReceiverStockAdjustment JOIN stockReceiverStockAdjustment.stockReceiverItems stockReceiverItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockReceiverItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockReceiverItem.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockReceiverItem.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		
		/* 
			Quantity on stock adjustment delivery
		*/
		public numeric function getQOSAD(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockAdjustmentDeliveryItem.quantity), 0 ) FROM SlatwallStockAdjustmentDeliveryItem stockAdjustmentDeliveryItem WHERE ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "stockAdjustmentDeliveryItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "stockAdjustmentDeliveryItem.stock.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "stockAdjustmentDeliveryItem.stock.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			var results = ormExecuteQuery(hql, params, true);
			
			return results;
		}
		

	</cfscript>
	
</cfcomponent>
