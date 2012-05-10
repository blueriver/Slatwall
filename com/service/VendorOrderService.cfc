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
component extends="BaseService" persistent="false" accessors="true" output="false" {
	
	property name="addressService";
	property name="taxService";
	property name="skuService";
	property name="productService";
	property name="DAO";
	
	public any function getVendorOrderSmartList(struct data={}) {
		arguments.entityName = "SlatwallVendorOrder";
		
		// Set the defaul showing to 25
		if(!structKeyExists(arguments.data, "P:Show")) {
			arguments.data["P:Show"] = 25;
		}
		
		var smartList = getDAO().getSmartList(argumentCollection=arguments);	
		smartList.addKeywordProperty(propertyIdentifier="vendorOrderNumber", weight=9);
		smartList.addKeywordProperty(propertyIdentifier="vendor_vendorName", weight=4);	
		smartList.joinRelatedProperty("SlatwallVendorOrder","vendor");
		
		return smartList;
	}
	
	public any function searchVendorOrders(struct data={}) {
		//set keyword and vendorOrderby
		var params = {
			keyword = arguments.data.keyword,
			vendorOrderBy = arguments.data.vendorOrderBy
		};
		// pass rc params (for paging) to smartlist
		structAppend(params,arguments.data);
		
		// date range (start or end) have been submitted 
		if(len(trim(arguments.data.vendorOrderDateStart)) > 0 || len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
			var dateStart = arguments.data.vendorOrderDateStart;
			var dateEnd = arguments.data.vendorOrderDateEnd;
			
			// if either the start or end date is blank, default them to a long time ago or now(), respectively
 			if(len(trim(arguments.data.vendorOrderDateStart)) == 0) {
 				dateStart = createDateTime(30,1,1,0,0,0);
 			} else if(len(trim(arguments.data.vendorOrderDateEnd)) == 0) {
 				dateEnd = now();
 			}
 			// make sure we have valid datetimes
 			if(isDate(dateStart) && isDate(dateEnd)) {
 				// since were comparing to datetime objects, I'll add 85,399 seconds to the end date to make sure we get all vendorOrders on the last day of the range (only if it was entered)
				if(len(trim(arguments.data.vendorOrderDateEnd)) > 0) {
					dateEnd = dateAdd('s',85399,dateEnd);	
				}
				params['R:createdDateTime'] = "#dateStart#,#dateEnd#";
 			} else {
 				arguments.data.message = #request.slatwallScope.rbKey("admin.vendorOrder.search.invaliddates")#;
 				arguments.data.messagetype = "warning";
 			}
		}

		return getVendorOrderSmartList(params);
	}

	
	public any function isProductInVendorOrder(required any productID, required any vendorOrderID){
		return getDAO().isProductInVendorOrder(arguments.productID, arguments.vendorOrderID);
	}
	
	public any function getQuantityOfStockAlreadyOnOrder(required any vendorOrderID, required any skuID, required any stockID) {
		return getDAO().getQuantityOfStockAlreadyOnOrder(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getQuantityOfStockAlreadyReceived(required any vendorOrderID, required any skuID, required any stockID) {
		return getDAO().getQuantityOfStockAlreadyReceived(arguments.vendorOrderId, arguments.skuID, arguments.stockID);
	}
	
	public any function getSkusOrdered(required any vendorOrderID) {
		return getDAO().getSkusOrdered(arguments.vendorOrderId);
	}
	
	public any function processVendorOrder(required any vendorOrder, struct data={}, string processContext="process"){
			
		if(val(arguments.data.quantity)){	
			var vendorOrderItem = new('VendorOrderItem');
			var stock = new('Stock');
			var sku = getSkuService().getSku(arguments.data.skuid);
			
			stock.setLocation(get('Location',arguments.data.locationID));
			stock.setSku(sku);
			
			//getSkuService().saveSku(stock);
			
			vendorOrderItem.setQuantity(arguments.data.quantity);
			vendorOrderItem.setCost(arguments.data.cost);
			vendorOrderItem.setStock(stock);
			
			arguments.vendorOrder.addVendorOrderItem(vendorOrderItem);	
		}		
		/*writedump(var="#arguments#" top="2");
		abort;*/
	}
}
