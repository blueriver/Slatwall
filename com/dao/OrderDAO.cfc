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
				o.orderNumber,
				o.orderOpenDateTime,
				sku.skucode,
				br.brandName, 
				p.productName,
				oi.price,
				oi.quantity,
				(oi.price * oi.quantity) as extendedPrice,
				odi.quantityDelivered,
				oi.taxAmount,
				of.fulfillmentCharge,
				sm.shippingMethodName,
				oist.type as status,
				ac.firstName as accountFirstName,
				ac.LastName as accountLastName,
				ac.company as accountCompany,
				ad.name as shippingName,
				ad.company as shippingCompany,
				ad.phone as shippingPhone,
				ad.streetAddress as shippingStreetAddress,
				ad.street2Address as shippingStreet2Address,
				ad.locality as shippingLocality,
				ad.city as shippingCity,
				ad.stateCode as shippingStateCode,
				ad.countryCode as shippingCountryCode
			 FROM 
			 	  SlatwallOrder o,
			 	  SlatwallSku sku,
			 	  SlatwallBrand br,
			 	  SlatwallProduct p,
			 	  SlatwallOrderFulfillment of,
			 	  SlatwallType oist,
			 	  SlatwallType ost,
			 	  SlatwallAccount ac,
			 	  SlatwallShippingMethod sm,
			 	  SlatwallAddress ad,
			 	  SlatwallOrderItem oi
			  LEFT OUTER JOIN SlatwallOrderDeliveryItem odi
			  		ON oi.orderItemID = odi.orderItemID
			  WHERE
			  		oi.orderID = o.orderID
			  	AND	o.accountID = ac.accountID	
			  	AND sku.skuID = oi.skuID
			  	AND p.productID = sku.productID
			  	AND p.brandID = br.brandID
			  	AND of.orderFulfillmentID = oi.orderFulfillmentID
			  	AND sm.shippingMethodID = of.shippingMethodID
			  	AND oist.typeID = oi.orderItemStatusTypeID
			  	AND ad.addressID = of.shippingAddressID
			  	AND o.orderStatusTypeID = ost.typeID";		  	
		
	// keyword search on order number, or account lastname or company	 	
		if(structKeyExists(arguments,"keyword") && len(trim(arguments.keyword)) > 0) {
			if(isNumeric(arguments.keyword)) {
				sql &= " AND o.orderNumber = :searchOrderNumber";
				searchOrderNumber = true;
			} else if (isSimpleValue(arguments.keyword)) {
				sql &= " AND ac.lastName like :searchLastName or ac.company like :searchComany";
				searchAccount = true;
			}
		}
		// date search
		if(structKeyExists(arguments,"orderDateStart") && len(arguments.orderDateStart) > 0 && isDate(arguments.orderDateStart)) {
			sql &= " AND o.orderOpenDateTime >= :searchDateStart";
			searchDateStart = true;
		} 
		// date search
		if(structKeyExists(arguments,"orderDateEnd") && len(arguments.orderDateEnd) > 0 && isDate(arguments.orderDateEnd)) {
			orderDateEnd = dateAdd('s',85399,orderDateEnd);
			sql &= " AND o.orderOpenDateTime <= :searchDateEnd";
			searchDateEnd = true;
		} 
		// status code
		if(structKeyExists(arguments,"statusCode") && len(arguments.statusCode) > 0) {
			sql&= " AND ost.systemCode in (:searchStatusCode)";
			searchStatusCode = true;
		} 
		// query ordering
		if(structKeyExists(arguments,"orderBy") && len(arguments.orderby) > 0) {
			var orderField = listFirst(arguments.orderBy,"|");
			var direction = listLast(arguments.orderBy,"|");
			if(direction == orderField) {
				direction = "ASC";
			}
			sql &= " ORDER BY o.#orderField# #direction#";
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
			
}
