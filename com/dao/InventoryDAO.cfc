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
		
		// Quantity on hand. Physically at any location
		public numeric function getQOH(string stockID, string skuID, string productID) {
			var params = [];
			var hql = "SELECT coalesce( sum(inventory.quantityIn), 0 ) - coalesce( sum(inventory.quantityOut), 0 ) FROM SlatwallInventory inventory WHERE ";
			
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
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity On Sales Hold
		public numeric function getQOSH(string stockID, string skuID, string productID) {
			// TODO: Setup Sales Hold
			return 0;
		}
		
		// Quantity Not Delivered on Order 
		public numeric function getQNDOO(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(orderItem.quantity), 0 ) - coalesce( sum(orderDeliveryItem.quantity), 0 )
					FROM
						SlatwallOrderItem orderItem
					  LEFT JOIN
				  		orderItem.orderDeliveryItems orderDeliveryItem
					WHERE
						orderItem.order.orderStatusType.systemCode != 'ostNotPlaced'
					  AND
					    orderItem.order.orderStatusType.systemCode != 'ostClosed'
					  AND
					  	orderItem.orderItemType.systemCode = 'oitSale'
					  AND ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "orderItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "orderItem.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "orderItem.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity not delivered on return vendor order 
		public numeric function getQNDORVO(string stockID, string skuID, string productID) {
			// TODO: Impliment this later when we add return vendor orders
			return 0;
		}
		
		// Quantity not delivered on stock adjustment
		public numeric function getQNDOSA(string stockID, string skuID, string productID) {
			
			var params = [];
			var hql = "SELECT coalesce( sum(stockAdjustmentItem.quantity), 0 ) - coalesce( sum(stockAdjustmentDeliveryItem.quantity), 0 ) FROM
					SlatwallStockAdjustmentItem stockAdjustmentItem
				  LEFT JOIN
				  	stockAdjustmentItem.stockAdjustmentDeliveryItems stockAdjustmentDeliveryItem
				WHERE
					stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
				AND ";
			
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
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity not received on return order
		public numeric function getQNRORO(string stockID, string skuID, string productID) {
			var params = [];
			var hql = "SELECT coalesce( sum(orderItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 )
					FROM
						SlatwallOrderItem orderItem
					  LEFT JOIN
				  		orderItem.stockReceiverItems stockReceiverItem
					WHERE
						orderItem.order.orderStatusType.systemCode != 'ostNotPlaced'
					  AND
					    orderItem.order.orderStatusType.systemCode != 'ostClosed'
					  AND
					  	orderItem.orderItemStatusType.systemCode = 'oitReturn'
					  AND ";
			
			if(structKeyExists(arguments, "stockID")) {
				params[1] = arguments.stockID;
				hql &= "orderItem.stock.stockID = ?";
			} else if (structKeyExists(arguments, "skuID")) {
				params[1] = arguments.skuID;
				hql &= "orderItem.sku.skuID = ?";
			} else if (structKeyExists(arguments, "productID")) {
				params[1] = arguments.productID;
				hql &= "orderItem.sku.product.productID = ?";
			} else {
				throw("You must specify a stockID, skuID, or productID to this method.");
			}
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity not received on vendor order
		public numeric function getQNROVO(string stockID, string skuID, string productID) {
			var params = [];
			var hql = "SELECT coalesce( sum(vendorOrderItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 )
					FROM
						SlatwallVendorOrderItem vendorOrderItem
					  LEFT JOIN
				  		vendorOrderItem.stockReceiverItems stockReceiverItem
					WHERE
						vendorOrderItem.vendorOrder.vendorOrderStatusType.systemCode != 'ostClosed'
					  AND
					  	vendorOrderItem.vendorOrder.vendorOrderType = 'votPurchaseOrder'
					  AND ";
			
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
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity not received on stock adjustment
		public numeric function getQNROSA(string stockID, string skuID, string productID) {
			var params = [];
			var hql = "SELECT coalesce( sum(stockAdjustmentItem.quantity), 0 ) - coalesce( sum(stockReceiverItem.quantity), 0 ) FROM
					SlatwallStockAdjustmentItem stockAdjustmentItem
				  LEFT JOIN
				  	stockAdjustmentItem.stockReceiverItems stockReceiverItem
				WHERE
					stockAdjustmentItem.stockAdjustment.stockAdjustmentStatusType.systemCode != 'sastClosed'
				AND ";
			
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
			
			return ormExecuteQuery(hql, params, true);
		}
		
		// Quantity received
		public numeric function getQR(string stockID, string skuID, string productID) {
			return 0;
		}
		
		// Quantity sold
		public numeric function getQS(string stockID, string skuID, string productID) {
			return 0;
		}
	</cfscript>
	
</cfcomponent>
