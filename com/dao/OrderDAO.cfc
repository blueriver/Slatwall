/*

    Slatwall - An Open Source eCommerce Platform
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
component extends="BaseDAO" {

	public query function getExportQuery(string keyword, string orderDateStart, string orderDateEnd, string statusCode, string orderBy) {
		//initialize search field flags
		var searchOrderNumber = false;
		var searchAccount = false;
		var searchDateStart = false;
		var searchDateEnd = false;
		var searchStatusCode = false;
		
		var qOrders = new Query();
		var sql =
			"SELECT
				SlatwallOrder.orderNumber,
				SlatwallOrder.orderOpenDateTime,
				SlatwallSku.skucode,
				SlatwallBrand.brandName, 
				SlatwallProduct.productName,
				SlatwallOrderItem.price,
				SlatwallOrderItem.quantity,
				(SlatwallOrderItem.price * SlatwallOrderItem.quantity) as extendedPrice,
				SlatwallOrderDeliveryItem.quantity,
				(SELECT sum(taxAmount) From SlatwallTaxApplied where SlatwallTaxApplied.orderItemID = SlatwallOrderItem.orderItemID) as taxAmount,
				SlatwallOrderFulfillment.fulfillmentCharge,
				SlatwallShippingMethod.shippingMethodName,
				orderItemStatusType.type as status,
				SlatwallAccount.firstName as accountFirstName,
				SlatwallAccount.LastName as accountLastName,
				SlatwallAccount.company as accountCompany,
				SlatwallAddress.name as shippingName,
				SlatwallAddress.company as shippingCompany,
				SlatwallAddress.phone as shippingPhone,
				SlatwallAddress.streetAddress as shippingStreetAddress,
				SlatwallAddress.street2Address as shippingStreet2Address,
				SlatwallAddress.locality as shippingLocality,
				SlatwallAddress.city as shippingCity,
				SlatwallAddress.stateCode as shippingStateCode,
				SlatwallAddress.countryCode as shippingCountryCode
			 FROM 
			 	  SlatwallOrder,
			 	  SlatwallSku,
			 	  SlatwallBrand,
			 	  SlatwallProduct,
			 	  SlatwallOrderFulfillment,
			 	  SlatwallType orderItemStatusType,
			 	  SlatwallType orderStatusType,
			 	  SlatwallAccount,
			 	  SlatwallShippingMethod,
			 	  SlatwallAddress,
			 	  SlatwallOrderItem
			  LEFT OUTER JOIN SlatwallOrderDeliveryItem
			  		ON SlatwallOrderItem.orderItemID = SlatwallOrderDeliveryItem.orderItemID
			  WHERE
			  		SlatwallOrderItem.orderID = SlatwallOrder.orderID
			  	AND	SlatwallOrder.accountID = SlatwallAccount.accountID	
			  	AND SlatwallSku.skuID = SlatwallOrderItem.skuID
			  	AND SlatwallProduct.productID = SlatwallSku.productID
			  	AND SlatwallProduct.brandID = SlatwallBrand.brandID
			  	AND SlatwallOrderFulfillment.orderFulfillmentID = SlatwallOrderItem.orderFulfillmentID
			  	AND SlatwallShippingMethod.shippingMethodID = SlatwallOrderFulfillment.shippingMethodID
			  	AND orderItemStatusType.typeID = SlatwallOrderItem.orderItemStatusTypeID
			  	AND SlatwallAddress.addressID = SlatwallOrderFulfillment.shippingAddressID
			  	AND SlatwallOrder.orderStatusTypeID = orderStatusType.typeID";		  	
		
		// keyword search on order number, or account lastname or company	 	
		if(structKeyExists(arguments,"keyword") && len(trim(arguments.keyword)) > 0) {
			if(isNumeric(arguments.keyword)) {
				sql &= " AND SlatwallOrder.orderNumber = :searchOrderNumber";
				searchOrderNumber = true;
			} else if (isSimpleValue(arguments.keyword)) {
				sql &= " AND SlatwallAccount.lastName like :searchLastName or SlatwallAccount.company like :searchComany";
				searchAccount = true;
			}
		}
		
		// date search
		if(structKeyExists(arguments,"orderDateStart") && len(arguments.orderDateStart) > 0 && isDate(arguments.orderDateStart)) {
			sql &= " AND SlatwallOrder.orderOpenDateTime >= :searchDateStart";
			searchDateStart = true;
		}
		
		// date search
		if(structKeyExists(arguments,"orderDateEnd") && len(arguments.orderDateEnd) > 0 && isDate(arguments.orderDateEnd)) {
			orderDateEnd = dateAdd('s',85399,orderDateEnd);
			sql &= " AND SlatwallOrder.orderOpenDateTime <= :searchDateEnd";
			searchDateEnd = true;
		}
		
		// status code
		if(structKeyExists(arguments,"statusCode") && len(arguments.statusCode) > 0) {
			sql&= " AND orderStatusType.systemCode in (:searchStatusCode)";
			searchStatusCode = true;
		} 
		
		// query ordering
		if(structKeyExists(arguments,"orderBy") && len(arguments.orderby) > 0) {
			var orderField = listFirst(arguments.orderBy,"|");
			var direction = listLast(arguments.orderBy,"|");
			if(direction == orderField) {
				direction = "ASC";
			}
			sql &= " ORDER BY SlatwallOrder.#orderField# #direction#";
		}
		
		qOrders.setSQL(sql);
		
		// param values
		if(searchOrderNumber) {
			qOrders.addParam(name="searchOrderNumber", value="#arguments.keyword#", cfsqltype="cf_sql_integer");
		} else if(searchAccount) {
			qOrders.addParam(name="searchLastName", value="%#arguments.keyword#%", cfsqltype="cf_sql_varchar");
			qOrders.addParam(name="searchCompany", value="%#arguments.keyword#%", cfsqltype="cf_sql_varchar");
		}
		if(searchDateStart) {
			qOrders.addParam(name="searchDateStart", value="#arguments.orderDateStart#", cfsqltype="cf_sql_timestamp");
		}
		if(searchDateEnd) {
			qOrders.addParam(name="searchDateEnd", value="#arguments.orderDateEnd#", cfsqltype="cf_sql_timestamp");
		}
		if(searchStatusCode) {
			qOrders.addParam(name="searchStatusCode", value="#arguments.statusCode#", cfsqlType="cf_sql_varchar", list="true");
		}
		return qOrders.execute().getResult();
	}
	
	public struct function getQuantityPriceSkuAlreadyReturned(required any orderID, required any skuID) {
		var params = [arguments.orderID, arguments.skuID];	

		var hql = " SELECT new map(sum(oi.quantity) as quantity, sum(oi.price) as price)
					FROM SlatwallOrderItem oi
					WHERE oi.order.referencedOrder.orderID = ?
					AND oi.sku.skuID = ?
					AND oi.order.referencedOrder.orderType.systemCode = 'otReturnAuthorization'    "; 
	
		var result = ormExecuteQuery(hql, params);
		var retStruct = {price = 0, quantity = 0};
		
		if(structKeyExists(result[1], "price")) {
			retStruct.price = result[1]["price"];
		}

		if(structKeyExists(result[1], "quantity")) {
			retStruct.quantity = result[1]["quantity"];
		}
		
		return retStruct;
	}
	
	// This method pulls the sum of all OriginalOrder -> Order (return) -> OrderReturn fulfillmentRefundAmounts
	public numeric function getPreviouslyReturnedFulfillmentTotal(required any orderID) {
		var params = [arguments.orderID];	
		var hql = " SELECT new map(sum(r.fulfillmentRefundAmount) as total)
					FROM SlatwallOrderReturn r
					WHERE r.order.referencedOrder.orderID = ?  "; 
	
		var result = ormExecuteQuery(hql, params);

		if(structKeyExists(result[1], "total")) {
			return result[1]["total"];
		} else {
			return 0;
		}
	}

	public any function getMaxOrderNumber() {
		return ormExecuteQuery("SELECT max(cast(aslatwallorder.orderNumber as int)) as maxOrderNumber FROM SlatwallOrder aslatwallorder");
	}
	

}
