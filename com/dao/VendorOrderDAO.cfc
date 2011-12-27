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

	public any function getStockForSkuAndLocation(skuID, locationID) {
		var params = [arguments.skuID, arguments.locationID];
		var hql = " SELECT s
					FROM SlatwallStock s
					INNER JOIN s.sku sk
					INNER JOIN s.location l
					WHERE sk.skuID = ?
					AND l.locationID = ?    ";
	
		return ormExecuteQuery(hql, params, true);	
	}	
	
	public any function isProductInVendorOrder(productId, vendorOrderId) {
		var params = [arguments.productId, arguments.vendorOrderId];
		/*var hql = " SELECT p
					FROM SlatwallProduct p
					INNER JOIN p.skus sk
					INNER JOIN sk.stocks s
					INNER JOIN s.vendorOrderItems i
					INNER JOIN i.vendorOrder o 
					WHERE p.productID = ?    
					AND o.vendorOrderId = ?			";*/
					
		var hql = " SELECT  o 
					FROM SlatwallVendorOrder o
					INNER JOIN o.vendorOrderItems i
					INNER JOIN i.stock s
					INNER JOIN s.sku sk
					INNER JOIN sk.product p
					WHERE p.productID = ?    
					AND o.vendorOrderID = ?			";
	
		return !isNull(ormExecuteQuery(hql, params, true));	
	}	
	
	
}
